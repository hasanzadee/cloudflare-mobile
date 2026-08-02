import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Narrow storage interface so the vault can be unit-tested without a device.
abstract interface class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<Set<String>> keys();
  Future<void> deleteAll();
}

/// Android Keystore-backed EncryptedSharedPreferences.
class FlutterSecureStore implements SecureStore {
  const FlutterSecureStore([this._storage = _default]);

  static const FlutterSecureStorage _default = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<Set<String>> keys() async => (await _storage.readAll()).keys.toSet();

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}

/// In-memory double used by tests.
class MemorySecureStore implements SecureStore {
  final Map<String, String> _data = {};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<Set<String>> keys() async => _data.keys.toSet();

  @override
  Future<void> deleteAll() async => _data.clear();
}
