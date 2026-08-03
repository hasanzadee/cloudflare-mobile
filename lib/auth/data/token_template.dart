import 'dart:convert';

/// Builds Cloudflare dashboard deep links that pre-fill the API token form.
///
/// This is what makes the token path feel close to a real sign-in: the user
/// taps a button, lands on the token screen with the right permissions already
/// selected, presses Create, and pastes the result back. No hunting through
/// the permission list for "Zone / DNS / Edit".
///
/// The keys below are the dashboard's own template keys, taken from
/// https://developers.cloudflare.com/fundamentals/api/how-to/account-owned-token-template/
/// They are NOT the permission-group ids returned by
/// `GET /user/tokens/permission_groups`, and they are NOT free-form: the
/// dashboard silently ignores a key it does not recognise, so a typo costs a
/// permission the user then has to find by hand. [allKeys] is the full accepted
/// set and [assertValid] guards every template against it.
class TokenTemplate {
  const TokenTemplate._();

  static const String dashboardBase = 'https://dash.cloudflare.com';

  /// Every key the dashboard's template form accepts, by scope.
  static const Set<String> accountKeys = {
    'account_analytics',
    'account_api_tokens',
    'account_settings',
    'billing',
    'workers_scripts',
    'workers_kv_storage',
    'workers_routes',
    'workers_r2',
    'd1',
    'queues',
    'page',
    'stream',
    'images',
    'logs',
  };

  static const Set<String> zoneKeys = {
    'dns',
    'zone',
    'zone_settings',
    'analytics',
    'firewall_services',
    'page_rules',
    'cache',
    'ssl_and_certificates',
  };

  static const Set<String> accessKeys = {
    'access',
    'access_acct',
    'access_audit_log',
    'access_custom_page',
    'teams',
  };

  static Set<String> get allKeys => {...accountKeys, ...zoneKeys, ...accessKeys};

  /// Accepted access levels. `edit` means full CRUD, not merely update.
  static const Set<String> types = {'read', 'edit', 'revoke', 'run', 'purge'};

  /// A single permission entry: `{"key": "dns", "type": "edit"}`.
  static Map<String, String> permission(String key, String type) {
    assert(allKeys.contains(key), 'unknown permission key: $key');
    assert(types.contains(type), 'unknown permission type: $type');
    return {'key': key, 'type': type};
  }

  /// Read-only across everything the app can show.
  static const List<Map<String, String>> readOnly = [
    {'key': 'zone', 'type': 'read'},
    {'key': 'dns', 'type': 'read'},
    {'key': 'zone_settings', 'type': 'read'},
    {'key': 'analytics', 'type': 'read'},
    {'key': 'firewall_services', 'type': 'read'},
    {'key': 'page_rules', 'type': 'read'},
    {'key': 'ssl_and_certificates', 'type': 'read'},
    {'key': 'account_settings', 'type': 'read'},
    {'key': 'account_analytics', 'type': 'read'},
    {'key': 'workers_scripts', 'type': 'read'},
    {'key': 'workers_kv_storage', 'type': 'read'},
    {'key': 'workers_routes', 'type': 'read'},
    {'key': 'workers_r2', 'type': 'read'},
    {'key': 'd1', 'type': 'read'},
    {'key': 'queues', 'type': 'read'},
    {'key': 'page', 'type': 'read'},
    {'key': 'access', 'type': 'read'},
    {'key': 'access_acct', 'type': 'read'},
    {'key': 'teams', 'type': 'read'},
  ];

  /// Everything the DNS screens need.
  static const List<Map<String, String>> dnsAdmin = [
    {'key': 'zone', 'type': 'read'},
    {'key': 'dns', 'type': 'edit'},
    {'key': 'zone_settings', 'type': 'read'},
    {'key': 'account_settings', 'type': 'read'},
  ];

