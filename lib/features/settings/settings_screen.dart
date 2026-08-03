import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_settings.dart';
import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/data/token_template.dart';
import '../../l10n/app_localizations.dart';

String _autoLockLabel(L l, Duration d) {
  if (d == Duration.zero) return l.settingsAutoLockImmediate;
  if (d.inDays > 100) return l.settingsAutoLockNever;
  if (d.inMinutes < 1) return '${d.inSeconds} s';
  return '${d.inMinutes} min';
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final auth = ref.watch(authProvider).valueOrNull;
    final ui = ref.watch(appSettingsProvider);
    final controller = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
          _Header(l.settingsAppearance),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: Text(l.settingsTheme),
            subtitle: Text(switch (ui.themeMode) {
              ThemeMode.light => l.settingsThemeLight,
              ThemeMode.dark => l.settingsThemeDark,
              ThemeMode.system => l.settingsThemeSystem,
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.phone_android, size: 18),
                  label: Text(l.settingsThemeSystem),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode_outlined, size: 18),
                  label: Text(l.settingsThemeLight),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_outlined, size: 18),
                  label: Text(l.settingsThemeDark),
                ),
              ],
              selected: {ui.themeMode},
              onSelectionChanged: (s) => controller.setThemeMode(s.first),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.palette_outlined),
            title: Text(l.settingsDynamicColor),
            subtitle: Text(l.settingsDynamicColorHint),
            value: ui.useDynamicColor,
            onChanged: (v) => controller.setDynamicColor(enabled: v),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l.settingsLanguage),
            trailing: DropdownButton<String>(
              value: ui.locale?.languageCode ?? '',
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(l.settingsLanguageSystem),
                ),
                for (final e in kSupportedLanguages.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => controller.setLocale(
                v == null || v.isEmpty ? null : Locale(v),
              ),
            ),
          ),

          _Header(l.authProfiles),
          if (auth != null)
            for (final p in auth.profiles)
              ListTile(
                leading: Icon(
                  p.credential.isUnrestricted
                      ? Icons.warning_amber_outlined
                      : Icons.vpn_key_outlined,
                  color: p.credential.isUnrestricted
                      ? context.cf.warning
                      : null,
                ),
                title: Text(p.label),
                subtitle: Text(p.credential.method.name),
                trailing: p.id == auth.activeId
                    ? const Icon(Icons.check)
                    : IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            ref.read(authProvider.notifier).removeProfile(p.id),
                      ),
                onTap: () => ref.read(authProvider.notifier).setActive(p.id),
              ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(l.authAddProfile),
            subtitle: const Text('Opens the Cloudflare token page'),
            onTap: () => launchUrl(
              TokenTemplate.userToken(TokenTemplate.full),
              mode: LaunchMode.externalApplication,
            ),
          ),

          _Header(l.settingsSecurity),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: Text(l.lockEnableBiometric),
            subtitle: const Text(
              'Wraps the vault key with a Keystore key that only unlocks after '
              'a successful fingerprint check.',
            ),
            value: auth?.biometricEnabled ?? false,
            onChanged: (v) async {
              final notifier = ref.read(authProvider.notifier);
              if (v) {
                final ok = await notifier.enableBiometric();
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Biometric hardware is not available'),
                    ),
                  );
                }
              } else {
                await notifier.disableBiometric();
              }
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.screenshot_monitor_outlined),
            title: Text(l.settingsBlockScreenshots),
            subtitle: Text(l.settingsBlockScreenshotsHint),
            value: ui.blockScreenshots,
            onChanged: (v) => controller.setBlockScreenshots(enabled: v),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(l.settingsAutoLock),
            trailing: DropdownButton<int>(
              value: ui.autoLock.inSeconds,
              underline: const SizedBox.shrink(),
              items: [
                for (final d in kAutoLockChoices)
                  DropdownMenuItem(
                    value: d.inSeconds,
                    child: Text(_autoLockLabel(l, d)),
                  ),
              ],
              onChanged: (v) => v == null
                  ? null
                  : controller.setAutoLock(Duration(seconds: v)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.settingsLockNow),
            onTap: () => ref.read(authProvider.notifier).lock(),
          ),

          _Header(l.settingsPrivacyTitle),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              l.settingsPrivacyBody,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

          _Header(l.settingsAbout),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Cloudflare Mobile'),
            subtitle: Text(
              'Open source, Apache-2.0. Not affiliated with Cloudflare, Inc.',
            ),
          ),

          const Divider(),
          ListTile(
            leading: Icon(Icons.delete_forever, color: context.cf.danger),
            title: Text(
              l.settingsWipe,
              style: TextStyle(color: context.cf.danger),
            ),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l.settingsWipe),
                  content: Text(l.settingsWipeConfirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(l.commonCancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l.commonDelete),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await ref.read(authProvider.notifier).wipe();
              }
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
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
