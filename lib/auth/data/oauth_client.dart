import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';

import '../domain/cf_credential.dart';

/// Cloudflare's OAuth 2.0 endpoints.
///
/// These are not published as an RFC 8414 metadata document — the obvious
/// `/.well-known/oauth-authorization-server` path serves the dashboard SPA —
/// so they are constants, confirmed by probing:
///
///   * `GET /oauth2/auth` with a bogus client redirects to
///     `/oauth/error?error=invalid_client`, i.e. it is a real authorization
///     endpoint that validated the request.
///   * `POST /oauth2/token` answers 401 rather than 404. (A `GET` there returns
///     404, which is what made the endpoint look absent at first.)
///
/// Overridable at runtime so a change on Cloudflare's side does not brick
/// installed builds.
class OAuthEndpoints {
  const OAuthEndpoints({
    this.authorize = defaultAuthorize,
    this.token = defaultToken,
    this.revoke = defaultRevoke,
  });

  static const String defaultAuthorize =
      'https://dash.cloudflare.com/oauth2/auth';
  static const String defaultToken = 'https://dash.cloudflare.com/oauth2/token';
  static const String defaultRevoke =
      'https://dash.cloudflare.com/oauth2/revoke';

  final String authorize;
  final String token;
  final String revoke;
}

/// Static configuration of the OAuth client.
///
/// The client id is not a secret — a public PKCE client has none — so baking a
/// default into release builds is fine, and Settings can override it for people
/// who registered their own.
class OAuthConfig {
  const OAuthConfig({
    required this.clientId,
    required this.redirectUri,
    this.scopes = defaultScopes,
    this.endpoints = const OAuthEndpoints(),
  });

  static const String clientIdFromBuild = String.fromEnvironment(
    'CFMGR_OAUTH_CLIENT_ID',
  );
  static const String redirectFromBuild = String.fromEnvironment(
    'CFMGR_OAUTH_REDIRECT',
  );

  /// What the app actually needs. Kept deliberately short: a consent screen
  /// asking for everything is a reason for a user to walk away.
  static const List<String> defaultScopes = [
    'account:read',
    'user:read',
    'zone:read',
    'dns_records:edit',
    'zone_settings:read',
    'cache_purge:edit',
    'offline_access',
  ];

  final String clientId;

  /// Must be https — Cloudflare's client form rejects custom schemes. The
  /// bridge Worker in tools/oauth-callback-worker bounces it back to the app.
  final String redirectUri;

  final List<String> scopes;
  final OAuthEndpoints endpoints;

  bool get isConfigured => clientId.isNotEmpty && redirectUri.isNotEmpty;

  /// Scheme the app listens on for the final hop.
  static const String callbackScheme = 'io.cfmgr.app';
}

/// One in-flight authorization attempt.
class PkcePair {
  const PkcePair({
    required this.verifier,
    required this.challenge,
    required this.state,
  });

  final String verifier;
  final String challenge;
  final String state;

  /// RFC 7636: the verifier is 43–128 unreserved characters. 32 random bytes
  /// base64url-encoded lands at 43, which is the shortest legal value and the
  /// full 256 bits of entropy.
  static Future<PkcePair> generate({Random? random}) async {
    final rng = random ?? Random.secure();
    final verifier = _urlSafe(_bytes(32, rng));
    final state = _urlSafe(_bytes(16, rng));
    final digest = await Sha256().hash(ascii.encode(verifier));
    return PkcePair(
      verifier: verifier,
      challenge: _urlSafe(digest.bytes),
      state: state,
    );
  }

  static List<int> _bytes(int n, Random rng) =>
      List<int>.generate(n, (_) => rng.nextInt(256));

  /// base64url without padding, per RFC 7636 appendix A.
  static String _urlSafe(List<int> bytes) =>
      base64Url.encode(bytes).replaceAll('=', '');
}

