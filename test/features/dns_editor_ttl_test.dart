import 'package:cloudflare_mobile/api/generated/generated.dart';
import 'package:cloudflare_mobile/app/theme.dart';
import 'package:cloudflare_mobile/features/dns/dns_editor.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The editor used to show "Auto" for any TTL outside its short list, so a
/// record set to 4 h in the dashboard looked automatic while it was not.
void main() {
  Future<void> open(WidgetTester tester, num ttl) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildTheme(mode: Brightness.light),
          localizationsDelegates: L.localizationsDelegates,
          supportedLocales: L.supportedLocales,
          home: Scaffold(
            body: DnsEditorSheet(
              zoneId: 'z',
              zoneName: 'example.com',
              existing: DnsRecordResponse(
                id: 'r',
                type_: 'A',
                name: 'www.example.com',
                content: '192.0.2.1',
                ttl: ttl,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a TTL outside the choices is shown, not passed off as Auto', (
    tester,
  ) async {
    await open(tester, 14400);
    expect(find.text('4 h'), findsOneWidget);
    expect(find.text('Auto'), findsNothing);
  });

  testWidgets('the dashboard\'s 15 min choice is shown as itself', (
    tester,
  ) async {
    await open(tester, 900);
    expect(find.text('15 min'), findsOneWidget);
    expect(find.text('Auto'), findsNothing);
  });
}
