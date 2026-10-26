import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/failure.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/ds/ds.dart';
import '../../ui/failure_text.dart';
import '../analytics/analytics_models.dart';
import '../analytics/analytics_providers.dart';
import '../analytics/analytics_queries.dart';
import '../analytics/analytics_screen.dart';
import '../dns/dns_screen.dart';
import '../pulse/pulse_screen.dart' show zoneTone;
import '../scope/scope_providers.dart';
import '../security/security_screen.dart';
import 'purge_screen.dart';
import 'zone_extras_screen.dart';
import 'zone_settings_providers.dart';
import 'zones_providers.dart';

export 'purge_screen.dart';

typedef _Settings = Map<String, ZoneSettingsGetAllZoneSettingsItem>;

/// Everything about one zone, ordered by urgency.
///
/// v1 led with six navigation rows and put the zone's actual state — plan,
/// status, SSL mode — below the fold. Here the top of the screen is the
/// state and anything wrong with it, then the actions people need in a hurry,
/// then today's traffic, and only then the way into each product.
class ZoneScreen extends ConsumerWidget {
  const ZoneScreen({required this.zoneId, required this.zoneName, super.key});

  final String zoneId;
  final String zoneName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final zone = ref.watch(zoneDetailsProvider(zoneId));
    final settings = ref.watch(zoneSettingsProvider(zoneId));
    final accountId = zone.valueOrNull?.account?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(zoneName),
        actions: [
          if (accountId != null)
            IconButton(
              tooltip: l.zoneOpenDashboard,
              icon: const Icon(Icons.open_in_new),
              onPressed: () => launchUrl(
                Uri.parse('https://dash.cloudflare.com/$accountId/$zoneName'),
                mode: LaunchMode.externalApplication,
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final key = (zoneId: zoneId, range: AnalyticsRange.last24h);
          ref
            ..invalidate(zoneDetailsProvider(zoneId))
            ..invalidate(zoneSettingsProvider(zoneId))
            ..invalidate(trafficSeriesProvider(key))
            ..invalidate(trafficSummaryProvider(key));
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.xl),
          children: [
            zone.when(
              skipLoadingOnRefresh: true,
              loading: () => const Panel(child: _HeroSkeleton()),
              error: (e, st) => Callout(
                tone: Tone.danger,
                title: failureMessage(context, e),
                action: l.commonRetry,
                onAction: () => ref.invalidate(zoneDetailsProvider(zoneId)),
              ),
              data: (z) => _Hero(zone: z, settings: settings.valueOrNull),
            ),
            if (zone.valueOrNull != null && settings.valueOrNull != null)
              _Recommendations(
                zone: zone.value!,
                settings: settings.value!,
                zoneId: zoneId,
              ),
            SectionTitle(l.zoneQuickActions),
            _QuickActions(
              zoneId: zoneId,
              zoneName: zoneName,
              settings: settings,
            ),
            SectionTitle(
              l.zoneLast24h,
              action: l.analyticsTitle,
              onAction: () => _openAnalytics(context),
            ),
            _Traffic(zoneId: zoneId, onTap: () => _openAnalytics(context)),
            SectionTitle(l.zoneManage),
            _Manage(zoneId: zoneId, zoneName: zoneName),
            _SettingsSection(zoneId: zoneId, settings: settings),
          ],
        ),
      ),
    );
  }

  void _openAnalytics(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AnalyticsScreen(zoneId: zoneId, zoneName: zoneName),
    ),
  );
}

/// How SSL modes read at a glance. Only Full (strict) verifies the origin.
Tone sslTone(String? mode) => switch (mode) {
  'strict' => Tone.success,
  'full' => Tone.info,
  'flexible' => Tone.warning,
  'off' => Tone.danger,
  _ => Tone.neutral,
};

class _Hero extends StatelessWidget {
  const _Hero({required this.zone, required this.settings});

