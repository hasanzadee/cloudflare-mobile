import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/cf_api.dart';
import '../core/state.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingState();
}

class _OnboardingState extends ConsumerState<OnboardingScreen> {
  final _token = TextEditingController();
  final _pin = TextEditingController();
  final _pin2 = TextEditingController();
  bool _bio = true;
  bool _busy = false;
  String? _err;
  int _step = 0; // 0: token, 1: pin

  @override
  void dispose() {
    _token.dispose();
    _pin.dispose();
    _pin2.dispose();
    super.dispose();
  }

  Future<void> _verifyTokenAndNext() async {
    final t = _token.text.trim();
    if (t.isEmpty) {
      setState(() => _err = 'Введи API token');
      return;
    }
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      final ok = await CFApi(t).verifyToken();
      if (!ok) {
        setState(() => _err = 'Cloudflare отклонил токен');
      } else {
        setState(() => _step = 1);
      }
    } on CFException catch (e) {
      setState(() => _err = e.toString());
    } catch (e) {
      setState(() => _err = 'Ошибка: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _finish() async {
    if (_pin.text.length < 4) {
      setState(() => _err = 'PIN минимум 4 цифры');
      return;
    }
    if (_pin.text != _pin2.text) {
      setState(() => _err = 'PIN-коды не совпадают');
      return;
    }
    setState(() {
      _busy = true;
      _err = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).setup(
            pin: _pin.text,
            token: _token.text.trim(),
            biometric: _bio,
          );
    } catch (e) {
      setState(() {
        _err = 'Ошибка сохранения: $e';
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подключение к Cloudflare')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: _step == 0 ? _buildTokenStep() : _buildPinStep(),
        ),
      ),
    );
  }

  Widget _buildTokenStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const Text('Шаг 1 из 2: Cloudflare API Token',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text(
          'Создай токен на dash.cloudflare.com → My Profile → API Tokens. '
          'Дай нужные права (Zone.DNS Edit и т.п.). Токен хранится только на этом устройстве, шифруется PIN-кодом.',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _token,
          maxLines: 2,
          autocorrect: false,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'API Token',
            hintText: 'eyJhbGciOiJI… или 40-символьный токен',
          ),
        ),
        if (_err != null) ...[
          const SizedBox(height: 12),
          Text(_err!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 24),
        FilledButton.icon(
          icon: _busy
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.check),
          onPressed: _busy ? null : _verifyTokenAndNext,
          label: const Text('Проверить и продолжить'),
        ),
      ],
    );
  }

  Widget _buildPinStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        const Text('Шаг 2 из 2: PIN-код',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text(
            'Из PIN-кода будет получен ключ шифрования (PBKDF2-HMAC-SHA256, 200 000 итераций), которым шифруется твой Cloudflare-токен.',
            style: TextStyle(fontSize: 13)),
        const SizedBox(height: 24),
        TextField(
          controller: _pin,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'PIN (мин. 4 цифры)',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _pin2,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Повторите PIN',
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _bio,
          onChanged: (v) => setState(() => _bio = v),
          title: const Text('Разблокировка по отпечатку / Face ID'),
          subtitle: const Text('Можно включить позже в настройках'),
        ),
        if (_err != null) ...[
          const SizedBox(height: 12),
          Text(_err!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            TextButton(
              onPressed: _busy ? null : () => setState(() => _step = 0),
              child: const Text('Назад'),
            ),
            const Spacer(),
            FilledButton.icon(
              icon: _busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.lock),
              onPressed: _busy ? null : _finish,
              label: const Text('Готово'),
            ),
          ],
        ),
      ],
    );
  }
}
