import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/data/token_template.dart';
import '../../core/net/failure.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/ds/ds.dart';
import '../../ui/failure_text.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
import '../zerotrust/zerotrust_screen.dart';
import 'pulse_providers.dart';

/// The home tab: the whole account at a glance.
///
/// v1's home was a credential status, a zone count and a paragraph about
/// privacy. Pulse answers the question people actually open the app with —
/// "is anything wrong?" — before they tap anything: traffic across every zone,
/// what needs attention, and which zone is busiest.
class PulseScreen extends ConsumerWidget {
  const PulseScreen({
    required this.onOpenZone,
    required this.onOpenZones,
    super.key,
  });

  final void Function(Zone zone) onOpenZone;
  final VoidCallback onOpenZones;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final auth = ref.watch(authProvider).valueOrNull;
    final tokenStatus = ref.watch(tokenStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.pulseTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Gap.lg),
            child: tokenStatus.when(
              data: (s) => StatusPill(
                s ?? 'active',
                tone: s == null || s == 'active' ? Tone.success : Tone.danger,
                icon: Icons.verified_user_outlined,
              ),
              loading: () => const SkeletonBox(width: 64, height: 22),
              error: (e, _) => StatusPill(
                l.pulseCredentialProblem,
                tone: Tone.danger,
                icon: Icons.key_off_outlined,
              ),
            ),
          ),
        ],
        bottom: const ScopeBar(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(tokenStatusProvider)
            ..invalidate(pulseZonesProvider)
            ..invalidate(pulseTrafficProvider)
            ..invalidate(pulseTunnelIncidentsProvider)
            ..invalidate(accountsProvider);
          await ref.read(pulseZonesProvider.future).catchError((Object _) {
            return CfPage.empty<Zone>();
          });
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.xl),
          children: [
            if (auth?.active?.credential.isUnrestricted ?? false) ...[
              Callout(
                tone: Tone.danger,
                title: l.authGlobalKeyWarnTitle,
                body: l.authGlobalKeyWarnBody,
              ),
              const SizedBox(height: Gap.md),
            ],
            const _TrafficHero(),
            _Attention(onOpenZone: onOpenZone),
            _Zones(onOpenZone: onOpenZone, onOpenZones: onOpenZones),
          ],
        ),
      ),
    );
  }
}

class _TrafficHero extends ConsumerWidget {
  const _TrafficHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final traffic = ref.watch(pulseTrafficProvider);

