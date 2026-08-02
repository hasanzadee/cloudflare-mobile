import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/application/oauth_providers.dart';
import '../../auth/data/token_template.dart';
import '../../core/security/secure_flag.dart';
import '../../l10n/app_localizations.dart';

/// Screenshot blocking, on by default because tokens and secrets pass through
/// the UI and the recents thumbnail is captured without user action.
final secureFlagProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final auth = ref.watch(authProvider).valueOrNull;
    final secure = ref.watch(secureFlagProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        children: [
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

          _Header(l.authOAuthSettings),
          const _OAuthConfigTile(),

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
            value: secure,
            onChanged: (v) {
              ref.read(secureFlagProvider.notifier).state = v;
              const SecureFlag().set(enabled: v);
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(l.commonUnlock),
            subtitle: const Text('Lock now'),
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

/// Lets anyone point the app at their own registered OAuth client.
///
/// Neither value is a secret: a public PKCE client has no secret, and the
/// redirect URL is visible in the consent screen anyway.
class _OAuthConfigTile extends ConsumerWidget {
  const _OAuthConfigTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final settings = ref.watch(oauthSettingsProvider).valueOrNull;
    final configured =
        (settings?.clientId.isNotEmpty ?? false) &&
        (settings?.redirectUri.isNotEmpty ?? false);

    return Column(
      children: [
        ListTile(
          leading: Icon(
            configured ? Icons.check_circle_outline : Icons.info_outline,
            color: configured ? context.cf.success : null,
          ),
          title: Text(l.authOAuthClientId),
          subtitle: Text(
            configured ? settings!.clientId : l.authOAuthNotConfigured,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.edit_outlined),
          onTap: () => _edit(context, ref, settings),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            l.authOAuthHelp,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    OAuthSettings? current,
  ) async {
    final l = L.of(context);
    final clientId = TextEditingController(text: current?.clientId ?? '');
    final redirect = TextEditingController(text: current?.redirectUri ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.authOAuthSettings),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: clientId,
              autocorrect: false,
              decoration: InputDecoration(labelText: l.authOAuthClientId),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: redirect,
              autocorrect: false,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: l.authOAuthRedirect,
                hintText: 'https://…/oauth/callback',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.commonSave),
          ),
        ],
      ),
    );

    if (saved == true) {
      final prefs = await ref.read(sharedPrefsProvider.future);
      await saveOAuthSettings(
        prefs,
        clientId: clientId.text,
        redirectUri: redirect.text,
      );
      ref.invalidate(oauthSettingsProvider);
    }
    clientId.dispose();
    redirect.dispose();
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
