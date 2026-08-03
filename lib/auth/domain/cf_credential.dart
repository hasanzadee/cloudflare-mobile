/// The two ways this app authenticates against the Cloudflare API.
///
/// The spec's `components.securitySchemes` lists `api_token` (bearer),
/// `api_email` + `api_key` (the legacy global key), and `user_service_key`.
/// The first two are what a person actually has.
///
/// OAuth is deliberately absent — see docs/why-api-tokens.md. It was built and
/// working, and dropped on purpose.
library;

import 'dart:convert';

enum CfAuthMethod {
  apiToken,
  globalKey;

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
