import 'package:cloudflare_mobile/app/theme.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:cloudflare_mobile/ui/ds/ds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// v1 wrote zone settings the moment a switch moved, so one stray thumb could
/// turn SSL off for a production zone. The change sheet is what stands in the
/// way now; these pin down that it shows both values and that nothing is
/// confirmed by accident.
void main() {
  final results = <bool>[];
  setUp(results.clear);

  Future<void> open(
    WidgetTester tester, {
    String? typeToConfirm,
    Brightness mode = Brightness.light,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(mode: mode),
        localizationsDelegates: L.localizationsDelegates,
        supportedLocales: L.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () async {
                  results.add(
                    await confirmChanges(
                      context,
                      title: 'Change Encryption mode?',
                      confirmLabel: 'Apply',
                      typeToConfirm: typeToConfirm,
                      changes: const [
                        Change(
                          'Encryption mode',
                          from: 'Flexible',
                          to: 'Full (strict)',
                        ),
                      ],
                    ),
                  );
                },
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

  testWidgets('shows the old and the new value', (tester) async {
    await open(tester);
    expect(find.text('−  Flexible'), findsOneWidget);
    expect(find.text('+  Full (strict)'), findsOneWidget);
  });

  testWidgets('apply confirms, cancel and dismiss do not', (tester) async {
    await open(tester);
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();

    await open(tester);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Dismissing by tapping the scrim must read as "no", not as a null that
    // something downstream might treat differently.
    await open(tester);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(results, [true, false, false]);
  });

  testWidgets('a typed confirmation keeps the button inert until typed', (
    tester,
  ) async {
    await open(tester, typeToConfirm: 'STRICT');

    FilledButton apply() =>
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Apply'));
    expect(apply().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'strict');
    await tester.pump();
    expect(apply().onPressed, isNotNull);
  });

  testWidgets('lays out in dark mode on a small phone', (tester) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await open(tester, mode: Brightness.dark, typeToConfirm: 'STRICT');
    expect(tester.takeException(), isNull);
  });
}
