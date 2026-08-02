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

/// Zones and zone-level settings
class ZonesApi {
  const ZonesApi(this._client);

  final CfClient _client;

  /// `GET /zones`
  /// List Zones
  Future<CfPage<Zone>> listZones({
    String? name,
    String? status,
    String? accountId,
    String? accountName,
    num? page,
    num? perPage,
    String? order,
    String? direction,
    String? match,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'GET',
      path: '/zones',
      query: <String, Object?>{
        'name': name,
        'status': status,
        'account.id': accountId,
        'account.name': accountName,
        'page': page,
        'per_page': perPage,
        'order': order,
        'direction': direction,
        'match': match,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Zone Read'},
    );
    return CfPage.from(env, Zone.fromJson);
  }

  /// `GET /zones/{zone_id}`
  /// Zone Details
  Future<Zone> getZone({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone Read'},
    );
    return Zone.fromJson(env.resultAsMap);
  }

  /// `GET /zones/{zone_id}/settings`
  /// Get all zone settings
  @Deprecated('Deprecated in the Cloudflare API.')
  Future<CfPage<ZoneSettingsGetAllZoneSettingsItem>> getAllSettings({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/settings',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone Settings Read'},
    );
    return CfPage.from(env, ZoneSettingsGetAllZoneSettingsItem.fromJson);
  }

  /// `GET /zones/{zone_id}/settings/{setting_id}`
  /// Get zone setting
  Future<Setting> getSetting({
    required String zoneId,
    required String settingId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/settings/$settingId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone Settings Read'},
    );
    return Setting.fromJson(env.resultAsMap);
  }

  /// `PATCH /zones/{zone_id}/settings/{setting_id}`
  /// Edit zone setting
  Future<Setting> editSetting({
    required String zoneId,
    required String settingId,
    required ZoneSettingsSingleRequest body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final env = await _client.send(
      method: 'PATCH',
      path: '/zones/$zoneId/settings/$settingId',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone Settings Write'},
    );
    return Setting.fromJson(env.resultAsMap);
  }
}
