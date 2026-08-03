import 'dart:convert';
import 'dart:io';

import 'package:cloudflare_mobile/app/app_settings.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:cloudflare_mobile/l10n/supported_languages.dart';
import 'package:flutter_test/flutter_test.dart';

/// Translations rot quietly: a new English string lands, the other locales keep
/// building, and users of those languages get English text mixed in with theirs
/// — or, for a plural, a runtime format error. `flutter gen-l10n` prints a
/// warning nobody reads. This fails the build instead.
void main() {
  final dir = Directory('lib/l10n');

  // Called while collecting tests, so it cannot use expect(): a missing file
  // has to surface as a load failure naming the path.
  Map<String, Object?> load(String locale) {
    final file = File('${dir.path}/app_$locale.arb');
    if (!file.existsSync()) throw StateError('${file.path} is missing');
    return jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  }

  /// Message keys only — `@@locale` and the `@key` metadata blocks are not
  /// translatable content.
  Set<String> messageKeys(Map<String, Object?> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();

  /// Placeholders the template *declares* for a message, from its `@key`
  /// metadata. Scraping `{...}` out of the string instead would also pick up
  /// ICU plural branches — `{No records}` reads as a placeholder named `No`.
  Set<String> declaredPlaceholders(Map<String, Object?> arb, String key) {
    final meta = arb['@$key'];
    if (meta is! Map<String, Object?>) return const {};
    final declared = meta['placeholders'];
    if (declared is! Map<String, Object?>) return const {};
    return declared.keys.toSet();
  }

  final template = load('en');
  final templateKeys = messageKeys(template);
  final locales = kSupportedLanguages.keys.toList();

  test('the app ships every language the picker offers', () {
    for (final code in locales) {
      expect(
        L.supportedLocales.map((l) => l.languageCode),
        contains(code),
        reason: '$code is in the picker but has no generated localization',
      );
    }
    // And nothing extra: a generated locale with no picker entry is
    // unreachable, which is the same bug seen from the other side.
    for (final locale in L.supportedLocales) {
      expect(kSupportedLanguages.keys, contains(locale.languageCode));
    }
  });

  test('English is the fallback and the template', () {
    expect(template['@@locale'], 'en');
    expect(const AppSettings().locale?.languageCode, 'en');
  });

  for (final code in locales.where((c) => c != 'en')) {
    group(code, () {
      final arb = load(code);

      test('declares its own locale', () => expect(arb['@@locale'], code));

      test('translates every key and invents none', () {
        final keys = messageKeys(arb);
        expect(
          templateKeys.difference(keys),
          isEmpty,
          reason: 'missing from app_$code.arb',
        );
        expect(
          keys.difference(templateKeys),
          isEmpty,
          reason: 'present in app_$code.arb but not in the template',
        );
      });

      test('keeps every placeholder the template declares', () {
        for (final key in templateKeys) {
          for (final name in declaredPlaceholders(template, key)) {
            expect(
              arb[key]! as String,
              contains('{$name'),
              reason: '$key drops {$name} in $code — it would throw at runtime',
            );
          }
        }
      });

      test('leaves no string identical to English by accident', () {
        // Two legitimate reasons a translation matches English exactly:
        // Cloudflare product names and acronyms, which are never translated;
        // and ordinary cognates — "Zones", "Tunnels", "Active", "Auto", "Tags"
        // really are spelled that way in French, German and Spanish.
        //
        // What this test is actually for is the other case: a locale file
        // copy-pasted from the template and half-finished. That still fails,
        // because it would light up dozens of keys outside this list.
        const shared = {
          'appTitle',
          'navExplorer',
          'navZeroTrust',
          'navZones',
          'navDeveloper',
          'devWorkers',
          'devPages',
          'd1Query',
          'dnsTitle',
          'dnsTtl',
          'dnsTtlAuto',
          'dnsTags',
          'dnsType',
          'dnsName',
          'lockPin',
          'moreTurnstile',
          'purgeByUrl',
          'purgeByHost',
          'purgeByTag',
          'purgeByPrefix',
          'tlsDnssec',
          'tlsUniversal',
          'trafficPageRules',
          'ztAccess',
          'ztGateway',
          'ztTunnels',
          'authApiToken',
          'authGlobalKey',
          'authGlobalKeyField',
          'settingsThemeSystem',
          'settingsLanguageSystem',
          'analyticsTitle',
          'explorerSubtitle',
          'zonePlan',
          'zonesTitle',
          'zoneStatusActive',
          'scopeZone',
          'securityAction',
          'securityValue',
          'securityExpression',
          'permTitle',
          'commonAll',
        };
        final untranslated = templateKeys
            .where((k) => !shared.contains(k))
            .where((k) => arb[k] == template[k])
            .toList();
        expect(untranslated, isEmpty, reason: 'still English in app_$code.arb');
      });
    });
  }
}
