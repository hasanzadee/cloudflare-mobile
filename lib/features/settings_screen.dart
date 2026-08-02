import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../core/state.dart';
import '../core/vault.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _accCtrl;
  late final TextEditingController _zoneCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(settingsProvider);
    _accCtrl = TextEditingController(text: s.accountId);
    _zoneCtrl = TextEditingController(text: s.zoneId);
  }

  @override
  void dispose() {
    _accCtrl.dispose();
    _zoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    return ListView(
      children: [
        const _Header('По умолчанию'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: TextField(
            controller: _accCtrl,
            decoration: const InputDecoration(
              labelText: 'Account ID',
              hintText: 'для подстановки в {account_id}',
              prefixIcon: Icon(Icons.business_outlined),
              border: OutlineInputBorder(),
            ),
            onChanged: (v) =>
                ref.read(settingsProvider.notifier).setAccountId(v.trim()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _zoneCtrl,
            decoration: const InputDecoration(
              labelText: 'Zone ID',
              hintText: 'для подстановки в {zone_id}',
              prefixIcon: Icon(Icons.public),
              border: OutlineInputBorder(),
            ),
            onChanged: (v) =>
                ref.read(settingsProvider.notifier).setZoneId(v.trim()),
          ),
        ),
        const _Header('Безопасность'),
        ListTile(
          leading: const Icon(Icons.timer_outlined),
          title: const Text('Авто-блокировка'),
          subtitle: Text(settings.lockTimeout.label),
          onTap: () async {
            final picked = await showDialog<LockTimeout>(
              context: context,
              builder: (_) => SimpleDialog(
                title: const Text('Авто-блокировка'),
                children: LockTimeout.values
                    .map((t) => SimpleDialogOption(
                          onPressed: () => Navigator.pop(context, t),
                          child: Text(t.label),
                        ))
                    .toList(),
              ),
            );
            if (picked != null) {
              await ref.read(settingsProvider.notifier).setTimeout(picked);
            }
          },
        ),
        SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: const Text('Биометрическая разблокировка'),
          subtitle: Text(settings.biometricEnabled ? 'Включена' : 'Выключена'),
          value: settings.biometricEnabled,
          onChanged: (v) async {
            if (v) {
              final auth = LocalAuthentication();
              final canCheck = await auth.canCheckBiometrics;
              if (!canCheck) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Биометрия недоступна')));
                }
                return;
              }
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Перенастрой через «Сбросить»')));
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: const Text('Заблокировать сейчас'),
          onTap: () => ref.read(authControllerProvider.notifier).lock(),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Сбросить (удалить токен и PIN)',
              style: TextStyle(color: Colors.red)),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Сбросить всё?'),
                content: const Text(
                    'Cloudflare-токен, PIN и настройки будут удалены с устройства. Восстановить нельзя.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Отмена')),
                  FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Сбросить')),
                ],
              ),
            );
            if (ok == true) {
              await ref.read(authControllerProvider.notifier).logout();
              await Vault.wipe();
              await ref.read(settingsProvider.notifier).refreshBio();
            }
          },
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('CF Manager'),
          subtitle: Text(
              'Cloudflare Mobile Client\nВсе данные локально, зашифрованы AES-GCM-256.\n2884 эндпоинта в каталоге.'),
          isThreeLine: true,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 1,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
