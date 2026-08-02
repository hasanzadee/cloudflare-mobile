import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/failure.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/failure_text.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
import 'security_providers.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final scope = ref.watch(scopeProvider);
    final zoneId = scope.zoneId;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navSecurity),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Column(
            children: [
              const ScopeBar(showZone: true),
              TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: RulesetPhase.custom.label),
                  Tab(text: RulesetPhase.rateLimit.label),
                  Tab(text: l.securityIpAccess),
                ],
              ),
            ],
          ),
        ),
      ),
      body: zoneId == null
          ? _PickZone(message: l.securityPickZone)
          : TabBarView(
              controller: _tabs,
              children: [
                _PhaseRules(zoneId: zoneId, phase: RulesetPhase.custom),
                _PhaseRules(zoneId: zoneId, phase: RulesetPhase.rateLimit),
                _IpAccessRules(zoneId: zoneId),
              ],
            ),
    );
  }
}

class _PickZone extends StatelessWidget {
  const _PickZone({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.public_off, size: 40),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _PhaseRules extends ConsumerWidget {
  const _PhaseRules({required this.zoneId, required this.phase});

  final String zoneId;
  final RulesetPhase phase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (zoneId: zoneId, phase: phase.id);
    final rules = ref.watch(phaseRulesProvider(key));
    final l = L.of(context);

    return AsyncView<GetZoneEntrypointRulesetResult?>(
      value: rules,
      onRetry: () => ref.invalidate(phaseRulesProvider(key)),
      isEmpty: (d) => d == null || (d.rules?.isEmpty ?? true),
      empty: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(l.securityNoRules, textAlign: TextAlign.center),
        ),
      ),
      builder: (ruleset) {
        final list = ruleset!.rules!;
        final rulesetId = ruleset.id?.toString() ?? '';
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(phaseRulesProvider(key)),
          child: ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => _RuleTile(
              rule: list[i],
              zoneId: zoneId,
              rulesetId: rulesetId,
              onChanged: () => ref.invalidate(phaseRulesProvider(key)),
            ),
          ),
        );
      },
    );
  }
}

class _RuleTile extends ConsumerWidget {
  const _RuleTile({
    required this.rule,
    required this.zoneId,
    required this.rulesetId,
    required this.onChanged,
  });

  final ResponseRule rule;
  final String zoneId;
  final String rulesetId;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = rule.enabled == true;
    final action = rule.action?.toString() ?? '—';
    final description = rule.description?.toString();

