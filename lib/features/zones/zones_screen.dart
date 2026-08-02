import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
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
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: l.zonesSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _search.clear();
                          ref.read(zoneSearchProvider.notifier).state = '';
                          setState(() {});
                        },
                      ),
              ),
              onSubmitted: (v) =>
                  ref.read(zoneSearchProvider.notifier).state = v.trim(),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: AsyncView<PagedData<Zone>>(
              value: zones,
              onRetry: () => ref.invalidate(zonesProvider),
              isEmpty: (d) => d.items.isEmpty,
              empty: Center(child: Text(l.zonesEmpty)),
              builder: (data) => RefreshIndicator(
                onRefresh: () => ref.read(zonesProvider.notifier).refresh(),
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
                    return _ZoneTile(
                      zone: data.items[i],
                      onTap: () {
                        final z = data.items[i];
                        ref.read(scopeProvider.notifier).setZone(z.id, z.name);
                        widget.onOpenZone(z);
                      },
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
}

class _ZoneTile extends StatelessWidget {
  const _ZoneTile({required this.zone, required this.onTap});

  final Zone zone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = zone.status == 'active';
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: active
            ? context.cf.success.withValues(alpha: 0.15)
            : context.cf.warning.withValues(alpha: 0.15),
        child: Icon(
          active ? Icons.public : Icons.pending_outlined,
          color: active ? context.cf.success : context.cf.warning,
        ),
      ),
      title: Text(zone.name ?? '—'),
      subtitle: Text(
        [
          if (zone.status != null) zone.status!,
          if (zone.plan?.name != null) zone.plan!.name!,
        ].join(' · '),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
