import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../explorer/explorer_screen.dart';
import '../settings/settings_screen.dart';
import '../zerotrust/zerotrust_screen.dart';

/// Landing tab for everything that does not deserve its own bottom-bar slot.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);

    void open(Widget screen) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => screen));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.navMore)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.hub_outlined),
            title: Text(l.navZeroTrust),
            subtitle: Text('${l.ztTunnels} · ${l.ztAccess} · ${l.ztGateway}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(const ZeroTrustScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.terminal_outlined),
            title: Text(l.explorerTitle),
            subtitle: Text(l.explorerSearchHint),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(const ExplorerScreen()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l.settingsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => open(const SettingsScreen()),
          ),
        ],
      ),
    );
  }
}
