// Cloudflare has a `Route` model (a Workers route) and Flutter has a `Route`
// (a navigator entry). We only need the former by name here.
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/failure.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
import 'd1_console_screen.dart';
import 'developer_providers.dart';
import 'kv_screen.dart';

class DeveloperScreen extends ConsumerStatefulWidget {
  const DeveloperScreen({super.key});

  @override
  ConsumerState<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends ConsumerState<DeveloperScreen>
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
        title: Text(l.navDeveloper),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Column(
            children: [
              const ScopeBar(),
              TabBar(
                controller: _tabs,
                tabs: [
                  Tab(text: l.devWorkers),
                  Tab(text: l.devPages),
                  Tab(text: l.devStorage),
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
                _Workers(accountId: accountId),
                _Pages(accountId: accountId),
                _Storage(accountId: accountId),
              ],
            ),
    );
  }
}

class _Workers extends ConsumerWidget {
  const _Workers({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scripts = ref.watch(workerScriptsProvider(accountId));

    return AsyncView<CfPage<WorkerScriptListWorkersItem>>(
      value: scripts,
      onRetry: () => ref.invalidate(workerScriptsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      builder: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(workerScriptsProvider(accountId)),
        child: ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final script = page.items[i];
            final routes = script.routes ?? const <Route>[];
            return ExpansionTile(
              leading: const Icon(Icons.bolt_outlined),
              title: Text(script.id ?? '—'),
              subtitle: Text(
                [
                  if (script.usageModel != null) script.usageModel!,
                  if (script.compatibilityDate != null)
                    'compat ${script.compatibilityDate}',
                  if (script.modifiedOn != null)
                    'modified ${script.modifiedOn!.split('T').first}',
                ].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                if (routes.isNotEmpty)
                  for (final r in routes)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.alt_route, size: 18),
                      title: Text(
                        r.pattern ?? '—',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                _CronTriggers(accountId: accountId, script: script.id ?? ''),
                if (script.handlers != null && script.handlers!.isNotEmpty)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.functions, size: 18),
                    title: Text(script.handlers!.join(', ')),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CronTriggers extends ConsumerWidget {
  const _CronTriggers({required this.accountId, required this.script});

  final String accountId;
  final String script;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (script.isEmpty) return const SizedBox.shrink();
    final triggers = ref.watch(
      cronTriggersProvider((accountId: accountId, script: script)),
    );

    return triggers.when(
      loading: () => const ListTile(
        dense: true,
        leading: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text('…'),
      ),
      // A worker with no cron access is normal, not an error worth shouting about.
      error: (_, _) => const SizedBox.shrink(),
      data: (result) {
        final schedules = result.schedules ?? const [];
        if (schedules.isEmpty) return const SizedBox.shrink();
        return ListTile(
          dense: true,
          leading: const Icon(Icons.schedule, size: 18),
          title: Text(
            schedules
                .map((s) => s.cron ?? '')
                .where((c) => c.isNotEmpty)
                .join(', '),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        );
      },
    );
  }
}

class _Pages extends ConsumerWidget {
  const _Pages({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(pagesProjectsProvider(accountId));

    return AsyncView<CfPage<Project>>(
      value: projects,
      onRetry: () => ref.invalidate(pagesProjectsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      builder: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(pagesProjectsProvider(accountId)),
        child: ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final project = page.items[i];
            return ListTile(
              leading: const Icon(Icons.web_outlined),
              title: Text(project.name ?? '—'),
              subtitle: Text(
                [
                  if (project.productionBranch != null)
                    project.productionBranch!,
                  if (project.subdomain != null) project.subdomain!,
                ].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => _DeploymentsScreen(
                    accountId: accountId,
                    project: project.name ?? '',
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

class _DeploymentsScreen extends ConsumerWidget {
  const _DeploymentsScreen({required this.accountId, required this.project});

  final String accountId;
  final String project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (accountId: accountId, project: project);
    final deployments = ref.watch(pagesDeploymentsProvider(key));

    return Scaffold(
      appBar: AppBar(title: Text(project)),
      body: AsyncView<CfPage<Deployment>>(
        value: deployments,
        onRetry: () => ref.invalidate(pagesDeploymentsProvider(key)),
        isEmpty: (d) => d.items.isEmpty,
        builder: (page) => ListView.separated(
          itemCount: page.items.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final d = page.items[i];
            return ListTile(
              leading: Icon(
                Icons.rocket_launch_outlined,
                color: context.cf.success,
              ),
              title: Text(d.environment ?? d.id ?? '—'),
              subtitle: Text(
                [
                  if (d.createdOn != null) d.createdOn!,
                  if (d.url != null) d.url!,
                ].join('\n'),
              ),
              isThreeLine: d.url != null,
            );
          },
        ),
      ),
    );
  }
}

class _Storage extends ConsumerWidget {
  const _Storage({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final kv = ref.watch(kvNamespacesProvider(accountId));
    final d1 = ref.watch(d1DatabasesProvider(accountId));
    final r2 = ref.watch(r2BucketsProvider(accountId));

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(kvNamespacesProvider(accountId))
          ..invalidate(d1DatabasesProvider(accountId))
          ..invalidate(r2BucketsProvider(accountId));
      },
      child: ListView(
        children: [
          _SectionHeader(l.devKvNamespaces),
          ...kv.when(
            loading: () => [const _Loading()],
            error: (e, _) => [_ErrorTile(error: e)],
            data: (page) => page.items.isEmpty
                ? [_EmptyTile(l.commonNothingHere)]
                : [
                    for (final n in page.items)
                      ListTile(
                        leading: const Icon(Icons.storage_outlined),
                        title: Text(n.title ?? '—'),
                        subtitle: Text(n.id ?? ''),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: n.id == null
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => KvScreen(
                                    accountId: accountId,
                                    namespaceId: n.id!,
                                    title: n.title ?? 'KV',
                                  ),
                                ),
                              ),
                      ),
                  ],
          ),
          _SectionHeader(l.devD1),
          ...d1.when(
            loading: () => [const _Loading()],
            error: (e, _) => [_ErrorTile(error: e)],
            data: (page) => page.items.isEmpty
                ? [_EmptyTile(l.commonNothingHere)]
                : [
                    for (final db in page.items)
                      ListTile(
                        leading: const Icon(Icons.table_chart_outlined),
                        title: Text(db.name ?? '—'),
                        subtitle: Text(db.uuid ?? ''),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: db.uuid == null
                            ? null
                            : () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => D1ConsoleScreen(
                                    accountId: accountId,
                                    databaseId: db.uuid!,
                                    name: db.name ?? 'D1',
                                  ),
                                ),
                              ),
                      ),
                  ],
          ),
          _SectionHeader(l.devR2),
          ...r2.when(
            loading: () => [const _Loading()],
            error: (e, _) => [_ErrorTile(error: e)],
            data: (result) {
              final buckets = result.buckets ?? const <Bucket>[];
              return buckets.isEmpty
                  ? [_EmptyTile(l.commonNothingHere)]
                  : [
                      for (final b in buckets)
                        ListTile(
                          leading: const Icon(Icons.folder_outlined),
                          title: Text(b.name ?? '—'),
                          subtitle: Text(
                            [
                              if (b.location != null) b.location!,
                              if (b.storageClass != null) b.storageClass!,
                            ].join(' · '),
                          ),
                        ),
                    ];
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    ),
  );
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) => const ListTile(
    dense: true,
    leading: SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
    title: Text('…'),
  );
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    title: Text(
      text,
      style: TextStyle(color: Theme.of(context).colorScheme.outline),
    ),
  );
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    // A local, because a final field is not promoted by a type test.
    final e = error;
    return ListTile(
      dense: true,
      leading: Icon(Icons.error_outline, color: context.cf.warning),
      title: Text(
        // Usually "this token has no permission for that product", which is
        // information rather than a failure of the screen.
        e is CfFailure ? e.summary : '$e',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
