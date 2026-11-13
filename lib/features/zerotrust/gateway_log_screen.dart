import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/async_view.dart';
import '../../ui/ds/ds.dart';
import 'gateway_log.dart';
import 'gateway_log_providers.dart';

/// Gateway DNS queries for one account, refreshed while the screen is open.
class GatewayLogScreen extends ConsumerStatefulWidget {
  const GatewayLogScreen({required this.accountId, super.key});

  final String accountId;

  @override
  ConsumerState<GatewayLogScreen> createState() => _GatewayLogScreenState();
}

class _GatewayLogScreenState extends ConsumerState<GatewayLogScreen> {
  final _search = TextEditingController();
  Timer? _debounce;

  // A log nobody is looking at should not keep spending the rate limit.
  late final AppLifecycleListener _lifecycle = AppLifecycleListener(
    onHide: () => _controller.suspend(),
    onShow: () => _controller.wake(),
  );

  DnsLogController get _controller =>
      ref.read(dnsLogProvider(widget.accountId).notifier);

  @override
  void initState() {
    super.initState();
    _lifecycle;
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => _controller.setSearch(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final log = ref.watch(dnsLogProvider(widget.accountId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.ztLogTitle),
        actions: [
          IconButton(
            tooltip: log.paused ? l.ztLogResume : l.ztLogPause,
            icon: Icon(
              log.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            ),
            onPressed: log.paused ? _controller.resume : _controller.pause,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, 0),
            child: SearchField(
              controller: _search,
              hint: l.ztLogSearch,
              onChanged: _onSearch,
              onSubmitted: (v) {
                _debounce?.cancel();
                _controller.setSearch(v);
              },
              onClear: () {
                _search.clear();
                _debounce?.cancel();
                setState(() {});
                _controller.setSearch('');
              },
            ),
          ),
          _DecisionChips(
            selected: log.decision,
            onSelected: _controller.setDecision,
          ),
          _StatusLine(state: log),
          Expanded(child: _body(context, l, log)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, L l, DnsLogState log) {
    if (log.entries.isEmpty) {
      if (log.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (log.error != null) {
        return FailureView(error: log.error!, onRetry: _controller.resume);
      }
      return EmptyState(
        icon: Icons.dns_outlined,
        tone: Tone.info,
        title: l.ztLogEmptyTitle,
        body: l.ztLogEmptyBody,
      );
    }

    final entries = log.entries;
    return RefreshIndicator(
      onRefresh: _controller.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: Gap.xs, bottom: Gap.xl),
        itemCount: entries.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.sm),
              child: log.error != null
                  ? Callout(
                      tone: Tone.warning,
                      icon: Icons.cloud_off_outlined,
                      title: l.ztLogPollFailed,
                    )
                  : Text(
                      l.ztLogLagNote,
                      style: context.text.bodySmall?.copyWith(
                        color: context.scheme.onSurfaceVariant,
                      ),
                    ),
            );
          }
          final e = entries[i - 1];
          return GroupedItem(
            index: i - 1,
            count: entries.length,
            child: _EntryRow(entry: e),
          );
        },
      ),
    );
  }
}

class _DecisionChips extends StatelessWidget {
  const _DecisionChips({required this.selected, required this.onSelected});

  final DnsDecision? selected;
  final ValueChanged<DnsDecision?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final options = <(DnsDecision?, String)>[
      (null, l.commonAll),
      (DnsDecision.blocked, l.ztLogBlocked),
      (DnsDecision.allowed, l.ztLogAllowed),
      (DnsDecision.overridden, l.ztLogOverridden),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, 0),
      child: Row(
        children: [
          for (final (value, label) in options)
            Padding(
              padding: const EdgeInsets.only(right: Gap.sm),
              child: ChoiceChip(
                label: Text(label),
                selected: selected == value,
                showCheckmark: false,
                onSelected: (_) => onSelected(value),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.state});

  final DnsLogState state;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final updated = state.updatedAt;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.lg + 2, Gap.sm, Gap.lg, Gap.sm),
      child: Row(
        children: [
          StatusDot(
            tone: state.paused
                ? Tone.neutral
                : (state.error != null ? Tone.warning : Tone.success),
          ),
          const SizedBox(width: Gap.sm),
          Text(
            state.paused ? l.ztLogPaused : l.ztLogLive,
            style: context.text.labelLarge,
          ),
          const Spacer(),
          if (updated != null)
            Text(
              _clock(updated),
              style: tabular(
                context.text.labelMedium?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry});

  final DnsLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final tone = decisionTone(entry.decision);
    final detail = [
      if (entry.policy.isNotEmpty) entry.policy,
      if (entry.location.isNotEmpty) entry.location,
      if (entry.categories.isNotEmpty) entry.categories.join(', '),
    ].join(' · ');

    return InkWell(
      onTap: () => _showDetails(context, entry),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.md, Gap.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: StatusDot(tone: tone),
            ),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.query,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail.isEmpty ? decisionLabel(l, entry.decision) : detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Gap.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _clock(entry.at.toLocal()),
                  style: tabular(
                    context.text.labelMedium?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (entry.count > 1)
                  Text(
                    '×${entry.count}',
                    style: tabular(context.text.labelSmall),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Tone decisionTone(DnsDecision d) => switch (d) {
  DnsDecision.blocked => Tone.danger,
  DnsDecision.allowed => Tone.success,
  DnsDecision.overridden => Tone.info,
  DnsDecision.unknown => Tone.neutral,
};

String decisionLabel(L l, DnsDecision d) => switch (d) {
  DnsDecision.blocked => l.ztLogBlocked,
  DnsDecision.allowed => l.ztLogAllowed,
  DnsDecision.overridden => l.ztLogOverridden,
  DnsDecision.unknown => l.ztLogUnknown,
};

String _clock(DateTime t) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

Future<void> _showDetails(BuildContext context, DnsLogEntry e) {
  final l = L.of(context);
  final tone = decisionTone(e.decision);
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Gap.xl, 0, Gap.xl, Gap.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StatusPill(decisionLabel(l, e.decision), tone: tone),
                const Spacer(),
                Text(
                  _clock(e.at.toLocal()),
                  style: tabular(context.text.labelLarge),
                ),
              ],
            ),
            const SizedBox(height: Gap.md),
            SelectableText(e.query, style: context.text.titleLarge),
            const SizedBox(height: Gap.lg),
            Panel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _Detail(
                    label: l.ztLogPolicy,
                    value: e.policy.isEmpty ? l.ztLogNoPolicy : e.policy,
                  ),
                  if (e.location.isNotEmpty)
                    _Detail(label: l.ztLogLocation, value: e.location),
                  if (e.categories.isNotEmpty)
                    _Detail(
                      label: l.ztLogCategories,
                      value: e.categories.join(', '),
                    ),
                  if (e.resolvedIps.isNotEmpty)
                    _Detail(
                      label: l.ztLogResolvedTo,
                      value: e.resolvedIps.join('\n'),
                    ),
                  if (e.country.isNotEmpty)
                    _Detail(label: l.ztLogSourceCountry, value: e.country),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Detail extends StatelessWidget {
  const _Detail({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: context.text.bodyMedium?.copyWith(
              color: context.scheme.onSurfaceVariant,
            ),
          ),
        ),
        // Selectable, so an IP can go straight into a lookup or a block rule.
        Expanded(child: SelectableText(value, style: context.text.bodyMedium)),
      ],
    ),
  );
}
