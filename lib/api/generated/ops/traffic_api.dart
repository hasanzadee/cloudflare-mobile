// GENERATED CODE — DO NOT EDIT BY HAND.
//
// Produced by tool/openapi/generate.dart from spec/openapi.json.
// Re-run `dart run tool/openapi/generate.dart` after changing the spec or
// tool/openapi/allowlist.yaml.

import 'package:dio/dio.dart';

import '../../../core/net/cf_client.dart';
import '../../../core/net/envelope.dart';
import '../../../core/net/paginator.dart';
import '../models.dart';

/// Page rules, load balancing and waiting rooms
class TrafficApi {
  const TrafficApi(this._client);

  final CfClient _client;

  /// `GET /zones/{zone_id}/pagerules`
  /// List Page Rules
  Future<CfPage<PageRule>> listPageRules({
    required String zoneId,
    String? order,
    String? direction,
    String? match,
    String? status,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/pagerules',
      query: <String, Object?>{
        'order': order,
        'direction': direction,
        'match': match,
        'status': status,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Page Rules Read'},
    );
    return CfPage.from(_env, PageRule.fromJson);
  }

  /// `PATCH /zones/{zone_id}/pagerules/{pagerule_id}`
  /// Edit a Page Rule
  Future<PageRule> editPageRule({
    required String zoneId,
    required String pageruleId,
    required PageRulesEditAPageRuleBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'PATCH',
      path: '/zones/$zoneId/pagerules/$pageruleId',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Page Rules Write'},
    );
    return PageRule.fromJson(_env.resultAsMap);
  }

  /// `DELETE /zones/{zone_id}/pagerules/{pagerule_id}`
  /// Delete a Page Rule
  Future<PageRulesDeleteAPageRuleResult> deletePageRule({
    required String zoneId,
    required String pageruleId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'DELETE',
      path: '/zones/$zoneId/pagerules/$pageruleId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Page Rules Write'},
    );
    return PageRulesDeleteAPageRuleResult.fromJson(_env.resultAsMap);
  }

  /// `GET /zones/{zone_id}/load_balancers`
  /// List Load Balancers
  Future<CfPage<LoadBalancer>> listLoadBalancers({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/load_balancers',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Load Balancers Read'},
    );
    return CfPage.from(_env, LoadBalancer.fromJson);
  }

  /// `GET /accounts/{account_id}/load_balancers/pools`
  /// List Pools
  Future<CfPage<Pool>> listPools({
    required String accountId,
    String? monitor,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/load_balancers/pools',
      query: <String, Object?>{'monitor': monitor, ...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Load Balancers Read'},
    );
    return CfPage.from(_env, Pool.fromJson);
  }

  /// `GET /accounts/{account_id}/load_balancers/monitors`
  /// List Monitors
  Future<CfPage<Monitor>> listMonitors({
    required String accountId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/load_balancers/monitors',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Load Balancers Read'},
    );
    return CfPage.from(_env, Monitor.fromJson);
  }

  /// `GET /zones/{zone_id}/waiting_rooms`
  /// List waiting rooms for zone
  Future<CfPage<Waitingroom>> listWaitingRooms({
    required String zoneId,
    num? page,
    num? perPage,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/waiting_rooms',
      query: <String, Object?>{
        'page': page,
        'per_page': perPage,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Waiting Room Read'},
    );
    return CfPage.from(_env, Waitingroom.fromJson);
  }
}
