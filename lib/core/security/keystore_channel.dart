import 'package:flutter/services.dart';

/// Result of asking the platform about the biometric-bound key.
enum KeystoreStatus {
  /// A hardware-backed key exists and biometrics are enrolled.
  ready,

  /// The device has no biometric hardware, or nothing is enrolled.
  unavailable,

  /// A key existed but was invalidated — typically a new fingerprint was
  /// enrolled, which is exactly the event we want to force a PIN fallback for.
  invalidated,

  /// No key has been created yet.
  absent,
}

/// Dart side of the Android Keystore bridge.
///
/// `local_auth` cannot express what is needed here: it returns a boolean, so a
/// caller can only *ask* whether a fingerprint matched and then decrypt anyway.
/// The prototype did exactly that — it stored a random key next to the
/// ciphertext in the same secure storage, so anything with app-data access
/// could read the token without ever touching the sensor.
///
/// This channel instead wraps the vault key with an AES key generated with
/// `setUserAuthenticationRequired(true)`. The unwrap `Cipher` is only usable
/// after a successful `BiometricPrompt`, and that is enforced by the TEE rather
/// than by our UI.
class KeystoreChannel {
  const KeystoreChannel();

  static const MethodChannel _channel = MethodChannel(
    'io.cfmgr.app/biometric_crypto',
  );

  Future<KeystoreStatus> status() async {
    final raw = await _channel.invokeMethod<String>('status');
    return switch (raw) {
      'ready' => KeystoreStatus.ready,
      'invalidated' => KeystoreStatus.invalidated,
      'absent' => KeystoreStatus.absent,
      _ => KeystoreStatus.unavailable,
    };
  }

  /// Creates (or replaces) the hardware key.
  Future<bool> createKey() async =>
      await _channel.invokeMethod<bool>('createKey') ?? false;

  /// Encrypts [data] with the hardware key, prompting for biometrics.
  ///
  /// Returns null when the user cancels.
  Future<Uint8List?> wrap(Uint8List data, {required String promptTitle}) async {
    final result = await _channel.invokeMethod<Uint8List>('wrap', {
      'data': data,
      'title': promptTitle,
    });
    return result;
  }

  /// Decrypts data previously produced by [wrap], prompting for biometrics.
  Future<Uint8List?> unwrap(
    Uint8List blob, {
    required String promptTitle,
  }) async {
    return _channel.invokeMethod<Uint8List>('unwrap', {
      'data': blob,
      'title': promptTitle,
    });
  }

  Future<void> deleteKey() => _channel.invokeMethod<void>('deleteKey');
}
