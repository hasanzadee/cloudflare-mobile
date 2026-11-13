import 'package:cloudflare_mobile/api/generated/generated.dart';
import 'package:cloudflare_mobile/app/theme.dart';
import 'package:cloudflare_mobile/features/dns/dns_editor.dart';
import 'package:cloudflare_mobile/features/dns/dns_providers.dart';
import 'package:cloudflare_mobile/features/zones/zones_providers.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The ranges in the record type table used to be decorative: "abc" or 70000
/// in an SRV port went to Cloudflare as typed and came back as a server error.
void main() {
  WidgetController.hitTestWarningShouldBeFatal = true;

  late List<DnsRecordPost> saved;

  setUp(() => saved = []);

  Future<void> open(
    WidgetTester tester,
    String type, {
    Locale locale = const Locale('en'),
  }) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [dnsProvider.overrideWith(() => _FakeDns(saved))],
        child: MaterialApp(
          theme: buildTheme(mode: Brightness.light),
          locale: locale,
          localizationsDelegates: L.localizationsDelegates,
          supportedLocales: L.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => DnsEditorSheet(
                    zoneId: 'z',
                    zoneName: 'example.com',
                    existing: DnsRecordResponse(
                      id: 'r',
                      type_: type,
                      name: 'example.com',
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  Future<void> fill(WidgetTester tester, Map<String, String> values) async {
    for (final MapEntry(:key, :value) in values.entries) {
      final field = find.widgetWithText(TextField, key);
      await tester.ensureVisible(field);
      await tester.enterText(field, value);
    }
  }

  Future<void> save(WidgetTester tester, [String label = 'Save']) async {
    final button = find.widgetWithText(FilledButton, label);
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  const srv = {
    'Priority': '10',
    'Weight': '60',
    'Port': '5060',
    'Target': 'sip.example.com',
  };

  Map<String, Object?> savedData() =>
      saved.single.data!.toJson().cast<String, Object?>();

  testWidgets('an SRV port above 65535 is refused before it is sent', (
    tester,
  ) async {
    await open(tester, 'SRV');
    await fill(tester, {...srv, 'Port': '70000'});
    await save(tester);

    expect(find.text('Port must be between 0 and 65535'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('text in a number field is refused', (tester) async {
    await open(tester, 'SRV');
    await fill(tester, {...srv, 'Port': 'abc'});
    await save(tester);

    expect(find.text('Port must be a whole number'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('a fraction in a whole-number field is refused', (tester) async {
    await open(tester, 'SRV');
    await fill(tester, {...srv, 'Weight': '1.5'});
    await save(tester);

    expect(find.text('Weight must be a whole number'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('CAA flags above 255 are refused', (tester) async {
    await open(tester, 'CAA');
    await fill(tester, {
      'Flags': '256',
      'Tag': 'issue',
      'Value': 'letsencrypt.org',
    });
    await save(tester);

    expect(find.text('Flags must be between 0 and 255'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('an MX priority above 65535 is refused', (tester) async {
    await open(tester, 'MX');
    await fill(tester, {'Content': 'mail.example.com', 'Priority': '70000'});
    await save(tester);

    expect(find.text('Priority must be between 0 and 65535'), findsOneWidget);
    expect(saved, isEmpty);
  });

  testWidgets('a valid SRV record is saved with numbers, not strings', (
    tester,
  ) async {
    await open(tester, 'SRV');
    await fill(tester, srv);
    await save(tester);

    expect(savedData(), {
      'priority': 10,
      'weight': 60,
      'port': 5060,
      'target': 'sip.example.com',
    });
  });

  testWidgets('LOC seconds take a fraction, with a point or a comma', (
    tester,
  ) async {
    await open(tester, 'LOC');
    await fill(tester, {
      'Latitude degrees': '37',
      'Latitude minutes': '46',
      'Latitude seconds': '46.123',
      'Latitude direction': 'N',
      'Longitude degrees': '122',
      'Longitude minutes': '23',
      'Longitude seconds': '35,5',
      'Longitude direction': 'W',
      'Altitude (m) (optional)': '-12.5',
    });
    await save(tester);

    final data = savedData();
    expect(data['lat_seconds'], 46.123);
    expect(data['long_seconds'], 35.5);
    expect(data['altitude'], -12.5);
  });

  testWidgets('LOC seconds stop below 60', (tester) async {
    await open(tester, 'LOC');
    await fill(tester, {
      'Latitude degrees': '37',
      'Latitude minutes': '46',
      'Latitude seconds': '60',
      'Latitude direction': 'N',
      'Longitude degrees': '122',
      'Longitude minutes': '23',
      'Longitude seconds': '35',
      'Longitude direction': 'W',
    });
    await save(tester);

    expect(
      find.text('Latitude seconds must be between 0 and 59.999'),
      findsOneWidget,
    );
    expect(saved, isEmpty);
  });

  testWidgets('the messages follow the app language', (tester) async {
    await open(tester, 'A', locale: const Locale('de'));
    await save(tester, 'Speichern');

    expect(find.text('Inhalt ist erforderlich'), findsOneWidget);
    expect(saved, isEmpty);
  });
}

class _FakeDns extends DnsController {
  _FakeDns(this.saved);

  final List<DnsRecordPost> saved;

  @override
  Future<PagedData<DnsRecordResponse>> build(String zoneId) async =>
      const PagedData();

  @override
  Future<void> create(DnsRecordPost record) async => saved.add(record);

  @override
  Future<void> edit(String recordId, DnsRecordPost record) async =>
      saved.add(record);
}
