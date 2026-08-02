/// The three ways to authenticate against the Cloudflare API, behind one type.
///
/// The spec's `components.securitySchemes` confirms exactly these: `api_token`
/// (bearer), `api_email` + `api_key` (the legacy global key), and
/// `user_service_key`. OAuth rides on the same bearer header as an API token
/// but carries expiry and refresh state, so it is a separate case.
library;

import 'dart:convert';

enum CfAuthMethod {
  apiToken,
  globalKey,
  oauth;

  static CfAuthMethod fromName(String? n) => CfAuthMethod.values.firstWhere(
    (m) => m.name == n,
    orElse: () => CfAuthMethod.apiToken,
  );
}

sealed class CfCredential {
  const CfCredential({required this.id, required this.label});

  /// Stable identifier of the profile this credential belongs to.
  final String id;

  /// User-chosen name, e.g. "Work" or "Client — example.com".
  final String label;

  CfAuthMethod get method;

  /// Headers to attach to every request.
  Map<String, String> get authHeaders;

  /// True when the credential is known to be unusable right now.
  bool get isExpired => false;

  /// True when the credential grants unrestricted account access and the UI
  /// must say so.
  bool get isUnrestricted => false;

  Map<String, Object?> toJson();

  CfCredential copyWithLabel(String newLabel);

  static CfCredential fromJson(Map<String, Object?> json) {
    final method = CfAuthMethod.fromName(json['method'] as String?);
    final id = json['id'] as String? ?? '';
    final label = json['label'] as String? ?? 'Cloudflare';
    return switch (method) {
      CfAuthMethod.apiToken => ApiTokenCredential(
        id: id,
        label: label,
        token: json['token'] as String? ?? '',
      ),
      CfAuthMethod.globalKey => GlobalKeyCredential(
        id: id,
        label: label,
        email: json['email'] as String? ?? '',
        apiKey: json['api_key'] as String? ?? '',
      ),
      CfAuthMethod.oauth => OAuthCredential(
        id: id,
        label: label,
        accessToken: json['access_token'] as String? ?? '',
        refreshToken: json['refresh_token'] as String?,
        expiresAt: switch (json['expires_at']) {
          final String s => DateTime.tryParse(s),
          _ => null,
        },
        scopes: switch (json['scopes']) {
          final List<Object?> l => l.map((e) => e.toString()).toSet(),
          _ => const <String>{},
        },
      ),
    };
  }

  static CfCredential decode(String raw) =>
      fromJson(jsonDecode(raw) as Map<String, Object?>);

  String encode() => jsonEncode(toJson());
}

/// Scoped API token — the recommended path. `Authorization: Bearer <token>`.
class ApiTokenCredential extends CfCredential {
  const ApiTokenCredential({
    required super.id,
    required super.label,
    required this.token,
  });

  final String token;

  @override
  CfAuthMethod get method => CfAuthMethod.apiToken;

  @override
  Map<String, String> get authHeaders => {'Authorization': 'Bearer $token'};

  @override
  Map<String, Object?> toJson() => {
    'method': method.name,
    'id': id,
    'label': label,
    'token': token,
  };

  @override
  CfCredential copyWithLabel(String newLabel) =>
      ApiTokenCredential(id: id, label: newLabel, token: token);
}

/// Legacy global API key. Cannot be scoped, cannot be IP-restricted, and covers
/// billing and account deletion. Supported because some users still only have
/// this, but the UI must warn every time it is used.
class GlobalKeyCredential extends CfCredential {
  const GlobalKeyCredential({
    required super.id,
    required super.label,
    required this.email,
    required this.apiKey,
  });

  final String email;
  final String apiKey;

  @override
  CfAuthMethod get method => CfAuthMethod.globalKey;

  @override
  bool get isUnrestricted => true;

  @override
  Map<String, String> get authHeaders => {
    'X-Auth-Email': email,
    'X-Auth-Key': apiKey,
  };

  @override
  Map<String, Object?> toJson() => {
    'method': method.name,
    'id': id,
    'label': label,
    'email': email,
    'api_key': apiKey,
  };

  @override
  CfCredential copyWithLabel(String newLabel) => GlobalKeyCredential(
    id: id,
    label: newLabel,
    email: email,
    apiKey: apiKey,
  );
}

/// OAuth 2.0 access token obtained through Authorization Code + PKCE.
class OAuthCredential extends CfCredential {
  const OAuthCredential({
    required super.id,
    required super.label,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.scopes = const {},
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;
  final Set<String> scopes;

  /// Refresh a little early so a long request cannot start on a token that
  /// expires mid-flight.
  static const Duration refreshMargin = Duration(minutes: 2);

  @override
  CfAuthMethod get method => CfAuthMethod.oauth;

  @override
  bool get isExpired {
    final exp = expiresAt;
    return exp != null && DateTime.now().isAfter(exp);
  }

  bool get needsRefresh {
    final exp = expiresAt;
    if (exp == null) return false;
    return DateTime.now().isAfter(exp.subtract(refreshMargin));
  }

  @override
  Map<String, String> get authHeaders => {
    'Authorization': 'Bearer $accessToken',
  };

  OAuthCredential copyWithTokens({
    required String accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    Set<String>? scopes,
  }) => OAuthCredential(
    id: id,
    label: label,
    accessToken: accessToken,
    refreshToken: refreshToken ?? this.refreshToken,
    expiresAt: expiresAt ?? this.expiresAt,
    scopes: scopes ?? this.scopes,
  );

  @override
  Map<String, Object?> toJson() => {
    'method': method.name,
    'id': id,
    'label': label,
    'access_token': accessToken,
    if (refreshToken != null) 'refresh_token': refreshToken,
    if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    'scopes': scopes.toList(),
  };

  @override
  CfCredential copyWithLabel(String newLabel) => OAuthCredential(
    id: id,
    label: newLabel,
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresAt: expiresAt,
    scopes: scopes,
  );
}
