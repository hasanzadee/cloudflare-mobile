import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/failure_text.dart';
import '../dns/dns_screen.dart';
import 'zone_settings_providers.dart';
import 'zones_providers.dart';

/// Everything about one zone: overview, DNS, cache purge and settings.
class ZoneScreen extends ConsumerWidget {
  const ZoneScreen({required this.zoneId, required this.zoneName, super.key});

  final String zoneId;
  final String zoneName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final zone = ref.watch(zoneDetailsProvider(zoneId));

    return Scaffold(
      appBar: AppBar(title: Text(zoneName)),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(zoneDetailsProvider(zoneId))
            ..invalidate(zoneSettingsProvider(zoneId));
        },
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(l.dnsTitle),
              subtitle: Text(l.zoneDnsSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => DnsScreen(zoneId: zoneId, zoneName: zoneName),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.cleaning_services_outlined,
                color: context.cf.warning,
              ),
              title: Text(l.cachePurgeTitle),
              subtitle: Text(l.zonePurgeSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      PurgeScreen(zoneId: zoneId, zoneName: zoneName),
                ),
              ),
            ),
            const Divider(),
            zone.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, st) => FailureView(error: e, stack: st),
              data: (z) => _Overview(zone: z),
            ),
            const Divider(),
            _Settings(zoneId: zoneId),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.zone});

  final Zone zone;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final ns = zone.nameServers ?? const <String>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          title: Text(l.zonePlan),
          trailing: Text(zone.plan?.name ?? '—'),
        ),
        ListTile(
          dense: true,
          title: Text(l.zoneStatusActive),
          trailing: Text(zone.status ?? '—'),
        ),
        if (ns.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.zoneNameservers,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 4),
                for (final n in ns)
                  Text(
                    n,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Settings extends ConsumerWidget {
  const _Settings({required this.zoneId});

  final String zoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(zoneSettingsProvider(zoneId));

    return AsyncView<Map<String, ZoneSettingsGetAllZoneSettingsItem>>(
      value: settings,
      onRetry: () => ref.invalidate(zoneSettingsProvider(zoneId)),
      builder: (values) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final group in kZoneSettings) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Text(
                group.group.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            for (final spec in group.settings)
              if (values.containsKey(spec.id))
                _SettingTile(
                  zoneId: zoneId,
                  spec: spec,
                  current: values[spec.id]!,
                ),
          ],
        ],
      ),
    );
  }
}

class _SettingTile extends ConsumerStatefulWidget {
  const _SettingTile({
    required this.zoneId,
    required this.spec,
    required this.current,
  });

  final String zoneId;
  final ZoneSettingSpec spec;
  final ZoneSettingsGetAllZoneSettingsItem current;

  @override
  ConsumerState<_SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends ConsumerState<_SettingTile> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final value = widget.current.value;
    // Cloudflare marks settings the current plan cannot change.
    final editable = widget.current.editable ?? true;

    if (spec.isToggle) {
      return SwitchListTile(
        title: Text(spec.label),
        subtitle: Text(spec.description),
        value: value == spec.onValue,
        onChanged: !editable || _busy
            ? null
            : (v) => _write(v ? spec.onValue : spec.offValue),
        isThreeLine: true,
      );
    }

    return ListTile(
      title: Text(spec.label),
      subtitle: Text(spec.description),
      isThreeLine: true,
      trailing: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : DropdownButton<String>(
              value: spec.options.any((o) => o.value == value) ? value : null,
              hint: Text(value ?? '—'),
              underline: const SizedBox.shrink(),
              onChanged: editable ? (v) => v == null ? null : _write(v) : null,
              items: [
                for (final o in spec.options)
                  DropdownMenuItem(value: o.value, child: Text(o.label)),
              ],
            ),
    );
  }

  Future<void> _write(String value) async {
    setState(() => _busy = true);
    try {
      await ref
          .read(zoneSettingsActionsProvider)
          .edit(zoneId: widget.zoneId, settingId: widget.spec.id, value: value);
      ref.invalidate(zoneSettingsProvider(widget.zoneId));
    } on CfFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(context, e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Cache purge, with the destructive option gated behind a typed confirmation.
class PurgeScreen extends ConsumerStatefulWidget {
  const PurgeScreen({required this.zoneId, required this.zoneName, super.key});

  final String zoneId;
  final String zoneName;

  @override
  ConsumerState<PurgeScreen> createState() => _PurgeScreenState();
}

class _PurgeScreenState extends ConsumerState<PurgeScreen> {
  final _targets = TextEditingController();
  String _mode = 'files';
  bool _busy = false;

  @override
  void dispose() {
    _targets.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('${l.cachePurgeTitle} · ${widget.zoneName}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'files', label: Text(l.purgeByUrl)),
              ButtonSegment(value: 'hosts', label: Text(l.purgeByHost)),
              ButtonSegment(value: 'prefixes', label: Text(l.purgeByPrefix)),
              ButtonSegment(value: 'tags', label: Text(l.purgeByTag)),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _targets,
            minLines: 3,
            maxLines: 8,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: l.purgeTargets,
              hintText: switch (_mode) {
                'files' =>
                  'https://example.com/style.css\nhttps://example.com/a.js',
                'hosts' => 'www.example.com\nassets.example.com',
                'prefixes' => 'example.com/blog\nexample.com/img',
                _ => 'landing-page\nproduct-images',
              },
              helperText: l.purgeOnePerLine,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _busy ? null : _purgeTargeted,
            icon: const Icon(Icons.cleaning_services_outlined),
            label: Text(l.cachePurgeTitle),
          ),

          const SizedBox(height: 32),
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.cachePurgeEverything,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.cachePurgeEverythingWarn,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _busy ? null : _purgeEverything,
                    child: Text(l.cachePurgeEverything),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> get _lines => _targets.text
      .split('\n')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  Future<void> _purgeTargeted() async {
    final targets = _lines;
    if (targets.isEmpty) return;

    final actions = ref.read(zoneSettingsActionsProvider);
    await _run(
      () => switch (_mode) {
        'files' => actions.purgeFiles(widget.zoneId, targets),
        'hosts' => actions.purgeHosts(widget.zoneId, targets),
        'prefixes' => actions.purgePrefixes(widget.zoneId, targets),
        _ => actions.purgeTags(widget.zoneId, targets),
      },
    );
  }

  /// Typed confirmation, because this one drops every cached object for the
  /// zone and briefly puts the full load on the origin.
  Future<void> _purgeEverything() async {
    final l = L.of(context);
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.cachePurgeEverything),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.cachePurgeEverythingWarn),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autocorrect: false,
              decoration: InputDecoration(labelText: l.cachePurgeConfirm),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(controller.text.trim().toUpperCase() == 'PURGE'),
            child: Text(l.cachePurgeEverything),
          ),
        ],
      ),
    );
    controller.dispose();
    if (ok != true) return;

    await _run(
      () =>
          ref.read(zoneSettingsActionsProvider).purgeEverything(widget.zoneId),
    );
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(L.of(context).cachePurged)));
      }
    } on CfFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(context, e))));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}
