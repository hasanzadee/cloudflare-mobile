import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/generated/generated.dart';
import '../auth/application/auth_providers.dart';
import '../core/net/paginator.dart';
import '../features/scope/scope_providers.dart';
import '../l10n/app_localizations.dart';
import 'async_view.dart';

typedef ZoneQuery = ({String? accountId, String search});

/// Zones for the picker.
///
/// Separate from the Zones tab's own provider: that one is bound to the tab's
/// search box and paging state, and the picker must not disturb it.
///
/// Searching is server-side. Filtering the loaded page locally would have meant
/// a search box that quietly only ever saw the first hundred zones.
final zonePickerProvider = FutureProvider.autoDispose
    .family<CfPage<Zone>, ZoneQuery>((ref, q) {
      return ref
          .watch(cfApiProvider)
          .zones
          .listZones(
            perPage: 100,
            accountId: q.accountId,
            name: q.search.isEmpty ? null : 'contains:${q.search}',
            cancelToken: autoCancelToken(ref),
          );
    });

/// Persistent "which account / which zone" strip.
///
/// Every chip is tappable, including the zone one when it has nothing selected
/// yet. An earlier version only rendered the zone chip once a zone had been
/// chosen, which made the zone-scoped screens impossible to use without first
/// visiting the Zones tab — a dead end the user hit immediately.
class ScopeBar extends ConsumerWidget implements PreferredSizeWidget {
  const ScopeBar({this.showZone = false, super.key});

  final bool showZone;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final scope = ref.watch(scopeProvider);
    final auth = ref.watch(authProvider).valueOrNull;

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        children: [
          _Chip(
            icon: Icons.badge_outlined,
            label: auth?.active?.label ?? l.authProfiles,
            onTap: () => pickProfile(context, ref),
          ),
          _Chip(
            icon: Icons.account_balance_outlined,
            label: scope.accountName ?? l.scopeAllAccounts,
            onTap: () => pickAccount(context, ref),
          ),
          if (showZone)
            _Chip(
              icon: Icons.public,
              label: scope.zoneName ?? l.scopePickZone,
              highlighted: scope.zoneName == null,
              onTap: () => pickZone(context, ref),
            ),
        ],
      ),
    );
  }
}

/// Opens the profile switcher.
Future<void> pickProfile(BuildContext context, WidgetRef ref) async {
  final auth = ref.read(authProvider).valueOrNull;
  if (auth == null || auth.profiles.isEmpty) return;

  await showModalBottomSheet<void>(
    context: context,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          _SheetTitle(L.of(context).authProfiles),
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

/// Opens the account switcher.
///
/// The sheet appears first and loads inside itself. Awaiting the request before
/// opening meant a slow or failing call looked like a dead button.
Future<void> pickAccount(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _AccountSheet(),
  );
}

Future<void> pickZone(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _ZoneSheet(),
  );
}

class _AccountSheet extends ConsumerWidget {
  const _AccountSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final accounts = ref.watch(accountsProvider);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetTitle(l.scopeAccount),
            Flexible(
              child: AsyncView<List<Account>>(
                value: accounts,
                onRetry: () => ref.invalidate(accountsProvider),
                isEmpty: (d) => d.isEmpty,
                builder: (list) => ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.clear_all),
                      title: Text(l.scopeAllAccounts),
                      onTap: () {
                        ref.read(scopeProvider.notifier).setAccount(null, null);
                        Navigator.of(context).pop();
                      },
                    ),
                    for (final a in list)
                      ListTile(
                        leading: const Icon(Icons.account_balance_outlined),
                        title: Text(a.name ?? a.id ?? '—'),
                        subtitle: Text(
                          a.id ?? '',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                          ),
                        ),
                        selected:
                            a.id == ref.watch(scopeProvider).accountId,
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
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneSheet extends ConsumerStatefulWidget {
  const _ZoneSheet();

  @override
  ConsumerState<_ZoneSheet> createState() => _ZoneSheetState();
}

class _ZoneSheetState extends ConsumerState<_ZoneSheet> {
  final _search = TextEditingController();
  Timer? _debounce;

  /// What the provider is actually keyed on, updated a beat behind the field so
  /// typing does not fire a request per keystroke.
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final accountId = ref.watch(scopeProvider).accountId;
    final key = (accountId: accountId, search: _query);
    final zones = ref.watch(zonePickerProvider(key));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      builder: (context, controller) => Column(
        children: [
          _SheetTitle(l.scopeZone),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l.zonesSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _onChanged,
            ),
          ),
          Expanded(
            child: AsyncView<CfPage<Zone>>(
              value: zones,
              onRetry: () => ref.invalidate(zonePickerProvider(key)),
              isEmpty: (d) => d.items.isEmpty,
              builder: (page) => ListView.builder(
                controller: controller,
                itemCount: page.items.length + (page.hasMore ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == page.items.length) {
                    return ListTile(
                      leading: const Icon(Icons.more_horiz),
                      title: Text(
                        l.scopeMoreZones,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }
                  final z = page.items[i];
                  return ListTile(
                    leading: const Icon(Icons.public),
                    title: Text(z.name ?? '—'),
                    subtitle: Text(z.status ?? ''),
                    selected: z.id == ref.watch(scopeProvider).zoneId,
                    onTap: () {
                      ref.read(scopeProvider.notifier).setZone(z.id, z.name);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state for a screen that cannot render until something is scoped.
///
/// It carries the button that fixes it. The version without one told the user
/// to pick a zone but gave them nowhere to do it.
class ScopePrompt extends StatelessWidget {
  const ScopePrompt({
    required this.icon,
    required this.message,
    required this.action,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String message;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 44,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.tune),
            label: Text(action),
          ),
        ],
      ),
    ),
  );
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Draws attention when the chip is the thing standing between the user and
  /// a screen that cannot render without it.
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label, overflow: TextOverflow.ellipsis),
      side: highlighted
          ? BorderSide(color: Theme.of(context).colorScheme.primary)
          : null,
      onPressed: onTap,
    ),
  );
}
