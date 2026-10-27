import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/ds/ds.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
import 'zone_tone.dart';
import 'zones_providers.dart';

class ZonesScreen extends ConsumerStatefulWidget {
  const ZonesScreen({required this.onOpenZone, super.key});

  final void Function(Zone zone) onOpenZone;

  @override
  ConsumerState<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends ConsumerState<ZonesScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      // Prefetch a screen ahead so the list never visibly stalls at the bottom.
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 600) {
        ref.read(zonesProvider.notifier).loadMore();
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
    final zones = ref.watch(zonesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.zonesTitle), bottom: const ScopeBar()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.md),
            child: SearchField(
              controller: _search,
              hint: l.zonesSearchHint,
              onChanged: (_) => setState(() {}),
              onSubmitted: (v) =>
                  ref.read(zoneSearchProvider.notifier).state = v.trim(),
              onClear: () {
                _search.clear();
                ref.read(zoneSearchProvider.notifier).state = '';
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: AsyncView<PagedData<Zone>>(
              value: zones,
              onRetry: () => ref.invalidate(zonesProvider),
              isEmpty: (d) => d.items.isEmpty,
              empty: EmptyState(icon: Icons.public_off, title: l.zonesEmpty),
              builder: (data) {
                final count = data.items.length;
                return RefreshIndicator(
                  onRefresh: () => ref.read(zonesProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.only(bottom: Gap.xl),
                    itemCount: count + (data.hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= count) {
                        return const Padding(
                          padding: EdgeInsets.all(Gap.lg),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final z = data.items[i];
                      return GroupedItem(
                        index: i,
                        count: count,
                        dividerIndent: 44,
                        child: _ZoneRow(
                          zone: z,
                          onTap: () {
                            ref
                                .read(scopeProvider.notifier)
                                .setZone(z.id, z.name);
                            widget.onOpenZone(z);
                          },
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
}

class _ZoneRow extends StatelessWidget {
  const _ZoneRow({required this.zone, required this.onTap});

  final Zone zone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = zone.status == 'active';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.sm, Gap.md),
        child: Row(
          children: [
            StatusDot(tone: zoneTone(zone.status)),
            const SizedBox(width: Gap.md + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  Text(
                    [
                      if (!active && zone.status != null) zone.status!,
                      if (zone.plan?.name != null) zone.plan!.name!,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      color: active
                          ? context.scheme.onSurfaceVariant
                          : context.toneColor(zoneTone(zone.status)),
                    ),
                  ),
                ],
              ),
            ),
            if (zone.paused ?? false)
              Padding(
                padding: const EdgeInsets.only(right: Gap.xs),
                child: Icon(
                  Icons.pause_circle_outline,
                  size: 18,
                  color: context.cf.warning,
                ),
              ),
            Icon(Icons.chevron_right, color: context.scheme.outline),
          ],
        ),
      ),
    );
  }
}
