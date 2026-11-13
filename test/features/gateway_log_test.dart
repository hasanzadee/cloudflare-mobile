import 'package:cloudflare_mobile/core/graphql/graphql_client.dart';
import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:cloudflare_mobile/features/analytics/analytics_providers.dart';
import 'package:cloudflare_mobile/features/zerotrust/gateway_log.dart';
import 'package:cloudflare_mobile/features/zerotrust/gateway_log_providers.dart';
import 'package:cloudflare_mobile/features/zerotrust/gateway_log_screen.dart';
import 'package:cloudflare_mobile/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _group(
  String at,
  String query, {
  int code = 5,
  int count = 1,
  String policy = '',
  List<String> ips = const [],
}) => {
  'count': count,
  'dimensions': {
    'datetime': at,
    'queryName': query,
    'resolverDecision': code,
    'policyName': policy,
    'locationName': 'Office',
    'srcIpCountry': 'AZ',
    'categoryNames': const <String>[],
    'resolvedIps': ips,
  },
};

Map<String, Object?> _answer(List<Map<String, Object?>> groups) => {
  'viewer': {
    'accounts': [
      {'gatewayResolverQueriesAdaptiveGroups': groups},
    ],
  },
};

/// Records every query and answers from a script, one answer per call.
class _FakeGraphQL implements CfGraphQL {
  _FakeGraphQL(this.answers);

  final List<Object> answers;
  final calls = <Map<String, Object?>>[];

  @override
  Future<Map<String, Object?>> query(
    String document, {
    Map<String, Object?> variables = const {},
    CancelToken? cancelToken,
    Set<String> missingPermissions = const {'Analytics Read'},
  }) async {
    calls.add(variables);
    final next = answers.length > 1 ? answers.removeAt(0) : answers.first;
    if (next is Exception) throw next;
    return next as Map<String, Object?>;
  }
}

