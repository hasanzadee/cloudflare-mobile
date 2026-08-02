import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/failure_text.dart';
import '../zones/zones_providers.dart';
import 'dns_editor.dart';
import 'dns_providers.dart';
import 'record_types.dart';

class DnsScreen extends ConsumerStatefulWidget {
  const DnsScreen({required this.zoneId, required this.zoneName, super.key});

  final String zoneId;
  final String zoneName;

  @override
  ConsumerState<DnsScreen> createState() => _DnsScreenState();
}

class _DnsScreenState extends ConsumerState<DnsScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 600) {
        ref.read(dnsProvider(widget.zoneId).notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final records = ref.watch(dnsProvider(widget.zoneId));
    final typeFilter = ref.watch(dnsTypeFilterProvider(widget.zoneId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.zoneName),
            Text(
              records.valueOrNull == null
                  ? l.dnsTitle
                  : l.dnsRecords(records.value!.items.length),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: Text(l.dnsAddRecord),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: l.dnsSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (v) =>
                  ref.read(dnsSearchProvider(widget.zoneId).notifier).state = v
                      .trim(),
            ),
          ),
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6, top: 6),
                  child: FilterChip(
                    label: Text(l.commonAll),
                    selected: typeFilter == null,
                    onSelected: (_) =>
                        ref
                                .read(
                                  dnsTypeFilterProvider(widget.zoneId).notifier,
                                )
                                .state =
                            null,
                  ),
                ),
                for (final t in const [
                  'A',
                  'AAAA',
                  'CNAME',
                  'TXT',
                  'MX',
                  'NS',
                  'SRV',
                  'CAA',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 6, top: 6),
                    child: FilterChip(
                      label: Text(t),
                      selected: typeFilter == t,
                      onSelected: (selected) =>
                          ref
                              .read(
                                dnsTypeFilterProvider(widget.zoneId).notifier,
                              )
                              .state = selected
                          ? t
                          : null,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: AsyncView<PagedData<DnsRecordResponse>>(
              value: records,
              onRetry: () => ref.invalidate(dnsProvider(widget.zoneId)),
              isEmpty: (d) => d.items.isEmpty,
              builder: (data) => RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(dnsProvider(widget.zoneId)),
                child: ListView.separated(
                  controller: _scroll,
                  itemCount: data.items.length + (data.hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    if (i >= data.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _RecordTile(
                      record: data.items[i],
                      onEdit: () => _openEditor(existing: data.items[i]),
                      onDelete: () => _confirmDelete(data.items[i]),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the editor on a freshly fetched copy.
  ///
  /// The list may be minutes old; offering Save over stale values is how a
  /// management app silently reverts somebody else's change.
  Future<void> _openEditor({DnsRecordResponse? existing}) async {
    DnsRecordResponse? fresh = existing;
    if (existing?.id != null) {
      try {
        fresh = await ref
            .read(dnsProvider(widget.zoneId).notifier)
            .readFresh(existing!.id!);
      } on CfFailure catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(context, e))));
        return;
      }
    }
    if (!mounted) return;

    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DnsEditorSheet(
        zoneId: widget.zoneId,
        zoneName: widget.zoneName,
        existing: fresh,
      ),
    );
  }

  Future<void> _confirmDelete(DnsRecordResponse record) async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.dnsDeleteConfirm(record.name ?? '')),
        content: Text('${record.type_ ?? ''}  ${record.content ?? ''}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || record.id == null) return;

    try {
      await ref.read(dnsProvider(widget.zoneId).notifier).delete(record.id!);
    } on CfFailure catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failureMessage(context, e))));
    }
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  final DnsRecordResponse record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final proxied = record.proxied ?? false;
    final type = record.type_ ?? '?';

    return ListTile(
      leading: SizedBox(
        width: 56,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ),
        ),
      ),
      title: Text(record.name ?? '—', overflow: TextOverflow.ellipsis),
      subtitle: Text(_subtitle(), maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (record.proxiable ?? false)
            Icon(
              Icons.cloud,
              size: 18,
              color: proxied
                  ? context.cf.proxied
                  : Theme.of(context).disabledColor,
            ),
          PopupMenuButton<String>(
            onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Text(L.of(context).commonEdit),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(L.of(context).commonDelete),
              ),
            ],
          ),
        ],
      ),
      onTap: onEdit,
    );
  }

  String _subtitle() {
    final parts = <String>[];
    if (record.content != null && record.content!.isNotEmpty) {
      parts.add(record.content!);
    }
    final data = record.data?.toJson() ?? const <String, Object?>{};
    if (data.isNotEmpty) {
      parts.add(
        data.entries
            .where((e) => e.value != null)
            .map((e) => '${e.key}=${e.value}')
            .join(' '),
      );
    }
    if (record.priority != null) parts.add('priority ${record.priority}');
    final ttl = record.ttl?.toInt();
    if (ttl != null) parts.add('TTL ${ttlLabel(ttl)}');
    return parts.join(' · ');
  }
}
