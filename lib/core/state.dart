import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'vault.dart';
import 'cf_api.dart';

/// Auto-lock timeout choices.
enum LockTimeout {
  immediate(0, 'Сразу'),
  s30(30, '30 секунд'),
  m1(60, '1 минута'),
  m5(300, '5 минут'),
  never(-1, 'Никогда');

  final int seconds;
  final String label;
  const LockTimeout(this.seconds, this.label);
}

class AuthState {
  final bool initialized;
  final bool unlocked;
  final String? token;
  const AuthState({
    required this.initialized,
    required this.unlocked,
    required this.token,
  });

  AuthState copyWith({bool? initialized, bool? unlocked, String? token}) =>
      AuthState(
        initialized: initialized ?? this.initialized,
        unlocked: unlocked ?? this.unlocked,
        token: token ?? this.token,
      );

  static const empty =
      AuthState(initialized: false, unlocked: false, token: null);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.empty) {
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final init = await Vault.isInitialized();
    state = state.copyWith(initialized: init, unlocked: false, token: null);
  }

  Future<void> setup({
    required String pin,
    required String token,
    required bool biometric,
  }) async {
    await Vault.setup(pin: pin, token: token, biometric: biometric);
    state = AuthState(initialized: true, unlocked: true, token: token);
  }

  Future<bool> unlockPin(String pin) async {
    final t = await Vault.unlockWithPin(pin);
    if (t == null) return false;
    state = state.copyWith(unlocked: true, token: t);
    return true;
  }

  Future<bool> unlockBiometric() async {
    final t = await Vault.unlockWithBiometric();
    if (t == null) return false;
    state = state.copyWith(unlocked: true, token: t);
    return true;
  }

  void lock() {
    state = AuthState(initialized: state.initialized, unlocked: false, token: null);
  }

  Future<void> logout() async {
    await Vault.wipe();
    state = AuthState.empty;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((_) => AuthController());

final cfApiProvider = Provider<CFApi?>((ref) {
  final t = ref.watch(authControllerProvider).token;
  return t == null ? null : CFApi(t);
});

/// Settings stored in SharedPreferences.
class Settings {
  final LockTimeout lockTimeout;
  final bool biometricEnabled;
  final String accountId;
  final String zoneId;
  const Settings({
    required this.lockTimeout,
    required this.biometricEnabled,
    required this.accountId,
    required this.zoneId,
  });

  Settings copyWith({
    LockTimeout? lockTimeout,
    bool? biometricEnabled,
    String? accountId,
    String? zoneId,
  }) =>
      Settings(
        lockTimeout: lockTimeout ?? this.lockTimeout,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        accountId: accountId ?? this.accountId,
        zoneId: zoneId ?? this.zoneId,
      );
}

class SettingsController extends StateNotifier<Settings> {
  SettingsController()
      : super(const Settings(
          lockTimeout: LockTimeout.m1,
          biometricEnabled: false,
          accountId: '',
          zoneId: '',
        )) {
    _load();
  }

  static const _kTimeout = 'lock_timeout_seconds';
  static const _kAccountId = 'cf_account_id';
  static const _kZoneId = 'cf_zone_id';

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final secs = p.getInt(_kTimeout) ?? 60;
    final bio = await Vault.isBiometricEnabled();
    state = Settings(
      lockTimeout: LockTimeout.values.firstWhere(
        (e) => e.seconds == secs,
        orElse: () => LockTimeout.m1,
      ),
      biometricEnabled: bio,
      accountId: p.getString(_kAccountId) ?? '',
      zoneId: p.getString(_kZoneId) ?? '',
    );
  }

  Future<void> setTimeout(LockTimeout t) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kTimeout, t.seconds);
    state = state.copyWith(lockTimeout: t);
  }

  Future<void> refreshBio() async {
    final bio = await Vault.isBiometricEnabled();
    state = state.copyWith(biometricEnabled: bio);
  }

  Future<void> setAccountId(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kAccountId, v);
    state = state.copyWith(accountId: v);
  }

  Future<void> setZoneId(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kZoneId, v);
    state = state.copyWith(zoneId: v);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsController, Settings>((_) => SettingsController());

/// Tracks when app went to background, used to auto-lock.
class LifecycleObserver extends WidgetsBindingObserver {
  final WidgetRef ref;
  DateTime? _backgroundedAt;
  LifecycleObserver(this.ref);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _backgroundedAt = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      final secs = ref.read(settingsProvider).lockTimeout.seconds;
      if (secs == -1) return; // never
      final auth = ref.read(authControllerProvider);
      if (!auth.unlocked) return;
      if (_backgroundedAt == null) return;
      final delta = DateTime.now().difference(_backgroundedAt!).inSeconds;
      if (delta >= secs) {
        ref.read(authControllerProvider.notifier).lock();
      }
      _backgroundedAt = null;
    }
  }
}
