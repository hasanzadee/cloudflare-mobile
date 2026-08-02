import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/catalog.dart';
import '../core/state.dart';
import '../core/ui.dart';

class EndpointRunnerScreen extends ConsumerStatefulWidget {
  final Endpoint endpoint;
  const EndpointRunnerScreen({super.key, required this.endpoint});

  @override
  ConsumerState<EndpointRunnerScreen> createState() =>
      _EndpointRunnerScreenState();
}

class _EndpointRunnerScreenState extends ConsumerState<EndpointRunnerScreen> {
  late final Map<String, TextEditingController> _pathParams;
  final _query = TextEditingController();
  final _body = TextEditingController();

  bool _busy = false;
  Response? _resp;
  Object? _err;

  @override
  void initState() {
    super.initState();
    _pathParams = {
      for (final p in widget.endpoint.pathParams) p: TextEditingController(),
    };
    // Auto-fill from settings.
    final s = ref.read(settingsProvider);
    _pathParams['account_id']?.text = s.accountId;
    _pathParams['zone_id']?.text = s.zoneId;
    if (widget.endpoint.method != 'GET' && widget.endpoint.method != 'DELETE') {
      _body.text = '{\n  \n}';
    }
  }

  @override
  void dispose() {
    for (final c in _pathParams.values) {
      c.dispose();
    }
    _query.dispose();
    _body.dispose();
    super.dispose();
  }

  String _buildPath() {
    var p = widget.endpoint.path;
    for (final entry in _pathParams.entries) {
      p = p.replaceAll('{${entry.key}}', Uri.encodeComponent(entry.value.text));
    }
    return p;
  }

  Future<void> _send() async {
    final api = ref.read(cfApiProvider);
    if (api == null) return;
    setState(() {
      _busy = true;
      _resp = null;
      _err = null;
    });
    try {
      final missing = _pathParams.entries
          .where((e) => e.value.text.trim().isEmpty)
          .map((e) => e.key)
          .toList();
      if (missing.isNotEmpty) {
        throw ArgumentError('Заполни параметры: ${missing.join(', ')}');
      }
      Map<String, dynamic>? query;
      if (_query.text.trim().isNotEmpty) {
        try {
          query = jsonDecode(_query.text) as Map<String, dynamic>;
        } catch (_) {
          // Treat as URL-encoded ?a=1&b=2
          query = Uri.splitQueryString(_query.text.trim());
        }
      }
      Object? body;
      final m = widget.endpoint.method;
      if (m != 'GET' && m != 'DELETE' && _body.text.trim().isNotEmpty) {
        body = jsonDecode(_body.text);
      }
      final r = await api.raw(
        method: m,
        path: _buildPath(),
        body: body,
        query: query,
      );
      setState(() => _resp = r);
    } catch (e) {
      setState(() => _err = e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.endpoint;
    return Scaffold(
      appBar: AppBar(
        title: Text(e.summary.isNotEmpty ? e.summary : e.operationId),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                MethodChip(e.method),
                const SizedBox(width: 8),
                Expanded(child: HighlightedPath(e.path)),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  tooltip: 'Скопировать путь',
                  onPressed: () => copyToClipboard(context, e.path),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          if (e.deprecated)
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Этот эндпоинт помечен как deprecated.'),
                  ),
                ],
              ),
            ),
          if (_pathParams.isNotEmpty)
            SectionCard(
              title: 'Path parameters',
              icon: Icons.tune,
              child: Column(
                children: _pathParams.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: entry.key,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          SectionCard(
            title: 'Query',
            icon: Icons.filter_alt_outlined,
            child: TextField(
              controller: _query,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'JSON: {"per_page": 50} или строка: per_page=50&page=1',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          if (e.method != 'GET' && e.method != 'DELETE')
            SectionCard(
              title: 'Body (JSON)',
              icon: Icons.code,
              child: TextField(
                controller: _body,
                maxLines: 10,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                decoration: const InputDecoration(
                  hintText: '{\n  "key": "value"\n}',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: _busy ? null : _send,
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_busy ? 'Отправка...' : 'Отправить запрос'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ),
          if (_err != null)
            SectionCard(
              title: 'Ошибка',
              icon: Icons.error_outline,
              child: Text(
                '$_err',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          if (_resp != null) _responseCard(_resp!),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _responseCard(Response r) {
    final pretty = prettyJson(r.data);
    return SectionCard(
      title: 'Ответ',
      icon: Icons.receipt_long,
      actions: [
        StatusChip(r.statusCode ?? 0),
        const SizedBox(width: 4),
        IconButton(
          tooltip: 'Скопировать',
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () => copyToClipboard(context, pretty),
        ),
      ],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(6),
        ),
        child: SelectableText(
          pretty,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
