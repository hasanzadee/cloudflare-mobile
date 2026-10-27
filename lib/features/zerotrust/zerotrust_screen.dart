import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/ds/ds.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
import '../security/security_screen.dart' show actionTone;
import 'zerotrust_providers.dart';

class ZeroTrustScreen extends ConsumerStatefulWidget {
  const ZeroTrustScreen({super.key});

  @override
  ConsumerState<ZeroTrustScreen> createState() => _ZeroTrustScreenState();
}

class _ZeroTrustScreenState extends ConsumerState<ZeroTrustScreen>
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
    final accountId = ref.watch(scopeProvider).accountId;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navZeroTrust),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Column(
            children: [
              const ScopeBar(),
              TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: l.ztTunnels),
                  Tab(text: l.ztAccess),
                  Tab(text: l.ztGateway),
                ],
              ),
            ],
          ),
        ),
      ),
      body: accountId == null
          ? ScopePrompt(
              icon: Icons.account_balance_outlined,
              message: l.devPickAccount,
              action: l.scopePickAccount,
              onTap: () => pickAccount(context, ref),
            )
          : TabBarView(
              controller: _tabs,
              children: [
                _Tunnels(accountId: accountId),
                _AccessApps(accountId: accountId),
                _GatewayRules(accountId: accountId),
              ],
            ),
    );
  }
}

