import 'dart:typed_data';

import 'package:cloudflare_mobile/auth/domain/cf_credential.dart';
import 'package:cloudflare_mobile/core/security/keystore_channel.dart';
import 'package:cloudflare_mobile/core/security/secure_store.dart';
import 'package:cloudflare_mobile/core/security/vault.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stands in for the Android Keystore. It deliberately does NOT model the
/// hardware guarantee — that is exactly what cannot be tested off-device — but
/// it does model the states the Dart side must handle.
class FakeKeystore extends KeystoreChannel {
  FakeKeystore({this.available = true});

  final bool available;
  bool created = false;
  bool invalidated = false;
  bool userCancels = false;
  Uint8List? _stored;

  @override
  Future<KeystoreStatus> status() async {
    if (!available) return KeystoreStatus.unavailable;
    if (invalidated) return KeystoreStatus.invalidated;
    return created ? KeystoreStatus.ready : KeystoreStatus.absent;
  }

  @override
  Future<bool> createKey() async {
    if (!available) return false;
    created = true;
    return true;
  }

  @override
  Future<Uint8List?> wrap(Uint8List data, {required String promptTitle}) async {
    if (userCancels) return null;
    _stored = Uint8List.fromList(data);
    // A real implementation returns ciphertext; the test only needs a token
    // that round-trips.
    return Uint8List.fromList([0xAA, ...data]);
  }

  @override
  Future<Uint8List?> unwrap(
    Uint8List blob, {
    required String promptTitle,
  }) async {
    if (userCancels || invalidated) return null;
    return _stored;
  }

  @override
  Future<void> deleteKey() async {
    created = false;
    _stored = null;
  }
}

Profile _profile(String id, String label) => Profile(
  id: id,
  label: label,
  credential: ApiTokenCredential(id: id, label: label, token: 'tok-$id'),
);

void main() {
  // PBKDF2 runs 210k iterations in an isolate, so these are seconds, not ms.
  group('Vault', () {
    late MemorySecureStore store;
    late FakeKeystore keystore;
    late Vault vault;

    setUp(() {
      store = MemorySecureStore();
      keystore = FakeKeystore();
      vault = Vault(store: store, keystore: keystore);
    });

    test('is uninitialized before create', () async {
      expect(await vault.isInitialized, isFalse);
    });

    test(
      'round-trips a profile through create and unlock',
      () async {
        final session = await vault.create(pin: '1234');
        await session.saveProfile(_profile('a', 'Work'));

        final reopened = await vault.unlockWithPin('1234');
        expect(reopened, isNotNull);

        final profiles = await reopened!.listProfiles();
        expect(profiles, hasLength(1));
        expect(profiles.single.label, 'Work');
        expect(
          (profiles.single.credential as ApiTokenCredential).token,
          'tok-a',
        );
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test('rejects a wrong PIN', () async {
      await vault.create(pin: '1234');
      expect(await vault.unlockWithPin('9999'), isNull);
    }, timeout: const Timeout(Duration(minutes: 2)));

    test(
      'nothing readable is stored in the clear',
      () async {
        final session = await vault.create(pin: '1234');
        await session.saveProfile(_profile('a', 'Work'));

        final dump = <String>[];
        for (final key in await store.keys()) {
          dump.add(await store.read(key) ?? '');
        }
        final blob = dump.join('|');
        expect(blob, isNot(contains('tok-a')));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'changing the PIN preserves profiles',
      () async {
        // This is the payoff of wrapping the vault key rather than encrypting
        // each secret with the PIN-derived key: no re-encryption, no data loss.
        final session = await vault.create(pin: '1111');
        await session.saveProfile(_profile('a', 'Work'));
        await session.saveProfile(_profile('b', 'Personal'));

        expect(await vault.changePin(current: '1111', next: '2222'), isTrue);
        expect(await vault.unlockWithPin('1111'), isNull);

        final reopened = await vault.unlockWithPin('2222');
        expect(reopened, isNotNull);
        expect(await reopened!.listProfiles(), hasLength(2));
      },
      timeout: const Timeout(Duration(minutes: 3)),
    );

    test(
      'changePin fails on a wrong current PIN',
      () async {
        await vault.create(pin: '1111');
        expect(await vault.changePin(current: 'nope', next: '2222'), isFalse);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'biometric unlock works after enrolment',
      () async {
        final session = await vault.create(pin: '1234');
        await session.saveProfile(_profile('a', 'Work'));

        expect(await vault.enableBiometric(session), isTrue);
        expect(await vault.biometricEnabled, isTrue);

        final reopened = await vault.unlockWithBiometric();
        expect(reopened, isNotNull);
        expect(await reopened!.listProfiles(), hasLength(1));
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'a cancelled prompt yields no session',
      () async {
        final session = await vault.create(pin: '1234');
        await vault.enableBiometric(session);
        keystore.userCancels = true;

        expect(await vault.unlockWithBiometric(), isNull);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'a new fingerprint invalidates the key and forces PIN fallback',
      () async {
        final session = await vault.create(pin: '1234');
        await session.saveProfile(_profile('a', 'Work'));
        await vault.enableBiometric(session);

        // Enrolling a finger destroys the Keystore key; an attacker who adds
        // their own must not gain access.
        keystore.invalidated = true;

        expect(await vault.unlockWithBiometric(), isNull);
        expect(
          await vault.biometricEnabled,
          isFalse,
          reason: 'the stale wrap must be dropped',
        );
        expect(await vault.unlockWithPin('1234'), isNotNull);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'enableBiometric fails gracefully without hardware',
      () async {
        final noHardware = Vault(
          store: MemorySecureStore(),
          keystore: FakeKeystore(available: false),
        );
        final session = await noHardware.create(pin: '1234');
        expect(await noHardware.enableBiometric(session), isFalse);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'deleting a profile removes it from the index',
      () async {
        final session = await vault.create(pin: '1234');
        await session.saveProfile(_profile('a', 'Work'));
        await session.saveProfile(_profile('b', 'Personal'));
        await session.deleteProfile('a');

        expect(await session.listProfiles(), hasLength(1));
        expect((await vault.listStubs()).single.id, 'b');
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test(
      'stubs are readable without unlocking, credentials are not',
      () async {
        final session = await vault.create(pin: '1234');
        await session.saveProfile(_profile('a', 'Work'));

        final stubs = await vault.listStubs();
        expect(stubs.single.label, 'Work');
        expect(stubs.single.method, CfAuthMethod.apiToken);
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );

    test('wipe clears everything', () async {
      final session = await vault.create(pin: '1234');
      await session.saveProfile(_profile('a', 'Work'));
      await vault.wipe();

      expect(await vault.isInitialized, isFalse);
      expect(await store.keys(), isEmpty);
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
