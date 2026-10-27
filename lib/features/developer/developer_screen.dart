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
import '../../ui/ds/ds.dart';
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
          ? ScopePrompt(
              icon: Icons.account_balance_outlined,
              message: l.devPickAccount,
              action: l.scopePickAccount,
              onTap: () => pickAccount(context, ref),
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
    final l = L.of(context);
    final scripts = ref.watch(workerScriptsProvider(accountId));

    return AsyncView<CfPage<WorkerScriptListWorkersItem>>(
      value: scripts,
      onRetry: () => ref.invalidate(workerScriptsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      empty: EmptyState(
        icon: Icons.bolt_outlined,
        tone: Tone.brand,
        title: l.devNoWorkers,
      ),
      builder: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(workerScriptsProvider(accountId)),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: Gap.md),
          itemCount: page.items.length,
          itemBuilder: (context, i) {
            final script = page.items[i];
            final routes = script.routes ?? const <Route>[];
            return GroupedItem(
              index: i,
              count: page.items.length,
              dividerIndent: 64,
              child: ExpansionTile(
                shape: const Border(),
                collapsedShape: const Border(),
                leading: const IconTile(icon: Icons.bolt, tone: Tone.brand),
                title: Text(script.id ?? '—', style: context.text.titleSmall),
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
                  style: context.text.bodySmall?.copyWith(
                    color: context.scheme.onSurfaceVariant,
                  ),
                ),
                childrenPadding: const EdgeInsets.only(bottom: Gap.sm),
                children: [
                  for (final r in routes)
                    _Detail(icon: Icons.alt_route, text: r.pattern ?? '—'),
                  _CronTriggers(accountId: accountId, script: script.id ?? ''),
                  if (script.handlers != null && script.handlers!.isNotEmpty)
                    _Detail(
                      icon: Icons.functions,
                      text: script.handlers!.join(', '),
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

/// One fact under an expanded Worker: a route, a schedule, a handler.
class _Detail extends StatelessWidget {
  const _Detail({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(68, Gap.xs, Gap.lg, Gap.xs),
    child: Row(
      children: [
        Icon(icon, size: 16, color: context.scheme.onSurfaceVariant),
        const SizedBox(width: Gap.sm),
        Expanded(
          child: Text(
            text,
            style: context.text.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ),
      ],
    ),
  );
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
      loading: () => const Padding(
        padding: EdgeInsets.fromLTRB(68, Gap.xs, Gap.lg, Gap.xs),
        child: SkeletonBox(width: 120),
      ),
      // A worker with no cron access is normal, not an error worth shouting about.
      error: (_, _) => const SizedBox.shrink(),
      data: (result) {
        final schedules = (result.schedules ?? const [])
            .map((s) => s.cron ?? '')
            .where((c) => c.isNotEmpty)
            .toList();
        if (schedules.isEmpty) return const SizedBox.shrink();
        return _Detail(icon: Icons.schedule, text: schedules.join(', '));
      },
    );
  }
}

class _Pages extends ConsumerWidget {
  const _Pages({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final projects = ref.watch(pagesProjectsProvider(accountId));

    return AsyncView<CfPage<Project>>(
      value: projects,
      onRetry: () => ref.invalidate(pagesProjectsProvider(accountId)),
      isEmpty: (d) => d.items.isEmpty,
      empty: EmptyState(
        icon: Icons.web_outlined,
        tone: Tone.info,
        title: l.devNoPages,
      ),
      builder: (page) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(pagesProjectsProvider(accountId)),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: Gap.md),
          itemCount: page.items.length,
          itemBuilder: (context, i) {
            final project = page.items[i];
            return GroupedItem(
              index: i,
              count: page.items.length,
              dividerIndent: 60,
              child: NavRow(
                icon: Icons.web_outlined,
                tone: Tone.info,
                title: project.name ?? '—',
                subtitle: [
                  if (project.productionBranch != null)
                    project.productionBranch!,
                  if (project.subdomain != null) project.subdomain!,
                ].join(' · '),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _DeploymentsScreen(
                      accountId: accountId,
                      project: project.name ?? '',
                    ),
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
        builder: (page) => ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: Gap.md),
          itemCount: page.items.length,
          itemBuilder: (context, i) {
            final d = page.items[i];
            final production = d.environment == 'production';
            return GroupedItem(
              index: i,
              count: page.items.length,
              child: Padding(
                padding: const EdgeInsets.all(Gap.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusPill(
                          d.environment ?? '—',
                          tone: production ? Tone.success : Tone.neutral,
                          icon: Icons.rocket_launch_outlined,
                        ),
                        const Spacer(),
                        if (d.createdOn != null)
                          Text(
                            d.createdOn!
                                .replaceFirst('T', ' ')
                                .split('.')
                                .first,
                            style: tabular(
                              context.text.labelSmall,
                            )?.copyWith(color: context.scheme.onSurfaceVariant),
                          ),
                      ],
                    ),
                    if (d.url != null) ...[
                      const SizedBox(height: Gap.sm),
                      SelectableText(
                        d.url!,
                        style: context.text.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
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

class _Storage extends ConsumerWidget {
  const _Storage({required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final kv = ref.watch(kvNamespacesProvider(accountId));
    final d1 = ref.watch(d1DatabasesProvider(accountId));
    final r2 = ref.watch(r2BucketsProvider(accountId));

    void open(Widget screen) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));

    return RefreshIndicator(
      onRefresh: () async {
        ref
          ..invalidate(kvNamespacesProvider(accountId))
          ..invalidate(d1DatabasesProvider(accountId))
          ..invalidate(r2BucketsProvider(accountId));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.xl),
        children: [
          SectionTitle(l.devKvNamespaces),
          _StorageGroup<CfPage<Namespace>>(
            value: kv,
            rows: (page) => [
              for (final n in page.items)
                NavRow(
                  icon: Icons.key_outlined,
                  tone: Tone.brand,
                  title: n.title ?? '—',
                  subtitle: n.id,
                  onTap: n.id == null
                      ? null
                      : () => open(
                          KvScreen(
                            accountId: accountId,
                            namespaceId: n.id!,
                            title: n.title ?? 'KV',
                          ),
                        ),
                ),
            ],
          ),
          SectionTitle(l.devD1),
          _StorageGroup<CfPage<DatabaseResponse>>(
            value: d1,
            rows: (page) => [
              for (final db in page.items)
                NavRow(
                  icon: Icons.table_chart_outlined,
                  tone: Tone.info,
                  title: db.name ?? '—',
                  subtitle: db.uuid,
                  onTap: db.uuid == null
                      ? null
                      : () => open(
                          D1ConsoleScreen(
                            accountId: accountId,
                            databaseId: db.uuid!,
                            name: db.name ?? 'D1',
                          ),
                        ),
                ),
            ],
          ),
          SectionTitle(l.devR2),
          _StorageGroup<R2ListBucketsResult>(
            value: r2,
            rows: (result) => [
              for (final b in result.buckets ?? const <Bucket>[])
                Padding(
                  padding: const EdgeInsets.all(Gap.md),
                  child: Row(
                    children: [
                      const IconTile(
                        icon: Icons.folder_outlined,
                        tone: Tone.success,
                      ),
                      const SizedBox(width: Gap.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.name ?? '—', style: context.text.titleSmall),
                            Text(
                              [
                                if (b.location != null) b.location!,
                                if (b.storageClass != null) b.storageClass!,
                              ].join(' · '),
                              style: context.text.bodySmall?.copyWith(
                                color: context.scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One storage product as a panel: its rows, a quiet line when there are none,
/// or why it could not be listed — usually a token without that product, which
/// is information rather than a failure of the screen.
class _StorageGroup<T> extends StatelessWidget {
  const _StorageGroup({required this.value, required this.rows});

  final AsyncValue<T> value;
  final List<Widget> Function(T data) rows;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    Widget note(IconData icon, String text, {Tone tone = Tone.neutral}) =>
        Panel(
          padding: const EdgeInsets.all(Gap.md),
          child: Row(
            children: [
              Icon(icon, size: 18, color: context.toneColor(tone)),
              const SizedBox(width: Gap.sm),
              Expanded(
                child: Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    color: context.scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );

    return value.when(
      loading: () => const Panel(child: SkeletonBox(height: 36, radius: 10)),
      error: (e, _) => note(
        Icons.info_outline,
        e is CfFailure ? e.summary : '$e',
        tone: Tone.warning,
      ),
      data: (data) {
        final list = rows(data);
        return list.isEmpty
            ? note(Icons.inbox_outlined, l.commonNothingHere)
            : RowGroup(children: list);
      },
    );
  }
}