  /// Read and write across every screen this app has.
  ///
  /// This is the "just let me use the whole app" preset. It does not cover
  /// literally every Cloudflare permission group — the dashboard's template
  /// format only accepts the keys in [allKeys], so Turnstile, Email Routing,
  /// Load Balancers, Waiting Rooms and Notifications have no key and must be
  /// ticked by hand on the same form. Those screens are read-only-ish anyway,
  /// and a 403 from them names the missing permission.
  static const List<Map<String, String>> full = [
    // Zone
    {'key': 'zone', 'type': 'edit'},
    {'key': 'dns', 'type': 'edit'},
    {'key': 'zone_settings', 'type': 'edit'},
    {'key': 'cache', 'type': 'purge'},
    {'key': 'firewall_services', 'type': 'edit'},
    {'key': 'page_rules', 'type': 'edit'},
    {'key': 'ssl_and_certificates', 'type': 'edit'},
    {'key': 'analytics', 'type': 'read'},
    // Account
    {'key': 'account_settings', 'type': 'read'},
    {'key': 'account_analytics', 'type': 'read'},
    {'key': 'workers_scripts', 'type': 'edit'},
    {'key': 'workers_kv_storage', 'type': 'edit'},
    {'key': 'workers_routes', 'type': 'edit'},
    {'key': 'workers_r2', 'type': 'edit'},
    {'key': 'd1', 'type': 'edit'},
    {'key': 'queues', 'type': 'edit'},
    {'key': 'page', 'type': 'edit'},
    // Zero Trust
    {'key': 'access', 'type': 'edit'},
    {'key': 'access_acct', 'type': 'edit'},
    {'key': 'teams', 'type': 'edit'},
  ];

  /// Throws in debug if a preset drifts onto a key the dashboard would drop.
  static void assertValid(List<Map<String, String>> permissions) {
    for (final p in permissions) {
      assert(allKeys.contains(p['key']), 'unknown permission key: ${p['key']}');
      assert(types.contains(p['type']), 'unknown type: ${p['type']}');
    }
  }

  /// User-owned token, scoped to all accounts and all zones.
  static Uri userToken(
    List<Map<String, String>> permissions, {
    String name = 'Cloudflare Mobile',
  }) {
    assertValid(permissions);
    return Uri.parse('$dashboardBase/profile/api-tokens').replace(
      queryParameters: {
        'permissionGroupKeys': jsonEncode(permissions),
        'accountId': '*',
        'zoneId': 'all',
        'name': name,
      },
    );
  }

  /// Account-owned token. The dashboard resolves `:account` by asking the user
  /// to pick, which is why no account id is needed here — and why passing one
  /// is explicitly wrong for this form.
  static Uri accountToken(
    List<Map<String, String>> permissions, {
    String name = 'Cloudflare Mobile',
  }) {
    assertValid(permissions);
    return Uri.parse(dashboardBase).replace(
      queryParameters: {
        'to': '/:account/api-tokens',
        'permissionGroupKeys': jsonEncode(permissions),
        'name': name,
      },
    );
  }

  /// Where to send someone whose token turned out to lack a permission.
  ///
  /// Starts from what they plainly already wanted and adds the missing area, so
  /// the new token is a superset rather than a sidegrade that breaks a screen
  /// that used to work.
  static Uri forMissing(Set<String> missingPermissionLabels) {
    final wanted = <Map<String, String>>[...dnsAdmin];
    void add(String key, String type) {
      if (!wanted.any((p) => p['key'] == key)) wanted.add(permission(key, type));
    }

    for (final label in missingPermissionLabels) {
      final lower = label.toLowerCase();
      if (lower.contains('cache')) add('cache', 'purge');
      if (lower.contains('firewall') ||
          lower.contains('waf') ||
          lower.contains('ruleset')) {
        add('firewall_services', 'edit');
      }
      if (lower.contains('analytics')) add('analytics', 'read');
      if (lower.contains('zone settings')) add('zone_settings', 'edit');
      if (lower.contains('page rule')) add('page_rules', 'edit');
      if (lower.contains('ssl') || lower.contains('certificate')) {
        add('ssl_and_certificates', 'edit');
      }
      if (lower.contains('worker') && lower.contains('kv')) {
        add('workers_kv_storage', 'edit');
      } else if (lower.contains('worker') && lower.contains('route')) {
        add('workers_routes', 'edit');
      } else if (lower.contains('worker')) {
        add('workers_scripts', 'edit');
      }
      if (lower.contains('r2')) add('workers_r2', 'edit');
      if (lower.contains('d1')) add('d1', 'edit');
      if (lower.contains('queue')) add('queues', 'edit');
      if (lower.contains('pages')) add('page', 'edit');
      if (lower.contains('access')) add('access', 'edit');
      if (lower.contains('gateway') ||
          lower.contains('teams') ||
          lower.contains('tunnel') ||
          lower.contains('zero trust')) {
        add('teams', 'edit');
      }
    }
    return userToken(wanted);
  }
}