    return Panel(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, Gap.md),
      child: traffic.when(
        skipLoadingOnRefresh: true,
        loading: () => const _HeroSkeleton(),
        error: (e, st) => _HeroError(error: e, stack: st),
        data: (t) {
          final cf = context.cf;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.pulseRequests24h,
                style: context.text.labelLarge?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Gap.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    compactCount(t.total.totalRequests),
                    style: tabular(
                      context.text.headlineMedium,
                    )?.copyWith(fontSize: 34, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: Gap.sm),
                  DeltaBadge(ratio: t.delta),
                ],
              ),
              const SizedBox(height: Gap.md),
              Sparkline(
                values: t.total.requests,
                secondary: t.total.cached,
                color: cf.proxied,
                secondaryColor: cf.success,
                height: 64,
              ),
              const SizedBox(height: Gap.md),
              Row(
                children: [
                  Expanded(
                    child: Metric(
                      label: l.analyticsBandwidth,
                      value: compactBytes(t.total.totalBytes),
                    ),
                  ),
                  Expanded(
                    child: Metric(
                      label: l.analyticsCacheRatio,
                      value: '${(t.cacheRatio * 100).round()}%',
                    ),
                  ),
                  Expanded(
                    child: Metric(
                      label: l.analyticsThreats,
                      value: compactCount(t.total.totalThreats),
                      tone: t.total.totalThreats > 0
                          ? Tone.danger
                          : Tone.neutral,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SkeletonBox(width: 140),
      SizedBox(height: Gap.sm),
      SkeletonBox(width: 110, height: 34, radius: 8),
      SizedBox(height: Gap.md),
      SkeletonBox(height: 64, radius: 10),
      SizedBox(height: Gap.md),
      Row(
        children: [
          Expanded(child: SkeletonBox(width: 60, height: 30)),
          Expanded(child: SkeletonBox(width: 60, height: 30)),
          Expanded(child: SkeletonBox(width: 60, height: 30)),
        ],
      ),
    ],
  );
}

/// Traffic failing is not the screen failing: zones and incidents still load.
class _HeroError extends ConsumerWidget {
  const _HeroError({required this.error, this.stack});

  final Object error;
  final StackTrace? stack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final permission = error is PermissionFailure;
    return Row(
      children: [
        IconTile(
          icon: permission ? Icons.key_off_outlined : Icons.cloud_off_outlined,
          tone: Tone.warning,
        ),
        const SizedBox(width: Gap.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                permission
                    ? l.pulseAnalyticsUnavailable
                    : failureMessage(context, error),
                style: context.text.bodyMedium,
              ),
              const SizedBox(height: Gap.xs),
              InkWell(
                onTap: permission
                    ? () => launchUrl(
                        TokenTemplate.userToken(TokenTemplate.full),
                        mode: LaunchMode.externalApplication,
                      )
                    : () => ref.invalidate(pulseTrafficProvider),
                child: Text(
                  permission ? l.permFixCta : l.commonRetry,
                  style: context.text.labelLarge?.copyWith(
                    color: context.scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Incidents first, so a broken tunnel is not three scrolls down.
class _Attention extends ConsumerWidget {
  const _Attention({required this.onOpenZone});

  final void Function(Zone zone) onOpenZone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final tunnels = ref.watch(pulseTunnelIncidentsProvider).valueOrNull;
    final zones = ref.watch(pulseZonesProvider).valueOrNull?.items;
    final pending = [
      for (final z in zones ?? const <Zone>[])
        if (z.status != null && z.status != 'active') z,
    ];

    // Until both have answered, "nothing to report" would be a guess.
    if (tunnels == null || zones == null) return const SizedBox.shrink();

    final items = <Widget>[
      for (final t in tunnels)
        Callout(
          tone: t.tunnel.status == 'down' ? Tone.danger : Tone.warning,
          icon: Icons.hub_outlined,
          title: t.tunnel.status == 'down'
              ? l.pulseTunnelDown(t.tunnel.name ?? '')
              : l.pulseTunnelDegraded(t.tunnel.name ?? ''),
          body: t.accountName,
          action: l.pulseOpenTunnels,
          onAction: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ZeroTrustScreen()),
          ),
        ),
      for (final z in pending.take(3))
        Callout(
          tone: Tone.warning,
          icon: Icons.pending_outlined,
          title: l.pulseZoneNotActive(z.name ?? '', z.status ?? ''),
          body: l.pulseZoneNotActiveBody,
          action: l.pulseOpenZone,
          onAction: () => onOpenZone(z),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.pulseAttention),
        if (items.isEmpty)
          Panel(
            padding: const EdgeInsets.all(Gap.md),
            child: Row(
              children: [
                const IconTile(icon: Icons.check, tone: Tone.success),
                const SizedBox(width: Gap.md),
                Expanded(
                  child: Text(l.pulseAllClear, style: context.text.bodyMedium),
                ),
              ],
            ),
          )
        else
          for (final item in items) ...[
            item,
            if (item != items.last) const SizedBox(height: Gap.sm),
          ],
      ],
    );
  }
}

class _Zones extends ConsumerWidget {
  const _Zones({required this.onOpenZone, required this.onOpenZones});

  final void Function(Zone zone) onOpenZone;
  final VoidCallback onOpenZones;

  /// Rows on Pulse; the Zones tab has the rest.
  static const int _shown = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final zones = ref.watch(pulseZonesProvider);
    final traffic = ref.watch(pulseTrafficProvider).valueOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          l.zonesTitle,
          action: zones.valueOrNull == null
              ? null
              : l.pulseAllZones(
                  zones.value!.info.totalCount ?? zones.value!.items.length,
                ),
          onAction: onOpenZones,
        ),
        zones.when(
          skipLoadingOnRefresh: true,
          loading: () => const RowGroup(
            children: [_ZoneSkeleton(), _ZoneSkeleton(), _ZoneSkeleton()],
          ),
          error: (e, _) => Callout(
            tone: Tone.danger,
            title: failureMessage(context, e),
            action: l.commonRetry,
            onAction: () => ref.invalidate(pulseZonesProvider),
          ),
          data: (page) {
            if (page.items.isEmpty) {
              return Panel(child: Text(l.zonesEmpty));
            }
            // Busiest first once traffic is known: the zone getting the
            // requests is the one most likely to be why you opened the app.
            final sorted = [...page.items];
            if (traffic != null) {
              int reqs(Zone z) => traffic.zones[z.id]?.totalRequests ?? -1;
              sorted.sort((a, b) => reqs(b).compareTo(reqs(a)));
            }
            return RowGroup(
              children: [
                for (final z in sorted.take(_shown))
                  _ZoneRow(
                    zone: z,
                    pulse: traffic?.zones[z.id],
                    onTap: () => onOpenZone(z),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

Tone zoneTone(String? status) => switch (status) {
  'active' => Tone.success,
  'pending' || 'initializing' => Tone.warning,
  'moved' || 'deleted' || 'deactivated' => Tone.danger,
  _ => Tone.neutral,
};

class _ZoneRow extends StatelessWidget {
  const _ZoneRow({
    required this.zone,
    required this.pulse,
    required this.onTap,
  });

  final Zone zone;
  final ZonePulse? pulse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = zone.status == 'active';
    final p = pulse;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.md, Gap.md),
        child: Row(
          children: [
            StatusDot(tone: zoneTone(zone.status)),
            const SizedBox(width: Gap.md),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  Text(
                    active ? (zone.plan?.name ?? '') : (zone.status ?? ''),
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
            const SizedBox(width: Gap.sm),
            SizedBox(
              width: 64,
              child: p == null
                  ? const SizedBox.shrink()
                  : Sparkline(
                      values: p.requests,
                      color: p.totalThreats > p.totalRequests / 2
                          ? context.cf.danger
                          : context.cf.proxied,
                      height: 22,
                      strokeWidth: 1.6,
                      fill: false,
                    ),
            ),
            SizedBox(
              width: 52,
              child: Text(
                p == null ? '' : compactCount(p.totalRequests),
                textAlign: TextAlign.right,
                style: tabular(
                  context.text.labelLarge,
                )?.copyWith(color: context.scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneSkeleton extends StatelessWidget {
  const _ZoneSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.all(Gap.lg),
    child: Row(
      children: [
        SkeletonBox(width: 9, height: 9, radius: 5),
        SizedBox(width: Gap.md),
        Expanded(child: SkeletonBox()),
        SizedBox(width: Gap.xl * 3),
      ],
    ),
  );
}
