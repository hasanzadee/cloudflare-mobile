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

/// DNS records
class DnsApi {
  const DnsApi(this._client);

  final CfClient _client;

  /// `GET /zones/{zone_id}/dns_records`
  /// List DNS Records
  Future<CfPage<DnsRecordResponse>> listRecords({
    required String zoneId,
    String? name,
    String? nameExact,
    String? nameContains,
    String? nameStartswith,
    String? nameEndswith,
    String? type_,
    String? content,
    String? contentExact,
    String? contentContains,
    String? contentStartswith,
    String? contentEndswith,
    bool? proxied,
    String? match,
    String? comment,
    String? commentPresent,
    String? commentAbsent,
    String? commentExact,
    String? commentContains,
    String? commentStartswith,
    String? commentEndswith,
    String? tag,
    String? tagPresent,
    String? tagAbsent,
    String? tagExact,
    String? tagContains,
    String? tagStartswith,
    String? tagEndswith,
    String? search,
    String? tagMatch,
    num? page,
    num? perPage,
    String? order,
    String? direction,
    bool? includeShadowMetadata,
    String? shadowedByName,
    String? shadowingName,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/dns_records',
      query: <String, Object?>{
        'name': name,
        'name.exact': nameExact,
        'name.contains': nameContains,
        'name.startswith': nameStartswith,
        'name.endswith': nameEndswith,
        'type': type_,
        'content': content,
        'content.exact': contentExact,
        'content.contains': contentContains,
        'content.startswith': contentStartswith,
        'content.endswith': contentEndswith,
        'proxied': proxied,
        'match': match,
        'comment': comment,
        'comment.present': commentPresent,
        'comment.absent': commentAbsent,
        'comment.exact': commentExact,
        'comment.contains': commentContains,
        'comment.startswith': commentStartswith,
        'comment.endswith': commentEndswith,
        'tag': tag,
        'tag.present': tagPresent,
        'tag.absent': tagAbsent,
        'tag.exact': tagExact,
        'tag.contains': tagContains,
        'tag.startswith': tagStartswith,
        'tag.endswith': tagEndswith,
        'search': search,
        'tag_match': tagMatch,
        'page': page,
        'per_page': perPage,
        'order': order,
        'direction': direction,
        'include_shadow_metadata': includeShadowMetadata,
        'shadowed_by_name': shadowedByName,
        'shadowing_name': shadowingName,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Read'},
    );
    return CfPage.from(env, DnsRecordResponse.fromJson);
  }

  /// `GET /zones/{zone_id}/dns_records/{dns_record_id}`
  /// DNS Record Details
  Future<DnsRecordResponse> getRecord({
    required String zoneId,
    required String dnsRecordId,
    bool? includeShadowMetadata,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/dns_records/$dnsRecordId',
      query: <String, Object?>{
        'include_shadow_metadata': includeShadowMetadata,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Read'},
    );
    return DnsRecordResponse.fromJson(env.resultAsMap);
  }

  /// `POST /zones/{zone_id}/dns_records`
  /// Create DNS Record
  Future<DnsRecordResponse> createRecord({
    required String zoneId,
    required DnsRecordPost body,
    bool? includeShadowMetadata,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'POST',
      path: '/zones/$zoneId/dns_records',
      body: body.toJson(),
      query: <String, Object?>{
        'include_shadow_metadata': includeShadowMetadata,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Write'},
    );
    return DnsRecordResponse.fromJson(env.resultAsMap);
  }

  /// `PUT /zones/{zone_id}/dns_records/{dns_record_id}`
  /// Overwrite DNS Record
  Future<DnsRecordResponse> updateRecord({
    required String zoneId,
    required String dnsRecordId,
    required DnsRecordPost body,
    bool? includeShadowMetadata,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'PUT',
      path: '/zones/$zoneId/dns_records/$dnsRecordId',
      body: body.toJson(),
      query: <String, Object?>{
        'include_shadow_metadata': includeShadowMetadata,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Write'},
    );
    return DnsRecordResponse.fromJson(env.resultAsMap);
  }

  /// `PATCH /zones/{zone_id}/dns_records/{dns_record_id}`
  /// Update DNS Record
  Future<DnsRecordResponse> patchRecord({
    required String zoneId,
    required String dnsRecordId,
    required DnsRecordPatch body,
    bool? includeShadowMetadata,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'PATCH',
      path: '/zones/$zoneId/dns_records/$dnsRecordId',
      body: body.toJson(),
      query: <String, Object?>{
        'include_shadow_metadata': includeShadowMetadata,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Write'},
    );
    return DnsRecordResponse.fromJson(env.resultAsMap);
  }

  /// `DELETE /zones/{zone_id}/dns_records/{dns_record_id}`
  /// Delete DNS Record
  Future<CfEnvelope> deleteRecord({
    required String zoneId,
    required String dnsRecordId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'DELETE',
      path: '/zones/$zoneId/dns_records/$dnsRecordId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Write'},
    );
    return env;
  }

  /// `GET /zones/{zone_id}/dns_records/export`
  /// Export DNS Records
  Future<CfEnvelope> exportBind({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/dns_records/export',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Read'},
      responseType: ResponseType.plain,
    );
    return env;
  }

  /// `POST /zones/{zone_id}/dns_records/import`
  /// Import DNS Records
  Future<DnsRecordsForAZoneImportDnsRecordsResult> importBind({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'POST',
      path: '/zones/$zoneId/dns_records/import',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Write'},
    );
    return DnsRecordsForAZoneImportDnsRecordsResult.fromJson(env.resultAsMap);
  }
}
