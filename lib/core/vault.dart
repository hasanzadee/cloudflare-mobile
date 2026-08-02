import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';

/// Vault: stores Cloudflare API token encrypted by a key derived from the
/// user PIN/password using PBKDF2-HMAC-SHA256 (200k iterations).
/// Encrypted blob lives in flutter_secure_storage (Android Keystore-backed).
class Vault {
  static const _kSalt = 'cf_salt_v1';
  static const _kBlob = 'cf_token_blob_v1';
  static const _kBioBlob = 'cf_token_bio_blob_v1'; // unlocked via biometrics
  static const _kBioKey = 'cf_bio_key_v1';
  static const _kPinHash = 'cf_pin_hash_v1';
  static const _kInit = 'cf_initialized_v1';
  static const _kBioEnabled = 'cf_bio_enabled_v1';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 200000,
    bits: 256,
  );
  static final _aes = AesGcm.with256bits();

  static Future<bool> isInitialized() async =>
      (await _storage.read(key: _kInit)) == '1';

  static Future<bool> isBiometricEnabled() async =>
      (await _storage.read(key: _kBioEnabled)) == '1';

  static Future<Uint8List> _deriveKey(String pin, Uint8List salt) async {
    final secretKey = await _pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    return Uint8List.fromList(await secretKey.extractBytes());
  }

  /// Initial setup: encrypt & store CF token, save PIN verifier hash.
  static Future<void> setup({
    required String pin,
    required String token,
    required bool biometric,
  }) async {
    final salt = _randomBytes(16);
    final key = await _deriveKey(pin, salt);
    final blob = await _encrypt(token, key);
    await _storage.write(key: _kSalt, value: base64.encode(salt));
    await _storage.write(key: _kBlob, value: blob);
    // PIN verifier: hash of derived key (we never store the key itself).
    final verifier = await Sha256().hash(key);
    await _storage.write(
      key: _kPinHash,
      value: base64.encode(verifier.bytes),
    );
    if (biometric) {
      // For biometric unlock, store a separate copy of the token encrypted
      // with a freshly generated random key, kept in secure storage. The
      // biometric prompt protects access to flutter_secure_storage on Android.
      final bioKey = _randomBytes(32);
      final bioBlob = await _encrypt(token, bioKey);
      await _storage.write(key: _kBioKey, value: base64.encode(bioKey));
      await _storage.write(key: _kBioBlob, value: bioBlob);
      await _storage.write(key: _kBioEnabled, value: '1');
    } else {
      await _storage.delete(key: _kBioKey);
      await _storage.delete(key: _kBioBlob);
      await _storage.write(key: _kBioEnabled, value: '0');
    }
    await _storage.write(key: _kInit, value: '1');
  }

  /// Verify PIN and return decrypted token, or null if PIN is wrong.
  static Future<String?> unlockWithPin(String pin) async {
    final saltB64 = await _storage.read(key: _kSalt);
    final blob = await _storage.read(key: _kBlob);
    final verifierB64 = await _storage.read(key: _kPinHash);
    if (saltB64 == null || blob == null || verifierB64 == null) return null;
    final key = await _deriveKey(pin, base64.decode(saltB64));
    final hash = await Sha256().hash(key);
    if (base64.encode(hash.bytes) != verifierB64) return null;
    return await _decrypt(blob, key);
  }

  static Future<String?> unlockWithBiometric() async {
    final keyB64 = await _storage.read(key: _kBioKey);
    final blob = await _storage.read(key: _kBioBlob);
    if (keyB64 == null || blob == null) return null;
    return await _decrypt(blob, base64.decode(keyB64));
  }

  static Future<void> wipe() async {
    await _storage.deleteAll();
  }

  static Future<String> _encrypt(String plain, List<int> key) async {
    final nonce = _randomBytes(12);
    final secretBox = await _aes.encrypt(
      utf8.encode(plain),
      secretKey: SecretKey(key),
      nonce: nonce,
    );
    final out = <int>[]
      ..addAll(nonce)
      ..addAll(secretBox.cipherText)
      ..addAll(secretBox.mac.bytes);
    return base64.encode(out);
  }

  static Future<String> _decrypt(String b64, List<int> key) async {
    final bytes = base64.decode(b64);
    final nonce = bytes.sublist(0, 12);
    final mac = bytes.sublist(bytes.length - 16);
    final cipher = bytes.sublist(12, bytes.length - 16);
    final clear = await _aes.decrypt(
      SecretBox(cipher, nonce: nonce, mac: Mac(mac)),
      secretKey: SecretKey(key),
    );
    return utf8.decode(clear);
  }

  static Uint8List _randomBytes(int n) {
    final r = Random.secure();
    return Uint8List.fromList(List.generate(n, (_) => r.nextInt(256)));
  }
}
