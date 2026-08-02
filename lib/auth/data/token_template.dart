import 'dart:convert';

/// Builds Cloudflare dashboard deep links that pre-fill the API token form.
///
/// This is what makes the token path feel close to a real sign-in: the user
/// taps a button, lands on the token screen with the right permissions already
/// selected, presses Create, and pastes the result back. No hunting through
/// the permission list for "Zone / DNS / Edit".
///
/// The exact `permissionGroupKeys` values are NOT in openapi.json. They are
/// taken from `GET /user/tokens/permission_groups`, which the app calls once a
/// credential exists; the constants below are the well-known keys used as a
/// bootstrap for the very first token, before any credential is available.
class TokenTemplate {
  const TokenTemplate._();

  static const String dashboardBase = 'https://dash.cloudflare.com';

  /// A single permission entry: `{"key": "dns_records", "type": "edit"}`.
  static Map<String, String> permission(String key, String type) => {
    'key': key,
    'type': type,
  };

  /// Read-only across zones and account settings.
  static const List<Map<String, String>> readOnly = [
    {'key': 'zone', 'type': 'read'},
    {'key': 'dns_records', 'type': 'read'},
    {'key': 'zone_settings', 'type': 'read'},
    {'key': 'analytics', 'type': 'read'},
    {'key': 'account_settings', 'type': 'read'},
  ];

  /// Everything the DNS screens need.
  static const List<Map<String, String>> dnsAdmin = [
    {'key': 'zone', 'type': 'read'},
    {'key': 'dns_records', 'type': 'edit'},
    {'key': 'zone_settings', 'type': 'read'},
    {'key': 'account_settings', 'type': 'read'},
  ];

  /// Everything this app can currently drive.
  static const List<Map<String, String>> full = [
    {'key': 'zone', 'type': 'edit'},
    {'key': 'dns_records', 'type': 'edit'},
    {'key': 'zone_settings', 'type': 'edit'},
    {'key': 'cache_purge', 'type': 'edit'},
    {'key': 'analytics', 'type': 'read'},
    {'key': 'waf', 'type': 'edit'},
    {'key': 'account_settings', 'type': 'read'},
  ];

  /// User-owned token, scoped to all accounts and all zones.
  static Uri userToken(
    List<Map<String, String>> permissions, {
    String name = 'Cloudflare Mobile',
  }) => Uri.parse('$dashboardBase/profile/api-tokens').replace(
    queryParameters: {
      'permissionGroupKeys': jsonEncode(permissions),
      'accountId': '*',
      'zoneId': 'all',
      'name': name,
    },
  );

  /// Account-owned token. The dashboard resolves `:account` by asking the user
  /// to pick, which is why no account id is needed here.
  static Uri accountToken(
    List<Map<String, String>> permissions, {
    String name = 'Cloudflare Mobile',
  }) => Uri.parse(dashboardBase).replace(
    queryParameters: {
      'to': '/:account/api-tokens',
      'permissionGroupKeys': jsonEncode(permissions),
      'name': name,
    },
  );

  /// Where to send someone whose token turned out to lack a permission.
  static Uri forMissing(Set<String> missingPermissionLabels) {
    final wanted = <Map<String, String>>[...dnsAdmin];
    for (final label in missingPermissionLabels) {
      final lower = label.toLowerCase();
      if (lower.contains('cache')) {
        wanted.add(permission('cache_purge', 'edit'));
      }
      if (lower.contains('waf') || lower.contains('firewall')) {
        wanted.add(permission('waf', 'edit'));
      }
      if (lower.contains('analytics')) {
        wanted.add(permission('analytics', 'read'));
      }
      if (lower.contains('zone settings')) {
        wanted.add(permission('zone_settings', 'edit'));
      }
    }
    return userToken(wanted);
  }
}
