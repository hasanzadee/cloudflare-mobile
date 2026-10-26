import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/failure_text.dart';
import 'zone_settings_providers.dart';

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
