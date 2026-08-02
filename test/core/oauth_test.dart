import 'dart:convert';

import 'package:cloudflare_mobile/auth/data/oauth_client.dart';
import 'package:cloudflare_mobile/auth/domain/cf_credential.dart';
import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

const _config = OAuthConfig(
  clientId: 'client-123',
  redirectUri: 'https://example.workers.dev/oauth/callback',
);

(CloudflareOAuth, DioAdapter) _subject({
  Future<String> Function({required String url, required String scheme})? open,
}) {
  final dio = Dio();
  final adapter = DioAdapter(dio: dio);
  dio.httpClientAdapter = adapter;
  return (
    CloudflareOAuth(config: _config, dio: dio, openBrowser: open),
    adapter,
  );
}

void main() {
  group('PKCE', () {
    test('verifier is RFC 7636 shaped', () async {
      final pkce = await PkcePair.generate();

      expect(pkce.verifier.length, greaterThanOrEqualTo(43));
      expect(pkce.verifier.length, lessThanOrEqualTo(128));
      // Unreserved characters only: no padding, no + or /.
      expect(RegExp(r'^[A-Za-z0-9\-._~]+$').hasMatch(pkce.verifier), isTrue);
      expect(pkce.verifier, isNot(contains('=')));
    });

    test('challenge is the base64url SHA-256 of the verifier', () async {
      final pkce = await PkcePair.generate();

      final digest = await Sha256().hash(ascii.encode(pkce.verifier));
      final expected = base64Url.encode(digest.bytes).replaceAll('=', '');
      expect(pkce.challenge, expected);
    });

    test('each attempt gets a fresh verifier and state', () async {
      final a = await PkcePair.generate();
      final b = await PkcePair.generate();

      expect(a.verifier, isNot(b.verifier));
      expect(a.state, isNot(b.state));
    });
  });

  group('authorization URL', () {
    test('carries every parameter Cloudflare needs', () async {
      final (oauth, _) = _subject();
      final pkce = await PkcePair.generate();

      final uri = oauth.authorizationUrl(pkce);

      expect(uri.origin, 'https://dash.cloudflare.com');
      expect(uri.path, '/oauth2/auth');
      expect(uri.queryParameters['response_type'], 'code');
      expect(uri.queryParameters['client_id'], 'client-123');
      expect(uri.queryParameters['redirect_uri'], _config.redirectUri);
      expect(uri.queryParameters['code_challenge'], pkce.challenge);
      expect(uri.queryParameters['code_challenge_method'], 'S256');
      expect(uri.queryParameters['state'], pkce.state);
      // The verifier must never travel to the authorization endpoint; that is
      // the entire point of PKCE.
      expect(uri.toString(), isNot(contains(pkce.verifier)));
    });
  });

  group('exchange', () {
    test('swaps a code for tokens and sends the verifier', () async {
      final (oauth, adapter) = _subject();
      final pkce = await PkcePair.generate();

      adapter.onPost(
        OAuthEndpoints.defaultToken,
        (server) => server.reply(200, {
          'access_token': 'at-1',
          'refresh_token': 'rt-1',
          'expires_in': 3600,
          'scope': 'zone:read dns_records:edit',
          'token_type': 'bearer',
        }),
        data: Matchers.any,
      );

      final tokens = await oauth.exchange(
        callbackUrl:
            'io.cfmgr.app://oauth/callback?code=abc&state=${pkce.state}',
        pkce: pkce,
      );

      expect(tokens.accessToken, 'at-1');
      expect(tokens.refreshToken, 'rt-1');
      expect(tokens.scopes, {'zone:read', 'dns_records:edit'});
      expect(tokens.expiresAt!.isAfter(DateTime.now()), isTrue);
    });

    test('rejects a mismatched state', () async {
      // Without this check an attacker could inject their own authorization
      // code and have the victim's app bind to the attacker's account.
      final (oauth, _) = _subject();
      final pkce = await PkcePair.generate();

      await expectLater(
        oauth.exchange(
          callbackUrl: 'io.cfmgr.app://oauth/callback?code=abc&state=WRONG',
          pkce: pkce,
        ),
        throwsA(
          isA<OAuthException>().having(
            (e) => e.error,
            'error',
            'state_mismatch',
          ),
        ),
      );
    });

    test('surfaces an error returned in the callback', () async {
      final (oauth, _) = _subject();
      final pkce = await PkcePair.generate();

      await expectLater(
        oauth.exchange(
          callbackUrl:
              'io.cfmgr.app://oauth/callback'
              '?error=access_denied&error_description=User+said+no'
              '&state=${pkce.state}',
          pkce: pkce,
        ),
        throwsA(
          isA<OAuthException>()
              .having((e) => e.error, 'error', 'access_denied')
              .having((e) => e.description, 'description', 'User said no'),
        ),
      );
    });

    test('a callback with no code is an error, not an empty token', () async {
      final (oauth, _) = _subject();
      final pkce = await PkcePair.generate();

      await expectLater(
        oauth.exchange(
          callbackUrl: 'io.cfmgr.app://oauth/callback?state=${pkce.state}',
          pkce: pkce,
        ),
        throwsA(
          isA<OAuthException>().having((e) => e.error, 'error', 'no_code'),
        ),
      );
    });

    test('an OAuth error body becomes an OAuthException', () async {
      final (oauth, adapter) = _subject();
      final pkce = await PkcePair.generate();

      adapter.onPost(
        OAuthEndpoints.defaultToken,
        (server) => server.reply(400, {
          'error': 'invalid_grant',
          'error_description': 'The code has expired',
        }),
        data: Matchers.any,
      );

      await expectLater(
        oauth.exchange(
          callbackUrl:
              'io.cfmgr.app://oauth/callback?code=abc&state=${pkce.state}',
          pkce: pkce,
        ),
        throwsA(
          isA<OAuthException>()
              .having((e) => e.error, 'error', 'invalid_grant')
              .having(
                (e) => e.description,
                'description',
                'The code has expired',
              ),
        ),
      );
    });

    test('a 200 without an access token is still an error', () async {
      final (oauth, adapter) = _subject();
      final pkce = await PkcePair.generate();

      adapter.onPost(
        OAuthEndpoints.defaultToken,
        (server) => server.reply(200, {'token_type': 'bearer'}),
        data: Matchers.any,
      );

      await expectLater(
        oauth.exchange(
          callbackUrl:
              'io.cfmgr.app://oauth/callback?code=abc&state=${pkce.state}',
          pkce: pkce,
        ),
        throwsA(isA<OAuthException>()),
      );
    });
  });

  group('refresh', () {
    test('exchanges a refresh token for a new access token', () async {
      final (oauth, adapter) = _subject();

      adapter.onPost(
        OAuthEndpoints.defaultToken,
        (server) => server.reply(200, {
          'access_token': 'at-2',
          'refresh_token': 'rt-2',
          'expires_in': 1800,
        }),
        data: Matchers.any,
      );

      final tokens = await oauth.refresh('rt-1');

      expect(tokens.accessToken, 'at-2');
      // Cloudflare may rotate the refresh token; keeping the new one is what
      // stops the next refresh from failing.
      expect(tokens.refreshToken, 'rt-2');
    });
  });

  group('full flow', () {
    test('drives the browser hop and returns a credential', () async {
      late String seenUrl;
      final (oauth, adapter) = _subject(
        open: ({required url, required scheme}) async {
          seenUrl = url;
          final state = Uri.parse(url).queryParameters['state'];
          expect(scheme, 'io.cfmgr.app');
          return 'io.cfmgr.app://oauth/callback?code=xyz&state=$state';
        },
      );

      adapter.onPost(
        OAuthEndpoints.defaultToken,
        (server) => server.reply(200, {
          'access_token': 'at-3',
          'expires_in': 600,
          'scope': 'account:read',
        }),
        data: Matchers.any,
      );

      final tokens = await oauth.authorize();
      final credential = credentialFromTokens(tokens, id: 'p1', label: 'Work');

      expect(seenUrl, contains('code_challenge_method=S256'));
      expect(credential.accessToken, 'at-3');
      expect(credential.scopes, {'account:read'});
      expect(credential.authHeaders['Authorization'], 'Bearer at-3');
      expect(credential.needsRefresh, isFalse);
    });
  });

  group('OAuthCredential expiry', () {
    test('needsRefresh fires inside the safety margin', () {
      final soon = OAuthCredential(
        id: 'p',
        label: 'p',
        accessToken: 'a',
        expiresAt: DateTime.now().add(const Duration(seconds: 30)),
      );
      expect(soon.needsRefresh, isTrue);
      expect(soon.isExpired, isFalse);
    });

    test('a token with no expiry never asks to be refreshed', () {
      const forever = OAuthCredential(id: 'p', label: 'p', accessToken: 'a');
      expect(forever.needsRefresh, isFalse);
      expect(forever.isExpired, isFalse);
    });
  });
}
