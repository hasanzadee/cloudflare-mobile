import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/ds/ds.dart';
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

  /// Records whose proxy flag is being written, so their cloud shows a
  /// spinner and cannot be tapped twice.
  final Set<String> _flipping = {};

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
            Text(l.dnsTitle),
            Text(
              records.valueOrNull == null
                  ? widget.zoneName
                  : '${widget.zoneName} · '
                        '${l.dnsRecords(records.value!.items.length)}',
              style: context.text.labelMedium?.copyWith(
                color: context.scheme.onSurfaceVariant,
              ),
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
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xs, Gap.lg, 0),
            child: SearchField(
              controller: _search,
              hint: l.dnsSearchHint,
              onChanged: (_) => setState(() {}),
              onSubmitted: (v) =>
                  ref.read(dnsSearchProvider(widget.zoneId).notifier).state = v
                      .trim(),
              onClear: () {
                _search.clear();
                ref.read(dnsSearchProvider(widget.zoneId).notifier).state = '';
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
              children: [
                for (final t in [null, ..._quickTypes])
                  Padding(
                    padding: const EdgeInsets.only(right: 6, top: Gap.sm),
                    child: ChoiceChip(
                      label: Text(t ?? l.commonAll),
                      selected: typeFilter == t,
                      showCheckmark: false,
                      onSelected: (_) =>
                          ref
                                  .read(
                                    dnsTypeFilterProvider(
                                      widget.zoneId,
                                    ).notifier,
                                  )
                                  .state =
                              t,
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
              empty: EmptyState(
                icon: Icons.dns_outlined,
                tone: Tone.brand,
                title: l.dnsEmptyTitle,
                body: l.dnsEmptyBody,
                action: l.dnsAddRecord,
                onAction: () => _openEditor(),
              ),
              builder: (data) {
                final count = data.items.length;
                return RefreshIndicator(
                  onRefresh: () async =>
                      ref.invalidate(dnsProvider(widget.zoneId)),
                  child: ListView.builder(
                    controller: _scroll,
                    // Room under the last row for the floating button.
                    padding: const EdgeInsets.only(top: Gap.xs, bottom: 96),
                    itemCount: count + (data.hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= count) {
                        return const Padding(
                          padding: EdgeInsets.all(Gap.lg),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final r = data.items[i];
                      return GroupedItem(
                        index: i,
                        count: count,
                        dividerIndent: 76,
                        child: _RecordRow(
                          record: r,
                          zoneName: widget.zoneName,
                          flipping: _flipping.contains(r.id),
                          onEdit: () => _openEditor(existing: r),
                          onDelete: () => _confirmDelete(r),
                          onProxy: () => _toggleProxy(r),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static const _quickTypes = [
    'A',
    'AAAA',
    'CNAME',
    'TXT',
    'MX',
    'NS',
    'SRV',
    'CAA',
  ];

  /// The orange cloud, one tap away — through the before/after sheet, because
  /// turning it off publishes the origin's real IP address.
  Future<void> _toggleProxy(DnsRecordResponse record) async {
    final l = L.of(context);
    final id = record.id;
    if (id == null) return;
    final on = !(record.proxied ?? false);
    final name = record.name ?? '';

    final ok = await confirmChanges(
      context,
      title: on ? l.dnsProxyOnTitle(name) : l.dnsProxyOffTitle(name),
      note: on ? l.dnsProxyOnNote : l.dnsProxyOffNote,
      tone: on ? Tone.brand : Tone.warning,
      confirmLabel: l.zoneApply,
      changes: [
        Change(
          '${record.type_ ?? ''} $name  ${record.content ?? ''}',
          from: on ? l.dnsStateDnsOnly : l.dnsStateProxied,
          to: on ? l.dnsStateProxied : l.dnsStateDnsOnly,
        ),
      ],
    );
    if (!ok || !mounted) return;

    setState(() => _flipping.add(id));
    try {
      await ref
          .read(dnsProvider(widget.zoneId).notifier)
          .setProxied(record, on: on);
    } on CfFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failureMessage(context, e))));
      }
    } finally {
      if (mounted) setState(() => _flipping.remove(id));
    }
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
    final ok = await confirmChanges(
      context,
      title: l.dnsDeleteConfirm(record.name ?? ''),
      tone: Tone.danger,
      confirmLabel: l.commonDelete,
      changes: [
        Change(
          '${record.type_ ?? ''} ${record.name ?? ''}',
          from: record.content ?? '',
          to: '—',
        ),
      ],
    );
    if (!ok || record.id == null) return;

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

/// Record types people scan for most get a colour; the rest stay neutral.
Tone _typeTone(String type) => switch (type) {
  'A' || 'AAAA' || 'CNAME' => Tone.brand,
  'MX' || 'SRV' => Tone.info,
  'TXT' || 'CAA' => Tone.success,
  'NS' || 'DS' || 'DNSKEY' => Tone.warning,
  _ => Tone.neutral,
};

class _RecordRow extends StatelessWidget {
  const _RecordRow({
    required this.record,
    required this.zoneName,
    required this.flipping,
    required this.onEdit,
    required this.onDelete,
    required this.onProxy,
  });

  final DnsRecordResponse record;
  final String zoneName;
  final bool flipping;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onProxy;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final type = record.type_ ?? '?';
    final proxied = record.proxied ?? false;
    final proxiable = record.proxiable ?? false;
    final tone = _typeTone(type);

    return InkWell(
      onTap: onEdit,
      onLongPress: onDelete,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.md, Gap.md, Gap.xs, Gap.md),
        child: Row(
          children: [
            Container(
              width: 52,
              padding: const EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.toneWash(tone),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                type,
                maxLines: 1,
                style: context.text.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: tone == Tone.neutral
                      ? context.scheme.onSurface
                      : context.toneColor(tone),
                ),
              ),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _shortName(record.name ?? '—'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  Text(
                    _value(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                  if (_meta().isNotEmpty)
                    Text(
                      _meta(),
                      maxLines: 1,
                      style: context.text.labelSmall?.copyWith(
                        color: context.scheme.outline,
                      ),
                    ),
                ],
              ),
            ),
            if (proxiable)
              SizedBox(
                width: 44,
                child: flipping
                    ? const Center(
                        child: SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        tooltip: proxied
                            ? l.dnsStateProxied
                            : l.dnsStateDnsOnly,
                        onPressed: onProxy,
                        icon: Icon(
                          proxied ? Icons.cloud : Icons.cloud_outlined,
                          color: proxied
                              ? context.cf.proxied
                              : context.scheme.outline,
                        ),
                      ),
              ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: context.scheme.outline),
              onSelected: (v) => v == 'edit' ? onEdit() : onDelete(),
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(l.commonEdit)),
                PopupMenuItem(value: 'delete', child: Text(l.commonDelete)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// `www.example.com` reads as `www` inside example.com's own list; the apex
  /// stays whole so it is never an empty line.
  String _shortName(String name) {
    if (name == zoneName) return name;
    final suffix = '.$zoneName';
    return name.endsWith(suffix)
        ? name.substring(0, name.length - suffix.length)
        : name;
  }

  String _value() {
    if (record.content != null && record.content!.isNotEmpty) {
      return record.content!;
    }
    final data = record.data?.toJson() ?? const <String, Object?>{};
    return data.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${e.value}')
        .join(' ');
  }

  String _meta() => [
    if (record.priority != null) 'priority ${record.priority}',
    if (record.ttl != null) 'TTL ${ttlLabel(record.ttl!.toInt())}',
    if (record.comment != null && record.comment!.isNotEmpty) record.comment!,
  ].join(' · ');
}
