import 'package:cloudflare_mobile/auth/application/auth_providers.dart';
import 'package:cloudflare_mobile/auth/domain/cf_credential.dart';
import 'package:cloudflare_mobile/core/net/cf_client.dart';
import 'package:cloudflare_mobile/core/security/vault.dart';
import 'package:cloudflare_mobile/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Walks the v2 screens against a believable fake account, pausing on each so
/// the host can capture it — README and store screenshots without anyone's
/// real zones in them.
///
/// Skipped unless asked for, so CI's `flutter test integration_test` does not
/// spend minutes posing:
///
///     flutter test integration_test/showcase_test.dart \
///       --dart-define=SHOWCASE=true [--dart-define=SHOWCASE_DARK=true]
///
/// It prints `SHOT <name>` and holds the frame for a few seconds; the host
/// script runs `adb exec-out screencap` when it sees the line.
const bool _enabled = bool.fromEnvironment('SHOWCASE');
const bool _dark = bool.fromEnvironment('SHOWCASE_DARK');

const _zones = [
  ('3f1c0a7d2e9b4c6a8f5e1d2c3b4a5968', 'emilll.dev', 'active', 'Free Website'),
  ('8b2e4d6f1a3c5e7092b4d6f8a1c3e5d7', 'parkzone.az', 'active', 'Pro Website'),
  ('c4a6e8f0b2d4f6a8c0e2b4d6f8a0c2e4', 'imaj.az', 'active', 'Free Website'),
  (
    'd1e3f5a7b9c1d3e5f7a9b1c3d5e7f9a1',
    'staging.convertino.app',
    'pending',
    'Free Website',
  ),
];

/// Hourly requests that look like a real day: quiet night, a morning ramp, an
/// afternoon peak, one spike.
List<int> _day(int scale, {int spikeAt = -1}) => [
  for (var h = 0; h < 48; h++)
    (scale *
            (0.35 +
                0.65 *
                    (0.5 +
                        0.5 *
                            (h % 24 >= 7 && h % 24 <= 21
                                ? 1 - ((h % 24) - 15).abs() / 9
                                : -0.6))) *
            (h == spikeAt ? 3.2 : 1))
        .round(),
];

Map<String, Object?> _series(
  String zoneTag,
  List<int> hourly, {
  int threats = 0,
}) {
  final now = DateTime.now().toUtc();
  final top = DateTime.utc(now.year, now.month, now.day, now.hour);
  return {
    'zoneTag': zoneTag,
    'series': [
      for (var i = 0; i < hourly.length; i++)
        {
          'dimensions': {
            'datetime': top
                .subtract(Duration(hours: hourly.length - 1 - i))
                .toIso8601String(),
          },
          'sum': {
            'requests': hourly[i],
            'cachedRequests': (hourly[i] * 0.68).round(),
            'bytes': hourly[i] * 41000,
            'threats': (threats * hourly[i] / 900).round(),
            'pageViews': hourly[i] ~/ 3,
          },
          'uniq': {'uniques': hourly[i] ~/ 9},
        },
    ],
  };
}

Map<String, Object?> _envelope(Object? result, {Map<String, Object?>? info}) =>
    {
      'success': true,
      'errors': <Object>[],
      'messages': <Object>[],
      'result': result,
      'result_info': ?info,
    };