/// Tokens as returned by the token endpoint.
class OAuthTokens {
  const OAuthTokens({
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.scopes = const {},
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final Set<String> scopes;

  static OAuthTokens fromJson(
    Map<String, Object?> json, {
    DateTime Function()? now,
  }) {
    final expiresIn = switch (json['expires_in']) {
      final int i => i,
      final num n => n.toInt(),
      final String s => int.tryParse(s),
      _ => null,
    };
    final scope = json['scope'];
    return OAuthTokens(
      accessToken: json['access_token']?.toString() ?? '',
      refreshToken: json['refresh_token']?.toString(),
      expiresAt: expiresIn == null
          ? null
          : (now ?? DateTime.now)().add(Duration(seconds: expiresIn)),
      scopes: switch (scope) {
        final String s when s.isNotEmpty => s.split(RegExp(r'\s+')).toSet(),
        final List<Object?> l => l.map((e) => e.toString()).toSet(),
        _ => const <String>{},
      },
    );
  }
}

/// Raised when the authorization server says no.
class OAuthException implements Exception {
  const OAuthException(this.error, [this.description]);

  final String error;
  final String? description;

  @override
  String toString() =>
      description == null ? 'OAuth error: $error' : '$error — $description';
}

/// Drives Authorization Code + PKCE against Cloudflare.
///
/// The browser hop is injected so the whole flow is testable without a device.
class CloudflareOAuth {
  CloudflareOAuth({
    required this.config,
    required Dio dio,
    Future<String> Function({required String url, required String scheme})?
    openBrowser,
  }) : _dio = dio,
       _open = openBrowser;

  final OAuthConfig config;
  final Dio _dio;
  final Future<String> Function({required String url, required String scheme})?
  _open;

  /// Builds the URL the user is sent to.
  Uri authorizationUrl(PkcePair pkce) =>
      Uri.parse(config.endpoints.authorize).replace(
        queryParameters: {
          'response_type': 'code',
          'client_id': config.clientId,
          'redirect_uri': config.redirectUri,
          'scope': config.scopes.join(' '),
          'state': pkce.state,
          'code_challenge': pkce.challenge,
          'code_challenge_method': 'S256',
        },
      );

  /// Runs the full flow and returns tokens.
  Future<OAuthTokens> authorize() async {
    final open = _open;
    if (open == null) {
      throw const OAuthException(
        'not_supported',
        'No browser hook was provided',
      );
    }

    final pkce = await PkcePair.generate();
    final result = await open(
      url: authorizationUrl(pkce).toString(),
      scheme: OAuthConfig.callbackScheme,
    );

    return exchange(callbackUrl: result, pkce: pkce);
  }

  /// Validates the callback and swaps the code for tokens.
  Future<OAuthTokens> exchange({
    required String callbackUrl,
    required PkcePair pkce,
  }) async {
    final uri = Uri.parse(callbackUrl);
    final params = uri.queryParameters;

    final error = params['error'];
    if (error != null) {
      throw OAuthException(error, params['error_description']);
    }

    // Rejecting a mismatched state is the entire defence against an injected
    // authorization code, so it is checked before anything else is used.
    if (params['state'] != pkce.state) {
      throw const OAuthException(
        'state_mismatch',
        'The callback did not match this sign-in attempt',
      );
    }

    final code = params['code'];
    if (code == null || code.isEmpty) {
      throw const OAuthException('no_code', 'Cloudflare returned no code');
    }

    return _postToken({
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': config.redirectUri,
      'client_id': config.clientId,
      'code_verifier': pkce.verifier,
    });
  }

  Future<OAuthTokens> refresh(String refreshToken) => _postToken({
    'grant_type': 'refresh_token',
    'refresh_token': refreshToken,
    'client_id': config.clientId,
  });

  Future<void> revoke(String token) async {
    await _dio.post<dynamic>(
      config.endpoints.revoke,
      data: {'token': token, 'client_id': config.clientId},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (_) => true,
      ),
    );
  }

  Future<OAuthTokens> _postToken(Map<String, String> form) async {
    final response = await _dio.post<dynamic>(
      config.endpoints.token,
      data: form,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        // Errors here are OAuth-shaped JSON, not Cloudflare envelopes, so they
        // are read rather than thrown by Dio.
        validateStatus: (_) => true,
      ),
    );

    final body = switch (response.data) {
      final Map<Object?, Object?> m => m.map(
        (k, v) => MapEntry(k.toString(), v),
      ),
      final String s when s.isNotEmpty => _tryDecode(s),
      _ => const <String, Object?>{},
    };

    final status = response.statusCode ?? 0;
    if (status < 200 || status >= 300 || body['access_token'] == null) {
      throw OAuthException(
        body['error']?.toString() ?? 'http_$status',
        body['error_description']?.toString(),
      );
    }
    return OAuthTokens.fromJson(body);
  }

  static Map<String, Object?> _tryDecode(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map
          ? decoded.map((k, v) => MapEntry(k.toString(), v))
          : const {};
    } on FormatException {
      return const {};
    }
  }
}

/// Turns tokens into the credential the rest of the app understands.
OAuthCredential credentialFromTokens(
  OAuthTokens tokens, {
  required String id,
  required String label,
}) => OAuthCredential(
  id: id,
  label: label,
  accessToken: tokens.accessToken,
  refreshToken: tokens.refreshToken,
  expiresAt: tokens.expiresAt,
  scopes: tokens.scopes,
);
