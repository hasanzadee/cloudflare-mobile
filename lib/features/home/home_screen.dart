import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/scope_bar.dart';
import '../scope/scope_providers.dart';
import '../zones/zones_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({required this.onOpenZones, super.key});

  final VoidCallback onOpenZones;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final auth = ref.watch(authProvider).valueOrNull;
    final tokenStatus = ref.watch(tokenStatusProvider);
    final zones = ref.watch(zonesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.appTitle), bottom: const ScopeBar()),
      body: RefreshIndicator(
        onRefresh: () async {
          ref
            ..invalidate(tokenStatusProvider)
            ..invalidate(zonesProvider)
            ..invalidate(accountsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (auth?.active?.credential.isUnrestricted ?? false)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: ListTile(
                  leading: const Icon(Icons.warning_amber),
                  title: Text(l.authGlobalKeyWarnTitle),
                  subtitle: Text(l.authGlobalKeyWarnBody),
                ),
              ),
            _StatCard(
              icon: Icons.verified_user_outlined,
              title: 'Credential',
              value: tokenStatus.when(
                data: (s) => s ?? 'active',
                loading: () => '…',
                error: (e, _) => 'problem',
              ),
              color: tokenStatus.hasError
                  ? context.cf.danger
                  : context.cf.success,
            ),
            _StatCard(
              icon: Icons.public,
              title: l.zonesTitle,
              value: zones.when(
                data: (d) =>
                    d.hasMore ? '${d.items.length}+' : '${d.items.length}',
                loading: () => '…',
                error: (e, _) => '—',
              ),
              onTap: onOpenZones,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.settingsPrivacyTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.settingsPrivacyBody,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      onTap: onTap,
    ),
  );
}
