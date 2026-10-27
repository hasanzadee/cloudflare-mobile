import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/ds/ds.dart';
import '../explorer/explorer_screen.dart';
import '../settings/settings_screen.dart';
import '../zerotrust/zerotrust_screen.dart';
import 'account_extras_screen.dart';

/// Landing tab for everything that does not deserve its own bottom-bar slot.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final active = ref.watch(authProvider).valueOrNull?.active;

    void open(Widget screen) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => screen));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.navMore)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.lg, Gap.xl),
        children: [
          if (active != null)
            Panel(
              onTap: () => open(const SettingsScreen()),
              child: Row(
                children: [
                  IconTile(
                    icon: active.credential.isUnrestricted
                        ? Icons.warning_amber_outlined
                        : Icons.vpn_key_outlined,
                    tone: active.credential.isUnrestricted
                        ? Tone.danger
                        : Tone.brand,
                    size: 44,
                  ),
                  const SizedBox(width: Gap.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(active.label, style: context.text.titleMedium),
                        Text(
                          active.credential.isUnrestricted
                              ? l.authGlobalKey
                              : l.authApiToken,
                          style: context.text.bodySmall?.copyWith(
                            color: context.scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: context.scheme.outline),
                ],
              ),
            ),
          SectionTitle(l.moreProducts),
          RowGroup(
            children: [
              NavRow(
                icon: Icons.hub_outlined,
                title: l.navZeroTrust,
                subtitle: '${l.ztTunnels} · ${l.ztAccess} · ${l.ztGateway}',
                tone: Tone.info,
                onTap: () => open(const ZeroTrustScreen()),
              ),
              NavRow(
                icon: Icons.notifications_outlined,
                title: '${l.moreAlerts} · ${l.moreTurnstile}',
                subtitle: l.moreAlertsSubtitle,
                tone: Tone.warning,
                onTap: () => open(const AccountExtrasScreen()),
              ),
              NavRow(
                icon: Icons.terminal_outlined,
                title: l.explorerTitle,
                subtitle: l.explorerSearchHint,
                tone: Tone.success,
                onTap: () => open(const ExplorerScreen()),
              ),
            ],
          ),
          SectionTitle(l.moreApp),
          RowGroup(
            children: [
              NavRow(
                icon: Icons.settings_outlined,
                title: l.settingsTitle,
                subtitle: l.moreSettingsSubtitle,
                onTap: () => open(const SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
