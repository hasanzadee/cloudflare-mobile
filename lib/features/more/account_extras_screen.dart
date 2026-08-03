import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/generated.dart';
import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../core/net/paginator.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
import '../zones/zone_extras_screen.dart';

final alertPoliciesProvider = FutureProvider.autoDispose
    .family<CfPage<Policies>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .email
          .listAlertPolicies(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

final alertHistoryProvider = FutureProvider.autoDispose
    .family<CfPage<History>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .email
          .listAlertHistory(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

final turnstileProvider = FutureProvider.autoDispose
    .family<CfPage<WidgetList>, String>((ref, accountId) {
      return ref
          .watch(cfApiProvider)
          .email
          .listTurnstileWidgets(
            accountId: accountId,
            cancelToken: autoCancelToken(ref),
          );
    });

/// Notification policies, recent alerts and Turnstile widgets.
class AccountExtrasScreen extends ConsumerWidget {
  const AccountExtrasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final accountId = ref.watch(scopeProvider).accountId;

    if (accountId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.moreAlerts)),
        body: ScopePrompt(
          icon: Icons.account_balance_outlined,
          message: l.devPickAccount,
          action: l.scopePickAccount,
          onTap: () => pickAccount(context, ref),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('${l.moreAlerts} · ${l.moreTurnstile}')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(alertPoliciesProvider(accountId))
            ..invalidate(alertHistoryProvider(accountId))
            ..invalidate(turnstileProvider(accountId));
        },
        child: ListView(
          children: [
            SectionHeader(l.moreAlerts),
            ...sectionOf<CfPage<Policies>>(
              context,
              ref.watch(alertPoliciesProvider(accountId)),
              (page) => [
                for (final p in page.items)
                  ListTile(
                    leading: Icon(
                      Icons.notifications_active_outlined,
                      color: (p.enabled ?? false) ? context.cf.success : null,
                    ),
                    title: Text(p.name ?? '—'),
                    subtitle: Text(
                      [
                        if (p.alertType != null) p.alertType!,
                        if (p.alertInterval != null) p.alertInterval!,
                        if (p.description != null && p.description!.isNotEmpty)
                          p.description!,
                      ].join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                  ),
              ],
            ),

            SectionHeader('${l.moreAlerts} · history'),
            ...sectionOf<CfPage<History>>(
              context,
              ref.watch(alertHistoryProvider(accountId)),
              (page) => [
                for (final h in page.items.take(20))
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.history, size: 20),
                    title: Text(h.name ?? h.alertType ?? '—'),
                    subtitle: Text(h.sent ?? ''),
                  ),
              ],
            ),

            SectionHeader(l.moreTurnstile),
            ...sectionOf<CfPage<WidgetList>>(
              context,
              ref.watch(turnstileProvider(accountId)),
              (page) => [
                for (final w in page.items)
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined),
                    title: Text(w.name ?? '—'),
                    subtitle: Text(
                      [if (w.mode != null) w.mode!, ...?w.domains].join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: w.sitekey == null
                        ? null
                        : Text(
                            w.sitekey!,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                            ),
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
