import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/failure.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../scope/scope_providers.dart';

// ---------------------------------------------------------------------------
// Providers. These are read-only listings, so one file keeps them together
// rather than scattering six near-identical providers across the tree.
// ---------------------------------------------------------------------------

final pageRulesProvider = FutureProvider.autoDispose
    .family<CfPage<PageRule>, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .traffic
          .listPageRules(zoneId: zoneId, cancelToken: autoCancelToken(ref));
    });

final loadBalancersProvider = FutureProvider.autoDispose
    .family<CfPage<LoadBalancer>, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .traffic
          .listLoadBalancers(zoneId: zoneId, cancelToken: autoCancelToken(ref));
    });

final waitingRoomsProvider = FutureProvider.autoDispose
    .family<CfPage<Waitingroom>, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .traffic
          .listWaitingRooms(zoneId: zoneId, cancelToken: autoCancelToken(ref));
    });

final certificatePacksProvider = FutureProvider.autoDispose
    .family<CfPage<CertificatePack>, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .tls
          .listCertificatePacks(
            zoneId: zoneId,
            cancelToken: autoCancelToken(ref),
          );
    });

final customHostnamesProvider = FutureProvider.autoDispose
    .family<CfPage<CustomHostname>, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .tls
          .listCustomHostnames(
            zoneId: zoneId,
            cancelToken: autoCancelToken(ref),
          );
    });

final dnssecProvider = FutureProvider.autoDispose.family<Dnssec, String>((
  ref,
  zoneId,
) {
  return ref
      .watch(cfApiProvider)
      .tls
      .getDnssec(zoneId: zoneId, cancelToken: autoCancelToken(ref));
});

final emailRulesProvider = FutureProvider.autoDispose
    .family<CfPage<Rules2>, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .email
          .listEmailRules(zoneId: zoneId, cancelToken: autoCancelToken(ref));
    });

final emailSettingsProvider = FutureProvider.autoDispose
    .family<Settings2, String>((ref, zoneId) {
      return ref
          .watch(cfApiProvider)
          .email
          .getEmailRouting(zoneId: zoneId, cancelToken: autoCancelToken(ref));
    });