    return ListTile(
      isThreeLine: true,
      leading: _ActionBadge(action: action),
      title: Text(
        description == null || description.isEmpty ? action : description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        rule.expression ?? '',
        style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: enabled,
            onChanged: rule.id == null
                ? null
                : (v) => _toggle(context, ref, enabled: v),
          ),
          PopupMenuButton<String>(
            onSelected: (_) => _delete(context, ref),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Text(L.of(context).commonDelete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref, {
    required bool enabled,
  }) async {
    try {
      await ref
          .read(securityActionsProvider)
          .setRuleEnabled(
            zoneId: zoneId,
            rulesetId: rulesetId,
            ruleId: rule.id!,
            enabled: enabled,
          );
      onChanged();
    } on CfFailure catch (e) {
      if (context.mounted) _snack(context, failureMessage(context, e));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.commonDelete),
        content: Text(rule.expression ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || rule.id == null) return;

    try {
      await ref
          .read(securityActionsProvider)
          .deleteRule(zoneId: zoneId, rulesetId: rulesetId, ruleId: rule.id!);
      onChanged();
    } on CfFailure catch (e) {
      if (context.mounted) _snack(context, failureMessage(context, e));
    }
  }
}

class _ActionBadge extends StatelessWidget {
  const _ActionBadge({required this.action});

  final String action;

  @override
  Widget build(BuildContext context) {
    final cf = context.cf;
    final color = switch (action) {
      'block' => cf.danger,
      'challenge' || 'managed_challenge' || 'js_challenge' => cf.warning,
      'skip' || 'allow' => cf.success,
      'log' => cf.post,
      _ => Theme.of(context).colorScheme.outline,
    };
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        action,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _IpAccessRules extends ConsumerWidget {
  const _IpAccessRules({required this.zoneId});

  final String zoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final rules = ref.watch(ipAccessRulesProvider(zoneId));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.commonAdd),
      ),
      body: AsyncView<CfPage<Rule>>(
        value: rules,
        onRetry: () => ref.invalidate(ipAccessRulesProvider(zoneId)),
        isEmpty: (d) => d.items.isEmpty,
        builder: (page) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(ipAccessRulesProvider(zoneId)),
          child: ListView.separated(
            itemCount: page.items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final rule = page.items[i];
              return ListTile(
                leading: _ActionBadge(action: rule.mode ?? '—'),
                title: Text(rule.configuration?.value ?? '—'),
                subtitle: Text(
                  [
                    if (rule.configuration?.target != null)
                      rule.configuration!.target!,
                    if (rule.notes != null && rule.notes!.isNotEmpty)
                      rule.notes!,
                  ].join(' · '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: rule.id == null
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(securityActionsProvider)
                                .deleteIpAccessRule(
                                  zoneId: zoneId,
                                  ruleId: rule.id!,
                                );
                            ref.invalidate(ipAccessRulesProvider(zoneId));
                          } on CfFailure catch (e) {
                            if (context.mounted) {
                              _snack(context, failureMessage(context, e));
                            }
                          }
                        },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet<_NewIpRule>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _IpRuleSheet(),
    );
    if (result == null) return;

    try {
      await ref
          .read(securityActionsProvider)
          .createIpAccessRule(
            zoneId: zoneId,
            target: result.target,
            value: result.value,
            mode: result.mode,
            notes: result.notes,
          );
      ref.invalidate(ipAccessRulesProvider(zoneId));
    } on CfFailure catch (e) {
      if (context.mounted) _snack(context, failureMessage(context, e));
    }
  }
}

class _NewIpRule {
  const _NewIpRule(this.target, this.value, this.mode, this.notes);
  final String target;
  final String value;
  final String mode;
  final String? notes;
}

class _IpRuleSheet extends StatefulWidget {
  const _IpRuleSheet();

  @override
  State<_IpRuleSheet> createState() => _IpRuleSheetState();
}

class _IpRuleSheetState extends State<_IpRuleSheet> {
  final _value = TextEditingController();
  final _notes = TextEditingController();
  String _target = 'ip';
  String _mode = 'block';

  @override
  void dispose() {
    _value.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.securityNewIpRule,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _mode,
            decoration: InputDecoration(labelText: l.securityAction),
            items: const [
              DropdownMenuItem(value: 'block', child: Text('Block')),
              DropdownMenuItem(value: 'challenge', child: Text('Challenge')),
              DropdownMenuItem(
                value: 'js_challenge',
                child: Text('JS challenge'),
              ),
              DropdownMenuItem(
                value: 'managed_challenge',
                child: Text('Managed challenge'),
              ),
              DropdownMenuItem(value: 'whitelist', child: Text('Allow')),
            ],
            onChanged: (v) => setState(() => _mode = v ?? 'block'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _target,
            decoration: InputDecoration(labelText: l.securityTarget),
            items: const [
              DropdownMenuItem(value: 'ip', child: Text('IP address')),
              DropdownMenuItem(value: 'ip_range', child: Text('IP range')),
              DropdownMenuItem(value: 'country', child: Text('Country')),
              DropdownMenuItem(value: 'asn', child: Text('ASN')),
            ],
            onChanged: (v) => setState(() => _target = v ?? 'ip'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _value,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l.securityValue,
              hintText: switch (_target) {
                'ip' => '198.51.100.4',
                'ip_range' => '198.51.100.0/24',
                'country' => 'AZ',
                _ => 'AS13335',
              },
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: InputDecoration(labelText: l.dnsComment),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(
              _NewIpRule(
                _target,
                _value.text.trim(),
                _mode,
                _notes.text.trim().isEmpty ? null : _notes.text.trim(),
              ),
            ),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );
  }
}

void _snack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
