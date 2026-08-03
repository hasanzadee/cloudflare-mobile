import 'dart:convert';

/// One Cloudflare permission group the app needs.
///
/// [group] is the exact wording of the checkbox in the dashboard's token form,
/// because that is the string a user has to find in a dropdown of ~150 entries.
/// [key] is the dashboard's *template* key, which is a different and much
/// smaller namespace — see [TokenTemplate.allKeys]. A null key means the token
/// form cannot pre-select this one and the user must tick it themselves.
class CfPermission {
  const CfPermission(this.group, this.type, {this.key, this.why});

  /// Name shown in the dashboard, e.g. `Zone WAF`.
  final String group;

  /// `read`, `edit` or `purge`.
  final String type;

  /// Template-URL key, or null when no key exists for this group.
  final String? key;

  /// What breaks without it, shown next to the manual checklist.
  final String? why;

  bool get isManual => key == null;

  /// How the dashboard labels the access level next to the group.
  String get level => switch (type) {
    'read' => 'Read',
    'purge' => 'Purge',
    _ => 'Edit',
  };

  @override
  String toString() => '$group — $level';
}

/// Builds Cloudflare dashboard deep links that pre-fill the API token form.
///
/// The template format accepts only the 27 keys in [allKeys], and silently
/// drops anything else, so a link can never cover everything this app touches.
/// Rather than pretend otherwise, [full] carries the whole list and marks the
/// entries the form cannot express; the UI shows those as a checklist.
///
/// Keys per
/// https://developers.cloudflare.com/fundamentals/api/how-to/account-owned-token-template/
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

  static Set<String> get allKeys => {
    ...accountKeys,
    ...zoneKeys,
    ...accessKeys,
  };

  /// Accepted access levels. `edit` means full CRUD, not merely update.
  static const Set<String> types = {'read', 'edit', 'revoke', 'run', 'purge'};

  /// Read and write across every screen this app has.
  ///
  /// Eight of these have no template key. That is not an oversight to fix
  /// later: Cloudflare's template format simply has no key for them, and
  /// inventing one gets it dropped without a word — which is how an earlier
  /// version shipped a "full access" link that produced a token with no DNS.
  static const List<CfPermission> full = [
    // Zone
    CfPermission('Zone', 'edit', key: 'zone'),
    CfPermission('DNS', 'edit', key: 'dns'),
    CfPermission('Zone Settings', 'edit', key: 'zone_settings'),
    CfPermission('Cache Purge', 'purge', key: 'cache'),
    CfPermission('Firewall Services', 'edit', key: 'firewall_services'),
    CfPermission('Page Rules', 'edit', key: 'page_rules'),
    CfPermission('SSL and Certificates', 'edit', key: 'ssl_and_certificates'),
    CfPermission('Zone Analytics', 'read', key: 'analytics'),
    // Account
    CfPermission('Account Settings', 'read', key: 'account_settings'),
    CfPermission('Account Analytics', 'read', key: 'account_analytics'),
    CfPermission('API Tokens', 'read', key: 'account_api_tokens'),
    CfPermission('Workers Scripts', 'edit', key: 'workers_scripts'),
    CfPermission('Workers KV Storage', 'edit', key: 'workers_kv_storage'),
    CfPermission('Workers Routes', 'edit', key: 'workers_routes'),
    CfPermission('Workers R2 Storage', 'edit', key: 'workers_r2'),
    CfPermission('D1', 'edit', key: 'd1'),
    CfPermission('Queues', 'edit', key: 'queues'),
    CfPermission('Pages', 'edit', key: 'page'),
    // Zero Trust
    CfPermission('Access: Apps and Policies', 'edit', key: 'access'),
    CfPermission(
      'Access: Organizations, Identity Providers, and Groups',
      'edit',
      key: 'access_acct',
    ),
    CfPermission('Zero Trust', 'edit', key: 'teams'),

    // No template key exists for any of the following.
    CfPermission('Zone WAF', 'edit', why: 'Custom rules and rate limiting'),
    CfPermission('Cloudflare Tunnel', 'read', why: 'Tunnels and connectors'),
    CfPermission('Email Routing Rules', 'read', why: 'Email routing'),
    CfPermission('Load Balancers', 'read', why: 'Load balancers'),
    CfPermission('Waiting Room', 'read', why: 'Waiting rooms'),
    CfPermission('Turnstile', 'read', why: 'Turnstile widgets'),
    CfPermission('Notifications', 'read', why: 'Alert policies and history'),
    CfPermission('User Details', 'read', why: 'Your profile'),
  ];

  /// Read-only across everything the app can show.
  ///
  /// Derived from [full] so a permission added there cannot be forgotten here.
  /// Cache Purge drops out entirely: it has no read level — purging *is* the
  /// write.
  static List<CfPermission> get readOnly => [
    for (final p in full)
      if (p.type != 'purge')
        CfPermission(p.group, 'read', key: p.key, why: p.why),
  ];

  /// Everything the DNS screens need, and nothing else.
  static const List<CfPermission> dnsAdmin = [
    CfPermission('Zone', 'read', key: 'zone'),
    CfPermission('DNS', 'edit', key: 'dns'),
    CfPermission('Zone Settings', 'read', key: 'zone_settings'),
    CfPermission('Account Settings', 'read', key: 'account_settings'),
  ];

  /// The subset the dashboard form has to be told about by hand.
  static List<CfPermission> manualIn(List<CfPermission> permissions) =>
      permissions.where((p) => p.isManual).toList();

  /// The checklist text, shaped so it can be pasted somewhere useful.
  static String manualChecklist(List<CfPermission> permissions) =>
      manualIn(permissions).map((p) => '${p.group} — ${p.level}').join('\n');

  static List<Map<String, String>> _encode(List<CfPermission> permissions) {
    final out = <Map<String, String>>[];
    for (final p in permissions) {
      final key = p.key;
      if (key == null) continue;
      assert(allKeys.contains(key), 'unknown permission key: $key');
      assert(types.contains(p.type), 'unknown permission type: ${p.type}');
      out.add({'key': key, 'type': p.type});
    }
    return out;
  }

  /// User-owned token, scoped to all accounts and all zones.
  static Uri userToken(
    List<CfPermission> permissions, {
    String name = 'Cloudflare Mobile',
  }) => Uri.parse('$dashboardBase/profile/api-tokens').replace(
    queryParameters: {
      'permissionGroupKeys': jsonEncode(_encode(permissions)),
      'accountId': '*',
      'zoneId': 'all',
      'name': name,
    },
  );

  /// Account-owned token. The dashboard resolves `:account` by asking the user
  /// to pick, which is why no account id is needed here — and why passing one
  /// is explicitly wrong for this form.
  static Uri accountToken(
    List<CfPermission> permissions, {
    String name = 'Cloudflare Mobile',
  }) => Uri.parse(dashboardBase).replace(
    queryParameters: {
      'to': '/:account/api-tokens',
      'permissionGroupKeys': jsonEncode(_encode(permissions)),
      'name': name,
    },
  );

  /// Where to send someone whose token turned out to lack a permission.
  ///
  /// Starts from the full set rather than from what they had: a token created
  /// to fix one 403 should not quietly drop a screen that already worked.
  static Uri forMissing(Set<String> missingPermissionLabels) =>
      userToken(full, name: 'Cloudflare Mobile');

  /// The groups behind a 403, matched to the checklist so the message can name
  /// what to tick rather than only what is missing.
  static List<CfPermission> resolveMissing(Set<String> missingLabels) {
    // Longest match wins. "Zone WAF Read" starts with "Zone" as well as with
    // "Zone WAF", and taking the first hit sent people to the wrong checkbox.
    final candidates = [...full]
      ..sort((a, b) => b.group.length.compareTo(a.group.length));

    final out = <CfPermission>[];
    for (final label in missingLabels) {
      final lower = label.toLowerCase();
      final match = candidates.firstWhere(
        (p) => lower.startsWith(p.group.toLowerCase()),
        orElse: () => CfPermission(label, 'edit'),
      );
      if (!out.any((p) => p.group == match.group)) out.add(match);
    }
    return out;
  }
}
