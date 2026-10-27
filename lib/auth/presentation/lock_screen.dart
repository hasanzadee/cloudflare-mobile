import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/ds/ds.dart';
import '../application/auth_providers.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _pin = TextEditingController();
  bool _busy = false;
  bool _wrong = false;
  bool _biometricTried = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final auth = ref.watch(authProvider).valueOrNull;
    final biometric = auth?.biometricEnabled ?? false;

    // Offer the fingerprint immediately; falling back to the PIN is one tap.
    if (biometric && !_biometricTried) {
      _biometricTried = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _biometric());
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Gap.xl + Gap.sm),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: BrandMark()),
                  const SizedBox(height: Gap.xl),
                  Text(
                    l.lockTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: Gap.xl),
                  TextField(
                    controller: _pin,
                    autofocus: !biometric,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(letterSpacing: 10),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: l.lockPin,
                      errorText: _wrong ? l.lockWrongPin : null,
                    ),
                    onChanged: (_) {
                      if (_wrong) setState(() => _wrong = false);
                    },
                    onSubmitted: (_) => _unlock(),
                  ),
                  const SizedBox(height: Gap.lg),
                  FilledButton(
                    onPressed: _busy ? null : _unlock,
                    child: _busy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.commonUnlock),
                  ),
                  if (biometric) ...[
                    const SizedBox(height: Gap.sm),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _biometric,
                      icon: const Icon(Icons.fingerprint),
                      label: Text(l.lockBiometric),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _unlock() async {
    if (_pin.text.isEmpty) return;
    setState(() => _busy = true);
    final ok = await ref.read(authProvider.notifier).unlockWithPin(_pin.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _wrong = !ok;
    });
  }

  Future<void> _biometric() async {
    setState(() => _busy = true);
    await ref.read(authProvider.notifier).unlockWithBiometric();
    if (mounted) setState(() => _busy = false);
  }
}