Object? _answer(RequestOptions o) {
  final path = o.path;
  final zone = _zones.first;

  if (path == 'user/tokens/verify') {
    return _envelope({'id': 'tok', 'status': 'active'});
  }
  if (path == 'accounts') {
    return _envelope([
      {'id': 'acct1', 'name': 'Emil'},
    ]);
  }
  if (path == 'zones') {
    return _envelope(
      [
        for (final z in _zones)
          {
            'id': z.$1,
            'name': z.$2,
            'status': z.$3,
            'plan': {'name': z.$4},
          },
      ],
      info: {'page': 1, 'per_page': 50, 'count': 4, 'total_count': 4},
    );
  }
  if (path == 'zones/${zone.$1}') {
    return _envelope({
      'id': zone.$1,
      'name': zone.$2,
      'status': 'active',
      'plan': {'name': zone.$4},
      'account': {'id': 'acct1', 'name': 'Emil'},
      'name_servers': ['dane.ns.cloudflare.com', 'dora.ns.cloudflare.com'],
    });
  }
  if (path == 'zones/${zone.$1}/settings') {
    final values = {
      'ssl': 'flexible',
      'always_use_https': 'off',
      'automatic_https_rewrites': 'on',
      'min_tls_version': '1.2',
      'opportunistic_encryption': 'on',
      'tls_1_3': 'on',
      'cache_level': 'aggressive',
      'browser_cache_ttl': '14400',
      'always_online': 'off',
      'development_mode': 'off',
      'http3': 'on',
      'websockets': 'on',
      'ipv6': 'on',
      'brotli': 'on',
      '0rtt': 'off',
      'security_level': 'medium',
      'browser_check': 'on',
      'email_obfuscation': 'on',
      'hotlink_protection': 'off',
    };
    return _envelope([
      for (final e in values.entries)
        {'id': e.key, 'value': e.value, 'editable': true},
    ]);
  }
  if (path == 'accounts/acct1/cfd_tunnel') {
    return _envelope([
      {'id': 't1', 'name': 'pangea-edge', 'status': 'down'},
      {'id': 't2', 'name': 'home-lab', 'status': 'healthy'},
    ]);
  }
  if (path == 'graphql') {
    final body = o.data is Map ? (o.data as Map)['query'].toString() : '';
    if (body.contains('zoneTag_in')) {
      return {
        'data': {
          'viewer': {
            'zones': [
              _series(_zones[0].$1, _day(900, spikeAt: 40), threats: 266),
              _series(_zones[1].$1, _day(21000)),
              _series(_zones[2].$1, _day(5400)),
              _series(_zones[3].$1, List.filled(48, 0)),
            ],
          },
        },
      };
    }
    final day = _day(900, spikeAt: 40).sublist(24);
    if (body.contains('Breakdown')) {
      final total = day.fold(0, (a, b) => a + b);
      return {
        'data': {
          'viewer': {
            'zones': [
              {
                'totals': [
                  {
                    'sum': {
                      'requests': total,
                      'cachedRequests': (total * 0.68).round(),
                      'bytes': total * 41000,
                      'cachedBytes': total * 30000,
                      'threats': 266,
                      'countryMap': <Object>[],
                      'responseStatusMap': <Object>[],
                      'contentTypeMap': <Object>[],
                    },
                    'uniq': {'uniques': total ~/ 9},
                  },
                ],
              },
            ],
          },
        },
      };
    }
    return {
      'data': {
        'viewer': {
          'zones': [_series(zone.$1, day)],
        },
      },
    };
  }
  return null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Dio transport() {
    final dio = Dio(BaseOptions(baseUrl: kCloudflareApiBase));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, handler) async {
          // A little latency, so skeletons are what the first frame shows
          // rather than a flash of finished content.
          await Future<void>.delayed(const Duration(milliseconds: 250));
          final body = _answer(o);
          handler.resolve(
            Response(
              requestOptions: o,
              statusCode: body == null ? 404 : 200,
              data:
                  body ??
                  {
                    'success': false,
                    'errors': [
                      {'code': 7003, 'message': 'No route'},
                    ],
                    'result': null,
                  },
            ),
            true,
          );
        },
      ),
    );
    return dio;
  }

  Future<void> hold(WidgetTester tester, String name) async {
    // Plain pumps rather than pumpAndSettle: a spinner on screen would keep
    // it from ever settling, and a spinner is sometimes the thing to show.
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 150));
    }
    // ignore: avoid_print
    print('SHOT $name');
    final until = DateTime.now().add(const Duration(seconds: 5));
    while (DateTime.now().isBefore(until)) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  testWidgets('showcase', skip: !_enabled, (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setBool('ui.block_screenshots', false);
    await prefs.setString('ui.theme_mode', _dark ? 'dark' : 'light');

    final vault = Vault();
    await vault.wipe();
    final session = await vault.create(pin: '2468');
    await session.saveProfile(
      const Profile(
        id: 'p1',
        label: 'Emil',
        credential: ApiTokenCredential(id: 'p1', label: 'Emil', token: 'x'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dioFactoryProvider.overrideWithValue(transport)],
        child: const CloudflareMobileApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.enterText(find.byType(TextField), '2468');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle(const Duration(seconds: 6));

    final mode = _dark ? 'dark' : 'light';
    await hold(tester, '$mode-01-pulse');

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
    await hold(tester, '$mode-02-pulse-zones');

    await tester.tap(find.text('emilll.dev').first);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    await hold(tester, '$mode-03-zone');

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -520));
    await hold(tester, '$mode-04-zone-manage');

    await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Switch to Full (strict)'));
    await hold(tester, '$mode-05-change-sheet');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Under attack'));
    await hold(tester, '$mode-06-under-attack');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
