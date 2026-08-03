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

/// Workers, Pages, KV, D1 and R2
class WorkersApi {
  const WorkersApi(this._client);

  final CfClient _client;

  /// `GET /accounts/{account_id}/workers/scripts`
  /// List Workers
  Future<CfPage<WorkerScriptListWorkersItem>> listScripts({
    required String accountId,
    String? tags,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/workers/scripts',
      query: <String, Object?>{'tags': tags, ...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Workers Scripts Read'},
    );
    return CfPage.from(_env, WorkerScriptListWorkersItem.fromJson);
  }

  /// `GET /accounts/{account_id}/workers/scripts/{script_name}/settings`
  /// Get Settings
  Future<ScriptAndVersionSettingsItem> getScriptSettings({
    required String accountId,
    required String scriptName,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/workers/scripts/$scriptName/settings',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Workers Scripts Read'},
    );
    return ScriptAndVersionSettingsItem.fromJson(_env.resultAsMap);
  }

  /// `GET /accounts/{account_id}/workers/scripts/{script_name}/schedules`
  /// Get Cron Triggers
  Future<WorkerCronTriggerGetCronTriggersResult> getCronTriggers({
    required String accountId,
    required String scriptName,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/workers/scripts/$scriptName/schedules',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Workers Scripts Read'},
    );
    return WorkerCronTriggerGetCronTriggersResult.fromJson(_env.resultAsMap);
  }

  /// `GET /zones/{zone_id}/workers/routes`
  /// List Routes
  Future<CfPage<Route>> listRoutes({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/workers/routes',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Workers Routes Read'},
    );
    return CfPage.from(_env, Route.fromJson);
  }

  /// `GET /accounts/{account_id}/pages/projects`
  /// Get projects
  Future<CfPage<Project>> listPagesProjects({
    required String accountId,
    int? page,
    int? perPage,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/pages/projects',
      query: <String, Object?>{
        'page': page,
        'per_page': perPage,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Pages Read'},
    );
    return CfPage.from(_env, Project.fromJson);
  }

  /// `GET /accounts/{account_id}/pages/projects/{project_name}/deployments`
  /// Get deployments
  Future<CfPage<Deployment>> listPagesDeployments({
    required String accountId,
    required String projectName,
    String? env,
    int? page,
    int? perPage,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/pages/projects/$projectName/deployments',
      query: <String, Object?>{
        'env': env,
        'page': page,
        'per_page': perPage,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Pages Read'},
    );
    return CfPage.from(_env, Deployment.fromJson);
  }

  /// `GET /accounts/{account_id}/storage/kv/namespaces`
  /// List Namespaces
  Future<CfPage<Namespace>> listKvNamespaces({
    required String accountId,
    num? page,
    num? perPage,
    String? order,
    String? direction,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/storage/kv/namespaces',
      query: <String, Object?>{
        'page': page,
        'per_page': perPage,
        'order': order,
        'direction': direction,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Workers KV Storage Read'},
    );
    return CfPage.from(_env, Namespace.fromJson);
  }

  /// `GET /accounts/{account_id}/d1/database`
  /// List D1 Databases
  Future<CfPage<DatabaseResponse>> listD1Databases({
    required String accountId,
    String? name,
    num? page,
    num? perPage,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/d1/database',
      query: <String, Object?>{
        'name': name,
        'page': page,
        'per_page': perPage,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'D1 Read'},
    );
    return CfPage.from(_env, DatabaseResponse.fromJson);
  }

  /// `POST /accounts/{account_id}/d1/database/{database_id}/query`
  /// Query D1 Database
  Future<CfPage<QueryResultResponse>> queryD1({
    required String accountId,
    required String databaseId,
    required BatchQuery body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'POST',
      path: '/accounts/$accountId/d1/database/$databaseId/query',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'D1 Write'},
    );
    return CfPage.from(_env, QueryResultResponse.fromJson);
  }

  /// `GET /accounts/{account_id}/r2/buckets`
  /// List Buckets
  Future<R2ListBucketsResult> listR2Buckets({
    required String accountId,
    String? nameContains,
    String? startAfter,
    num? perPage,
    String? order,
    String? direction,
    String? cursor,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/r2/buckets',
      query: <String, Object?>{
        'name_contains': nameContains,
        'start_after': startAfter,
        'per_page': perPage,
        'order': order,
        'direction': direction,
        'cursor': cursor,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Workers R2 Storage Read'},
    );
    return R2ListBucketsResult.fromJson(_env.resultAsMap);
  }

  /// `GET /accounts/{account_id}/storage/kv/namespaces/{namespace_id}/keys`
  /// List a Namespace's Keys
  Future<CfPage<Key>> listKvKeys({
    required String accountId,
    required String namespaceId,
    num? limit,
    String? prefix,
    String? cursor,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/storage/kv/namespaces/$namespaceId/keys',
      query: <String, Object?>{
        'limit': limit,
        'prefix': prefix,
        'cursor': cursor,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Workers KV Storage Read'},
    );
    return CfPage.from(_env, Key.fromJson);
  }

  /// `GET /accounts/{account_id}/storage/kv/namespaces/{namespace_id}/values/{key_name}`
  /// Read key-value pair
  Future<CfEnvelope> readKvValue({
    required String accountId,
    required String namespaceId,
    required String keyName,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path:
          '/accounts/$accountId/storage/kv/namespaces/$namespaceId/values/$keyName',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Workers KV Storage Read'},
      responseType: ResponseType.plain,
    );
    return _env;
  }

  /// `PUT /accounts/{account_id}/storage/kv/namespaces/{namespace_id}/values/{key_name}`
  /// Write key-value pair with optional metadata
  Future<CfEnvelope> writeKvValue({
    required String accountId,
    required String namespaceId,
    required String keyName,
    num? expiration,
    num? expirationTtl,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'PUT',
      path:
          '/accounts/$accountId/storage/kv/namespaces/$namespaceId/values/$keyName',
      query: <String, Object?>{
        'expiration': expiration,
        'expiration_ttl': expirationTtl,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Workers KV Storage Write'},
    );
    return _env;
  }

  /// `DELETE /accounts/{account_id}/storage/kv/namespaces/{namespace_id}/values/{key_name}`
  /// Delete key-value pair
  Future<CfEnvelope> deleteKvValue({
    required String accountId,
    required String namespaceId,
    required String keyName,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'DELETE',
      path:
          '/accounts/$accountId/storage/kv/namespaces/$namespaceId/values/$keyName',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Workers KV Storage Write'},
    );
    return _env;
  }

  /// `PUT /accounts/{account_id}/workers/scripts/{script_name}/schedules`
  /// Update Cron Triggers
  Future<WorkerCronTriggerUpdateCronTriggersResult> updateCronTriggers({
    required String accountId,
    required String scriptName,
    required List<Schedule> body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'PUT',
      path: '/accounts/$accountId/workers/scripts/$scriptName/schedules',
      body: body,
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Workers Scripts Write'},
    );
    return WorkerCronTriggerUpdateCronTriggersResult.fromJson(_env.resultAsMap);
  }

  /// `POST /accounts/{account_id}/pages/projects/{project_name}/deployments/{deployment_id}/retry`
  /// Retry deployment
  Future<Deployment> retryDeployment({
    required String accountId,
    required String projectName,
    required String deploymentId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'POST',
      path:
          '/accounts/$accountId/pages/projects/$projectName/deployments/$deploymentId/retry',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Pages Write'},
    );
    return Deployment.fromJson(_env.resultAsMap);
  }

  /// `POST /accounts/{account_id}/pages/projects/{project_name}/deployments/{deployment_id}/rollback`
  /// Rollback deployment
  Future<Deployment> rollbackDeployment({
    required String accountId,
    required String projectName,
    required String deploymentId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'POST',
      path:
          '/accounts/$accountId/pages/projects/$projectName/deployments/$deploymentId/rollback',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Pages Write'},
    );
    return Deployment.fromJson(_env.resultAsMap);
  }
}
