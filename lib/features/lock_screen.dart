import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../core/state.dart';
import '../core/vault.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});
  @override
  ConsumerState<LockScreen> createState() => _LockState();
}

class _LockState extends ConsumerState<LockScreen> {
  final _pin = TextEditingController();
  bool _busy = false;
  String? _err;
  bool _bioTried = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeBio());
  }

  Future<void> _maybeBio() async {
    if (_bioTried) return;
    _bioTried = true;
    if (!await Vault.isBiometricEnabled()) return;
    final auth = LocalAuthentication();
    try {
      final ok = await auth.authenticate(
        localizedReason: 'Разблокируйте CF Manager',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (ok && mounted) {
        await ref.read(authControllerProvider.notifier).unlockBiometric();
      }
    } catch (_) {}
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _err = null;
    });
    final ok = await ref.read(authControllerProvider.notifier).unlockPin(_pin.text);
    if (!ok && mounted) {
      setState(() {
        _err = 'Неверный PIN';
        _busy = false;
      });
      _pin.clear();
    }
  }

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_outlined, size: 80),
                const SizedBox(height: 16),
                const Text('CF Manager', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 32),
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _pin,
                    obscureText: true,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, letterSpacing: 8),
                    onSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'PIN',
                    ),
                  ),
                ),
                if (_err != null) ...[
                  const SizedBox(height: 12),
                  Text(_err!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  icon: _busy
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.lock_open),
                  onPressed: _busy ? null : _submit,
                  label: const Text('Войти'),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: _maybeBio,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Биометрия'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
