import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/paginator.dart';
import '../analytics/analytics_providers.dart';
import '../scope/scope_providers.dart';

/// Hourly buckets shown on Pulse. The query asks for twice as many so the
/// headline can be compared with the 24 hours before it.
const int kPulseHours = 24;

/// Zones whose traffic is fetched for Pulse.
///
/// GraphQL is billed by complexity, and someone with four hundred zones does
/// not need four hundred sparklines on a phone. The list is the first page the
/// Zones tab would show; the rest are a tap away.
const int kPulseMaxZones = 30;

/// How many zone tags go into one GraphQL request.
const int _kZonesPerQuery = 10;

/// The first page of zones for the scoped account.
final pulseZonesProvider = FutureProvider.autoDispose<CfPage<Zone>>((ref) {
  final accountId = ref.watch(scopeProvider.select((s) => s.accountId));
  return ref
      .watch(cfApiProvider)
      .zones
      .listZones(
        page: 1,
        perPage: 50,
        accountId: accountId,
        cancelToken: autoCancelToken(ref),
      );
});

/// 24 hourly buckets for one zone, plus the total of the 24 before them.
class ZonePulse {
  ZonePulse({
    required this.requests,
    required this.cached,
    required this.threats,
    required this.bytes,
    required this.previousRequests,
  });

  factory ZonePulse.empty() => ZonePulse(
    requests: List.filled(kPulseHours, 0),
    cached: List.filled(kPulseHours, 0),
    threats: List.filled(kPulseHours, 0),
    bytes: List.filled(kPulseHours, 0),
    previousRequests: 0,
  );

  final List<int> requests;
  final List<int> cached;
  final List<int> threats;
  final List<int> bytes;
  final int previousRequests;

  int get totalRequests => requests.fold(0, (a, b) => a + b);
  int get totalCached => cached.fold(0, (a, b) => a + b);
  int get totalThreats => threats.fold(0, (a, b) => a + b);
  int get totalBytes => bytes.fold(0, (a, b) => a + b);
}

/// Traffic for every zone on Pulse, and the account-wide sum of it.
class PulseTraffic {
  PulseTraffic(this.zones) : total = _sum(zones.values);

  final Map<String, ZonePulse> zones;
  final ZonePulse total;

  double get cacheRatio =>
      total.totalRequests == 0 ? 0 : total.totalCached / total.totalRequests;

  /// Change against the previous 24 hours, or null with nothing to compare.
  double? get delta => total.previousRequests == 0
      ? null
      : total.totalRequests / total.previousRequests - 1;

  static ZonePulse _sum(Iterable<ZonePulse> all) {
    final out = ZonePulse.empty();
    var previous = 0;
    for (final z in all) {
      for (var i = 0; i < kPulseHours; i++) {
        out.requests[i] += z.requests[i];
        out.cached[i] += z.cached[i];
        out.threats[i] += z.threats[i];
        out.bytes[i] += z.bytes[i];
      }
      previous += z.previousRequests;
    }
    return ZonePulse(
      requests: out.requests,
      cached: out.cached,
      threats: out.threats,
      bytes: out.bytes,
      previousRequests: previous,
    );
  }
}

/// Zone ids are 32 hex characters. They are written into the query text
/// rather than passed as a variable, so anything else is refused outright.
final RegExp _zoneTag = RegExp(r'^[0-9a-f]{32}$');

/// Requests, cache and threats for several zones in one round trip.
///
/// `zoneTag_in` takes the whole batch, and each zone node carries its own
/// series — the same dataset the per-zone analytics screen reads, so the
/// numbers agree with it.
String pulseQuery(List<String> zoneTags) =>
    '''
query Pulse(\$since: Time!, \$until: Time!) {
  viewer {
    zones(filter: { zoneTag_in: [${zoneTags.map((t) => '"$t"').join(', ')}] }) {
      zoneTag
      series: httpRequests1hGroups(
        limit: ${kPulseHours * 2 + 2}
        filter: { datetime_geq: \$since, datetime_leq: \$until }
        orderBy: [datetime_ASC]
      ) {
        dimensions { datetime }
        sum { requests cachedRequests bytes threats }
      }
    }
  }
}
''';

