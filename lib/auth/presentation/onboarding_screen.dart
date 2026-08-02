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

/// First-run flow: pick a sign-in method, provide the credential, set a PIN.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

enum _Step { chooseMethod, token, globalKey, pin }

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  _Step _step = _Step.chooseMethod;

  final _token = TextEditingController();
  final _email = TextEditingController();
  final _key = TextEditingController();
  final _pin = TextEditingController();
  final _pin2 = TextEditingController();
  final _confirm = TextEditingController();

  CfCredential? _pending;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_token, _email, _key, _pin, _pin2, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.appTitle),
        leading: _step == _Step.chooseMethod
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _error = null;
                  _step = _Step.chooseMethod;
                }),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: switch (_step) {
            _Step.chooseMethod => _chooseMethod(l),
            _Step.token => _tokenForm(l),
            _Step.globalKey => _globalKeyForm(l),
            _Step.pin => _pinForm(l),
          },
        ),
      ),
    );
  }

  Widget _chooseMethod(L l) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l.onboardWelcomeTitle, style: context.headline),
      const SizedBox(height: 8),
      Text(
        l.onboardWelcomeBody(2884),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 28),
      Text(l.authChooseMethod, style: context.title),
      const SizedBox(height: 12),
      _MethodCard(
        icon: Icons.vpn_key_outlined,
        title: l.authApiToken,
        body: l.authApiTokenBlurb,
        recommended: true,
        onTap: () => setState(() => _step = _Step.token),
      ),
      _MethodCard(
        icon: Icons.account_circle_outlined,
        title: l.authOAuth,
        body: l.authOAuthBlurb,
        // Enabled once the OAuth client registration is verified; see
        // docs/oauth-spike.md for what is still unknown.
        disabledNote: 'Coming in 1.1 — see docs/oauth-spike.md',
        onTap: null,
      ),
      _MethodCard(
        icon: Icons.warning_amber_outlined,
        title: l.authGlobalKey,
        body: l.authGlobalKeyBlurb,
        onTap: () => setState(() => _step = _Step.globalKey),
      ),
    ],
  );

  Widget _tokenForm(L l) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l.authApiToken, style: context.headline),
      const SizedBox(height: 8),
      Text(
        'Cloudflare opens with the right permissions already ticked. '
        'Create the token, then paste it here.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        children: [
          OutlinedButton.icon(
            onPressed: () =>
                _open(TokenTemplate.userToken(TokenTemplate.dnsAdmin)),
            icon: const Icon(Icons.dns_outlined),
            label: const Text('DNS admin'),
          ),
          OutlinedButton.icon(
            onPressed: () =>
                _open(TokenTemplate.userToken(TokenTemplate.readOnly)),
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('Read only'),
          ),
          OutlinedButton.icon(
            onPressed: () => _open(TokenTemplate.userToken(TokenTemplate.full)),
            icon: const Icon(Icons.all_inclusive),
            label: const Text('Full'),
          ),
        ],
      ),
      const SizedBox(height: 20),
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
        onPressed: _busy ? null : _verifyToken,
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
        onPressed: _busy ? null : _verifyGlobalKey,
        child: Text(_busy ? l.authVerifying : l.authVerify),
      ),
    ],
  );

  Widget _pinForm(L l) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l.lockSetPin, style: context.headline),
      const SizedBox(height: 8),
      Text(
        'The PIN encrypts your credential on this device. It is never sent '
        'anywhere and cannot be recovered — forgetting it means starting over.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 20),
      TextField(
        controller: _pin,
        decoration: InputDecoration(labelText: l.lockPin),
        keyboardType: TextInputType.number,
        obscureText: true,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _pin2,
        decoration: InputDecoration(labelText: l.lockConfirmPin),
        keyboardType: TextInputType.number,
        obscureText: true,
      ),
      if (_error != null) _errorText(_error!),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _busy ? null : _finish,
        child: Text(_busy ? '…' : l.commonContinue),
      ),
    ],
  );

  Widget _errorText(String message) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(
      message,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    ),
  );

  Future<void> _open(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Checks the credential against `GET /user/tokens/verify` before we accept
  /// it, so a typo is caught here instead of on the first screen that fails.
  Future<void> _verify(CfCredential credential) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final client = ref.read(candidateClientProvider)(credential);
    try {
      await client.send(method: 'GET', path: 'user/tokens/verify');
      if (!mounted) return;
      setState(() {
        _pending = credential;
        _step = _Step.pin;
      });
    } on CfFailure catch (e) {
      if (!mounted) return;
      setState(() => _error = failureMessage(context, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verifyToken() async {
    final token = _token.text.trim();
    if (token.isEmpty) {
      setState(() => _error = 'Paste a token first');
      return;
    }
    await _verify(
      ApiTokenCredential(id: _newId(), label: 'Cloudflare', token: token),
    );
  }

  Future<void> _verifyGlobalKey() async {
    if (_confirm.text.trim().toUpperCase() != 'UNRESTRICTED') {
      setState(() => _error = L.of(context).authGlobalKeyConfirm);
      return;
    }
    await _verify(
      GlobalKeyCredential(
        id: _newId(),
        label: _email.text.trim(),
        email: _email.text.trim(),
        apiKey: _key.text.trim(),
      ),
    );
  }

  Future<void> _finish() async {
    final l = L.of(context);
    if (_pin.text.length < 4) {
      setState(() => _error = l.lockPinTooShort);
      return;
    }
    if (_pin.text != _pin2.text) {
      setState(() => _error = l.lockPinMismatch);
      return;
    }
    final credential = _pending;
    if (credential == null) return;

    setState(() => _busy = true);
    final auth = ref.read(authProvider.notifier);
    await auth.createVault(pin: _pin.text);
    await auth.saveProfile(
      Profile(
        id: credential.id,
        label: credential.label,
        credential: credential,
      ),
    );
    if (mounted) setState(() => _busy = false);
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.recommended = false,
    this.disabledNote,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback? onTap;
  final bool recommended;
  final String? disabledNote;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        enabled: enabled,
        leading: Icon(icon),
        title: Row(
          children: [
            Flexible(child: Text(title)),
            if (recommended) ...[
              const SizedBox(width: 8),
              const _Pill(text: 'Recommended'),
            ],
          ],
        ),
        subtitle: Text(disabledNote == null ? body : '$body\n$disabledNote'),
        isThreeLine: disabledNote != null,
        trailing: enabled ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    ),
  );
}

extension on BuildContext {
  TextStyle? get headline => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get title => Theme.of(this).textTheme.titleMedium;
}
