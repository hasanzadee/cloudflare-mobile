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

/// Certificates, custom hostnames and DNSSEC
class TlsApi {
  const TlsApi(this._client);

  final CfClient _client;

  /// `GET /zones/{zone_id}/ssl/certificate_packs`
  /// List Certificate Packs
  Future<CfPage<CertificatePack>> listCertificatePacks({
    required String zoneId,
    num? page,
    num? perPage,
    String? status,
    String? deploy,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/ssl/certificate_packs',
      query: <String, Object?>{
        'page': page,
        'per_page': perPage,
        'status': status,
        'deploy': deploy,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'SSL and Certificates Read'},
    );
    return CfPage.from(_env, CertificatePack.fromJson);
  }

  /// `GET /zones/{zone_id}/ssl/universal/settings`
  /// Universal SSL Settings Details
  Future<Universal> getUniversalSsl({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/ssl/universal/settings',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'SSL and Certificates Read'},
    );
    return Universal.fromJson(_env.resultAsMap);
  }

  /// `PATCH /zones/{zone_id}/ssl/universal/settings`
  /// Edit Universal SSL Settings
  Future<Universal> editUniversalSsl({
    required String zoneId,
    required Universal body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'PATCH',
      path: '/zones/$zoneId/ssl/universal/settings',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'SSL and Certificates Write'},
    );
    return Universal.fromJson(_env.resultAsMap);
  }

  /// `GET /zones/{zone_id}/ssl/verification`
  /// SSL Verification Details
  Future<CfEnvelope> getSslVerification({
    required String zoneId,
    bool? retry,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/ssl/verification',
      query: <String, Object?>{'retry': retry, ...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'SSL and Certificates Read'},
    );
    return _env;
  }

  /// `GET /zones/{zone_id}/custom_hostnames`
  /// List Custom Hostnames
  Future<CfPage<CustomHostname>> listCustomHostnames({
    required String zoneId,
    String? hostname,
    String? hostnameExact,
    String? hostnameStartsWith,
    String? hostnameContain,
    String? id,
    num? page,
    num? perPage,
    String? order,
    String? direction,
    String? sslStatus,
    String? hostnameStatus,
    String? certificateAuthority,
    bool? wildcard,
    String? customOriginServer,
    int? ssl,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/custom_hostnames',
      query: <String, Object?>{
        'hostname': hostname,
        'hostname.exact': hostnameExact,
        'hostname.startsWith': hostnameStartsWith,
        'hostname.contain': hostnameContain,
        'id': id,
        'page': page,
        'per_page': perPage,
        'order': order,
        'direction': direction,
        'ssl_status': sslStatus,
        'hostname_status': hostnameStatus,
        'certificate_authority': certificateAuthority,
        'wildcard': wildcard,
        'custom_origin_server': customOriginServer,
        'ssl': ssl,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'SSL and Certificates Read'},
    );
    return CfPage.from(_env, CustomHostname.fromJson);
  }

  /// `GET /zones/{zone_id}/dnssec`
  /// DNSSEC Details
  Future<Dnssec> getDnssec({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/dnssec',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Read'},
    );
    return Dnssec.fromJson(_env.resultAsMap);
  }

  /// `PATCH /zones/{zone_id}/dnssec`
  /// Edit DNSSEC Status
  Future<Dnssec> editDnssec({
    required String zoneId,
    required DnssecEditDnssecStatusBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'PATCH',
      path: '/zones/$zoneId/dnssec',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'DNS Write'},
    );
    return Dnssec.fromJson(_env.resultAsMap);
  }
}
