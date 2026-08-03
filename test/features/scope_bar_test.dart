import 'package:cloudflare_mobile/api/generated/generated.dart';
import 'package:cloudflare_mobile/core/net/envelope.dart';
import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:cloudflare_mobile/core/net/paginator.dart';
import 'package:cloudflare_mobile/features/scope/scope_providers.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:cloudflare_mobile/ui/scope_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regressions for two defects reported from a real device.
///
/// 1. The zone chip only rendered once a zone was already chosen, and had no
///    tap handler — so every zone-scoped screen was unreachable unless the user
///    happened to visit the Zones tab first.
/// 2. The account picker awaited `accountsProvider.future` from a callback.
///    That provider is autoDispose, so with no listener Riverpod disposed it
///    the moment the read returned a future, `ref.onDispose(token.cancel)` fired
///    and the request died of cancellation. The sheet never opened, silently.
///    Both failure and success now have to render something.
Widget _host({List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: L.localizationsDelegates,
      supportedLocales: L.supportedLocales,
      home: const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: ScopeBar(showZone: true),
        ),
      ),
    ),
  );
}

CfPage<T> _page<T>(List<T> items) =>
    CfPage<T>(items: items, info: CfResultInfo.empty);

void main() {
  final accounts = [
    const Account(id: 'acc-1', name: 'Personal'),
    const Account(id: 'acc-2', name: 'Side project'),
    const Account(id: 'acc-3', name: 'Client work'),
  ];

  testWidgets('zone chip is offered before a zone is chosen', (tester) async {
    await tester.pumpWidget(
      _host(
        overrides: [
          accountsProvider.overrideWith((ref) async => accounts),
          zonePickerProvider.overrideWith(
            (ref, q) async => _page([
              const Zone(id: 'z1', name: 'example.com', status: 'active'),
            ]),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pick a zone'), findsOneWidget);

    await tester.tap(find.text('Pick a zone'));
    await tester.pumpAndSettle();

    expect(find.text('example.com'), findsOneWidget);
  });

  testWidgets('picking a zone updates the chip', (tester) async {
    late WidgetRef captured;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsProvider.overrideWith((ref) async => accounts),
          zonePickerProvider.overrideWith(
            (ref, q) async => _page([
              const Zone(id: 'z1', name: 'example.com', status: 'active'),
            ]),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: L.localizationsDelegates,
          supportedLocales: L.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) {
              captured = ref;
              return const Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: ScopeBar(showZone: true),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pick a zone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('example.com'));
    await tester.pumpAndSettle();

    expect(captured.read(scopeProvider).zoneId, 'z1');
    expect(find.text('example.com'), findsOneWidget);
    expect(find.text('Pick a zone'), findsNothing);
  });

  testWidgets('zone search asks the server rather than filtering the page', (
    tester,
  ) async {
    final asked = <String>[];
    await tester.pumpWidget(
      _host(
        overrides: [
          accountsProvider.overrideWith((ref) async => accounts),
          zonePickerProvider.overrideWith((ref, q) async {
            asked.add(q.search);
            return _page([
              Zone(id: 'z-${q.search}', name: 'match-${q.search}.com'),
            ]);
          }),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pick a zone'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'shop');
    // Debounced: nothing goes out until the user stops typing.
    await tester.pump(const Duration(milliseconds: 100));
    expect(asked, ['']);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(asked, ['', 'shop']);
    expect(find.text('match-shop.com'), findsOneWidget);
  });

  testWidgets('account sheet lists every account', (tester) async {
    await tester.pumpWidget(
      _host(overrides: [accountsProvider.overrideWith((ref) async => accounts)]),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('All accounts').last);
    await tester.pumpAndSettle();

    for (final a in accounts) {
      expect(find.text(a.name!), findsOneWidget);
    }
  });

  testWidgets('account sheet opens and shows the error when listing fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        overrides: [
          accountsProvider.overrideWith(
            (ref) async => throw const AuthFailure(AuthReason.invalid),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('All accounts').last);
    await tester.pumpAndSettle();

    // The sheet is up regardless: a dead button was the original bug.
    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
