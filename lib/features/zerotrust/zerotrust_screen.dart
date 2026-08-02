import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
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
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(l.devPickAccount, textAlign: TextAlign.center),
              ),
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
    final tunnels = ref.watch(tunnelsProvider(accountId));

    return AsyncView<CfPage<CfdTunnel>>(
      value: tunnels,
      onRetry: () => ref.invalidate(tunnelsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      builder: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(tunnelsProvider(accountId)),
        child: ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final t = page.items[i];
            final healthy = t.status == 'healthy';
            final degraded = t.status == 'degraded';
            final color = healthy
                ? context.cf.success
                : degraded
                ? context.cf.warning
                : context.cf.danger;
            final active = t.connections?.length ?? 0;

            return ListTile(
              leading: Icon(Icons.hub_outlined, color: color),
              title: Text(t.name ?? '—'),
              subtitle: Text(
                [
                  t.status ?? 'unknown',
                  if (active > 0) '$active connector(s)',
                  if (t.tunType != null) t.tunType!,
                ].join(' · '),
              ),
              trailing: const Icon(Icons.chevron_right),
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
            );
          },
        ),
      ),
    );
  }
}

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
        empty: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              L.of(context).ztNoConnectors,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        builder: (page) => ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final c = page.items[i];
            return ListTile(
              leading: Icon(Icons.dns_outlined, color: context.cf.success),
              title: Text(c.id ?? '—'),
              subtitle: Text(
                [
                  if (c.version != null) 'cloudflared ${c.version}',
                  if (c.arch != null) c.arch!,
                  if (c.runAt != null) 'up since ${c.runAt}',
                  '${c.conns?.length ?? 0} edge conn.',
                ].join(' · '),
              ),
              isThreeLine: true,
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
    final apps = ref.watch(accessAppsProvider(accountId));

    return AsyncView<CfPage<AppResponse>>(
      value: apps,
      onRetry: () => ref.invalidate(accessAppsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      builder: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(accessAppsProvider(accountId)),
        child: ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final app = page.items[i];
            final policies = app.policies ?? const <AppPolicyResponse>[];
            return ExpansionTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(app.name ?? '—'),
              subtitle: Text(
                [
                  if (app.domain != null) app.domain!,
                  if (app.type_ != null) app.type_.toString(),
                ].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                if (policies.isEmpty)
                  ListTile(dense: true, title: Text(L.of(context).ztNoPolicies))
                else
                  for (final p in policies)
                    ListTile(
                      dense: true,
                      leading: Icon(
                        p.decision == 'allow'
                            ? Icons.check_circle_outline
                            : Icons.block,
                        size: 18,
                        color: p.decision == 'allow'
                            ? context.cf.success
                            : context.cf.danger,
                      ),
                      title: Text(p.name ?? '—'),
                      subtitle: Text(p.decision ?? ''),
                    ),
              ],
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
    final rules = ref.watch(gatewayRulesProvider(accountId));

    return AsyncView<CfPage<Rules>>(
      value: rules,
      onRetry: () => ref.invalidate(gatewayRulesProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      builder: (page) {
        final sorted = [...page.items]
          ..sort((a, b) => (a.precedence ?? 0).compareTo(b.precedence ?? 0));
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(gatewayRulesProvider(accountId)),
          child: ListView.separated(
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = sorted[i];
              final enabled = r.enabled == true;
              final color = switch (r.action) {
                'block' => context.cf.danger,
                'allow' => context.cf.success,
                'isolate' || 'safesearch' => context.cf.warning,
                _ => Theme.of(context).colorScheme.outline,
              };
              return ListTile(
                leading: Container(
                  width: 58,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: color.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    r.action ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  r.name ?? '—',
                  style: TextStyle(
                    decoration: enabled ? null : TextDecoration.lineThrough,
                  ),
                ),
                subtitle: Text(
                  [
                    if (r.precedence != null) '#${r.precedence}',
                    if (r.filters != null && r.filters!.isNotEmpty)
                      r.filters!.join(', '),
                    if (r.description != null && r.description!.isNotEmpty)
                      r.description!,
                  ].join(' · '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
