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

/// Tunnels, Access and Gateway
class ZeroTrustApi {
  const ZeroTrustApi(this._client);

  final CfClient _client;

  /// `GET /accounts/{account_id}/cfd_tunnel`
  /// List Cloudflare Tunnels
  Future<CfPage<CfdTunnel>> listTunnels({
    required String accountId,
    String? name,
    bool? isDeleted,
    String? existedAt,
    String? uuid,
    String? wasActiveAt,
    String? wasInactiveAt,
    String? includePrefix,
    String? excludePrefix,
    String? status,
    num? perPage,
    num? page,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/cfd_tunnel',
      query: <String, Object?>{
        'name': name,
        'is_deleted': isDeleted,
        'existed_at': existedAt,
        'uuid': uuid,
        'was_active_at': wasActiveAt,
        'was_inactive_at': wasInactiveAt,
        'include_prefix': includePrefix,
        'exclude_prefix': excludePrefix,
        'status': status,
        'per_page': perPage,
        'page': page,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Cloudflare Tunnel Read'},
    );
    return CfPage.from(_env, CfdTunnel.fromJson);
  }

  /// `GET /accounts/{account_id}/cfd_tunnel/{tunnel_id}`
  /// Get a Cloudflare Tunnel
  Future<CfdTunnel> getTunnel({
    required String accountId,
    required String tunnelId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/cfd_tunnel/$tunnelId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Cloudflare Tunnel Read'},
    );
    return CfdTunnel.fromJson(_env.resultAsMap);
  }

  /// `GET /accounts/{account_id}/cfd_tunnel/{tunnel_id}/connections`
  /// List Cloudflare Tunnel connections
  Future<CfPage<TunnelClient>> listTunnelConnections({
    required String accountId,
    required String tunnelId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/cfd_tunnel/$tunnelId/connections',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Cloudflare Tunnel Read'},
    );
    return CfPage.from(_env, TunnelClient.fromJson);
  }

  /// `GET /accounts/{account_id}/access/apps`
  /// List Access applications
  Future<CfPage<AppResponse>> listAccessApps({
    required String accountId,
    String? name,
    String? domain,
    String? aud,
    String? targetAttributes,
    bool? exact,
    String? search,
    int? page,
    int? perPage,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/access/apps',
      query: <String, Object?>{
        'name': name,
        'domain': domain,
        'aud': aud,
        'target_attributes': targetAttributes,
        'exact': exact,
        'search': search,
        'page': page,
        'per_page': perPage,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Access Apps and Policies Read'},
    );
    return CfPage.from(_env, AppResponse.fromJson);
  }

  /// `GET /accounts/{account_id}/access/apps/{app_id}/policies`
  /// List Access application policies
  Future<CfPage<AppPolicyResponse>> listAccessPolicies({
    required String accountId,
    required String appId,
    int? page,
    int? perPage,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/access/apps/$appId/policies',
      query: <String, Object?>{
        'page': page,
        'per_page': perPage,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Access Apps and Policies Read'},
    );
    return CfPage.from(_env, AppPolicyResponse.fromJson);
  }

  /// `GET /accounts/{account_id}/gateway/rules`
  /// List Zero Trust Gateway rules
  Future<CfPage<Rules>> listGatewayRules({
    required String accountId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/gateway/rules',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zero Trust Read'},
    );
    return CfPage.from(_env, Rules.fromJson);
  }
}
