import 'package:flutter/services.dart';

/// Controls Android's FLAG_SECURE.
///
/// Worth having even though the user can turn it off: the recent-apps
/// thumbnail is captured by the system without any user action, and this app
/// routinely has an API token, a KV value or a Workers secret on screen.
class SecureFlag {
  const SecureFlag();

  static const MethodChannel _channel = MethodChannel(
    'io.cfmgr.app/secure_flag',
  );

  Future<void> set({required bool enabled}) async {
    try {
      await _channel.invokeMethod<bool>('setSecure', {'enabled': enabled});
    } on PlatformException {
      // Non-Android hosts and unit tests have no channel; not fatal.
    } on MissingPluginException {
      // Same.
    }
  }
}
