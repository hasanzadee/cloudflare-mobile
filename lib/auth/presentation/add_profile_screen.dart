import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/net/failure.dart';
import '../../core/security/vault.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/failure_text.dart';
import '../application/auth_providers.dart';
import '../data/token_template.dart';
import '../domain/cf_credential.dart';
import 'manual_permissions.dart';

/// Adds a second, third, nth credential once the vault already exists.
///
/// The vault, the switcher and the storage layer have always been
/// multi-profile; there was simply no way to reach any of it after onboarding.
/// Settings offered "Add profile", which opened the Cloudflare website and
/// then left you holding a token with nowhere to paste it.
///
/// No PIN step here, unlike onboarding: the vault is already unlocked, and the
/// new profile is encrypted with the same vault key as the others.
class AddProfileScreen extends ConsumerStatefulWidget {
  const AddProfileScreen({super.key});

  @override
  ConsumerState<AddProfileScreen> createState() => _AddProfileScreenState();
}

enum _Method { chooseMethod, token, globalKey }

class _AddProfileScreenState extends ConsumerState<AddProfileScreen> {
  _Method _step = _Method.chooseMethod;

  final _label = TextEditingController();
  final _token = TextEditingController();
  final _email = TextEditingController();
  final _key = TextEditingController();
  final _confirm = TextEditingController();

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_label, _token, _email, _key, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.authAddProfile),
        leading: _step == _Method.chooseMethod
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _error = null;
                  _step = _Method.chooseMethod;
                }),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: switch (_step) {
            _Method.chooseMethod => _chooseMethod(l),
            _Method.token => _tokenForm(l),
            _Method.globalKey => _globalKeyForm(l),
          },
        ),
      ),
    );
  }

  Widget _chooseMethod(L l) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(l.authChooseMethod, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 16),
      Card(
        child: ListTile(
          leading: const Icon(Icons.vpn_key_outlined),
          title: Text(l.authApiToken),
          subtitle: Text(l.authApiTokenBlurb),
          onTap: () => setState(() => _step = _Method.token),
        ),
      ),
      Card(
        child: ListTile(
          leading: const Icon(Icons.warning_amber_outlined),
          title: Text(l.authGlobalKey),
          subtitle: Text(l.authGlobalKeyBlurb),
          onTap: () => setState(() => _step = _Method.globalKey),
        ),
      ),
    ],
  );

  Widget _tokenForm(L l) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      OutlinedButton.icon(
        onPressed: () => launchUrl(
          TokenTemplate.userToken(TokenTemplate.full),
          mode: LaunchMode.externalApplication,
        ),
        icon: const Icon(Icons.open_in_new),
        label: Text(l.authCreateToken),
      ),
      const SizedBox(height: 12),
      ManualPermissions(permissions: TokenTemplate.full),
      const SizedBox(height: 20),
      _labelField(l),
      const SizedBox(height: 12),
      TextField(
        controller: _token,
        decoration: InputDecoration(
          labelText: l.authPasteToken,
          hintText: l.authTokenHint,
        ),
        maxLines: 2,
        autocorrect: false,
        enableSuggestions: false,
      ),
      if (_error != null) _errorText(_error!),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _busy ? null : _saveToken,
        child: Text(_busy ? l.authVerifying : l.authVerify),
      ),
    ],
  );

  Widget _globalKeyForm(L l) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.authGlobalKeyWarnTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l.authGlobalKeyWarnBody,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      _labelField(l),
      const SizedBox(height: 12),
      TextField(
        controller: _email,
        decoration: InputDecoration(labelText: l.authEmail),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _key,
        decoration: InputDecoration(labelText: l.authGlobalKeyField),
        obscureText: true,
        autocorrect: false,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _confirm,
        decoration: InputDecoration(labelText: l.authGlobalKeyConfirm),
        autocorrect: false,
      ),
      if (_error != null) _errorText(_error!),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _busy ? null : _saveGlobalKey,
        child: Text(_busy ? l.authVerifying : l.authVerify),
      ),
    ],
  );

  /// The whole point of a second profile is telling it from the first, so the
  /// name is asked for up front rather than defaulted to "Cloudflare" twice.
  Widget _labelField(L l) => TextField(
    controller: _label,
    decoration: InputDecoration(
      labelText: l.authProfileName,
      hintText: 'Work, Client, Personal…',
    ),
    autocorrect: false,
  );

  Widget _errorText(String message) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(
      message,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    ),
  );

  Future<void> _saveToken() async {
    final token = _token.text.trim();
    if (token.isEmpty) {
      setState(() => _error = 'Paste a token first');
      return;
    }
    await _verifyAndSave(
      ApiTokenCredential(
        id: _newId(),
        label: _labelOr('Cloudflare'),
        token: token,
      ),
    );
  }

  Future<void> _saveGlobalKey() async {
    if (_confirm.text.trim().toUpperCase() != 'UNRESTRICTED') {
      setState(() => _error = L.of(context).authGlobalKeyConfirm);
      return;
    }
    final email = _email.text.trim();
    await _verifyAndSave(
      GlobalKeyCredential(
        id: _newId(),
        label: _labelOr(email.isEmpty ? 'Global key' : email),
        email: email,
        apiKey: _key.text.trim(),
      ),
    );
  }

  String _labelOr(String fallback) =>
      _label.text.trim().isEmpty ? fallback : _label.text.trim();

  /// Checks the credential before storing it, so a typo fails here rather than
  /// on whichever screen happens to be opened next.
  Future<void> _verifyAndSave(CfCredential credential) async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final client = ref.read(candidateClientProvider)(credential);
      await client.send(method: 'GET', path: 'user/tokens/verify');

      await ref
          .read(authProvider.notifier)
          .saveProfile(
            Profile(
              id: credential.id,
              label: credential.label,
              credential: credential,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } on CfFailure catch (e) {
      if (!mounted) return;
      setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);
}
