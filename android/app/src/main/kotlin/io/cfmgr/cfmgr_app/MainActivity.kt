package io.cfmgr.cfmgr_app

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * FlutterFragmentActivity rather than FlutterActivity: androidx BiometricPrompt
 * requires a FragmentActivity host.
 */
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            BiometricCryptoPlugin.CHANNEL,
        ).setMethodCallHandler(BiometricCryptoPlugin(this))

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SecureFlagPlugin.CHANNEL,
        ).setMethodCallHandler(SecureFlagPlugin(this))
    }
}