/// Folds one zone's raw groups into hourly buckets ending at [currentHour].
///
/// Hours with no traffic are absent from the response rather than zero, so
/// position in the list means nothing — each group is placed by its timestamp.
ZonePulse bucketZone(List<Object?> groups, DateTime currentHour) {
  final z = ZonePulse.empty();
  var previous = 0;
  for (final raw in groups) {
    if (raw is! Map) continue;
    final dims = raw['dimensions'];
    final sum = raw['sum'];
    if (dims is! Map || sum is! Map) continue;
    final at = DateTime.tryParse(dims['datetime']?.toString() ?? '')?.toUtc();
    if (at == null) continue;

    final hoursAgo = currentHour.difference(at).inHours;
    int n(String k) => (sum[k] as num?)?.toInt() ?? 0;

    if (hoursAgo >= 0 && hoursAgo < kPulseHours) {
      final i = kPulseHours - 1 - hoursAgo;
      z.requests[i] += n('requests');
      z.cached[i] += n('cachedRequests');
      z.threats[i] += n('threats');
      z.bytes[i] += n('bytes');
    } else if (hoursAgo >= kPulseHours && hoursAgo < kPulseHours * 2) {
      previous += n('requests');
    }
  }
  return ZonePulse(
    requests: z.requests,
    cached: z.cached,
    threats: z.threats,
    bytes: z.bytes,
    previousRequests: previous,
  );
}

final pulseTrafficProvider = FutureProvider.autoDispose<PulseTraffic>((
  ref,
) async {
  final zones = await ref.watch(pulseZonesProvider.future);
  final tags = zones.items
      .map((z) => z.id ?? '')
      .where(_zoneTag.hasMatch)
      .take(kPulseMaxZones)
      .toList();
  if (tags.isEmpty) return PulseTraffic(const {});

  final now = DateTime.now().toUtc();
  final currentHour = DateTime.utc(now.year, now.month, now.day, now.hour);
  final since = currentHour.subtract(
    const Duration(hours: kPulseHours * 2 - 1),
  );
  String iso(DateTime t) => '${t.toIso8601String().split('.').first}Z';

  final graphql = ref.watch(graphqlProvider);
  final cancel = autoCancelToken(ref);
  final batches = [
    for (var i = 0; i < tags.length; i += _kZonesPerQuery)
      tags.sublist(i, (i + _kZonesPerQuery).clamp(0, tags.length)),
  ];

  final results = await Future.wait([
    for (final batch in batches)
      graphql.query(
        pulseQuery(batch),
        variables: {'since': iso(since), 'until': iso(now)},
        cancelToken: cancel,
        missingPermissions: const {'Zone Analytics Read'},
      ),
  ]);

  final out = <String, ZonePulse>{for (final t in tags) t: ZonePulse.empty()};
  for (final data in results) {
    final viewer = data['viewer'];
    final nodes = viewer is Map ? viewer['zones'] : null;
    if (nodes is! List) continue;
    for (final node in nodes) {
      if (node is! Map) continue;
      final tag = node['zoneTag']?.toString();
      final series = node['series'];
      if (tag == null || series is! List) continue;
      out[tag] = bucketZone(series, currentHour);
    }
  }
  return PulseTraffic(out);
});

/// A tunnel that is not serving, with the account it belongs to.
typedef TunnelIncident = ({String accountName, CfdTunnel tunnel});

/// Accounts checked for tunnel health. Each costs a request.
const int _kTunnelAccounts = 5;

/// Tunnels that are down or degraded, across the accounts in scope.
///
/// Best effort by design: a token without Cloudflare Tunnel Read is the normal
/// case for a DNS-only profile, and Pulse should simply have nothing to report
/// rather than show an error for a product the user does not use.
final pulseTunnelIncidentsProvider =
    FutureProvider.autoDispose<List<TunnelIncident>>((ref) async {
      final scope = ref.watch(scopeProvider);
      final api = ref.watch(cfApiProvider);
      final cancel = autoCancelToken(ref);

      final List<({String id, String name})> accounts;
      if (scope.accountId != null) {
        accounts = [
          (id: scope.accountId!, name: scope.accountName ?? scope.accountId!),
        ];
      } else {
        try {
          final all = await ref.watch(accountsProvider.future);
          accounts = [
            for (final a in all.take(_kTunnelAccounts))
              if (a.id != null) (id: a.id!, name: a.name ?? a.id!),
          ];
        } on Object {
          return const [];
        }
      }

      final perAccount = await Future.wait([
        for (final a in accounts)
          api.zeroTrust
              .listTunnels(
                accountId: a.id,
                isDeleted: false,
                perPage: 100,
                cancelToken: cancel,
              )
              .then(
                (page) => [
                  for (final t in page.items)
                    if (t.status == 'down' || t.status == 'degraded')
                      (accountName: a.name, tunnel: t),
                ],
              )
              .catchError((Object _) => <TunnelIncident>[]),
      ]);
      return [for (final list in perAccount) ...list];
    });