  final Zone zone;
  final _Settings? settings;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final ns = zone.nameServers ?? const <String>[];
    final ssl = settings?['ssl']?.value;
    final sslSpec = zoneSettingSpec('ssl');

    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(
                icon: Icons.public,
                tone: zoneTone(zone.status),
                size: 44,
              ),
              const SizedBox(width: Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.titleLarge,
                    ),
                    if (zone.account?.name != null)
                      Text(
                        zone.account!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          color: context.scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Gap.md),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              StatusPill(zone.status ?? '?', tone: zoneTone(zone.status)),
              if (zone.plan?.name != null) StatusPill(zone.plan!.name!),
              if (ssl != null)
                StatusPill(
                  'SSL ${sslSpec?.labelFor(ssl) ?? ssl}',
                  tone: sslTone(ssl),
                  icon: Icons.lock_outline,
                ),
              if (zone.paused ?? false)
                StatusPill(l.zonePaused, tone: Tone.warning),
            ],
          ),
          if (ns.isNotEmpty) ...[
            const SizedBox(height: Gap.md),
            const Divider(),
            const SizedBox(height: Gap.sm),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.zoneNameservers,
                        style: context.text.labelMedium?.copyWith(
                          color: context.scheme.onSurfaceVariant,
                        ),
                      ),
                      for (final n in ns)
                        Text(
                          n,
                          style: context.text.bodySmall?.copyWith(
                            fontFamily: 'monospace',
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l.commonCopy,
                  icon: const Icon(Icons.copy_all_outlined, size: 20),
                  onPressed: () => _copy(context, ns.join('\n')),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

Future<void> _copy(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(L.of(context).commonCopied)));
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SkeletonBox(width: 44, height: 44, radius: 14),
          SizedBox(width: Gap.md),
          SkeletonBox(width: 160, height: 20),
        ],
      ),
      SizedBox(height: Gap.md),
      SkeletonBox(width: 220, height: 22),
    ],
  );
}

/// Writes one zone setting, through the before/after sheet when the spec says
/// so. Returns whether anything was written.
///
/// [onConfirmed] fires once the user has said yes and the request is about to
/// go out — the moment a busy indicator belongs. Showing one while the sheet
/// is still asking reads as "already doing it".
Future<bool> writeZoneSetting(
  BuildContext context,
  WidgetRef ref, {
  required String zoneId,
  required ZoneSettingSpec spec,
  required String? from,
  required String to,
  String? note,
  Tone tone = Tone.brand,
  bool forceConfirm = false,
  VoidCallback? onConfirmed,
}) async {
  final l = L.of(context);
  if (spec.confirm || forceConfirm) {
    final ok = await confirmChanges(
      context,
      title: l.zoneChangeTitle(spec.label),
      note: note,
      tone: tone,
      confirmLabel: l.zoneApply,
      changes: [
        Change(spec.label, from: spec.labelFor(from), to: spec.labelFor(to)),
      ],
    );
    if (!ok || !context.mounted) return false;
  }

  onConfirmed?.call();
  try {
    await ref
        .read(zoneSettingsActionsProvider)
        .edit(zoneId: zoneId, settingId: spec.id, value: to);
    ref
      ..invalidate(zoneSettingsProvider(zoneId))
      ..invalidate(zoneDetailsProvider(zoneId));
    return true;
  } on CfFailure catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failureMessage(context, e))));
    }
    return false;
  }
}

/// What is wrong with this zone and the one tap that fixes it.
class _Recommendations extends ConsumerWidget {
  const _Recommendations({
    required this.zone,
    required this.settings,
    required this.zoneId,
  });

  final Zone zone;
  final _Settings settings;
  final String zoneId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final ssl = settings['ssl'];
    final https = settings['always_use_https'];
    final sslSpec = zoneSettingSpec('ssl')!;
    final httpsSpec = zoneSettingSpec('always_use_https')!;