void main() {
  group('decisions', () {
    test('every documented code lands in a bucket', () {
      expect(dnsDecisionOf(2), DnsDecision.blocked);
      expect(dnsDecisionOf(3), DnsDecision.blocked);
      expect(dnsDecisionOf(6), DnsDecision.blocked);
      expect(dnsDecisionOf(9), DnsDecision.blocked);
      expect(dnsDecisionOf(1), DnsDecision.allowed);
      expect(dnsDecisionOf(5), DnsDecision.allowed);
      expect(dnsDecisionOf(10), DnsDecision.allowed);
      expect(dnsDecisionOf(7), DnsDecision.overridden);
      expect(dnsDecisionOf(8), DnsDecision.overridden);
    });

    test('a code Cloudflare adds later is unknown, not guessed', () {
      expect(dnsDecisionOf(0), DnsDecision.unknown);
      expect(dnsDecisionOf(42), DnsDecision.unknown);
    });

    test('the filter codes agree with the buckets', () {
      for (final MapEntry(key: bucket, value: codes)
          in kDnsDecisionCodes.entries) {
        for (final c in codes) {
          expect(dnsDecisionOf(c), bucket, reason: 'code $c');
        }
      }
    });
  });

  group('parsing', () {
    test('reads a group', () {
      final rows = parseDnsLog(
        _answer([
          _group(
            '2026-11-13T10:00:05Z',
            'ads.example.com',
            code: 3,
            count: 4,
            policy: 'Block ads',
            ips: ['0.0.0.0'],
          ),
        ]),
      );
      expect(rows, hasLength(1));
      final e = rows.single;
      expect(e.query, 'ads.example.com');
      expect(e.decision, DnsDecision.blocked);
      expect(e.count, 4);
      expect(e.policy, 'Block ads');
      expect(e.location, 'Office');
      expect(e.country, 'AZ');
      expect(e.resolvedIps, ['0.0.0.0']);
      expect(e.at, DateTime.utc(2026, 11, 13, 10, 0, 5));
    });

    test('drops malformed groups and keeps the rest', () {
      final rows = parseDnsLog(
        _answer([
          {'count': 1},
          {
            'dimensions': {'datetime': 'nope', 'queryName': 'a.com'},
          },
          {
            'dimensions': {'datetime': '2026-11-13T10:00:00Z'},
          },
          _group('2026-11-13T10:00:00Z', 'ok.example.com'),
        ]),
      );
      expect(rows.map((e) => e.query), ['ok.example.com']);
    });

    test('an answer without the account is empty, not a crash', () {
      expect(parseDnsLog(const {}), isEmpty);
      expect(
        parseDnsLog(const {
          'viewer': {'accounts': <Object>[]},
        }),
        isEmpty,
      );
    });
  });

  group('merging', () {
    DnsLogEntry row(int second, String q, {int count = 1}) => DnsLogEntry(
      at: DateTime.utc(2026, 11, 13, 10, 0, second),
      query: q,
      code: 5,
      count: count,
    );

    test('a re-read row replaces its count instead of duplicating', () {
      final merged = mergeDnsLog(
        [row(1, 'a.com', count: 2)],
        [row(1, 'a.com', count: 5)],
      );
      expect(merged, hasLength(1));
      expect(merged.single.count, 5);
    });

    test('newest first, late rows slot into place', () {
      final merged = mergeDnsLog(
        [row(30, 'c.com'), row(10, 'a.com')],
        [row(20, 'b.com'), row(40, 'd.com')],
      );
      expect(merged.map((e) => e.query), ['d.com', 'c.com', 'b.com', 'a.com']);
    });

    test('stops at the cap, dropping the oldest', () {
      final merged = mergeDnsLog(
        [for (var s = 0; s < 10; s++) row(s, 'q$s.com')],
        [row(59, 'new.com')],
        cap: 3,
      );
      expect(merged.map((e) => e.query), ['new.com', 'q9.com', 'q8.com']);
    });
  });

  group('filter', () {
    final since = DateTime.utc(2026, 11, 13, 10, 0, 0, 123);
    final until = DateTime.utc(2026, 11, 13, 10, 30);

    test('times go out in the form GraphQL accepts', () {
      final f = dnsLogFilter(since: since, until: until);
      expect(f['datetime_geq'], '2026-11-13T10:00:00Z');
      expect(f['datetime_leq'], '2026-11-13T10:30:00Z');
      expect(f.containsKey('resolverDecision_in'), isFalse);
      expect(f.containsKey('queryName_ilike'), isFalse);
    });

    test('a decision filters on the server', () {
      final f = dnsLogFilter(
        since: since,
        until: until,
        decision: DnsDecision.blocked,
      );
      expect(f['resolverDecision_in'], [2, 3, 6, 9]);
    });

    test('search is a case-insensitive substring', () {
      final f = dnsLogFilter(since: since, until: until, search: '  Google ');
      expect(f['queryName_ilike'], '%Google%');
    });
  });

  group('controller', () {
    Future<ProviderContainer> start(_FakeGraphQL fake) async {
      final container = ProviderContainer(
        overrides: [graphqlProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);
      container.listen(dnsLogProvider('acc'), (_, _) {});
      // The first poll is scheduled in a microtask after build.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      return container;
    }

    test('the first poll reads the backlog for the account', () async {
      final fake = _FakeGraphQL([
        _answer([_group('2026-11-13T10:00:00Z', 'a.com')]),
      ]);
      final c = await start(fake);

      final state = c.read(dnsLogProvider('acc'));
      expect(state.loading, isFalse);
      expect(state.entries.map((e) => e.query), ['a.com']);
      expect(fake.calls.single['accountTag'], 'acc');
    });

    test('a later poll re-reads from just before the newest row', () async {
      final fake = _FakeGraphQL([
        _answer([_group('2026-11-13T10:00:00Z', 'a.com')]),
      ]);
      final c = await start(fake);
      await c.read(dnsLogProvider('acc').notifier).refresh();

      final filter = fake.calls.last['filter']! as Map<String, Object?>;
      expect(filter['datetime_geq'], '2026-11-13T09:57:00Z');
    });

    test('changing the filter starts a new log', () async {
      final fake = _FakeGraphQL([
        _answer([_group('2026-11-13T10:00:00Z', 'a.com')]),
        _answer([_group('2026-11-13T10:00:01Z', 'ads.com', code: 2)]),
      ]);
      final c = await start(fake);
      c.read(dnsLogProvider('acc').notifier).setDecision(DnsDecision.blocked);
      await Future<void>.delayed(Duration.zero);

      final state = c.read(dnsLogProvider('acc'));
      expect(state.entries.map((e) => e.query), ['ads.com']);
      final filter = fake.calls.last['filter']! as Map<String, Object?>;
      expect(filter['resolverDecision_in'], [2, 3, 6, 9]);
    });

    test('a GraphQL refusal names the permission to add', () async {
      final fake = _FakeGraphQL([
        ValidationFailure([
          FieldError(
            null,
            "Actor 'x' does not have permission 'com.cloudflare.api."
            "account.analytics.read' for account acc",
            0,
          ),
        ], httpStatus: 200),
      ]);
      final c = await start(fake);

      final error = c.read(dnsLogProvider('acc')).error;
      expect(error, isA<PermissionFailure>());
      expect(
        (error! as PermissionFailure).missingPermissions,
        contains('Account Analytics Read'),
      );
    });

    test('pausing keeps the rows and stops polling', () async {
      final fake = _FakeGraphQL([
        _answer([_group('2026-11-13T10:00:00Z', 'a.com')]),
      ]);
      final c = await start(fake);
      c.read(dnsLogProvider('acc').notifier).pause();

      final state = c.read(dnsLogProvider('acc'));
      expect(state.paused, isTrue);
      expect(state.entries, hasLength(1));
    });
  });

  testWidgets('a row opens its details', (tester) async {
    final fake = _FakeGraphQL([
      _answer([
        _group(
          '2026-11-13T10:00:05Z',
          'tracker.example.net',
          code: 9,
          policy: 'Block trackers',
          ips: ['0.0.0.0'],
        ),
      ]),
    ]);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [graphqlProvider.overrideWithValue(fake)],
        child: MaterialApp(
          localizationsDelegates: L.localizationsDelegates,
          supportedLocales: L.supportedLocales,
          home: const GatewayLogScreen(accountId: 'acc'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('tracker.example.net'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('tracker.example.net'));
    await tester.pumpAndSettle();
    expect(find.text('Block trackers'), findsWidgets);
    expect(find.text('0.0.0.0'), findsOneWidget);

    // Leave the screen so the poll timer is cancelled before the test ends.
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
