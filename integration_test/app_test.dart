import 'package:cloudflare_mobile/auth/application/auth_providers.dart';
import 'package:cloudflare_mobile/core/net/cf_client.dart';
import 'package:cloudflare_mobile/core/security/vault.dart';
import 'package:cloudflare_mobile/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Drives the real app on a real device against a mocked Cloudflare.
///
/// This is the end-to-end proof that matters: the actual widget tree, the
/// actual vault writing to Android Keystore-backed storage, the actual
/// interceptor chain and the actual provider graph — everything except the
/// network, which is mocked so the suite needs no Cloudflare account and stays
/// deterministic in CI.
///
/// Only the transport is overridden, via [dioFactoryProvider]. Replacing
/// [cfClientProvider] itself would be easier and would also stub out the
/// wiring that has already broken twice: whether the client is rebuilt when a
/// profile appears.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Every request the app made, in order, for asserting on request bodies.
  late List<RequestOptions> requests;

  // Storage survives between tests on a real device. The vault has to go or
  // the next test starts at the lock screen; preferences have to go too, or a
  // test that changes the language and then fails leaves every later test
  // hunting for English text in a Russian app.
  setUp(() async {
    requests = [];
    await Vault().wipe();
    await (await SharedPreferences.getInstance()).clear();
  });

  Map<String, Object?> envelope(Object? result, {Map<String, Object?>? info}) =>
      {
        'success': true,
        'errors': <Object>[],
        'messages': <Object>[],
        'result': result,
        'result_info': ?info,
      };

  Map<String, Object?> rule({
    required String id,
    required String action,
    required String description,
    bool enabled = true,
  }) => {
    'id': id,
    'version': '3',
    'last_updated': '2026-08-01T10:00:00Z',
    'action': action,
    'expression': '(http.host eq "example.com")',
    'description': description,
    'enabled': enabled,
    'ref': '$id-ref',
    // A key the generated model has no field for. It must survive a toggle.
    'unmodelled_setting': {'nested': 42},
  };

  void script(DioAdapter adapter) {
    adapter
      ..onGet(
        'user/tokens/verify',
        (server) =>
            server.reply(200, envelope({'id': 'tok1', 'status': 'active'})),
      )
      ..onGet(
        'accounts',
        (server) => server.reply(
          200,
          envelope(
            [
              {'id': 'acct1', 'name': 'Personal Account'},
              {'id': 'acct2', 'name': 'Side Project'},
            ],
            info: {'page': 1, 'per_page': 50, 'count': 2, 'total_count': 2},
          ),
        ),
        queryParameters: {'per_page': 50},
      )
      ..onGet(
        'zones',
        (server) => server.reply(
          200,
          envelope(
            [
              {
                'id': 'zone1',
                'name': 'example.com',
                'status': 'active',
                'plan': {'name': 'Free Website'},
              },
              {
                'id': 'zone2',
                'name': 'second.dev',
                'status': 'pending',
                'plan': {'name': 'Free Website'},
              },
            ],
            info: {
              'page': 1,
              'per_page': 50,
              'count': 2,
              'total_count': 2,
              'total_pages': 1,
            },
          ),
        ),
        queryParameters: {'page': 1, 'per_page': 50},
      )
      // The scope bar's zone picker asks for a bigger page and no page number.
      ..onGet(
        'zones',
        (server) => server.reply(
          200,
          envelope(
            [
              {'id': 'zone1', 'name': 'example.com', 'status': 'active'},
              {'id': 'zone2', 'name': 'second.dev', 'status': 'pending'},
            ],
            info: {'page': 1, 'per_page': 100, 'count': 2, 'total_count': 2},
          ),
        ),
        queryParameters: {'per_page': 100},
      )
      ..onGet(
        'zones/zone1/dns_records',
        (server) => server.reply(
          200,
          envelope(
            [
              {
                'id': 'rec1',
                'type': 'A',
                'name': 'example.com',
                'content': '192.0.2.1',
                'ttl': 1,
                'proxied': true,
                'proxiable': true,
              },
              {
                'id': 'rec2',
                'type': 'MX',
                'name': 'example.com',
                'content': 'mail.example.com',
                'priority': 10,
                'ttl': 3600,
              },
            ],
            info: {
              'page': 1,
              'per_page': 100,
              'count': 2,
              'total_count': 2,
              'total_pages': 1,
            },
          ),
        ),
        queryParameters: {'page': 1, 'per_page': 100},
      )
      ..onGet(
        'zones/zone1/rulesets/phases/http_request_firewall_custom/entrypoint',
        (server) => server.reply(
          200,
          envelope({
            'id': 'rs1',
            'name': 'default',
            'phase': 'http_request_firewall_custom',
            'rules': [
              rule(id: 'rule-1', action: 'block', description: 'vault aze'),
              rule(id: 'rule-2', action: 'skip', description: 'skip oidc'),
            ],
          }),
        ),
      )
      ..onGet(
        'zones/zone1/rulesets/phases/http_ratelimit/entrypoint',
        (server) =>
            server.reply(200, envelope({'id': 'rs2', 'rules': <Object>[]})),
      )
      ..onPatch(
        'zones/zone1/rulesets/rs1/rules/rule-1',
        (server) =>
            server.reply(200, envelope({'id': 'rs1', 'rules': <Object>[]})),
        data: Matchers.any,
      )
      ..onPost(
        'zones/zone1/rulesets/rs1/rules',
        (server) =>
            server.reply(200, envelope({'id': 'rs1', 'rules': <Object>[]})),
        data: Matchers.any,
      )
      ..onPost(
        'zones/zone1/dns_records',
        (server) => server.reply(
          200,
          envelope({
            'id': 'rec3',
            'type': 'A',
            'name': 'api.example.com',
            'content': '198.51.100.7',
          }),
        ),
        data: Matchers.any,
      );
  }

  /// A fresh transport per client, each with the full script.
  ///
  /// Per client and not shared, because [cfClientProvider] closes the Dio it
  /// disposes; a shared mock adapter would be torn down with the first one.
  Dio Function() transport() => () {
    final dio = Dio(
      BaseOptions(baseUrl: kCloudflareApiBase, contentType: 'application/json'),
    );
    final adapter = DioAdapter(dio: dio);
    script(adapter);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          handler.next(options);
        },
      ),
    );
    return dio;
  };

  Widget app() => ProviderScope(
    overrides: [
      dioFactoryProvider.overrideWithValue(transport()),
      candidateClientProvider.overrideWithValue(
        (_) => CfClient.raw(transport()()),
      ),
    ],
    child: const CloudflareMobileApp(),
  );

  /// Everything currently on screen, for failure messages. A finder that comes
  /// back empty says nothing about *why*; this says what was there instead.
  String onScreen(WidgetTester tester) => tester
      .widgetList<Text>(find.byType(Text))
      .map((t) => t.data ?? '')
      .where((s) => s.isNotEmpty)
      .join(' | ');

  /// Scrolls a lazy list until the target exists.
  ///
  /// `ListView(children:)` only mounts what fits the viewport plus its cache
  /// extent, so anything below the fold is absent from the tree entirely — a
  /// `find.text` for it comes back empty rather than merely off-screen.
  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  /// Returns the first scrollable to the top.
  ///
  /// Opening a dropdown scrolls its list to show the menu anchor, which can
  /// push what was at the top out of the build cache entirely.
  Future<void> scrollToTop(WidgetTester tester) async {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, 800));
    await tester.pumpAndSettle();
  }

  /// Scrolls the topmost scrollable — the open bottom sheet, when there is one.
  ///
  /// [scrollTo] targets the first scrollable, which is the screen behind the
  /// sheet. A sheet's own list is lazy like any other, so a button below its
  /// fold is absent from the tree, not merely off-screen.
  Future<void> scrollToInSheet(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
  }

  /// Taps, scrolling the target into view first when it lives in a scrollable.
  ///
  /// The emulator runs landscape at 1097x617, where onboarding's button sits
  /// below the fold — and a tap on a widget laid out off-screen lands on
  /// nothing while still reporting success. Every tap goes through here so the
  /// suite says the same thing on a phone, a tablet and CI.
  /// Set [scrollFirst] false for anything pinned to the screen rather than laid
  /// out in a list — a floating action button, a bottom-navigation item.
  ///
  /// A TabBarView is itself a Scrollable, so those widgets do have a scrollable
  /// ancestor, and ensureVisible obligingly scrolls it: the tab slides sideways,
  /// the button it was aiming at goes offstage, and the tap finds nothing. The
  /// quieter version of the same bug put a WAF rule in the rate-limiting
  /// ruleset while the test still passed.
  Future<void> tapAt(
    WidgetTester tester,
    Finder finder, {
    Duration settle = const Duration(seconds: 2),
    bool scrollFirst = true,
  }) async {
    final scrollable = find.ancestor(
      of: finder,
      matching: find.byType(Scrollable),
    );
    if (scrollFirst && scrollable.evaluate().isNotEmpty) {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
    }
    await tester.tap(finder);
    await tester.pumpAndSettle(settle);
  }

  /// Onboards with an API token and a PIN, landing on the app shell.
  Future<void> onboard(WidgetTester tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tapAt(tester, find.text('API token'));

    await tester.enterText(find.byType(TextField).first, 'a-plausible-token');
    await tester.pumpAndSettle();
    await tapAt(
      tester,
      find.text('Verify and continue'),
      settle: const Duration(seconds: 3),
    );

    expect(find.text('Set a PIN'), findsOneWidget);
    final pinFields = find.byType(TextField);
    await tester.enterText(pinFields.at(0), '1234');
    await tester.enterText(pinFields.at(1), '1234');
    await tester.pumpAndSettle();
    // PBKDF2 runs 210k iterations in an isolate; give it room.
    await tapAt(
      tester,
      find.text('Continue'),
      settle: const Duration(seconds: 15),
    );
  }

  Future<void> openTab(WidgetTester tester, String label) => tapAt(
    tester,
    find.text(label).last,
    settle: const Duration(seconds: 3),
    scrollFirst: false,
  );

  testWidgets('home has live data immediately after sign-in', (tester) async {
    await onboard(tester);

    // The reported bug: the shell appeared before a credential existed, the
    // home providers failed against nothing, and nothing re-ran them. It read
    // "problem" and "—" until the app was restarted.
    expect(find.text('problem'), findsNothing);
    expect(find.text('active'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('zones list and DNS records, including MX priority', (
    tester,
  ) async {
    await onboard(tester);
    await openTab(tester, 'Zones');

    expect(find.text('example.com'), findsOneWidget);
    expect(find.text('second.dev'), findsOneWidget);

    await tapAt(
      tester,
      find.text('example.com'),
      settle: const Duration(seconds: 3),
    );

    // Tapping a zone lands on the zone hub, not straight in DNS.
    expect(find.text('example.com'), findsWidgets, reason: onScreen(tester));
    await tapAt(
      tester,
      find.text('DNS').first,
      settle: const Duration(seconds: 3),
    );

    expect(find.text('A'), findsWidgets);
    expect(find.text('MX'), findsWidgets);
    // The prototype dropped MX priority entirely.
    expect(find.textContaining('priority 10'), findsOneWidget);
  });

  testWidgets('creating a DNS record posts what the form was filled with', (
    tester,
  ) async {
    await onboard(tester);
    await openTab(tester, 'Zones');
    await tapAt(
      tester,
      find.text('example.com'),
      settle: const Duration(seconds: 3),
    );
    await tapAt(
      tester,
      find.text('DNS').first,
      settle: const Duration(seconds: 3),
    );

    await tapAt(
      tester,
      find.text('Add record'),
      settle: const Duration(seconds: 2),
    );

    // By label, not by index: the DNS screen has its own search field, and
    // which one `find.byType(TextField).at(n)` lands on is paint order.
    Finder field(String label) =>
        find.ancestor(of: find.text(label), matching: find.byType(TextField));

    await tester.enterText(field('Name'), 'api');
    await tester.enterText(field('Content'), '198.51.100.7');
    await tester.pumpAndSettle();

    await scrollToInSheet(tester, find.text('Save'));
    await tapAt(tester, find.text('Save'), settle: const Duration(seconds: 3));

    final post = requests.lastWhere((r) => r.method == 'POST');
    final body = post.data! as Map<String, Object?>;

    expect(post.path, contains('zones/zone1/dns_records'));
    expect(body['type'], 'A');
    expect(body['name'], 'api');
    expect(body['content'], '198.51.100.7');
    // TTL 1 is Cloudflare's "automatic"; the form defaults there rather than
    // sending nothing, which the API rejects.
    expect(body['ttl'], 1);
  });

  testWidgets('a zone can be chosen from Security without visiting Zones', (
    tester,
  ) async {
    await onboard(tester);
    await openTab(tester, 'Security');

    // Reported bug: the zone chip only existed once a zone was already set,
    // so this screen was a dead end.
    expect(find.text('Pick a zone'), findsWidgets);
    // Two of them: the scope-bar chip and the empty state's button. Either
    // opens the picker; the button is the one a user actually reaches for.
    await tapAt(
      tester,
      find.text('Pick a zone').last,
      settle: const Duration(seconds: 3),
    );
    await tapAt(
      tester,
      find.text('example.com').last,
      settle: const Duration(seconds: 3),
    );

    expect(find.text('vault aze'), findsOneWidget);
    expect(find.text('skip oidc'), findsOneWidget);
  });

  testWidgets('toggling a WAF rule sends the whole rule back', (tester) async {
    await onboard(tester);
    await openTab(tester, 'Security');
    // Two of them: the scope-bar chip and the empty state's button. Either
    // opens the picker; the button is the one a user actually reaches for.
    await tapAt(
      tester,
      find.text('Pick a zone').last,
      settle: const Duration(seconds: 3),
    );
    await tapAt(
      tester,
      find.text('example.com').last,
      settle: const Duration(seconds: 3),
    );

    await tapAt(
      tester,
      find.byType(Switch).first,
      settle: const Duration(seconds: 3),
    );

    final patch = requests.lastWhere((r) => r.method == 'PATCH');
    final body = patch.data! as Map<String, Object?>;

    // Sending only {enabled: false} was rejected: "action is required" and
    // "expression cannot be blank".
    expect(body['enabled'], isFalse);
    expect(body['action'], 'block');
    expect(body['expression'], '(http.host eq "example.com")');
    expect(body['description'], 'vault aze');
    // Fields the model never knew about must not be stripped on the way.
    expect(body['unmodelled_setting'], {'nested': 42});
    // Server-managed fields must not be echoed.
    expect(body.containsKey('version'), isFalse);
    expect(body.containsKey('last_updated'), isFalse);
  });

  testWidgets('a WAF rule can be created from the Security tab', (
    tester,
  ) async {
    await onboard(tester);
    await openTab(tester, 'Security');
    await tapAt(
      tester,
      find.text('Pick a zone').last,
      settle: const Duration(seconds: 3),
    );
    await tapAt(
      tester,
      find.text('example.com').last,
      settle: const Duration(seconds: 3),
    );

    // There was no way to create one at all: the tab listed rules and offered
    // nothing else, so an empty phase was a screen you could only look at.
    //
    // By key, not by label: all three tabs have an "Add" button, and the first
    // version of this test silently created the rule in the rate-limiting
    // ruleset instead.
    const addRule = ValueKey('add-rule-http_request_firewall_custom');
    expect(find.byKey(addRule), findsOneWidget, reason: onScreen(tester));
    await tapAt(
      tester,
      find.byKey(addRule),
      settle: const Duration(seconds: 2),
      scrollFirst: false,
    );

    await tester.enterText(
      find.ancestor(
        of: find.text('Expression'),
        matching: find.byType(TextField),
      ),
      '(ip.src.country ne "AZ")',
    );
    await tester.pumpAndSettle();

    await scrollToInSheet(tester, find.text('Save'));
    await tapAt(tester, find.text('Save'), settle: const Duration(seconds: 3));

    final post = requests.lastWhere((r) => r.method == 'POST');
    final body = post.data! as Map<String, Object?>;

    expect(post.path, contains('rulesets/rs1/rules'));
    expect(body['expression'], '(ip.src.country ne "AZ")');
    expect(body['action'], 'block');
    expect(body['enabled'], isTrue);
  });

  testWidgets('a second credential can be added after setup', (tester) async {
    await onboard(tester);
    await openTab(tester, 'More');
    await tapAt(
      tester,
      find.text('Settings'),
      settle: const Duration(seconds: 3),
    );

    await tapAt(
      tester,
      find.text('Add profile'),
      settle: const Duration(seconds: 2),
    );

    // This used to open the Cloudflare website and end there.
    await tapAt(tester, find.text('API token'));

    await tester.enterText(
      find.ancestor(
        of: find.text('Profile name'),
        matching: find.byType(TextField),
      ),
      'Client',
    );
    await tester.enterText(
      find.ancestor(
        of: find.text('Paste your API token'),
        matching: find.byType(TextField),
      ),
      'a-second-token',
    );
    await tester.pumpAndSettle();

    await scrollToInSheet(tester, find.text('Verify and continue'));
    await tapAt(
      tester,
      find.text('Verify and continue'),
      settle: const Duration(seconds: 5),
    );

    // Back on Settings, listing both. The profiles sit below the appearance
    // section, so the list has to be at the top for both to be built.
    await scrollToTop(tester);
    expect(find.text('Client'), findsOneWidget, reason: onScreen(tester));
    expect(find.text('Cloudflare'), findsOneWidget, reason: onScreen(tester));
  });

  testWidgets('the account picker lists every account', (tester) async {
    await onboard(tester);

    await tapAt(
      tester,
      find.text('All accounts').last,
      settle: const Duration(seconds: 3),
    );

    // Awaiting an autoDispose provider from the callback used to cancel the
    // request before it answered, so the sheet never appeared at all.
    expect(find.text('Personal Account'), findsOneWidget);
    expect(find.text('Side Project'), findsOneWidget);

    await tapAt(tester, find.text('Side Project'));
    // The chip now carries the chosen account.
    expect(find.text('Side Project'), findsOneWidget);
    expect(find.text('All accounts'), findsNothing);
  });

  testWidgets('language and theme can be changed and stick', (tester) async {
    await onboard(tester);
    await openTab(tester, 'More');
    expect(find.text('Settings'), findsOneWidget);
    await tapAt(
      tester,
      find.text('Settings'),
      settle: const Duration(seconds: 3),
    );

    // English is the default regardless of the device locale.
    expect(find.text('Language'), findsOneWidget, reason: onScreen(tester));
    expect(find.text('Theme'), findsOneWidget);

    await tapAt(tester, find.text('English'));
    await tapAt(tester, find.text('Русский').last);
    await scrollToTop(tester);

    expect(find.text('Язык'), findsOneWidget, reason: onScreen(tester));
    expect(find.text('Тема'), findsOneWidget, reason: onScreen(tester));

    // The theme switcher is a SegmentedButton, so its label is also its state.
    await tapAt(tester, find.text('Тёмная'));
    expect(find.text('Тёмная'), findsWidgets);

    // And back, which also proves the switch is not one-way.
    await tapAt(tester, find.text('Русский').first);
    await tapAt(tester, find.text('English').last);
    await scrollToTop(tester);
    expect(find.text('Language'), findsOneWidget, reason: onScreen(tester));
  });

  testWidgets('locking requires the PIN again', (tester) async {
    await onboard(tester);
    await openTab(tester, 'More');
    expect(find.text('Settings'), findsOneWidget);
    await tapAt(
      tester,
      find.text('Settings'),
      settle: const Duration(seconds: 3),
    );

    await scrollTo(tester, find.text('Auto-lock'));
    await scrollTo(tester, find.text('Lock now'));
    await tapAt(
      tester,
      find.text('Lock now'),
      settle: const Duration(seconds: 3),
    );

    expect(
      find.text('Enter your PIN'),
      findsOneWidget,
      reason: onScreen(tester),
    );
    // And the screen we were on is gone, not merely covered. Pushed routes
    // outlive the swap that shows the lock screen, so this is the assertion
    // that matters: the thing being locked away is off the screen.
    expect(find.text('Lock now'), findsNothing);
    expect(find.text('Language'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '9999');
    await tapAt(
      tester,
      find.text('Unlock'),
      settle: const Duration(seconds: 10),
    );
    expect(find.text('Wrong PIN'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '1234');
    await tapAt(
      tester,
      find.text('Unlock'),
      settle: const Duration(seconds: 15),
    );

    // Back in, with data — the client is rebuilt on unlock too.
    expect(find.text('active'), findsOneWidget);
  });

  testWidgets('the API explorer loads the full spec and can search', (
    tester,
  ) async {
    await onboard(tester);

    await openTab(tester, 'More');
    // Parsing 3.6 MB of spec JSON happens in a background isolate.
    await tapAt(
      tester,
      find.text('API explorer'),
      settle: const Duration(seconds: 20),
    );

    // A concrete count proves the whole generated index parsed, not merely
    // that the screen rendered. Matched by shape so a spec refresh does not
    // break the test — the anchors keep it from also matching the search hint.
    expect(find.textContaining(RegExp(r'^\d{3,5} endpoints$')), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'dns_records');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.textContaining('/zones/{zone_id}/dns_records'), findsWidgets);
  });
}
