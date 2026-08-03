import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../core/graphql/graphql_client.dart';
import '../scope/scope_providers.dart';
import 'analytics_models.dart';
import 'analytics_queries.dart';

final graphqlProvider = Provider<CfGraphQL>(
  (ref) => CfGraphQL(ref.watch(cfClientProvider)),
);

final analyticsRangeProvider = StateProvider<AnalyticsRange>(
  (ref) => AnalyticsRange.last24h,
);

typedef AnalyticsKey = ({String zoneId, AnalyticsRange range});

Map<String, Object?> _vars(AnalyticsKey key) => {
  'zoneTag': key.zoneId,
  'since': key.range.sinceParam,
  'until': key.range.untilParam,
};

final trafficSeriesProvider = FutureProvider.autoDispose
    .family<List<TrafficPoint>, AnalyticsKey>((ref, key) async {
      final data = await ref
          .watch(graphqlProvider)
          .query(
            trafficQuery(key.range),
            variables: _vars(key),
            cancelToken: autoCancelToken(ref),
          );
      return TrafficPoint.listFrom(data);
    });

final trafficSummaryProvider = FutureProvider.autoDispose
    .family<TrafficSummary, AnalyticsKey>((ref, key) async {
      final data = await ref
          .watch(graphqlProvider)
          .query(
            breakdownQuery(key.range),
            variables: _vars(key),
            cancelToken: autoCancelToken(ref),
          );
      return TrafficSummary.fromJson(data);
    });

/// Firewall activity is only available at datetime resolution, so it always
/// asks in hours regardless of the selected bucket.
final firewallEventsProvider = FutureProvider.autoDispose
    .family<List<FirewallEvent>, AnalyticsKey>((ref, key) async {
      final since = DateTime.now().toUtc().subtract(
        Duration(hours: key.range.hours),
      );
      final data = await ref
          .watch(graphqlProvider)
          .query(
            firewallEventsQuery,
            variables: {
              'zoneTag': key.zoneId,
              'since': '${since.toIso8601String().split('.').first}Z',
              'until':
                  '${DateTime.now().toUtc().toIso8601String().split('.').first}Z',
            },
            cancelToken: autoCancelToken(ref),
          );
      return FirewallEvent.listFrom(data);
    });
