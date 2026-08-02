import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/failure_text.dart';
import '../scope/scope_providers.dart';
import 'explorer_screen.dart';
import 'spec_repository.dart';

/// Runs one endpoint, with a form built from its schema.
///
/// The prototype rendered a bare TextField per `{path_param}` and an empty JSON
/// box; nothing knew a parameter's type, whether it was required, or which
/// values an enum allowed, because the bundled asset carried no schema at all.
class RunnerScreen extends ConsumerStatefulWidget {
  const RunnerScreen({required this.operation, super.key});

  final SpecOperation operation;

  @override
  ConsumerState<RunnerScreen> createState() => _RunnerScreenState();
}

class _RunnerScreenState extends ConsumerState<RunnerScreen> {
  final Map<String, TextEditingController> _fields = {};
  final Map<String, String?> _enums = {};
  late final TextEditingController _body;

  bool _busy = false;
  int? _status;
  String? _response;
  String? _error;

  @override
  void initState() {
    super.initState();
    final scope = ref.read(scopeProvider);

    for (final p in widget.operation.params) {
      if (p.enumValues != null && p.enumValues!.isNotEmpty) {
        _enums[p.name] = p.defaultValue?.toString();
        continue;
      }
      // Pre-fill the ids the user is already scoped to — the single biggest
      // time-saver, and the reason scope is app state.
      final prefill = switch (p.name) {
        'account_id' || 'account_identifier' => scope.accountId,
        'zone_id' || 'zone_identifier' => scope.zoneId,
        _ => p.defaultValue?.toString(),
      };
      _fields[p.name] = TextEditingController(text: prefill ?? '');
    }

    _body = TextEditingController();
  }

  @override
  void dispose() {
    for (final c in _fields.values) {
      c.dispose();
    }
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final op = widget.operation;
    final spec = ref.watch(specProvider).valueOrNull;

    if (op.takesBody && _body.text.isEmpty && spec != null) {
      _body.text = spec.bodyTemplate(op.bodyRef);
    }

    return Scaffold(
      appBar: AppBar(title: Text(op.tag, overflow: TextOverflow.ellipsis)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Row(
            children: [
              MethodBadge(method: op.method),
              const SizedBox(width: 10),
              Expanded(
                child: SelectableText(
                  op.path,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
            ],
          ),
          if (op.summary != null) ...[
            const SizedBox(height: 8),
            Text(op.summary!, style: Theme.of(context).textTheme.bodySmall),
          ],
          if (op.deprecated) ...[
            const SizedBox(height: 8),
            _Banner(
              icon: Icons.warning_amber,
              color: context.cf.warning,
              text: 'Cloudflare marks this endpoint as deprecated.',
            ),
          ],
          const Divider(height: 28),

          if (op.params.isEmpty && !op.takesBody)
            Text(l.explorerNoParams)
          else ...[
            for (final p in op.pathParams) _field(p, isPath: true),
            for (final p in op.queryParams) _field(p, isPath: false),
          ],

          if (op.takesBody) ...[
            const SizedBox(height: 16),
            Text(l.explorerBody, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            TextField(
              controller: _body,
              maxLines: 10,
              minLines: 4,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: const InputDecoration(hintText: '{ }'),
            ),
          ],

          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _busy ? null : _send,
            icon: const Icon(Icons.play_arrow),
            label: Text(_busy ? '…' : l.explorerSend),
          ),

          if (_error != null) ...[
            const SizedBox(height: 16),
            _Banner(
              icon: Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              text: _error!,
            ),
          ],

          if (_response != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                _StatusChip(code: _status ?? 0),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: _response!));
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(l.commonCopied)));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                _response!,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _field(SpecParam p, {required bool isPath}) {
    final label = p.required || isPath ? '${p.name} *' : p.name;
    final help = [
      if (p.type != null) p.type!,
      if (p.format != null) p.format!,
      if (p.minimum != null || p.maximum != null)
        '${p.minimum ?? ''}..${p.maximum ?? ''}',
      if (p.doc != null) p.doc!,
    ].join(' · ');

    if (p.enumValues != null && p.enumValues!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          initialValue: _enums[p.name],
          decoration: InputDecoration(
            labelText: label,
            helperText: help.isEmpty ? null : help,
            helperMaxLines: 2,
          ),
          items: [
            const DropdownMenuItem(child: Text('—')),
            for (final v in p.enumValues!)
              DropdownMenuItem(value: v, child: Text(v)),
          ],
          onChanged: (v) => setState(() => _enums[p.name] = v),
        ),
      );
    }

    final numeric = p.type == 'integer' || p.type == 'number';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _fields[p.name],
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
        inputFormatters: numeric
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: label,
          helperText: help.isEmpty ? null : help,
          helperMaxLines: 2,
        ),
      ),
    );
  }

  Future<void> _send() async {
    final op = widget.operation;
    setState(() {
      _busy = true;
      _error = null;
      _response = null;
    });

    var path = op.path;
    for (final p in op.pathParams) {
      final value = _fields[p.name]?.text.trim() ?? '';
      if (value.isEmpty) {
        setState(() {
          _busy = false;
          _error = '${p.name} is required';
        });
        return;
      }
      path = path.replaceAll('{${p.name}}', Uri.encodeComponent(value));
    }

    final query = <String, Object?>{};
    for (final p in op.queryParams) {
      final enumValue = _enums[p.name];
      if (enumValue != null && enumValue.isNotEmpty) {
        query[p.name] = enumValue;
        continue;
      }
      final value = _fields[p.name]?.text.trim() ?? '';
      if (value.isNotEmpty) query[p.name] = value;
    }

    Object? body;
    if (op.takesBody && _body.text.trim().isNotEmpty) {
      try {
        body = jsonDecode(_body.text);
      } on FormatException catch (e) {
        setState(() {
          _busy = false;
          _error = 'Body is not valid JSON: ${e.message}';
        });
        return;
      }
    }

    try {
      final response = await ref
          .read(cfClientProvider)
          .sendRaw(method: op.method, path: path, query: query, body: body);
      final data = response.data;
      setState(() {
        _status = response.statusCode;
        _response = data is String
            ? data
            : const JsonEncoder.withIndent('  ').convert(data);
      });
    } on CfFailure catch (e) {
      if (mounted) setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.4)),
    ),
    child: Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: color)),
        ),
      ],
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.code});

  final int code;

  @override
  Widget build(BuildContext context) {
    final cf = context.cf;
    final color = switch (code) {
      >= 200 && < 300 => cf.success,
      >= 300 && < 400 => cf.post,
      >= 400 && < 500 => cf.warning,
      >= 500 => cf.danger,
      _ => Theme.of(context).disabledColor,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        'HTTP $code',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
