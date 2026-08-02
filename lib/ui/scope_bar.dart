import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/application/auth_providers.dart';
import '../features/scope/scope_providers.dart';
import '../l10n/app_localizations.dart';

/// Persistent "which account / which zone" strip.
///
/// This is the fix for the prototype's dead end: it knew the zone the user had
/// just tapped but only ever stored a zone id typed by hand in Settings, so
/// nothing downstream could use it.
class ScopeBar extends ConsumerWidget implements PreferredSizeWidget {
  const ScopeBar({this.showZone = false, super.key});

  final bool showZone;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(scopeProvider);
    final auth = ref.watch(authProvider).valueOrNull;

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          const SizedBox(width: 8),
          Flexible(
            child: _Chip(
              icon: Icons.badge_outlined,
              label: auth?.active?.label ?? 'No profile',
              onTap: () => _pickProfile(context, ref),
            ),
          ),
          Flexible(
            child: _Chip(
              icon: Icons.account_balance_outlined,
              label: scope.accountName ?? 'All accounts',
              onTap: () => _pickAccount(context, ref),
            ),
          ),
          if (showZone && scope.zoneName != null)
            Flexible(
              child: _Chip(
                icon: Icons.public,
                label: scope.zoneName!,
                onTap: null,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Future<void> _pickProfile(BuildContext context, WidgetRef ref) async {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || auth.profiles.isEmpty) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(
                L.of(context).authProfiles,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            for (final p in auth.profiles)
              ListTile(
                leading: Icon(
                  p.credential.isUnrestricted
                      ? Icons.warning_amber_outlined
                      : Icons.vpn_key_outlined,
                ),
                title: Text(p.label),
                subtitle: Text(p.credential.method.name),
                selected: p.id == auth.activeId,
                onTap: () {
                  ref.read(authProvider.notifier).setActive(p.id);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAccount(BuildContext context, WidgetRef ref) async {
    final accounts = await ref.read(accountsProvider.future);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: Text(L.of(context).commonAll),
              onTap: () {
                ref.read(scopeProvider.notifier).setAccount(null, null);
                Navigator.of(context).pop();
              },
            ),
            for (final a in accounts)
              ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                title: Text(a.name ?? a.id ?? '—'),
                subtitle: Text(a.id ?? ''),
                onTap: () {
                  ref
                      .read(scopeProvider.notifier)
                      .setAccount(a.id, a.name ?? a.id);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label, overflow: TextOverflow.ellipsis),
      onPressed: onTap ?? () {},
    ),
  );
}
