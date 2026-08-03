import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import 'analytics_models.dart';
import 'analytics_providers.dart';
import 'analytics_queries.dart';

/// Traffic, cache and threats for one zone.
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({
    required this.zoneId,
    required this.zoneName,
    super.key,
  });

  final String zoneId;
  final String zoneName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final range = ref.watch(analyticsRangeProvider);
    final key = (zoneId: zoneId, range: range);

    return Scaffold(
      appBar: AppBar(title: Text('${l.analyticsTitle} · $zoneName')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(trafficSeriesProvider(key))
            ..invalidate(trafficSummaryProvider(key))
            ..invalidate(firewallEventsProvider(key));
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<AnalyticsRange>(
                segments: [
                  for (final r in AnalyticsRange.values)
                    ButtonSegment(value: r, label: Text(r.label)),
                ],
                selected: {range},
                onSelectionChanged: (s) =>
                    ref.read(analyticsRangeProvider.notifier).state = s.first,
              ),
            ),
            _Summary(zoneKey: key),
            _TrafficChart(zoneKey: key),
            _Breakdowns(zoneKey: key),
            _Firewall(zoneKey: key),
          ],
        ),
      ),
    );
  }
}

String _compact(int n) {
  if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(1)}B';
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '$n';
}

String _bytes(int n) {
  if (n >= 1099511627776) return '${(n / 1099511627776).toStringAsFixed(1)} TB';
  if (n >= 1073741824) return '${(n / 1073741824).toStringAsFixed(1)} GB';
  if (n >= 1048576) return '${(n / 1048576).toStringAsFixed(1)} MB';
  if (n >= 1024) return '${(n / 1024).toStringAsFixed(0)} KB';
  return '$n B';
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.zoneKey});

  final AnalyticsKey zoneKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final summary = ref.watch(trafficSummaryProvider(zoneKey));

    return summary.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(12),
        child: FailureView(
          error: e,
          stack: st,
          onRetry: () => ref.invalidate(trafficSummaryProvider(zoneKey)),
        ),
      ),
      data: (s) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _Stat(
              label: l.analyticsRequests,
              value: _compact(s.requests),
              icon: Icons.swap_vert,
            ),
            _Stat(
              label: l.analyticsBandwidth,
              value: _bytes(s.bytes),
              icon: Icons.data_usage,
            ),
            _Stat(
              label: l.analyticsUniques,
              value: _compact(s.uniques),
              icon: Icons.person_outline,
            ),
            _Stat(
              label: l.analyticsCacheRatio,
              value: '${(s.cacheHitRatio * 100).toStringAsFixed(0)}%',
              icon: Icons.bolt,
              color: context.cf.success,
            ),
            _Stat(
              label: l.analyticsThreats,
              value: _compact(s.threats),
              icon: Icons.shield_outlined,
              color: s.threats > 0 ? context.cf.danger : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    width: 108,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    ),
  );
}

class _TrafficChart extends ConsumerWidget {
  const _TrafficChart({required this.zoneKey});

  final AnalyticsKey zoneKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final series = ref.watch(trafficSeriesProvider(zoneKey));

