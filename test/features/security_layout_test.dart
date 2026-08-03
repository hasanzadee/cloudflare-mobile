import 'package:cloudflare_mobile/api/generated/generated.dart';
import 'package:cloudflare_mobile/auth/application/auth_providers.dart';
import 'package:cloudflare_mobile/features/scope/scope_providers.dart';
import 'package:cloudflare_mobile/features/security/security_providers.dart';
import 'package:cloudflare_mobile/features/security/security_screen.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The rules list at the screen size CI runs, and smaller.
///
/// A WAF rule tile overflowed by 7 pixels on a 360x640 device — four on-device
/// tests failed on it, and the reported widget was already disposed by the time
/// Flutter tried to name it, so the log said only "RenderFlex overflowed".
///
/// This pins the layout at a fixed surface instead. It runs in `flutter test`
/// in seconds rather than in the 20-minute emulator job, and it fails with the
/// widget still alive, so the next one names itself.
class _FakeAuth extends AuthController {
  @override
  Future<AuthState> build() async =>
      const AuthState(status: AuthStatus.unlocked);
}

Map<String, Object?> _rule({
  required String id,
  required String action,
  required String description,
  required String expression,
}) => {
  'id': id,
  'version': '1',
  'action': action,
  'description': description,
  'expression': expression,
  'enabled': true,
};

void main() {
  /// Real rules, including one long enough to wrap several times — which is
  /// what an expression looks like once someone lists a handful of hostnames.
  final ruleset = GetZoneEntrypointRulesetResult.fromJson({
    'id': 'rs1',
    'phase': 'http_request_firewall_custom',
    'rules': [
      _rule(
        id: 'r1',
        action: 'block',
        description: 'test-restrict',
        expression:
            '(http.host in {"test.example.com" "testadmin.example.com" '
            '"testadminapi.example.com" "testcrons.example.com" '
            '"testterminal.example.com" "panel.example.com"}) '
            'and (ip.src ne 203.0.113.7)',
      ),
      _rule(
        id: 'r2',
        action: 'skip',
        description: 'skip-managed-oidc-callback',
        expression:
            '(http.host eq "docs.example.com" and http.request.uri.path in '
            '{"/signin-oidc" "/signout-callback-oidc" "/signout-oidc"})',
      ),
    ],
  });

  Future<void> pumpSecurity(WidgetTester tester, Size logical) async {
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = logical * 3;
    addTearDown(tester.view.reset);

    late WidgetRef captured;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_FakeAuth.new),
          phaseRulesProvider.overrideWith((ref, key) async => ruleset),
        ],
        child: MaterialApp(
          localizationsDelegates: L.localizationsDelegates,
          supportedLocales: L.supportedLocales,
          home: Consumer(
            builder: (context, ref, _) {
              captured = ref;
              return const SecurityScreen();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    captured.read(scopeProvider.notifier).setZone('zone1', 'example.com');
    await tester.pumpAndSettle();
  }

  // 360x640 is the CI emulator. The others are a small phone and a large one:
  // the tile has to survive both a narrow column and a wide one.
  for (final size in const [Size(360, 640), Size(320, 568), Size(412, 915)]) {
    testWidgets(
      'rules lay out at ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        await pumpSecurity(tester, size);

        expect(
          tester.takeException(),
          isNull,
          reason: 'a RenderFlex overflowed at $size',
        );
        expect(find.text('test-restrict'), findsOneWidget);
        expect(find.text('skip-managed-oidc-callback'), findsOneWidget);
      },
    );
  }

  // The empty state is a column of fixed-height children — icon, message,
  // button — and CI reported a 7px overflow from a min-sized vertical flex
  //256 logical pixels wide, which is a 320dp screen minus this padding.
  for (final size in const [Size(320, 480), Size(320, 568), Size(360, 640)]) {
    testWidgets(
      'the pick-a-zone prompt fits at ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        tester.view.devicePixelRatio = 3;
        tester.view.physicalSize = size * 3;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authProvider.overrideWith(_FakeAuth.new),
              phaseRulesProvider.overrideWith((ref, key) async => ruleset),
            ],
            child: MaterialApp(
              localizationsDelegates: L.localizationsDelegates,
              supportedLocales: L.supportedLocales,
              home: const SecurityScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Pick a zone'), findsWidgets);
        expect(
          tester.takeException(),
          isNull,
          reason: 'the empty state overflowed at $size',
        );
      },
    );
  }

  testWidgets('the add-rule button is reachable on the smallest screen', (
    tester,
  ) async {
    await pumpSecurity(tester, const Size(320, 568));

    expect(
      find.byKey(const ValueKey('add-rule-http_request_firewall_custom')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