    final items = <Widget>[
      if (zone.status != null && zone.status != 'active')
        Callout(
          tone: Tone.warning,
          icon: Icons.dns_outlined,
          title: l.zoneNotActiveTitle(zone.status!),
          body: l.zoneNotActiveBody,
          action: (zone.nameServers ?? const []).isEmpty
              ? null
              : l.zoneCopyNameservers,
          onAction: () => _copy(context, zone.nameServers!.join('\n')),
        ),
      if (ssl?.value == 'flexible' || ssl?.value == 'off')
        Callout(
          tone: ssl!.value == 'off' ? Tone.danger : Tone.warning,
          icon: Icons.lock_open_outlined,
          title: l.zoneSslWeakTitle(sslSpec.labelFor(ssl.value)),
          body: l.zoneSslWeakBody,
          action: (ssl.editable ?? true) ? l.zoneSslUseStrict : null,
          onAction: () => writeZoneSetting(
            context,
            ref,
            zoneId: zoneId,
            spec: sslSpec,
            from: ssl.value,
            to: 'strict',
            note: l.zoneSslStrictNote,
          ),
        ),
      if (https?.value == 'off' && (https?.editable ?? true))
        Callout(
          tone: Tone.info,
          icon: Icons.https_outlined,
          title: l.zoneHttpsOffTitle,
          body: l.zoneHttpsOffBody,
          action: l.zoneTurnOn,
          onAction: () => writeZoneSetting(
            context,
            ref,
            zoneId: zoneId,
            spec: httpsSpec,
            from: 'off',
            to: 'on',
          ),
        ),
    ];
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items) ...[
            item,
            if (item != items.last) const SizedBox(height: Gap.sm),
          ],
        ],
      ),
    );
  }
}

/// The three things people open this app for in a bad moment.
class _QuickActions extends ConsumerStatefulWidget {
  const _QuickActions({
    required this.zoneId,
    required this.zoneName,
    required this.settings,
  });

  final String zoneId;
  final String zoneName;

  /// The whole async value, not just its data: "still loading" earns a
  /// spinner, "failed to load" must not — a spinner that never stops reads as
  /// the app hanging rather than the token lacking Zone Settings.
  final AsyncValue<_Settings> settings;

  @override
  ConsumerState<_QuickActions> createState() => _QuickActionsState();
}

class _QuickActionsState extends ConsumerState<_QuickActions> {
  String? _busy;

