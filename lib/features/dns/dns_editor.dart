import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/failure_text.dart';
import 'dns_providers.dart';
import 'record_types.dart';

/// Create/edit form with fields that match the selected record type.
///
/// The prototype offered `type` as a free-text box plus a single `content`
/// field, so an MX record silently lost its priority and an SRV record could
/// not be created at all.
///
/// Per-type members go into the `data` object. The generated model only
/// declares the two fields the spec's `anyOf` branches share, so the rest ride
/// in `extra` — which the generator preserves through `toJson`, precisely so
/// spec gaps like this one do not lose data.
class DnsEditorSheet extends ConsumerStatefulWidget {
  const DnsEditorSheet({
    required this.zoneId,
    required this.zoneName,
    this.existing,
    super.key,
  });

  final String zoneId;
  final String zoneName;
  final DnsRecordResponse? existing;

  @override
  ConsumerState<DnsEditorSheet> createState() => _DnsEditorSheetState();
}

class _DnsEditorSheetState extends ConsumerState<DnsEditorSheet> {
  late DnsRecordType _type;
  late final TextEditingController _name;
  late final TextEditingController _content;
  late final TextEditingController _priority;
  late final TextEditingController _comment;
  final Map<String, TextEditingController> _data = {};

  int _ttl = 1;
  bool _proxied = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _type = dnsTypeByName(existing?.type_ ?? 'A');
    _name = TextEditingController(text: existing?.name ?? '');
    _content = TextEditingController(text: existing?.content ?? '');
    _priority = TextEditingController(
      text: existing?.priority?.toString() ?? '',
    );
    _comment = TextEditingController(text: existing?.comment ?? '');
    _ttl = existing?.ttl?.toInt() ?? 1;
    _proxied = existing?.proxied ?? false;

    final existingData = existing?.data?.toJson() ?? const <String, Object?>{};
    for (final field in _type.dataFields) {
      _data[field.key] = TextEditingController(
        text: existingData[field.key]?.toString() ?? '',
      );
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _content, _priority, _comment, ..._data.values]) {
      c.dispose();
    }
    super.dispose();
  }

  void _changeType(DnsRecordType next) {
    setState(() {
      _type = next;
      for (final c in _data.values) {
        c.dispose();
      }
      _data
        ..clear()
        ..addEntries(
          next.dataFields.map((f) => MapEntry(f.key, TextEditingController())),
        );
      if (!next.proxyable) _proxied = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final editing = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    editing ? l.dnsEditRecord : l.dnsAddRecord,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _type.name,
              decoration: InputDecoration(labelText: l.dnsType),
              items: [
                for (final t in kDnsRecordTypes)
                  DropdownMenuItem(
                    value: t.name,
                    child: Text('${t.name} — ${t.description}'),
                  ),
              ],
              onChanged: editing
                  ? null // Cloudflare does not allow changing a record's type.
                  : (v) => _changeType(dnsTypeByName(v)),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: l.dnsName,
                hintText: '@ for ${widget.zoneName}',
              ),
              autocorrect: false,
            ),
            const SizedBox(height: 12),

            if (_type.usesContent)
              TextField(
                controller: _content,
                decoration: InputDecoration(
                  labelText: l.dnsContent,
                  hintText: _type.contentHint,
                ),
                autocorrect: false,
                maxLines: _type.name == 'TXT' ? 4 : 1,
              ),

            if (_type.hasPriority) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _priority,
                decoration: InputDecoration(labelText: l.dnsPriority),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],

            for (final field in _type.dataFields) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _data[field.key],
                decoration: InputDecoration(
                  labelText: field.required
                      ? field.label
                      : '${field.label} (optional)',
                  hintText: field.hint,
                ),
                keyboardType: field.kind == DnsFieldKind.number
                    ? TextInputType.number
                    : TextInputType.text,
                maxLines: field.kind == DnsFieldKind.multiline ? 3 : 1,
                autocorrect: false,
              ),
            ],

            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: kTtlChoices.contains(_ttl) ? _ttl : 1,
              decoration: InputDecoration(labelText: l.dnsTtl),
              items: [
                for (final t in kTtlChoices)
                  DropdownMenuItem(value: t, child: Text(ttlLabel(t))),
              ],
              onChanged: (v) => setState(() => _ttl = v ?? 1),
            ),

            if (_type.proxyable) ...[
              const SizedBox(height: 4),
              SwitchListTile(
                value: _proxied,
                onChanged: (v) => setState(() => _proxied = v),
                title: Text(l.dnsProxied),
                subtitle: const Text(
                  'Traffic goes through Cloudflare and the origin IP is hidden. '
                  'TTL is managed by Cloudflare while this is on.',
                ),
                secondary: Icon(Icons.cloud, color: context.cf.proxied),
                contentPadding: EdgeInsets.zero,
              ),
            ],

            const SizedBox(height: 12),
            TextField(
              controller: _comment,
              decoration: InputDecoration(labelText: l.dnsComment),
              maxLines: 2,
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],

            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: Text(_busy ? '…' : l.commonSave),
            ),
          ],
        ),
      ),
    );
  }

  DnsRecordPost _build() {
    final data = <String, Object?>{};
    for (final field in _type.dataFields) {
      final raw = _data[field.key]?.text.trim() ?? '';
      if (raw.isEmpty) continue;
      data[field.key] = field.kind == DnsFieldKind.number
          ? num.tryParse(raw) ?? raw
          : raw;
    }

    return DnsRecordPost(
      type_: _type.name,
      name: _name.text.trim().isEmpty ? '@' : _name.text.trim(),
      ttl: _ttl,
      proxied: _type.proxyable ? _proxied : null,
      comment: _comment.text.trim().isEmpty ? null : _comment.text.trim(),
      content: _type.usesContent ? _content.text.trim() : null,
      priority: _type.hasPriority ? num.tryParse(_priority.text.trim()) : null,
      // Unknown-key preservation is what lets per-type members through.
      data: data.isEmpty ? null : DnsRecordPostData(extra: data),
    );
  }

  String? _validate() {
    if (_type.usesContent && _content.text.trim().isEmpty) {
      return '${L.of(context).dnsContent} is required';
    }
    if (_type.hasPriority && num.tryParse(_priority.text.trim()) == null) {
      return '${L.of(context).dnsPriority} is required';
    }
    for (final field in _type.dataFields.where((f) => f.required)) {
      if ((_data[field.key]?.text.trim() ?? '').isEmpty) {
        return '${field.label} is required';
      }
    }
    return null;
  }

  Future<void> _save() async {
    final problem = _validate();
    if (problem != null) {
      setState(() => _error = problem);
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final controller = ref.read(dnsProvider(widget.zoneId).notifier);
    try {
      final existingId = widget.existing?.id;
      if (existingId == null) {
        await controller.create(_build());
      } else {
        await controller.edit(existingId, _build());
      }
      if (mounted) Navigator.of(context).pop(true);
    } on CfFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = failureMessage(context, e);
      });
    }
  }
}
