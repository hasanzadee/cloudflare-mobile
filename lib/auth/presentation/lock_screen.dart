import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
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
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 44),
                const SizedBox(height: 16),
                Text(
                  l.lockTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _pin,
                  autofocus: !biometric,
                  obscureText: true,
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
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _busy ? null : _unlock,
                  child: Text(l.commonUnlock),
                ),
                if (biometric)
                  TextButton.icon(
                    onPressed: _busy ? null : _biometric,
                    icon: const Icon(Icons.fingerprint),
                    label: Text(l.lockBiometric),
                  ),
              ],
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
