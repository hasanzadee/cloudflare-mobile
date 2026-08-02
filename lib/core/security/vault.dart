import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import '../../auth/domain/cf_credential.dart';
import 'crypto_isolate.dart';
import 'keystore_channel.dart';
import 'secure_store.dart';

/// One stored Cloudflare identity.
class Profile {
  const Profile({
    required this.id,
    required this.label,
    required this.credential,
    this.accountId,
    this.accountName,
  });

  final String id;
  final String label;
  final CfCredential credential;

  /// Last account the user was scoped to, restored on next launch.
  final String? accountId;
  final String? accountName;

  Profile copyWith({
    String? label,
    CfCredential? credential,
    String? accountId,
    String? accountName,
  }) => Profile(
    id: id,
    label: label ?? this.label,
    credential: credential ?? this.credential,
    accountId: accountId ?? this.accountId,
    accountName: accountName ?? this.accountName,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'label': label,
    'credential': credential.toJson(),
    if (accountId != null) 'account_id': accountId,
    if (accountName != null) 'account_name': accountName,
  };

  static Profile fromJson(Map<String, Object?> json) => Profile(
    id: json['id'] as String? ?? '',
    label: json['label'] as String? ?? 'Cloudflare',
    credential: CfCredential.fromJson(
      (json['credential'] as Map?)?.map((k, v) => MapEntry(k.toString(), v)) ??
          const {},
    ),
    accountId: json['account_id'] as String?,
    accountName: json['account_name'] as String?,
  );
}

/// Non-secret listing entry, readable without unlocking so the lock screen can
/// say which profiles exist.
class ProfileStub {
  const ProfileStub({
    required this.id,
    required this.label,
    required this.method,
  });

  final String id;
  final String label;
  final CfAuthMethod method;

  Map<String, Object?> toJson() => {
    'id': id,
    'label': label,
    'method': method.name,
  };

  static ProfileStub fromJson(Map<String, Object?> json) => ProfileStub(
    id: json['id'] as String? ?? '',
    label: json['label'] as String? ?? '',
    method: CfAuthMethod.fromName(json['method'] as String?),
  );
}

/// Encrypted credential storage.
///
/// Layout — every value below is stored in Keystore-backed
/// EncryptedSharedPreferences, and the vault adds a second layer on top:
///
/// ```text
/// masterKey  = PBKDF2-HMAC-SHA256(pin, salt)      (never stored)
/// vaultKey   = 32 random bytes                    (never stored in the clear)
///   wrap_pin = AES-GCM(vaultKey, masterKey)
///   wrap_bio = AES-GCM(vaultKey, hardware key)    (optional, Keystore-bound)
/// profile.N  = AES-GCM(profile JSON, vaultKey)
/// verifier   = SHA-256(masterKey)                 (to reject a wrong PIN fast)
/// ```
///
/// Wrapping the vault key — rather than encrypting each secret directly with
/// the PIN-derived key, as the prototype did — is what makes changing the PIN,
/// turning biometrics on later, and holding several profiles O(1) instead of
/// "re-encrypt everything".
class Vault {
  Vault({
    SecureStore? store,
    KeystoreChannel keystore = const KeystoreChannel(),
    Random? random,
  }) : _store = store ?? const FlutterSecureStore(),
       _keystore = keystore,
       _random = random ?? Random.secure();

  final SecureStore _store;
  final KeystoreChannel _keystore;
  final Random _random;

  static const String _kSalt = 'v2.salt';
  static const String _kWrapPin = 'v2.wrap_pin';
  static const String _kWrapBio = 'v2.wrap_bio';
  static const String _kVerifier = 'v2.verifier';
  static const String _kIndex = 'v2.index';
  static const String _profilePrefix = 'v2.profile.';

  static final AesGcm _aes = AesGcm.with256bits();

  Future<bool> get isInitialized async =>
      (await _store.read(_kWrapPin)) != null;

  Future<bool> get biometricEnabled async =>
      (await _store.read(_kWrapBio)) != null;

  /// Creates a fresh vault protected by [pin].
  Future<VaultSession> create({required String pin}) async {
    final salt = _randomBytes(16);
    final master = await deriveKeyFromPin(pin, salt);
    final vaultKey = _randomBytes(32);

    await _store.write(_kSalt, base64.encode(salt));
    await _store.write(_kWrapPin, await _seal(vaultKey, master));
    await _store.write(_kVerifier, await _verifierOf(master));
    await _store.write(_kIndex, jsonEncode(const <Object>[]));

    return VaultSession._(this, vaultKey);
  }

  /// Returns a session, or null when the PIN is wrong.
  Future<VaultSession?> unlockWithPin(String pin) async {
    final saltRaw = await _store.read(_kSalt);
    final wrapped = await _store.read(_kWrapPin);
    final verifier = await _store.read(_kVerifier);
    if (saltRaw == null || wrapped == null || verifier == null) return null;

    final master = await deriveKeyFromPin(pin, base64.decode(saltRaw));
    if (await _verifierOf(master) != verifier) return null;

    final vaultKey = await _open(wrapped, master);
    if (vaultKey == null) return null;
    return VaultSession._(this, vaultKey);
  }

