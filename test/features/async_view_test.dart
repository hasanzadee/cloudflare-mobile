import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:cloudflare_mobile/ui/async_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// AsyncView is used two ways: as a whole screen body, and nested inside a
/// page that already scrolls — the analytics charts do the latter. Its loading
/// skeleton was a plain ListView, which in the nested case is a viewport with
/// unbounded height and throws during layout. The screen went red for as long
/// as the request was in flight and then quietly worked, so it only showed up
/// on a slow connection or a cold start.
Widget host(Widget child, {required bool scrolling}) => ProviderScope(
  child: MaterialApp(
    localizationsDelegates: L.localizationsDelegates,
    supportedLocales: L.supportedLocales,
    home: Scaffold(
      body: scrolling
          ? ListView(children: [child])
          : SizedBox.expand(child: child),
    ),
  ),
);

void main() {
  for (final scrolling in [false, true]) {
    final where = scrolling ? 'inside a scrolling page' : 'as a screen body';

    group(where, () {
      testWidgets('loading lays out without throwing', (tester) async {
        await tester.pumpWidget(
          host(
            AsyncView<List<String>>(
              value: const AsyncValue.loading(),
              builder: (d) => const SizedBox.shrink(),
            ),
            scrolling: scrolling,
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);
      });

      testWidgets('data lays out without throwing', (tester) async {
        await tester.pumpWidget(
          host(
            AsyncView<List<String>>(
              value: const AsyncValue.data(['a', 'b']),
              builder: (d) => Column(children: [for (final s in d) Text(s)]),
            ),
            scrolling: scrolling,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('a'), findsOneWidget);
      });

      testWidgets('failure lays out and offers a retry', (tester) async {
        var retried = 0;
        await tester.pumpWidget(
          host(
            AsyncView<List<String>>(
              value: AsyncValue.error(
                const NetworkFailure(NetworkKind.dns),
                StackTrace.empty,
              ),
              onRetry: () => retried++,
              builder: (d) => const SizedBox.shrink(),
            ),
            scrolling: scrolling,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('No internet connection'), findsOneWidget);

        await tester.tap(find.text('Retry'));
        expect(retried, 1);
      });

      testWidgets('the empty state lays out', (tester) async {
        await tester.pumpWidget(
          host(
            AsyncView<List<String>>(
              value: const AsyncValue.data([]),
              isEmpty: (d) => d.isEmpty,
              builder: (d) => const SizedBox.shrink(),
            ),
            scrolling: scrolling,
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Nothing here yet'), findsOneWidget);
      });
    });
  }

  testWidgets('a permission failure names the group to tick', (tester) async {
    await tester.pumpWidget(
      host(
        AsyncView<List<String>>(
          value: AsyncValue.error(
            const PermissionFailure(missingPermissions: {'Zone WAF Read'}),
            StackTrace.empty,
          ),
          builder: (d) => const SizedBox.shrink(),
        ),
        scrolling: false,
      ),
    );
    await tester.pumpAndSettle();

    // The dashboard's own wording, and the fix button that used to be dead
    // code because no caller ever passed onFixPermissions.
    expect(find.text('Zone WAF — Edit'), findsOneWidget);
    expect(find.text('Create a token with this permission'), findsOneWidget);
  });
}
