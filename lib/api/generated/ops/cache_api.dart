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

/// Cache purging
class CacheApi {
  const CacheApi(this._client);

  final CfClient _client;

  /// `POST /zones/{zone_id}/purge_cache`
  /// Purge Cached Content
  Future<ZonePurgeResult> purge({
    required String zoneId,
    required ZonePurgeBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'POST',
      path: '/zones/$zoneId/purge_cache',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Cache Purge'},
    );
    return ZonePurgeResult.fromJson(env.resultAsMap);
  }
}