class _Tunnels extends ConsumerWidget {
  const _Tunnels({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final tunnels = ref.watch(tunnelsProvider(accountId));

    return AsyncView<CfPage<CfdTunnel>>(
      value: tunnels,
      onRetry: () => ref.invalidate(tunnelsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      empty: EmptyState(
        icon: Icons.hub_outlined,
        tone: Tone.info,
        title: l.ztNoTunnels,
      ),
      builder: (page) {
        // Broken tunnels first: they are why anyone opens this tab.
        final sorted = [...page.items]
          ..sort((a, b) => _rank(a.status).compareTo(_rank(b.status)));
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(tunnelsProvider(accountId)),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: Gap.md),
            itemCount: sorted.length,
            itemBuilder: (context, i) {
              final t = sorted[i];
              final active = t.connections?.length ?? 0;
              return GroupedItem(
                index: i,
                count: sorted.length,
                dividerIndent: 44,
                child: InkWell(
                  onTap: t.id == null
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => _TunnelScreen(
                              accountId: accountId,
                              tunnelId: t.id!,
                              name: t.name ?? '',
                            ),
                          ),
                        ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Gap.lg,
                      Gap.md,
                      Gap.sm,
                      Gap.md,
                    ),
                    child: Row(
                      children: [
                        StatusDot(tone: tunnelTone(t.status)),
                        const SizedBox(width: Gap.md + 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.name ?? '—',
                                style: context.text.titleSmall,
                              ),
                              Text(
                                [
                                  t.status ?? 'unknown',
                                  if (active > 0) l.ztConnectors(active),
                                  if (t.tunType != null) t.tunType!,
                                ].join(' · '),
                                style: context.text.bodySmall?.copyWith(
                                  color: context.scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: context.scheme.outline,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static int _rank(String? status) => switch (status) {
    'down' => 0,
    'degraded' => 1,
    'healthy' => 2,
    _ => 3,
  };
}

Tone tunnelTone(String? status) => switch (status) {
  'healthy' => Tone.success,
  'degraded' => Tone.warning,
  'down' => Tone.danger,
  _ => Tone.neutral,
};

class _TunnelScreen extends ConsumerWidget {
  const _TunnelScreen({
    required this.accountId,
    required this.tunnelId,
    required this.name,
  });

  final String accountId;
  final String tunnelId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (accountId: accountId, tunnelId: tunnelId);
    final connections = ref.watch(tunnelConnectionsProvider(key));

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(tunnelConnectionsProvider(key)),
          ),
        ],
      ),
      body: AsyncView<CfPage<TunnelClient>>(
        value: connections,
        onRetry: () => ref.invalidate(tunnelConnectionsProvider(key)),
        isEmpty: (d) => d.items.isEmpty,
        empty: EmptyState(
          icon: Icons.link_off,
          tone: Tone.danger,
          title: L.of(context).ztNoConnectors,
        ),
        builder: (page) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: Gap.md),
          itemCount: page.items.length,
          itemBuilder: (context, i) {
            final c = page.items[i];
            return GroupedItem(
              index: i,
              count: page.items.length,
              child: Padding(
                padding: const EdgeInsets.all(Gap.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconTile(
                      icon: Icons.dns_outlined,
                      tone: Tone.success,
                    ),
                    const SizedBox(width: Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.id ?? '—',
                            style: context.text.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(height: Gap.xs),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              if (c.version != null)
                                StatusPill('cloudflared ${c.version}'),
                              if (c.arch != null) StatusPill(c.arch!),
                              StatusPill(
                                '${c.conns?.length ?? 0} edge',
                                tone: Tone.success,
                              ),
                            ],
                          ),
                          if (c.runAt != null) ...[
                            const SizedBox(height: Gap.xs),
                            Text(
                              c.runAt!.replaceFirst('T', ' ').split('.').first,
                              style: tabular(context.text.labelSmall)?.copyWith(
                                color: context.scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AccessApps extends ConsumerWidget {
  const _AccessApps({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final apps = ref.watch(accessAppsProvider(accountId));

    return AsyncView<CfPage<AppResponse>>(
      value: apps,
      onRetry: () => ref.invalidate(accessAppsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      empty: EmptyState(
        icon: Icons.shield_outlined,
        tone: Tone.info,
        title: l.ztNoApps,
      ),
      builder: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(accessAppsProvider(accountId)),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: Gap.md),
          itemCount: page.items.length,
          itemBuilder: (context, i) {
            final app = page.items[i];
            final policies = app.policies ?? const <AppPolicyResponse>[];
            return GroupedItem(
              index: i,
              count: page.items.length,
              dividerIndent: 64,
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                leading: const IconTile(
                  icon: Icons.shield_outlined,
                  tone: Tone.info,
                ),
                title: Text(app.name ?? '—', style: context.text.titleSmall),
                subtitle: Text(
                  [
                    if (app.domain != null) app.domain!,
                    if (app.type_ != null) app.type_.toString(),
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: context.scheme.onSurfaceVariant,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  64,
                  0,
                  Gap.lg,
                  Gap.md,
                ),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (policies.isEmpty)
                    Text(
                      l.ztNoPolicies,
                      style: context.text.bodySmall?.copyWith(
                        color: context.scheme.onSurfaceVariant,
                      ),
                    )
                  else
                    for (final p in policies)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Gap.sm),
                        child: Row(
                          children: [
                            StatusPill(
                              p.decision ?? '—',
                              tone: switch (p.decision) {
                                'allow' || 'bypass' => Tone.success,
                                'deny' => Tone.danger,
                                _ => Tone.neutral,
                              },
                            ),
                            const SizedBox(width: Gap.sm),
                            Expanded(
                              child: Text(
                                p.name ?? '—',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GatewayRules extends ConsumerWidget {
  const _GatewayRules({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final rules = ref.watch(gatewayRulesProvider(accountId));

    return AsyncView<CfPage<Rules>>(
      value: rules,
      onRetry: () => ref.invalidate(gatewayRulesProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      empty: EmptyState(
        icon: Icons.filter_alt_outlined,
        tone: Tone.info,
        title: l.ztNoGatewayRules,
      ),
      builder: (page) {
        final sorted = [...page.items]
          ..sort((a, b) => (a.precedence ?? 0).compareTo(b.precedence ?? 0));
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(gatewayRulesProvider(accountId)),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: Gap.md),
            itemCount: sorted.length,
            itemBuilder: (context, i) {
              final r = sorted[i];
              final enabled = r.enabled == true;
              return GroupedItem(
                index: i,
                count: sorted.length,
                child: Padding(
                  padding: const EdgeInsets.all(Gap.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StatusPill(
                            r.action ?? '—',
                            tone: actionTone(r.action ?? ''),
                          ),
                          const SizedBox(width: Gap.sm),
                          Expanded(
                            child: Text(
                              r.name ?? '—',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.titleSmall?.copyWith(
                                color: enabled
                                    ? null
                                    : context.scheme.onSurfaceVariant,
                                decoration: enabled
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          if (r.precedence != null)
                            Text(
                              '#${r.precedence}',
                              style: tabular(context.text.labelMedium)
                                  ?.copyWith(
                                    color: context.scheme.onSurfaceVariant,
                                  ),
                            ),
                        ],
                      ),
                      if ((r.filters?.isNotEmpty ?? false) ||
                          (r.description?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: Gap.xs),
                        Text(
                          [
                            if (r.filters != null && r.filters!.isNotEmpty)
                              r.filters!.join(', '),
                            if (r.description != null &&
                                r.description!.isNotEmpty)
                              r.description!,
                          ].join(' · '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodySmall?.copyWith(
                            color: context.scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
