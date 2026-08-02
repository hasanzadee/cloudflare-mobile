import 'dart:isolate';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Key derivation, moved off the UI isolate.
///
/// The prototype ran 200 000 rounds of pure-Dart PBKDF2 directly in the widget
/// tree, which freezes the frame for seconds on a mid-range phone — the unlock
/// screen appeared to hang. Running it in a short-lived isolate keeps the UI
/// responsive and lets us raise the iteration count.
const int kPbkdf2Iterations = 210000;

/// Derives a 256-bit key from a PIN.
Future<Uint8List> deriveKeyFromPin(String pin, Uint8List salt) =>
    Isolate.run(() => _derive(pin, salt));

Future<Uint8List> _derive(String pin, Uint8List salt) async {
  final pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: kPbkdf2Iterations,
    bits: 256,
  );
  final key = await pbkdf2.deriveKeyFromPassword(password: pin, nonce: salt);
  return Uint8List.fromList(await key.extractBytes());
}