  /// Returns a session after a successful hardware-backed biometric unwrap.
  ///
  /// Returns null when the user cancels, when no biometric wrap exists, or
  /// when the key was invalidated by a fingerprint being enrolled — in which
  /// case the caller must fall back to the PIN.
  Future<VaultSession?> unlockWithBiometric({
    String promptTitle = 'Unlock Cloudflare Mobile',
  }) async {
    final wrapped = await _store.read(_kWrapBio);
    if (wrapped == null) return null;

    final status = await _keystore.status();
    if (status != KeystoreStatus.ready) {
      if (status == KeystoreStatus.invalidated) await disableBiometric();
      return null;
    }

    final vaultKey = await _keystore.unwrap(
      base64.decode(wrapped),
      promptTitle: promptTitle,
    );
    if (vaultKey == null) return null;
    return VaultSession._(this, Uint8List.fromList(vaultKey));
  }

  Future<bool> enableBiometric(
    VaultSession session, {
    String promptTitle = 'Confirm to enable fingerprint unlock',
  }) async {
    if (!await _keystore.createKey()) return false;
    final wrapped = await _keystore.wrap(
      session._vaultKey,
      promptTitle: promptTitle,
    );
    if (wrapped == null) return false;
    await _store.write(_kWrapBio, base64.encode(wrapped));
    return true;
  }

  Future<void> disableBiometric() async {
    await _store.delete(_kWrapBio);
    await _keystore.deleteKey();
  }

  /// Re-wraps the vault key under a new PIN. Profiles are untouched, which is
  /// the whole point of the wrapping layer.
  Future<bool> changePin({
    required String current,
    required String next,
  }) async {
    final session = await unlockWithPin(current);
    if (session == null) return false;

    final salt = _randomBytes(16);
    final master = await deriveKeyFromPin(next, salt);
    await _store.write(_kSalt, base64.encode(salt));
    await _store.write(_kWrapPin, await _seal(session._vaultKey, master));
    await _store.write(_kVerifier, await _verifierOf(master));
    return true;
  }

  Future<void> wipe() => _store.deleteAll();

  /// Profile list without unlocking — labels only, never credentials.
  Future<List<ProfileStub>> listStubs() async {
    final raw = await _store.read(_kIndex);
    if (raw == null) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<Object?, Object?>>()
        .map(
          (e) =>
              ProfileStub.fromJson(e.map((k, v) => MapEntry(k.toString(), v))),
        )
        .toList();
  }

  // --- internals -----------------------------------------------------------

  Uint8List _randomBytes(int n) =>
      Uint8List.fromList(List<int>.generate(n, (_) => _random.nextInt(256)));

  Future<String> _verifierOf(Uint8List master) async {
    final digest = await Sha256().hash(master);
    return base64.encode(digest.bytes);
  }

  /// AES-GCM seal, serialized as base64(nonce ‖ ciphertext ‖ mac).
  Future<String> _seal(List<int> plain, List<int> key) async {
    final nonce = _randomBytes(12);
    final box = await _aes.encrypt(
      plain,
      secretKey: SecretKey(key),
      nonce: nonce,
    );
    return base64.encode([...nonce, ...box.cipherText, ...box.mac.bytes]);
  }

  Future<Uint8List?> _open(String sealed, List<int> key) async {
    try {
      final bytes = base64.decode(sealed);
      if (bytes.length < 12 + 16) return null;
      final box = SecretBox(
        bytes.sublist(12, bytes.length - 16),
        nonce: bytes.sublist(0, 12),
        mac: Mac(bytes.sublist(bytes.length - 16)),
      );
      final clear = await _aes.decrypt(box, secretKey: SecretKey(key));
      return Uint8List.fromList(clear);
    } on Object {
      // A wrong key surfaces as a MAC failure; callers treat null as "denied".
      return null;
    }
  }
}

/// An unlocked vault. Holds the vault key in memory only for as long as the
/// app is unlocked.
class VaultSession {
  VaultSession._(this._vault, this._vaultKey);

  final Vault _vault;
  final Uint8List _vaultKey;

  Future<List<Profile>> listProfiles() async {
    final stubs = await _vault.listStubs();
    final out = <Profile>[];
    for (final stub in stubs) {
      final profile = await readProfile(stub.id);
      if (profile != null) out.add(profile);
    }
    return out;
  }

  Future<Profile?> readProfile(String id) async {
    final sealed = await _vault._store.read('${Vault._profilePrefix}$id');
    if (sealed == null) return null;
    final plain = await _vault._open(sealed, _vaultKey);
    if (plain == null) return null;
    final decoded = jsonDecode(utf8.decode(plain));
    if (decoded is! Map) return null;
    return Profile.fromJson(decoded.map((k, v) => MapEntry(k.toString(), v)));
  }

  Future<void> saveProfile(Profile profile) async {
    final sealed = await _vault._seal(
      utf8.encode(jsonEncode(profile.toJson())),
      _vaultKey,
    );
    await _vault._store.write('${Vault._profilePrefix}${profile.id}', sealed);

    final stubs = await _vault.listStubs();
    final updated = [
      ...stubs.where((s) => s.id != profile.id),
      ProfileStub(
        id: profile.id,
        label: profile.label,
        method: profile.credential.method,
      ),
    ];
    await _vault._store.write(
      Vault._kIndex,
      jsonEncode(updated.map((s) => s.toJson()).toList()),
    );
  }

  Future<void> deleteProfile(String id) async {
    await _vault._store.delete('${Vault._profilePrefix}$id');
    final stubs = await _vault.listStubs();
    await _vault._store.write(
      Vault._kIndex,
      jsonEncode(
        stubs.where((s) => s.id != id).map((s) => s.toJson()).toList(),
      ),
    );
  }
}
