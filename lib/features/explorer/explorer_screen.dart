import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import 'runner_screen.dart';
import 'spec_repository.dart';

/// Browse and search every endpoint in the Cloudflare API.
class ExplorerScreen extends ConsumerStatefulWidget {
  const ExplorerScreen({super.key});

  @override
  ConsumerState<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends ConsumerState<ExplorerScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final spec = ref.watch(specProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.explorerTitle),
            Text(
              spec.valueOrNull == null
                  ? '…'
                  : l.explorerSubtitle(spec.value!.operations.length),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: l.explorerSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: AsyncView<SpecIndex>(
              value: spec,
              onRetry: () => ref.invalidate(specProvider),
              builder: (index) =>
                  _query.trim().isEmpty ? _tags(index) : _results(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tags(SpecIndex index) {
    final tags = index.byTag.keys.toList()..sort();
    return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, i) {
        final tag = tags[i];
        final ops = index.byTag[tag]!;
        return ExpansionTile(
          title: Text(tag),
          subtitle: Text('${ops.length}'),
          children: [
            for (final op in ops)
              _OperationTile(op: op, onTap: () => _open(op)),
          ],
        );
      },
    );
  }

  Widget _results(SpecIndex index) {
    final results = index.search(_query);
    if (results.isEmpty) {
      return Center(child: Text(L.of(context).commonNothingHere));
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) =>
          _OperationTile(op: results[i], onTap: () => _open(results[i])),
    );
  }

  void _open(SpecOperation op) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RunnerScreen(operation: op)),
    );
  }
}

class _OperationTile extends StatelessWidget {
  const _OperationTile({required this.op, required this.onTap});

  final SpecOperation op;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    leading: MethodBadge(method: op.method),
    title: Text(
      op.path,
      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: op.summary == null
        ? null
        : Text(
            op.summary!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: op.deprecated
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
    trailing: op.deprecated
        ? Tooltip(
            message: L.of(context).explorerDeprecated,
            child: Icon(Icons.warning_amber, color: context.cf.warning),
          )
        : null,
    onTap: onTap,
  );
}

class MethodBadge extends StatelessWidget {
  const MethodBadge({required this.method, super.key});

  final String method;

  @override
  Widget build(BuildContext context) {
    final color = context.cf.forMethod(method);
    return Container(
      width: 58,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        method,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}
