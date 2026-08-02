import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/generated/generated.dart';
import '../../core/ext.dart';
import '../../core/net/cf_client.dart';
import '../../core/net/interceptors/auth_interceptor.dart';
import '../../core/security/vault.dart';
import '../domain/cf_credential.dart';
import 'oauth_providers.dart';

enum AuthStatus {
  /// No vault yet — first launch.
  uninitialized,

  /// Vault exists, PIN not entered.
  locked,

  /// Unlocked, credentials available in memory.
  unlocked,
}

class AuthState {
  const AuthState({
    required this.status,
    this.profiles = const [],
    this.activeId,
    this.stubs = const [],
    this.biometricEnabled = false,
  });

  final AuthStatus status;
  final List<Profile> profiles;
  final List<ProfileStub> stubs;
  final String? activeId;
  final bool biometricEnabled;

  Profile? get active => profiles.firstWhereOrNull((p) => p.id == activeId);

  CfCredential? get credential => active?.credential;

  AuthState copyWith({
    AuthStatus? status,
    List<Profile>? profiles,
    List<ProfileStub>? stubs,
    String? activeId,
    bool? biometricEnabled,
  }) => AuthState(
    status: status ?? this.status,
    profiles: profiles ?? this.profiles,
    stubs: stubs ?? this.stubs,
    activeId: activeId ?? this.activeId,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
  );
}

final vaultProvider = Provider<Vault>((ref) => Vault());

final sharedPrefsProvider = FutureProvider<SharedPreferences>(
  (ref) => SharedPreferences.getInstance(),
);

class AuthController extends AsyncNotifier<AuthState> {
  VaultSession? _session;

  static const String _activeKey = 'active_profile_id';

  @override
  Future<AuthState> build() async {
    final vault = ref.read(vaultProvider);
    final initialized = await vault.isInitialized;
    final biometric = await vault.biometricEnabled;
    return AuthState(
      status: initialized ? AuthStatus.locked : AuthStatus.uninitialized,
      stubs: initialized ? await vault.listStubs() : const [],
      biometricEnabled: biometric,
    );
  }

  Future<bool> createVault({required String pin}) async {
    final vault = ref.read(vaultProvider);
    _session = await vault.create(pin: pin);
    state = AsyncData(
      AuthState(status: AuthStatus.unlocked, profiles: const []),
    );
    return true;
  }

  Future<bool> unlockWithPin(String pin) async {
    final vault = ref.read(vaultProvider);
    final session = await vault.unlockWithPin(pin);
    if (session == null) return false;
    _session = session;
    await _loadProfiles();
    return true;
  }

  Future<bool> unlockWithBiometric() async {
    final vault = ref.read(vaultProvider);
    final session = await vault.unlockWithBiometric();
    if (session == null) return false;
    _session = session;
    await _loadProfiles();
    return true;
  }

  Future<void> _loadProfiles() async {
    final session = _session;
    if (session == null) return;
    final profiles = await session.listProfiles();
    final prefs = await ref.read(sharedPrefsProvider.future);
    final stored = prefs.getString(_activeKey);
    final activeId = profiles.any((p) => p.id == stored)
        ? stored
        : profiles.firstOrNull?.id;

    state = AsyncData(
      AuthState(
        status: AuthStatus.unlocked,
        profiles: profiles,
        activeId: activeId,
        biometricEnabled: await ref.read(vaultProvider).biometricEnabled,
      ),
    );
  }

  Future<void> saveProfile(Profile profile, {bool makeActive = true}) async {
    final session = _session;
    if (session == null) return;
    await session.saveProfile(profile);
    if (makeActive) {
      final prefs = await ref.read(sharedPrefsProvider.future);
      await prefs.setString(_activeKey, profile.id);
    }
    await _loadProfiles();
  }

  Future<void> removeProfile(String id) async {
    final session = _session;
    if (session == null) return;
    await session.deleteProfile(id);
    await _loadProfiles();
  }

  Future<void> setActive(String id) async {
    final prefs = await ref.read(sharedPrefsProvider.future);
    await prefs.setString(_activeKey, id);
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(activeId: id));
    }
  }

  Future<bool> enableBiometric() async {
    final session = _session;
    if (session == null) return false;
    final ok = await ref.read(vaultProvider).enableBiometric(session);
    if (ok) {
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncData(current.copyWith(biometricEnabled: true));
      }
    }
    return ok;
  }

  Future<void> disableBiometric() async {
    await ref.read(vaultProvider).disableBiometric();
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(biometricEnabled: false));
    }
  }

  /// Drops the in-memory vault key. Everything encrypted stays on disk.
  void lock() {
    _session = null;
    final current = state.valueOrNull;
    state = AsyncData(
      AuthState(
        status: AuthStatus.locked,
        stubs: current?.stubs ?? const [],
        biometricEnabled: current?.biometricEnabled ?? false,
      ),
    );
  }

  Future<void> wipe() async {
    await ref.read(vaultProvider).wipe();
    _session = null;
    state = const AsyncData(AuthState(status: AuthStatus.uninitialized));
  }
}

final authProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Bridges the auth layer to the networking core without the latter depending
/// on Riverpod or storage.
class _RiverpodCredentialSource implements CredentialSource {
  _RiverpodCredentialSource(this._ref);

  final Ref _ref;

  @override
  CfCredential? get current => _ref.read(authProvider).valueOrNull?.credential;

  @override
  Future<CfCredential?> refresh() async {
    final active = _ref.read(authProvider).valueOrNull?.active;
    final credential = active?.credential;
    // API tokens and global keys have nothing to renew; callers correctly see
    // "not renewable" rather than a spurious retry.
    if (credential is! OAuthCredential) return null;

    final token = credential.refreshToken;
    if (token == null || token.isEmpty) return null;

    try {
      final oauth = await _ref.read(cloudflareOAuthProvider.future);
      final tokens = await oauth.refresh(token);
      final renewed = credential.copyWithTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        expiresAt: tokens.expiresAt,
        scopes: tokens.scopes.isEmpty ? null : tokens.scopes,
      );
      // Persist immediately: with rotating refresh tokens, losing the new one
      // means the session is unrecoverable.
      await _ref
          .read(authProvider.notifier)
          .saveProfile(
            active!.copyWith(credential: renewed),
            makeActive: false,
          );
      return renewed;
    } on Object {
      // A failed refresh is reported as "not renewable"; the 401 that triggered
      // it then surfaces as an AuthFailure and the user re-authenticates.
      return null;
    }
  }
}

final credentialSourceProvider = Provider<CredentialSource>(
  _RiverpodCredentialSource.new,
);

final cfClientProvider = Provider<CfClient>(
  (ref) => CfClient(credentials: ref.watch(credentialSourceProvider)),
);

final cfApiProvider = Provider<CfApi>(
  (ref) => CfApi(ref.watch(cfClientProvider)),
);

/// A credential that is not in the vault yet, used to validate it during
/// onboarding before anything is persisted.
class OneShotCredentialSource implements CredentialSource {
  OneShotCredentialSource(this.current);

  @override
  final CfCredential current;

  @override
  Future<CfCredential?> refresh() async => null;
}

/// Builds a client for a candidate credential.
///
/// Exposed as a provider purely so integration tests can swap in a mocked
/// transport and drive the real onboarding UI without a Cloudflare account.
final candidateClientProvider = Provider<CfClient Function(CfCredential)>(
  (ref) =>
      (credential) =>
          CfClient(credentials: OneShotCredentialSource(credential)),
);
