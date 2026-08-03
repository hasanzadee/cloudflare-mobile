import 'dart:convert';

import 'package:cloudflare_mobile/auth/data/token_template.dart';
import 'package:flutter_test/flutter_test.dart';

/// The dashboard drops permission keys it does not recognise, without a word.
/// Three of the original presets used invented keys (`dns_records`,
/// `cache_purge`, `waf`), so "Create a token" pre-filled a form that quietly
/// lacked DNS, cache and firewall. Nothing about that was visible from the app.
///
/// Keys per
/// developers.cloudflare.com/fundamentals/api/how-to/account-owned-token-template/
void main() {
  List<Map<String, String>> decode(Uri uri) {
    final raw = uri.queryParameters['permissionGroupKeys']!;
    return (jsonDecode(raw) as List)
        .cast<Map<String, Object?>>()
        .map((e) => e.map((k, v) => MapEntry(k, v! as String)))
        .toList();
  }

  test('every preset uses keys the dashboard actually accepts', () {
    for (final preset in [
      TokenTemplate.readOnly,
      TokenTemplate.dnsAdmin,
      TokenTemplate.full,
    ]) {
      for (final p in preset) {
        expect(
          TokenTemplate.allKeys,
          contains(p['key']),
          reason: '${p['key']} is not a template key the dashboard knows',
        );
        expect(TokenTemplate.types, contains(p['type']));
      }
    }
  });

  test('no preset lists the same key twice', () {
    for (final preset in [
      TokenTemplate.readOnly,
      TokenTemplate.dnsAdmin,
      TokenTemplate.full,
    ]) {
      final keys = preset.map((p) => p['key']).toList();
      expect(keys.toSet().length, keys.length);
    }
  });

  test('full covers writes for every area the app can drive', () {
    final byKey = {for (final p in TokenTemplate.full) p['key']!: p['type']!};

    // Zone-level writes.
    expect(byKey['dns'], 'edit');
    expect(byKey['zone'], 'edit');
    expect(byKey['zone_settings'], 'edit');
    expect(byKey['firewall_services'], 'edit');
    expect(byKey['page_rules'], 'edit');
    expect(byKey['ssl_and_certificates'], 'edit');
    // Purge is its own access level, not `edit`.
    expect(byKey['cache'], 'purge');

    // Account-level writes.
    expect(byKey['workers_scripts'], 'edit');
    expect(byKey['workers_kv_storage'], 'edit');
    expect(byKey['workers_r2'], 'edit');
    expect(byKey['d1'], 'edit');
    expect(byKey['page'], 'edit');

    // Zero Trust.
    expect(byKey['access'], 'edit');
    expect(byKey['teams'], 'edit');

    // Listing accounts needs this, and without it the app cannot scope at all.
    expect(byKey['account_settings'], 'read');
  });

  test('readOnly asks for no write anywhere', () {
    for (final p in TokenTemplate.readOnly) {
      expect(p['type'], 'read');
    }
  });

  test('user token URL carries the documented scope parameters', () {
    final uri = TokenTemplate.userToken(TokenTemplate.full);

    expect(uri.host, 'dash.cloudflare.com');
    expect(uri.path, '/profile/api-tokens');
    expect(uri.queryParameters['accountId'], '*');
    expect(uri.queryParameters['zoneId'], 'all');
    expect(uri.queryParameters['name'], 'Cloudflare Mobile');
    expect(decode(uri), TokenTemplate.full);
  });

  test('account token URL omits accountId and zoneId', () {
    final uri = TokenTemplate.accountToken(TokenTemplate.full);

    expect(uri.queryParameters['to'], '/:account/api-tokens');
    // The docs are explicit that these break the account-owned form.
    expect(uri.queryParameters.containsKey('accountId'), isFalse);
    expect(uri.queryParameters.containsKey('zoneId'), isFalse);
    expect(decode(uri), TokenTemplate.full);
  });

  test('forMissing keeps what worked and adds the missing area', () {
    final uri = TokenTemplate.forMissing({
      'Cache Purge',
      'Workers KV Storage Write',
      'Zero Trust Gateway',
    });
    final got = {for (final p in decode(uri)) p['key']!: p['type']!};

    // Still everything dnsAdmin had.
    expect(got['dns'], 'edit');
    expect(got['zone'], 'read');
    // Plus the areas that just 403'd.
    expect(got['cache'], 'purge');
    expect(got['workers_kv_storage'], 'edit');
    expect(got['teams'], 'edit');
  });

  test('forMissing never emits a duplicate key', () {
    final uri = TokenTemplate.forMissing({
      'DNS Write',
      'Cache Purge',
      'Cache Settings',
      'Zone Settings Write',
    });
    final keys = decode(uri).map((p) => p['key']).toList();

    expect(keys.toSet().length, keys.length);
  });

  test('an unknown key is rejected rather than silently shipped', () {
    expect(
      () => TokenTemplate.userToken([
        {'key': 'dns_records', 'type': 'edit'},
      ]),
      throwsA(isA<AssertionError>()),
    );
  });
}
