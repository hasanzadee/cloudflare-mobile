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

/// WAF, rate limiting and IP access rules
class WafApi {
  const WafApi(this._client);

  final CfClient _client;

  /// `GET /zones/{zone_id}/rulesets`
  /// List zone rulesets
  Future<CfPage<ListZoneRulesetsItem>> listRulesets({
    required String zoneId,
    String? cursor,
    int? perPage,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/rulesets',
      query: <String, Object?>{
        'cursor': cursor,
        'per_page': perPage,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Zone WAF Read'},
    );
    return CfPage.from(_env, ListZoneRulesetsItem.fromJson);
  }

  /// `GET /zones/{zone_id}/rulesets/{ruleset_id}`
  /// Get a zone ruleset
  Future<GetZoneRulesetResult> getRuleset({
    required String zoneId,
    required String rulesetId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/rulesets/$rulesetId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone WAF Read'},
    );
    return GetZoneRulesetResult.fromJson(_env.resultAsMap);
  }

  /// `GET /zones/{zone_id}/rulesets/phases/{ruleset_phase}/entrypoint`
  /// Get a zone entry point ruleset
  Future<GetZoneEntrypointRulesetResult> getPhaseEntrypoint({
    required String zoneId,
    required String rulesetPhase,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/rulesets/phases/$rulesetPhase/entrypoint',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone WAF Read'},
    );
    return GetZoneEntrypointRulesetResult.fromJson(_env.resultAsMap);
  }

  /// `POST /zones/{zone_id}/rulesets/{ruleset_id}/rules`
  /// Create a zone ruleset rule
  Future<CreateZoneRulesetRuleResult> createRule({
    required String zoneId,
    required String rulesetId,
    required CreateZoneRulesetRuleBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'POST',
      path: '/zones/$zoneId/rulesets/$rulesetId/rules',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone WAF Write'},
    );
    return CreateZoneRulesetRuleResult.fromJson(_env.resultAsMap);
  }

  /// `PUT /zones/{zone_id}/rulesets/phases/{ruleset_phase}/entrypoint`
  /// Update a zone entry point ruleset
  Future<UpdateZoneEntrypointRulesetResult> putPhaseEntrypoint({
    required String zoneId,
    required String rulesetPhase,
    required UpdateZoneEntrypointRulesetBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'PUT',
      path: '/zones/$zoneId/rulesets/phases/$rulesetPhase/entrypoint',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone WAF Write'},
    );
    return UpdateZoneEntrypointRulesetResult.fromJson(_env.resultAsMap);
  }

  /// `PATCH /zones/{zone_id}/rulesets/{ruleset_id}/rules/{rule_id}`
  /// Update a zone ruleset rule
  Future<UpdateZoneRulesetRuleResult> updateRule({
    required String zoneId,
    required String rulesetId,
    required String ruleId,
    required UpdateZoneRulesetRuleBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'PATCH',
      path: '/zones/$zoneId/rulesets/$rulesetId/rules/$ruleId',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone WAF Write'},
    );
    return UpdateZoneRulesetRuleResult.fromJson(_env.resultAsMap);
  }

  /// `DELETE /zones/{zone_id}/rulesets/{ruleset_id}/rules/{rule_id}`
  /// Delete a zone ruleset rule
  Future<DeleteZoneRulesetRuleResult> deleteRule({
    required String zoneId,
    required String rulesetId,
    required String ruleId,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'DELETE',
      path: '/zones/$zoneId/rulesets/$rulesetId/rules/$ruleId',
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Zone WAF Write'},
    );
    return DeleteZoneRulesetRuleResult.fromJson(_env.resultAsMap);
  }

  /// `GET /zones/{zone_id}/firewall/access_rules/rules`
  /// List IP Access rules
  Future<CfPage<Rule>> listIpAccessRules({
    required String zoneId,
    String? mode,
    String? configurationTarget,
    String? configurationValue,
    String? notes,
    String? match,
    num? page,
    num? perPage,
    String? order,
    String? direction,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'GET',
      path: '/zones/$zoneId/firewall/access_rules/rules',
      query: <String, Object?>{
        'mode': mode,
        'configuration.target': configurationTarget,
        'configuration.value': configurationValue,
        'notes': notes,
        'match': match,
        'page': page,
        'per_page': perPage,
        'order': order,
        'direction': direction,
        ...?extraQuery,
      },
      cancelToken: cancelToken,
      missingPermissions: const {'Firewall Services Read'},
    );
    return CfPage.from(_env, Rule.fromJson);
  }

  /// `POST /zones/{zone_id}/firewall/access_rules/rules`
  /// Create an IP Access rule
  Future<Rule> createIpAccessRule({
    required String zoneId,
    required IpAccessRulesForAZoneCreateAnIpAccessRuleBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'POST',
      path: '/zones/$zoneId/firewall/access_rules/rules',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Firewall Services Write'},
    );
    return Rule.fromJson(_env.resultAsMap);
  }

  /// `DELETE /zones/{zone_id}/firewall/access_rules/rules/{rule_id}`
  /// Delete an IP Access rule
  Future<IpAccessRulesForAZoneDeleteAnIpAccessRuleResult> deleteIpAccessRule({
    required String zoneId,
    required String ruleId,
    required IpAccessRulesForAZoneDeleteAnIpAccessRuleBody body,
    Map<String, Object?>? extraQuery,
    CancelToken? cancelToken,
  }) async {
    final _env = await _client.send(
      method: 'DELETE',
      path: '/zones/$zoneId/firewall/access_rules/rules/$ruleId',
      body: body.toJson(),
      query: <String, Object?>{...?extraQuery},
      cancelToken: cancelToken,
      missingPermissions: const {'Firewall Services Write'},
    );
    return IpAccessRulesForAZoneDeleteAnIpAccessRuleResult.fromJson(
      _env.resultAsMap,
    );
  }
}
