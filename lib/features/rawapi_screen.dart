import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/state.dart';

class RawApiScreen extends ConsumerStatefulWidget {
  const RawApiScreen({super.key});
  @override
  ConsumerState<RawApiScreen> createState() => _RawApiState();
}

class _RawApiState extends ConsumerState<RawApiScreen> {
  String _method = 'GET';
  final _path = TextEditingController(text: 'user/tokens/verify');
  final _body = TextEditingController();
  bool _busy = false;
  String? _result;
  int? _status;

  @override
  void dispose() {
    _path.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final api = ref.read(cfApiProvider);
    if (api == null) return;
    setState(() {
      _busy = true;
      _result = null;
      _status = null;
    });
    try {
      Object? body;
      if (_body.text.trim().isNotEmpty &&
          (_method == 'POST' || _method == 'PUT' || _method == 'PATCH' || _method == 'DELETE')) {
        try {
          body = jsonDecode(_body.text);
        } catch (_) {
          setState(() {
            _result = 'Неверный JSON в body';
            _busy = false;
          });
          return;
        }
      }
      final r = await api.raw(method: _method, path: _path.text.trim(), body: body);
      setState(() {
        _status = r.statusCode;
        const enc = JsonEncoder.withIndent('  ');
        _result = enc.convert(r.data);
      });
    } catch (e) {
      setState(() => _result = 'Ошибка: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                width: 120,
                child: DropdownButtonFormField<String>(
                  value: _method,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Method'),
                  items: const ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => _method = v ?? 'GET'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _path,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Path',
                    hintText: 'zones или accounts/{id}/...',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _body,
            maxLines: 6,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'JSON body (для POST/PUT/PATCH)',
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            FilledButton.icon(
              icon: _busy
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.send),
              onPressed: _busy ? null : _send,
              label: const Text('Отправить'),
            ),
            const SizedBox(width: 12),
            if (_status != null)
              Chip(
                label: Text('HTTP $_status'),
                backgroundColor: (_status! >= 200 && _status! < 300)
                    ? Colors.green.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
              ),
            const Spacer(),
            if (_result != null)
              IconButton(
                tooltip: 'Скопировать',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _result!));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Скопировано')));
                },
                icon: const Icon(Icons.copy),
              ),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: SelectableText(
                  _result ?? '',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
