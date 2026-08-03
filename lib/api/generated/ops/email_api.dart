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

/// Email routing, Turnstile and alerts
class EmailApi {
  const EmailApi(this._client);

  final CfClient _client;

  /// `GET /zones/{zone_id}/email/routing`
  /// Get Email Routing settings
  Future<Settings2> getEmailRouting({
    required String zoneId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/email/routing',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Email Routing Read'},
    );
    return Settings2.fromJson(_env.resultAsMap);
  }

  /// `GET /zones/{zone_id}/email/routing/rules`
  /// List routing rules
  Future<CfPage<Rules2>> listEmailRules({
    required String zoneId,
    num? page,
    num? perPage,
    bool? enabled,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/email/routing/rules',
      query: <String, Object?>{
        'page': page,
        'per_page': perPage,
        'enabled': enabled,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Email Routing Read'},
    );
    return CfPage.from(_env, Rules2.fromJson);
  }

  /// `GET /accounts/{account_id}/email/routing/addresses`
  /// List destination addresses
  Future<CfPage<Addresses>> listDestinationAddresses({
    required String accountId,
    num? page,
    num? perPage,
    String? direction,
    bool? verified,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/email/routing/addresses',
      query: <String, Object?>{
        'page': page,
        'per_page': perPage,
        'direction': direction,
        'verified': verified,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Email Routing Read'},
    );
    return CfPage.from(_env, Addresses.fromJson);
  }

  /// `GET /accounts/{account_id}/challenges/widgets`
  /// List Turnstile Widgets
  Future<CfPage<WidgetList>> listTurnstileWidgets({
    required String accountId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/challenges/widgets',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Turnstile Read'},
    );
    return CfPage.from(_env, WidgetList.fromJson);
  }

  /// `GET /accounts/{account_id}/alerting/v3/policies`
  /// List Notification policies
  Future<CfPage<Policies>> listAlertPolicies({
    required String accountId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/alerting/v3/policies',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Notifications Read'},
    );
    return CfPage.from(_env, Policies.fromJson);
  }

  /// `GET /accounts/{account_id}/alerting/v3/history`
  /// List History
  Future<CfPage<History>> listAlertHistory({
    required String accountId,
    num? perPage,
    String? before,
    num? page,
    String? since,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/accounts/$accountId/alerting/v3/history',
      query: <String, Object?>{
        'per_page': perPage,
        'before': before,
        'page': page,
        'since': since,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Notifications Read'},
    );
    return CfPage.from(_env, History.fromJson);
  }
}
