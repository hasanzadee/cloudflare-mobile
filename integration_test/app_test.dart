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

/// Drives the real app on a real device against a mocked Cloudflare.
///
/// This is the end-to-end proof that matters: the actual widget tree, the
/// actual vault writing to Android Keystore-backed storage, the actual
/// interceptor chain — everything except the network, which is mocked so the
/// suite needs no Cloudflare account and stays deterministic in CI.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Secure storage survives between tests on a real device, so without this
  // the second test would start at the lock screen instead of onboarding.
  setUp(() async {
    await Vault().wipe();
  });

  Map<String, Object?> envelope(Object? result, {Map<String, Object?>? info}) =>
      {
        'success': true,
        'errors': <Object>[],
        'messages': <Object>[],
        'result': result,
        'result_info': ?info,
      };

  /// Builds a client whose transport is a scripted mock.
  (CfClient, DioAdapter) mockedClient() {
    final dio = Dio(
      BaseOptions(baseUrl: kCloudflareApiBase, contentType: 'application/json'),
    );
    final adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    return (CfClient.raw(dio), adapter);
  }

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
            ],
            info: {'page': 1, 'per_page': 50, 'count': 1, 'total_count': 1},
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
      );
  }

  testWidgets('onboard with a token, then browse zones and DNS', (
    tester,
  ) async {
    final (client, adapter) = mockedClient();
    script(adapter);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cfClientProvider.overrideWithValue(client),
          candidateClientProvider.overrideWithValue((_) => client),
        ],
        child: const CloudflareMobileApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // --- onboarding: choose the API token method ---------------------------
    expect(find.text('API token'), findsOneWidget);
    await tester.tap(find.text('API token'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).first,
      'a-token-that-the-mock-will-accept',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Verify and continue'));
    // Token verification plus the PIN screen transition.
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // --- set a PIN ---------------------------------------------------------
    expect(find.text('Set a PIN'), findsOneWidget);
    final pinFields = find.byType(TextField);
    await tester.enterText(pinFields.at(0), '1234');
    await tester.enterText(pinFields.at(1), '1234');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    // PBKDF2 runs 210k iterations in an isolate; give it room.
    await tester.pumpAndSettle(const Duration(seconds: 15));

    // --- we should now be inside the shell --------------------------------
    expect(find.text('Zones'), findsWidgets);

    await tester.tap(find.text('Zones').last);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('example.com'), findsOneWidget);
    expect(find.text('second.dev'), findsOneWidget);

    // --- open a zone and see its records ----------------------------------
    await tester.tap(find.text('example.com'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('A'), findsWidgets);
    expect(find.text('MX'), findsWidgets);
    // The MX priority must be visible; the prototype dropped it entirely.
    expect(find.textContaining('priority 10'), findsOneWidget);
  });

  testWidgets('the API explorer loads the full spec and can search', (
    tester,
  ) async {
    final (client, adapter) = mockedClient();
    script(adapter);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cfClientProvider.overrideWithValue(client),
          candidateClientProvider.overrideWithValue((_) => client),
        ],
        child: const CloudflareMobileApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fast-path through onboarding.
    await tester.tap(find.text('API token'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'token');
    await tester.tap(find.text('Verify and continue'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    final pinFields = find.byType(TextField);
    await tester.enterText(pinFields.at(0), '1234');
    await tester.enterText(pinFields.at(1), '1234');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle(const Duration(seconds: 15));

    // The explorer moved under the "More" tab when Security and Developer
    // took bottom-bar slots.
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text('API explorer'));
    // Parsing 3.6 MB of spec JSON happens in a background isolate.
    await tester.pumpAndSettle(const Duration(seconds: 20));

    // A concrete count proves the whole generated index parsed, not merely
    // that the screen rendered. Matched by shape so a spec refresh does not
    // break the test — the anchors keep it from also matching the search hint.
    expect(find.textContaining(RegExp(r'^\d{3,5} endpoints$')), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'dns_records');
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.textContaining('/zones/{zone_id}/dns_records'), findsWidgets);
  });
}
