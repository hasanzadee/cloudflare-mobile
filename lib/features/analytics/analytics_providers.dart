import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import '../../core/graphql/graphql_client.dart';
import '../../core/net/failure.dart';
import '../scope/scope_providers.dart';
import 'analytics_denials.dart';
import 'analytics_models.dart';
import 'analytics_queries.dart';

final graphqlProvider = Provider<CfGraphQL>(
  (ref) => CfGraphQL(ref.watch(cfClientProvider)),
);

/// Runs an analytics query, turning a GraphQL-shaped refusal into the
/// [PermissionFailure] every other screen already knows how to explain — with
/// the missing permission named and a link to re-issue the token.
Future<Map<String, Object?>> _analytics(
  Ref ref,
  String document,
  Map<String, Object?> variables,
) async {
  try {
    return await ref
        .watch(graphqlProvider)
        .query(
          document,
          variables: variables,
          cancelToken: autoCancelToken(ref),
        );
  } on CfFailure catch (e) {
    if (e is! PermissionFailure && isAnalyticsDenied(e)) {
      throw PermissionFailure(
        missingPermissions: const {'Zone Analytics Read'},
        errors: e.errors,
        httpStatus: e.httpStatus,
        requestPath: e.requestPath,
      );
    }
    rethrow;
  }
}

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
      final data = await _analytics(ref, trafficQuery(key.range), _vars(key));
      return TrafficPoint.listFrom(data);
    });

final trafficSummaryProvider = FutureProvider.autoDispose
    .family<TrafficSummary, AnalyticsKey>((ref, key) async {
      final data = await _analytics(ref, breakdownQuery(key.range), _vars(key));
      return TrafficSummary.fromJson(data);
    });

/// Firewall activity is only available at datetime resolution, so it always
/// asks in hours regardless of the selected bucket.
final firewallEventsProvider = FutureProvider.autoDispose
    .family<List<FirewallEvent>, AnalyticsKey>((ref, key) async {
      final since = DateTime.now().toUtc().subtract(
        Duration(hours: key.range.hours),
      );
      final data = await _analytics(ref, firewallEventsQuery, {
        'zoneTag': key.zoneId,
        'since': '${since.toIso8601String().split('.').first}Z',
        'until':
            '${DateTime.now().toUtc().toIso8601String().split('.').first}Z',
      });
      return FirewallEvent.listFrom(data);
    });