final destinationAddressesProvider = FutureProvider.autoDispose
    .family<CfPage<Addresses>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .email
          .listDestinationAddresses(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

// ---------------------------------------------------------------------------
// Screens
// ---------------------------------------------------------------------------

/// Page rules, load balancers and waiting rooms for one zone.
class ZoneTrafficScreen extends ConsumerWidget {
  const ZoneTrafficScreen({
    required this.zoneId,
    required this.zoneName,
    super.key,
  });

  final String zoneId;
  final String zoneName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('${l.navZones} · $zoneName')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(pageRulesProvider(zoneId))
            ..invalidate(loadBalancersProvider(zoneId))
            ..invalidate(waitingRoomsProvider(zoneId));
        },
        child: ListView(
          children: [
            SectionHeader(l.trafficPageRules),
            ...sectionOf<CfPage<PageRule>>(
              context,
              ref.watch(pageRulesProvider(zoneId)),
              (page) => [
                for (final r in page.items)
                  ListTile(
                    leading: Icon(
                      r.status == 'active'
                          ? Icons.check_circle_outline
                          : Icons.pause_circle_outline,
                      color: r.status == 'active' ? context.cf.success : null,
                    ),
                    title: Text(
                      r.targets
                              ?.map((t) => t.constraint?.value ?? '')
                              .where((s) => s.isNotEmpty)
                              .join(', ') ??
                          '—',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      [
                        if (r.priority != null) '#${r.priority}',
                        ...?r.actions?.map((a) => a.id?.toString() ?? ''),
                      ].where((s) => s.isNotEmpty).join(' · '),
                    ),
                  ),
              ],
            ),

            SectionHeader(l.trafficLoadBalancers),
            ...sectionOf<CfPage<LoadBalancer>>(
              context,
              ref.watch(loadBalancersProvider(zoneId)),
              (page) => [
                for (final lb in page.items)
                  ListTile(
                    leading: Icon(
                      Icons.balance,
                      color: (lb.enabled ?? false) ? context.cf.success : null,
                    ),
                    title: Text(lb.name ?? '—'),
                    subtitle: Text(
                      [
                        if (lb.steeringPolicy != null) lb.steeringPolicy!,
                        '${lb.defaultPools?.length ?? 0} pool(s)',
                        if (lb.proxied ?? false) 'proxied',
                      ].join(' · '),
                    ),
                  ),
              ],
            ),

            SectionHeader(l.trafficWaitingRooms),
            ...sectionOf<CfPage<Waitingroom>>(
              context,
              ref.watch(waitingRoomsProvider(zoneId)),
              (page) => [
                for (final w in page.items)
                  ListTile(
                    leading: Icon(
                      Icons.groups_outlined,
                      color: (w.suspended ?? false) ? null : context.cf.success,
                    ),
                    title: Text(w.name ?? '—'),
                    subtitle: Text(
                      [
                        if (w.host != null) '${w.host}${w.path ?? ''}',
                        if (w.newUsersPerMinute != null)
                          '${w.newUsersPerMinute}/min',
                        if (w.totalActiveUsers != null)
                          '${w.totalActiveUsers} active',
                      ].join(' · '),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Certificates, custom hostnames and DNSSEC.
class ZoneTlsScreen extends ConsumerWidget {
  const ZoneTlsScreen({
    required this.zoneId,
    required this.zoneName,
    super.key,
  });

  final String zoneId;
  final String zoneName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('TLS · $zoneName')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(certificatePacksProvider(zoneId))
            ..invalidate(customHostnamesProvider(zoneId))
            ..invalidate(dnssecProvider(zoneId));
        },
        child: ListView(
          children: [
            SectionHeader(l.tlsDnssec),
            ...sectionOf<Dnssec>(
              context,
              ref.watch(dnssecProvider(zoneId)),
              (d) => [
                ListTile(
                  leading: Icon(
                    d.status == 'active' ? Icons.verified_user : Icons.gpp_bad,
                    color: d.status == 'active'
                        ? context.cf.success
                        : context.cf.warning,
                  ),
                  title: Text('${d.status ?? 'unknown'}'),
                  subtitle: Text(
                    [
                      if (d.algorithm != null) 'alg ${d.algorithm}',
                      if (d.keyTag != null) 'tag ${d.keyTag}',
                      if (d.digestType != null) 'digest ${d.digestType}',
                    ].join(' · '),
                  ),
                ),
                if (d.ds != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: SelectableText(
                      d.ds!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),

            SectionHeader(l.tlsCertificates),
            ...sectionOf<CfPage<CertificatePack>>(
              context,
              ref.watch(certificatePacksProvider(zoneId)),
              (page) => [
                for (final c in page.items)
                  ListTile(
                    leading: Icon(
                      Icons.workspace_premium_outlined,
                      color: c.status == 'active' ? context.cf.success : null,
                    ),
                    title: Text(c.hosts?.join(', ') ?? c.id ?? '—'),
                    subtitle: Text(
                      [
                        if (c.type_ != null) c.type_!,
                        if (c.certificateAuthority != null)
                          c.certificateAuthority!,
                        if (c.status != null) c.status!,
                        if (c.validityDays != null) '${c.validityDays} days',
                      ].join(' · '),
                    ),
                    isThreeLine: true,
                  ),
              ],
            ),

            SectionHeader(l.tlsCustomHostnames),
            ...sectionOf<CfPage<CustomHostname>>(
              context,
              ref.watch(customHostnamesProvider(zoneId)),
              (page) => [
                for (final h in page.items)
                  ListTile(
                    leading: Icon(
                      Icons.dns_outlined,
                      color: h.status == 'active' ? context.cf.success : null,
                    ),
                    title: Text(h.hostname ?? '—'),
                    subtitle: Text(
                      [
                        if (h.status != null) h.status!,
                        if (h.ssl?.status != null) 'ssl ${h.ssl!.status}',
                      ].join(' · '),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Email routing for one zone, plus the account's destination addresses.
class ZoneEmailScreen extends ConsumerWidget {
  const ZoneEmailScreen({
    required this.zoneId,
    required this.zoneName,
    super.key,
  });

  final String zoneId;
  final String zoneName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final accountId = ref.watch(scopeProvider).accountId;

    return Scaffold(
      appBar: AppBar(title: Text('Email · $zoneName')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(emailSettingsProvider(zoneId))
            ..invalidate(emailRulesProvider(zoneId));
          if (accountId != null) {
            ref.invalidate(destinationAddressesProvider(accountId));
          }
        },
        child: ListView(
          children: [
            ...sectionOf<Settings2>(
              context,
              ref.watch(emailSettingsProvider(zoneId)),
              (s) => [
                ListTile(
                  leading: Icon(
                    (s.enabled ?? false)
                        ? Icons.mark_email_read_outlined
                        : Icons.unsubscribe_outlined,
                    color: (s.enabled ?? false) ? context.cf.success : null,
                  ),
                  title: Text(s.name ?? '—'),
                  subtitle: Text(s.status ?? ''),
                ),
              ],
            ),

            SectionHeader(l.emailRules),
            ...sectionOf<CfPage<Rules2>>(
              context,
              ref.watch(emailRulesProvider(zoneId)),
              (page) => [
                for (final r in page.items)
                  ListTile(
                    leading: Icon(
                      Icons.alt_route,
                      color: (r.enabled ?? false) ? context.cf.success : null,
                    ),
                    title: Text(
                      r.matchers
                              ?.map((m) => m.value ?? '')
                              .where((s) => s.isNotEmpty)
                              .join(', ') ??
                          r.name ??
                          '—',
                    ),
                    subtitle: Text(
                      r.actions
                              ?.map(
                                (a) =>
                                    '${a.type_ ?? ''} ${a.value?.join(', ') ?? ''}',
                              )
                              .join(' · ') ??
                          '',
                    ),
                  ),
              ],
            ),

            if (accountId != null) ...[
              SectionHeader(l.emailAddresses),
              ...sectionOf<CfPage<Addresses>>(
                context,
                ref.watch(destinationAddressesProvider(accountId)),
                (page) => [
                  for (final a in page.items)
                    ListTile(
                      leading: Icon(
                        a.verified != null
                            ? Icons.verified_outlined
                            : Icons.pending_outlined,
                        color: a.verified != null ? context.cf.success : null,
                      ),
                      title: Text(a.email ?? '—'),
                      subtitle: Text(
                        a.verified == null ? 'not verified' : 'verified',
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared bits
// ---------------------------------------------------------------------------

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    ),
  );
}

/// Renders one async section inline.
///
/// A missing permission or an unconfigured product becomes a single quiet line
/// rather than an error state — a zone with no load balancers is the normal
/// case, not a failure worth shouting about.
List<Widget> sectionOf<T>(
  BuildContext context,
  AsyncValue<T> value,
  List<Widget> Function(T data) builder,
) {
  return value.when(
    loading: () => const [
      ListTile(
        dense: true,
        leading: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text('…'),
      ),
    ],
    error: (e, _) => [
      ListTile(
        dense: true,
        leading: Icon(Icons.info_outline, color: context.cf.warning),
        title: Text(
          e is CfFailure ? e.summary : '$e',
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
    data: (data) {
      final widgets = builder(data);
      if (widgets.isEmpty) {
        return [
          ListTile(
            dense: true,
            title: Text(
              L.of(context).commonNothingHere,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ];
      }
      return widgets;
    },
  );
}
