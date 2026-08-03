import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/paginator.dart';
import '../scope/scope_providers.dart';

/// Ruleset Engine phases.
///
/// Cloudflare drives WAF custom rules, rate limiting and managed rulesets
/// through one API; the phase selects which of them you are looking at. Each
/// phase has a single "entrypoint" ruleset that holds the rules a user edits.
class RulesetPhase {
  const RulesetPhase(this.id, this.label);

  final String id;
  final String label;

  static const custom = RulesetPhase(
    'http_request_firewall_custom',
    'Custom rules',
  );
  static const rateLimit = RulesetPhase('http_ratelimit', 'Rate limiting');
  static const managed = RulesetPhase(
    'http_request_firewall_managed',
    'Managed rules',
  );

  static const all = [custom, rateLimit, managed];
}

typedef PhaseKey = ({String zoneId, String phase});

/// The entrypoint ruleset for one phase.
///
/// A zone that has never had a rule in this phase returns 404, which is a
/// normal empty state rather than an error — hence the null result.
final phaseRulesProvider = FutureProvider.autoDispose
    .family<GetZoneEntrypointRulesetResult?, PhaseKey>((ref, key) async {
      final api = ref.watch(cfApiProvider);
      try {
        return await api.waf.getPhaseEntrypoint(
          zoneId: key.zoneId,
          rulesetPhase: key.phase,
          cancelToken: autoCancelToken(ref),
        );
      } on Object catch (e) {
        if (e.toString().contains('Not found')) return null;
        rethrow;
      }
    });

final ipAccessRulesProvider = FutureProvider.autoDispose
    .family<CfPage<Rule>, String>((ref, zoneId) {
      final api = ref.watch(cfApiProvider);
      return api.waf.listIpAccessRules(
        zoneId: zoneId,
        perPage: 100,
        cancelToken: autoCancelToken(ref),
      );
    });

final rulesetsProvider = FutureProvider.autoDispose
    .family<CfPage<ListZoneRulesetsItem>, String>((ref, zoneId) {
      final api = ref.watch(cfApiProvider);
      return api.waf.listRulesets(
        zoneId: zoneId,
        cancelToken: autoCancelToken(ref),
      );
    });

/// Mutations, kept off the providers so a failure surfaces at the call site.
class SecurityActions {
  const SecurityActions(this._ref);

  final Ref _ref;

  CfApi get _api => _ref.read(cfApiProvider);

  /// Enables or disables a rule.
  ///
  /// The Ruleset API does not merge, whatever the verb suggests: sending
  /// `{enabled: false}` on its own is rejected with *"action is required to
  /// create or update a rule"* and *"expression cannot be blank"*. The whole
  /// rule has to come back.
  ///
  /// So it round-trips the rule already on screen. Every field the generator
  /// did not model survives in `extra` and is written back untouched — which is
  /// what `extra` is for, and the only thing that makes a replace-semantics
  /// update safe against a rule using features this app has never heard of.
  ///
  /// Three server-managed fields are dropped: `version` and `last_updated`
  /// belong to Cloudflare, and `id` travels in the path.
  Future<void> setRuleEnabled({
    required String zoneId,
    required String rulesetId,
    required ResponseRule rule,
    required bool enabled,
  }) async {
    final body = Map<String, Object?>.from(rule.toJson())
      ..['enabled'] = enabled
      ..remove('id')
      ..remove('version')
      ..remove('last_updated');

    await _api.waf.updateRule(
      zoneId: zoneId,
      rulesetId: rulesetId,
      ruleId: rule.id!,
      body: UpdateZoneRulesetRuleBody.fromJson(body),
    );
  }

  /// Adds a rule to a phase, creating the phase's ruleset if it has none.
  ///
  /// Two paths, because Cloudflare gives no single one. `createRule` needs a
  /// ruleset id, and a zone that has never had a rule in this phase has no
  /// entry point ruleset — the GET 404s and [phaseRulesProvider] reports null.
  /// `PUT .../phases/{phase}/entrypoint` creates the ruleset and its rules
  /// together, so that is the path for the first rule.
  ///
  /// [rulesetId] null means "no ruleset yet", which is why it is not simply a
  /// required String: passing an empty one silently posts to `/rulesets//rules`.
  Future<void> createPhaseRule({
    required String zoneId,
    required String phase,
    required String? rulesetId,
    required Map<String, Object?> rule,
  }) async {
    if (rulesetId != null && rulesetId.isNotEmpty) {
      await _api.waf.createRule(
        zoneId: zoneId,
        rulesetId: rulesetId,
        body: CreateZoneRulesetRuleBody.fromJson(rule),
      );
      return;
    }

    await _api.waf.putPhaseEntrypoint(
      zoneId: zoneId,
      rulesetPhase: phase,
      body: UpdateZoneEntrypointRulesetBody.fromJson({
        'rules': [rule],
      }),
    );
  }

  Future<void> deleteRule({
    required String zoneId,
    required String rulesetId,
    required String ruleId,
  }) async {
    await _api.waf.deleteRule(
      zoneId: zoneId,
      rulesetId: rulesetId,
      ruleId: ruleId,
    );
  }

  Future<void> createIpAccessRule({
    required String zoneId,
    required String target,
    required String value,
    required String mode,
    String? notes,
  }) async {
    await _api.waf.createIpAccessRule(
      zoneId: zoneId,
      body: IpAccessRulesForAZoneCreateAnIpAccessRuleBody(
        configuration: Configuration(target: target, value: value),
        mode: mode,
        notes: notes,
      ),
    );
  }

  Future<void> deleteIpAccessRule({
    required String zoneId,
    required String ruleId,
  }) async {
    await _api.waf.deleteIpAccessRule(
      zoneId: zoneId,
      ruleId: ruleId,
      body: const IpAccessRulesForAZoneDeleteAnIpAccessRuleBody(),
    );
  }
}

final securityActionsProvider = Provider<SecurityActions>(SecurityActions.new);
