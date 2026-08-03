import 'dart:convert';

import 'package:cloudflare_mobile/auth/data/token_template.dart';
import 'package:flutter_test/flutter_test.dart';

/// Two ways this has already shipped broken, both silent.
///
/// First, three invented keys (`dns_records`, `cache_purge`, `waf`). The
/// dashboard drops a key it does not recognise without a word, so the "create a
/// token" link produced a token with no DNS, no cache purge and no firewall.
///
/// Second, and worse because it survived the first fix: the button said
/// "Everything (read + write)" while Cloudflare's template format has no key
/// for Zone WAF at all. The token looked complete and the Security tab still
/// answered "Your credential is missing: Zone WAF Read". A link can only carry
/// the 27 documented keys; anything else has to be shown to the user.
///
/// Keys per
/// developers.cloudflare.com/fundamentals/api/how-to/account-owned-token-template/
void main() {
  /// As `key:type` strings, because Dart's `==` on maps is identity — a
  /// `contains({'key': 'dns', ...})` matcher would pass on nothing at all.
  List<String> decode(Uri uri) {
    final raw = uri.queryParameters['permissionGroupKeys']!;
    return (jsonDecode(raw) as List)
        .cast<Map<String, Object?>>()
        .map((e) => '${e['key']}:${e['type']}')
        .toList();
  }

  CfPermission byGroup(List<CfPermission> list, String group) =>
      list.firstWhere((p) => p.group == group);

  group('permission table', () {
    test('every key is one the dashboard actually accepts', () {
      for (final preset in [
        TokenTemplate.full,
        TokenTemplate.readOnly,
        TokenTemplate.dnsAdmin,
      ]) {
        for (final p in preset.where((p) => !p.isManual)) {
          expect(
            TokenTemplate.allKeys,
            contains(p.key),
            reason: '${p.key} is not a template key the dashboard knows',
          );
          expect(TokenTemplate.types, contains(p.type));
        }
      }
    });

    test('no group appears twice', () {
      final groups = TokenTemplate.full.map((p) => p.group).toList();
      expect(groups.toSet().length, groups.length);
    });

    test('Zone WAF is required, and is known to have no key', () {
      final waf = byGroup(TokenTemplate.full, 'Zone WAF');

      expect(waf.type, 'edit');
      // If Cloudflare ever documents a key for it, this flips and the checklist
      // shrinks by one — which is the good kind of test failure.
      expect(waf.isManual, isTrue);
      expect(TokenTemplate.manualIn(TokenTemplate.full), contains(waf));
    });

    test('every manual entry explains what it unlocks', () {
      for (final p in TokenTemplate.manualIn(TokenTemplate.full)) {
        expect(p.why, isNotNull, reason: '${p.group} has no explanation');
        expect(p.why, isNotEmpty);
      }
    });

    test('full covers writes for every area the app can drive', () {
      final byName = {for (final p in TokenTemplate.full) p.group: p.type};

      expect(byName['DNS'], 'edit');
      expect(byName['Zone'], 'edit');
      expect(byName['Zone Settings'], 'edit');
      expect(byName['Firewall Services'], 'edit');
      expect(byName['Page Rules'], 'edit');
      expect(byName['SSL and Certificates'], 'edit');
      // Purge is its own access level, not `edit`.
      expect(byName['Cache Purge'], 'purge');

      expect(byName['Workers Scripts'], 'edit');
      expect(byName['Workers KV Storage'], 'edit');
      expect(byName['Workers R2 Storage'], 'edit');
      expect(byName['D1'], 'edit');
      expect(byName['Pages'], 'edit');

      expect(byName['Access: Apps and Policies'], 'edit');
      expect(byName['Zero Trust'], 'edit');

      // Listing accounts needs this, and without it nothing can be scoped.
      expect(byName['Account Settings'], 'read');
    });

    test('readOnly asks for no write, and drops purge entirely', () {
      for (final p in TokenTemplate.readOnly) {
        expect(p.type, 'read');
      }
      expect(
        TokenTemplate.readOnly.any((p) => p.group == 'Cache Purge'),
        isFalse,
        reason: 'Cache Purge has no read level — purging is the write',
      );
    });

    test('readOnly is derived, so it cannot fall behind full', () {
      final writable = TokenTemplate.full
          .where((p) => p.type != 'purge')
          .map((p) => p.group)
          .toSet();
      expect(TokenTemplate.readOnly.map((p) => p.group).toSet(), writable);
    });
  });

  group('template URLs', () {
    test('user token carries the documented scope parameters', () {
      final uri = TokenTemplate.userToken(TokenTemplate.full);

      expect(uri.host, 'dash.cloudflare.com');
      expect(uri.path, '/profile/api-tokens');
      expect(uri.queryParameters['accountId'], '*');
      expect(uri.queryParameters['zoneId'], 'all');
      expect(uri.queryParameters['name'], 'Cloudflare Mobile');
    });

    test('account token omits accountId and zoneId', () {
      final uri = TokenTemplate.accountToken(TokenTemplate.full);

      expect(uri.queryParameters['to'], '/:account/api-tokens');
      // The docs are explicit that these break the account-owned form.
      expect(uri.queryParameters.containsKey('accountId'), isFalse);
      expect(uri.queryParameters.containsKey('zoneId'), isFalse);
    });

    test('keyless permissions are left out of the URL, not faked', () {
      final encoded = decode(TokenTemplate.userToken(TokenTemplate.full));
      final keyed = TokenTemplate.full.where((p) => !p.isManual);

      expect(encoded.length, keyed.length);
      for (final p in keyed) {
        expect(encoded, contains('${p.key}:${p.type}'));
      }
      // Nothing resembling the groups that have no key.
      expect(encoded, isNot(contains('waf:edit')));
    });

    test('the checklist names exactly what the URL could not carry', () {
      final text = TokenTemplate.manualChecklist(TokenTemplate.full);

      expect(text, contains('Zone WAF — Edit'));
      expect(text, contains('Turnstile — Read'));
      for (final p in TokenTemplate.manualIn(TokenTemplate.full)) {
        expect(text, contains(p.group));
      }
      // And nothing the link already handled.
      expect(text, isNot(contains('DNS —')));
    });

    test('dnsAdmin stays narrow and needs no checklist', () {
      expect(TokenTemplate.manualIn(TokenTemplate.dnsAdmin), isEmpty);
      expect(decode(TokenTemplate.userToken(TokenTemplate.dnsAdmin)), [
        'zone:read',
        'dns:edit',
        'zone_settings:read',
        'account_settings:read',
      ]);
    });
  });

  group('recovering from a 403', () {
    test('resolves the label Cloudflare screens show to a real group', () {
      // Exactly the string from the failing Security tab.
      final missing = TokenTemplate.resolveMissing({'Zone WAF Read'});

      expect(missing, hasLength(1));
      expect(missing.single.group, 'Zone WAF');
      expect(missing.single.level, 'Edit');
      expect(missing.single.isManual, isTrue);
    });

    test('an unrecognised label still surfaces rather than vanishing', () {
      final missing = TokenTemplate.resolveMissing({
        'Some Future Product Read',
      });

      expect(missing.single.group, 'Some Future Product Read');
    });

    test('two labels for one group collapse to one entry', () {
      final missing = TokenTemplate.resolveMissing({
        'Zone WAF Read',
        'Zone WAF Write',
      });

      expect(missing, hasLength(1));
    });

    test('the fix link grants everything, not just the one that failed', () {
      // A token minted to fix the Security tab must not lose DNS on the way.
      final encoded = decode(TokenTemplate.forMissing({'Zone WAF Read'}));

      expect(encoded, contains('dns:edit'));
      expect(encoded, contains('workers_scripts:edit'));
    });
  });
}
