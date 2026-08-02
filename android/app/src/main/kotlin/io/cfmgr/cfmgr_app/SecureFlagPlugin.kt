package io.cfmgr.cfmgr_app

import android.app.Activity
import android.view.WindowManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Toggles FLAG_SECURE.
 *
 * With it set, the OS excludes the window from screenshots, screen recording
 * and the recent-apps thumbnail. That matters here because API tokens, Workers
 * secrets and KV values all pass through the UI, and the recents thumbnail is
 * captured without any user action at all.
 */
class SecureFlagPlugin(private val activity: Activity) :
    MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "io.cfmgr.app/secure_flag"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setSecure" -> {
                val enabled = call.argument<Boolean>("enabled") ?: true
                activity.runOnUiThread {
                    if (enabled) {
                        activity.window.setFlags(
                            WindowManager.LayoutParams.FLAG_SECURE,
                            WindowManager.LayoutParams.FLAG_SECURE,
                        )
                    } else {
                        activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    }
                }
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }
}