  /// Where the security level goes back to when "Under attack" is switched
  /// off. Remembered per zone at the moment it was switched on, because the
  /// API has no memory of it and guessing "medium" would quietly lower a zone
  /// that was set to high.
  String get _restoreKey => 'zone.${widget.zoneId}.level_before_attack';

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final s = widget.settings.valueOrNull;
    final loading = widget.settings.isLoading && s == null;
    final level = s?['security_level'];
    final dev = s?['development_mode'];
    final underAttack = level?.value == 'under_attack';
    final devOn = dev?.value == 'on';
    final left = dev?.timeRemaining?.toInt() ?? 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ActionTile(
            icon: Icons.shield_outlined,
            label: l.zoneUnderAttack,
            caption: underAttack ? l.zoneStateOn : l.zoneUnderAttackCaption,
            tone: Tone.danger,
            active: underAttack,
            busy: _busy == 'attack' || loading,
            onTap: level == null || !(level.editable ?? true)
                ? null
                : () => _toggleAttack(level.value, underAttack),
          ),
        ),
        const SizedBox(width: Gap.sm),
        Expanded(
          child: ActionTile(
            icon: Icons.code,
            label: l.zoneDevMode,
            caption: devOn
                ? l.zoneDevModeLeft(_duration(left))
                : l.zoneDevModeCaption,
            tone: Tone.info,
            active: devOn,
            busy: _busy == 'dev' || loading,
            onTap: dev == null || !(dev.editable ?? true)
                ? null
                : () => _toggleDev(devOn),
          ),
        ),
        const SizedBox(width: Gap.sm),
        Expanded(
          child: ActionTile(
            icon: Icons.cleaning_services_outlined,
            label: l.cachePurgeTitle,
            caption: l.zonePurgeCaption,
            tone: Tone.warning,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => PurgeScreen(
                  zoneId: widget.zoneId,
                  zoneName: widget.zoneName,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _toggleAttack(String? current, bool on) async {
    final l = L.of(context);
    final spec = zoneSettingSpec('security_level')!;
    final prefs = await ref.read(sharedPrefsProvider.future);
    if (!mounted) return;

    final restore = prefs.getString(_restoreKey);
    final to = on
        ? (restore == null || restore == 'under_attack' ? 'medium' : restore)
        : 'under_attack';

    final written = await writeZoneSetting(
      context,
      ref,
      zoneId: widget.zoneId,
      spec: spec,
      from: current,
      to: to,
      tone: on ? Tone.brand : Tone.danger,
      note: on ? l.zoneUnderAttackOffNote : l.zoneUnderAttackNote,
      onConfirmed: () => setState(() => _busy = 'attack'),
    );
    if (written) {
      on
          ? await prefs.remove(_restoreKey)
          : await prefs.setString(_restoreKey, current ?? 'medium');
    }
    if (mounted) setState(() => _busy = null);
  }

  Future<void> _toggleDev(bool on) async {
    final l = L.of(context);
    await writeZoneSetting(
      context,
      ref,
      zoneId: widget.zoneId,
      spec: zoneSettingSpec('development_mode')!,
      from: on ? 'on' : 'off',
      to: on ? 'off' : 'on',
      tone: Tone.info,
      note: on ? null : l.zoneDevModeNote,
      onConfirmed: () => setState(() => _busy = 'dev'),
    );
    if (mounted) setState(() => _busy = null);
  }
}

/// "2h 41m", "12m". Development mode reports whole seconds.
String _duration(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  return h > 0 ? '${h}h ${m.toString().padLeft(2, '0')}m' : '${m}m';
}

class _Traffic extends ConsumerWidget {
  const _Traffic({required this.zoneId, required this.onTap});

  final String zoneId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final key = (zoneId: zoneId, range: AnalyticsRange.last24h);
    final summary = ref.watch(trafficSummaryProvider(key));
    final series = ref.watch(trafficSeriesProvider(key)).valueOrNull;

    return Panel(
      onTap: onTap,
      child: summary.when(
        skipLoadingOnRefresh: true,
        loading: () => const Column(
          children: [
            SkeletonBox(height: 30),
            SizedBox(height: Gap.md),
            SkeletonBox(height: 48, radius: 10),
          ],
        ),
        error: (e, _) => Row(
          children: [
            const IconTile(icon: Icons.insights_outlined, tone: Tone.warning),
            const SizedBox(width: Gap.md),
            Expanded(
              child: Text(
                e is PermissionFailure
                    ? l.pulseAnalyticsUnavailable
                    : failureMessage(context, e),
                style: context.text.bodyMedium,
              ),
            ),
          ],
        ),
        data: (TrafficSummary s) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Metric(
                    label: l.analyticsRequests,
                    value: compactCount(s.requests),
                  ),
                ),
                Expanded(
                  child: Metric(
                    label: l.analyticsUniques,
                    value: compactCount(s.uniques),
                  ),
                ),
                Expanded(
                  child: Metric(
                    label: l.analyticsCacheRatio,
                    value: '${(s.cacheHitRatio * 100).round()}%',
                  ),
                ),
                Expanded(
                  child: Metric(
                    label: l.analyticsThreats,
                    value: compactCount(s.threats),
                    tone: s.threats > 0 ? Tone.danger : Tone.neutral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Gap.md),
            Sparkline(
              values: [
                for (final p in series ?? const <TrafficPoint>[]) p.requests,
              ],
              secondary: [
                for (final p in series ?? const <TrafficPoint>[])
                  p.cachedRequests,
              ],
              color: context.cf.proxied,
              secondaryColor: context.cf.success,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}

class _Manage extends ConsumerWidget {
  const _Manage({required this.zoneId, required this.zoneName});

  final String zoneId;
  final String zoneName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);

    void open(Widget screen) => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));

    return RowGroup(
      children: [
        NavRow(
          icon: Icons.dns_outlined,
          title: l.dnsTitle,
          subtitle: l.zoneDnsSubtitle,
          tone: Tone.brand,
          onTap: () => open(DnsScreen(zoneId: zoneId, zoneName: zoneName)),
        ),
        NavRow(
          icon: Icons.shield_outlined,
          title: l.navSecurity,
          subtitle: l.zoneSecuritySubtitle,
          tone: Tone.danger,
          onTap: () {
            // The Security screen reads its zone from scope, so point scope
            // here before opening it — even if the hub was reached some other
            // way than by tapping this zone in a list.
            ref.read(scopeProvider.notifier).setZone(zoneId, zoneName);
            open(const SecurityScreen());
          },
        ),
        NavRow(
          icon: Icons.lock_outline,
          title: l.zoneTlsTitle,
          subtitle: l.zoneTlsSubtitle,
          tone: Tone.success,
          onTap: () => open(ZoneTlsScreen(zoneId: zoneId, zoneName: zoneName)),
        ),
        NavRow(
          icon: Icons.alt_route_outlined,
          title: l.trafficPageRules,
          subtitle: l.zoneTrafficSubtitle,
          tone: Tone.info,
          onTap: () =>
              open(ZoneTrafficScreen(zoneId: zoneId, zoneName: zoneName)),
        ),
        NavRow(
          icon: Icons.mail_outline,
          title: l.zoneEmailTitle,
          subtitle: l.zoneEmailSubtitle,
          onTap: () =>
              open(ZoneEmailScreen(zoneId: zoneId, zoneName: zoneName)),
        ),
      ],
    );
  }
}

class _SettingsSection extends ConsumerWidget {
  const _SettingsSection({required this.zoneId, required this.settings});

  final String zoneId;
  final AsyncValue<_Settings> settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    return settings.when(
      skipLoadingOnRefresh: true,
      loading: () => const Padding(
        padding: EdgeInsets.only(top: Gap.xl),
        child: Panel(child: SkeletonBox(height: 120, radius: 10)),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.only(top: Gap.xl),
        child: Callout(
          tone: Tone.warning,
          title: failureMessage(context, e),
          action: l.commonRetry,
          onAction: () => ref.invalidate(zoneSettingsProvider(zoneId)),
        ),
      ),
      data: (values) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final group in kZoneSettings)
            if (group.settings.any((s) => values.containsKey(s.id))) ...[
              SectionTitle(group.group),
              Panel(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final (i, spec)
                        in group.settings
                            .where((s) => values.containsKey(s.id))
                            .indexed) ...[
                      if (i > 0) const Divider(indent: Gap.lg, height: 0.6),
                      _SettingRow(
                        zoneId: zoneId,
                        spec: spec,
                        current: values[spec.id]!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}

class _SettingRow extends ConsumerStatefulWidget {
  const _SettingRow({
    required this.zoneId,
    required this.spec,
    required this.current,
  });

  final String zoneId;
  final ZoneSettingSpec spec;
  final ZoneSettingsGetAllZoneSettingsItem current;

  @override
  ConsumerState<_SettingRow> createState() => _SettingRowState();
}

class _SettingRowState extends ConsumerState<_SettingRow> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final value = widget.current.value;
    // Cloudflare marks settings the current plan cannot change.
    final editable = widget.current.editable ?? true;

    final trailing = _busy
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : spec.isToggle
        ? Switch(
            value: value == spec.onValue,
            onChanged: editable
                ? (v) => _write(v ? spec.onValue : spec.offValue)
                : null,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                spec.labelFor(value),
                style: context.text.labelLarge?.copyWith(
                  color: editable
                      ? context.scheme.primary
                      : context.scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (editable)
                Icon(
                  Icons.unfold_more,
                  size: 18,
                  color: context.scheme.primary,
                ),
            ],
          );

    return InkWell(
      onTap: !editable || _busy || spec.isToggle ? null : _pick,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.md, Gap.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spec.label, style: context.text.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    spec.description,
                    style: context.text.bodySmall?.copyWith(
                      color: context.scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Gap.md),
            trailing,
          ],
        ),
      ),
    );
  }

  /// A sheet of choices rather than a dropdown: the options carry enough text
  /// ("I am under attack", "Ignore query string") that a dropdown clips them.
  Future<void> _pick() async {
    final spec = widget.spec;
    final picked = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.xl, 0, Gap.xl, Gap.sm),
              child: Text(spec.label, style: context.text.titleLarge),
            ),
            for (final o in spec.options)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: Gap.xl),
                title: Text(o.label),
                trailing: o.value == widget.current.value
                    ? Icon(Icons.check, color: context.scheme.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(o.value),
              ),
            const SizedBox(height: Gap.sm),
          ],
        ),
      ),
    );
    if (picked == null || picked == widget.current.value) return;
    await _write(picked);
  }

  Future<void> _write(String value) async {
    await writeZoneSetting(
      context,
      ref,
      zoneId: widget.zoneId,
      spec: widget.spec,
      from: widget.current.value,
      to: value,
      onConfirmed: () => setState(() => _busy = true),
    );
    if (mounted) setState(() => _busy = false);
  }
}