    return AsyncView<List<TrafficPoint>>(
      value: series,
      onRetry: () => ref.invalidate(trafficSeriesProvider(zoneKey)),
      isEmpty: (d) => d.isEmpty,
      empty: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(l.analyticsNoData)),
      ),
      builder: (points) {
        final maxY = points
            .map((p) => p.requests)
            .fold<int>(0, (a, b) => a > b ? a : b)
            .toDouble();

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 24, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.analyticsRequestsOverTime,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              _Legend(
                items: [
                  (l.analyticsRequests, Theme.of(context).colorScheme.primary),
                  (l.analyticsCached, context.cf.success),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 190,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: maxY == 0 ? 1 : maxY * 1.15,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 0.5,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(),
                      rightTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (value, meta) => Text(
                            _compact(value.toInt()),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 26,
                          interval: (points.length / 4).ceilToDouble(),
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= points.length) {
                              return const SizedBox.shrink();
                            }
                            final at = points[i].at;
                            final label = zoneKey.range.isDaily
                                ? '${at.day}.${at.month}'
                                : '${at.hour.toString().padLeft(2, '0')}:00';
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                label,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (spots) => spots.map((spot) {
                          final p = points[spot.x.toInt()];
                          return LineTooltipItem(
                            '${_compact(p.requests)} req\n'
                            '${_compact(p.cachedRequests)} cached',
                            TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onInverseSurface,
                              fontSize: 11,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    lineBarsData: [
                      _line(
                        points
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.requests.toDouble(),
                              ),
                            )
                            .toList(),
                        Theme.of(context).colorScheme.primary,
                        fill: true,
                      ),
                      _line(
                        points
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                e.key.toDouble(),
                                e.value.cachedRequests.toDouble(),
                              ),
                            )
                            .toList(),
                        context.cf.success,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  LineChartBarData _line(
    List<FlSpot> spots,
    Color color, {
    bool fill = false,
  }) => LineChartBarData(
    spots: spots,
    isCurved: true,
    curveSmoothness: 0.2,
    color: color,
    barWidth: 2,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: fill, color: color.withValues(alpha: 0.12)),
  );
}

class _Legend extends StatelessWidget {
  const _Legend({required this.items});

  final List<(String, Color)> items;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    children: [
      for (final (label, color) in items)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 10, height: 3, color: color),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
    ],
  );
}

class _Breakdowns extends ConsumerWidget {
  const _Breakdowns({required this.zoneKey});

  final AnalyticsKey zoneKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final summary = ref.watch(trafficSummaryProvider(zoneKey)).valueOrNull;
    if (summary == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (summary.statuses.isNotEmpty)
          _BarList(
            title: l.analyticsStatusCodes,
            items: summary.statuses,
            colorFor: (label) {
              final code = int.tryParse(label) ?? 0;
              return switch (code) {
                >= 500 => context.cf.danger,
                >= 400 => context.cf.warning,
                >= 300 => context.cf.post,
                _ => context.cf.success,
              };
            },
          ),
        if (summary.countries.isNotEmpty)
          _BarList(
            title: l.analyticsTopCountries,
            items: summary.countries,
            trailing: (c) =>
                c.secondary > 0 ? '${_compact(c.secondary)} threats' : null,
          ),
        if (summary.contentTypes.isNotEmpty)
          _BarList(
            title: l.analyticsContentTypes,
            items: summary.contentTypes,
            trailing: (c) => _bytes(c.secondary),
          ),
      ],
    );
  }
}

class _BarList extends StatelessWidget {
  const _BarList({
    required this.title,
    required this.items,
    this.colorFor,
    this.trailing,
  });

  final String title;
  final List<NamedCount> items;
  final Color Function(String label)? colorFor;
  final String? Function(NamedCount)? trailing;

  @override
  Widget build(BuildContext context) {
    final max = items.map((i) => i.value).fold<int>(1, (a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        [
                          _compact(item.value),
                          ?trailing?.call(item),
                        ].join(' · '),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: item.value / max,
                      minHeight: 5,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      color:
                          colorFor?.call(item.label) ??
                          Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Firewall extends ConsumerWidget {
  const _Firewall({required this.zoneKey});

  final AnalyticsKey zoneKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final events = ref.watch(firewallEventsProvider(zoneKey)).valueOrNull;
    if (events == null || events.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.analyticsSecurityEvents,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          for (final e in events.take(20))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                e.action == 'block' ? Icons.block : Icons.help_outline,
                color: e.action == 'block'
                    ? context.cf.danger
                    : context.cf.warning,
                size: 20,
              ),
              title: Text('${e.action} · ${e.country}'),
              subtitle: Text(
                [e.source, if (e.host.isNotEmpty) e.host].join(' · '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(_compact(e.count)),
            ),
        ],
      ),
    );
  }
}
