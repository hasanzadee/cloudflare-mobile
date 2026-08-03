import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/failure_text.dart';
import 'developer_providers.dart';

/// A SQL console for one D1 database.
///
/// Destructive statements go behind a typed confirmation. A phone is a bad
/// place to discover you meant `DELETE FROM t WHERE id = 1` and typed the first
/// four words.
class D1ConsoleScreen extends ConsumerStatefulWidget {
  const D1ConsoleScreen({
    required this.accountId,
    required this.databaseId,
    required this.name,
    super.key,
  });

  final String accountId;
  final String databaseId;
  final String name;

  @override
  ConsumerState<D1ConsoleScreen> createState() => _D1ConsoleScreenState();
}

class _D1ConsoleScreenState extends ConsumerState<D1ConsoleScreen> {
  final _sql = TextEditingController(
    text: "SELECT name FROM sqlite_master WHERE type='table';",
  );

  bool _busy = false;
  String? _error;
  List<Object?>? _rows;
  String? _meta;

  static final _destructive = RegExp(
    r'^\s*(delete|drop|truncate|update|alter|insert|replace)\b',
    caseSensitive: false,
  );

  @override
  void dispose() {
    _sql.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final destructive = _destructive.hasMatch(_sql.text);

    return Scaffold(
      appBar: AppBar(title: Text('D1 · ${widget.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _sql,
            minLines: 3,
            maxLines: 10,
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: InputDecoration(
              labelText: l.d1Query,
              helperText: l.d1OneStatement,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy ? null : _run,
                  icon: Icon(
                    destructive ? Icons.warning_amber : Icons.play_arrow,
                  ),
                  style: destructive
                      ? FilledButton.styleFrom(
                          backgroundColor: context.cf.danger,
                        )
                      : null,
                  label: Text(_busy ? '…' : l.d1Run),
                ),
              ),
            ],
          ),
          if (destructive)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l.d1DestructiveWarning,
                style: TextStyle(color: context.cf.danger, fontSize: 12),
              ),
            ),

          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],

          if (_meta != null) ...[
            const SizedBox(height: 16),
            Text(_meta!, style: Theme.of(context).textTheme.labelSmall),
          ],

          if (_rows != null) ...[
            const SizedBox(height: 8),
            if (_rows!.isEmpty)
              Text(l.d1NoRows)
            else
              _ResultTable(rows: _rows!),
          ],
        ],
      ),
    );
  }

  Future<void> _run() async {
    final sql = _sql.text.trim();
    if (sql.isEmpty) return;

    if (_destructive.hasMatch(sql) && !await _confirm(sql)) return;

    setState(() {
      _busy = true;
      _error = null;
      _rows = null;
      _meta = null;
    });

    try {
      final page = await ref
          .read(d1ActionsProvider)
          .query(
            accountId: widget.accountId,
            databaseId: widget.databaseId,
            sql: sql,
          );
      final first = page.items.isEmpty ? null : page.items.first;
      setState(() {
        _rows = first?.results ?? const [];
        final m = first?.meta;
        _meta = m == null
            ? null
            : 'rows read ${m.rowsRead ?? 0} · rows written ${m.rowsWritten ?? 0}'
                  ' · ${m.duration ?? 0} ms';
      });
    } on CfFailure catch (e) {
      if (mounted) setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String sql) async {
    final l = L.of(context);
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.d1ConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sql,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autocorrect: false,
              decoration: InputDecoration(labelText: l.d1ConfirmHint),
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
            ).pop(controller.text.trim().toUpperCase() == 'RUN'),
            child: Text(l.d1Run),
          ),
        ],
      ),
    );
    controller.dispose();
    return ok ?? false;
  }
}

class _ResultTable extends StatelessWidget {
  const _ResultTable({required this.rows});

  final List<Object?> rows;

  @override
  Widget build(BuildContext context) {
    final maps = rows
        .whereType<Map<Object?, Object?>>()
        .map((r) => r.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
    if (maps.isEmpty) {
      return SelectableText(
        rows.join('\n'),
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      );
    }

    final columns = maps.first.keys.toList();
    return SingleChildScrollView(
      // A result set is arbitrarily wide; the page must not scroll sideways.
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingRowHeight: 36,
        dataRowMinHeight: 32,
        dataRowMaxHeight: 48,
        columns: [
          for (final c in columns)
            DataColumn(
              label: Text(
                c,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
        ],
        rows: [
          for (final row in maps.take(200))
            DataRow(
              cells: [
                for (final c in columns)
                  DataCell(
                    Text(
                      '${row[c] ?? ''}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
