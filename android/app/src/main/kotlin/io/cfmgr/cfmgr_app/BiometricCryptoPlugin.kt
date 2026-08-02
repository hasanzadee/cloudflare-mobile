package io.cfmgr.cfmgr_app

import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyPermanentlyInvalidatedException
import android.security.keystore.KeyProperties
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Hardware-bound biometric wrapping of the vault key.
 *
 * The point of this plugin is that decryption is gated by the TEE, not by our
 * UI. `local_auth` can only tell Dart "a fingerprint matched", after which the
 * app is free to decrypt anyway — which is precisely the weakness this replaces:
 * the previous implementation stored a random key beside the ciphertext in the
 * same preferences file, so the sensor protected nothing.
 *
 * Here the AES key lives in the Android Keystore with
 * `setUserAuthenticationRequired(true)`, so the [Cipher] handed to
 * [BiometricPrompt.CryptoObject] only becomes usable after the prompt succeeds.
 * `setInvalidatedByBiometricEnrollment(true)` means enrolling a new fingerprint
 * permanently destroys the key — an attacker who adds their own finger gets
 * nothing, and the app falls back to the PIN.
 */
class BiometricCryptoPlugin(private val activity: FragmentActivity) :
    MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "io.cfmgr.app/biometric_crypto"
        private const val KEY_ALIAS = "cfmgr_vault_key_v2"
        private const val KEYSTORE = "AndroidKeyStore"
        private const val TRANSFORMATION =
            "${KeyProperties.KEY_ALGORITHM_AES}/${KeyProperties.BLOCK_MODE_GCM}/" +
                KeyProperties.ENCRYPTION_PADDING_NONE
        private const val IV_LENGTH = 12
        private const val TAG_BITS = 128
        private const val AUTHENTICATORS = BiometricManager.Authenticators.BIOMETRIC_STRONG
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "status" -> result.success(status())
            "createKey" -> result.success(createKey())
            "deleteKey" -> {
                deleteKey()
                result.success(null)
            }
            "wrap" -> crypt(call, result, encrypt = true)
            "unwrap" -> crypt(call, result, encrypt = false)
            else -> result.notImplemented()
        }
    }

    private fun status(): String {
        val canAuthenticate = BiometricManager.from(activity).canAuthenticate(AUTHENTICATORS)
        if (canAuthenticate != BiometricManager.BIOMETRIC_SUCCESS) return "unavailable"

        val key = loadKey() ?: return "absent"
        return try {
            // Initialising the cipher is the only reliable way to learn that a
            // new biometric enrollment invalidated the key.
            Cipher.getInstance(TRANSFORMATION).init(Cipher.ENCRYPT_MODE, key)
            "ready"
        } catch (e: KeyPermanentlyInvalidatedException) {
            "invalidated"
        } catch (e: Exception) {
            "unavailable"
        }
    }

    private fun loadKey(): SecretKey? = try {
        val store = KeyStore.getInstance(KEYSTORE).apply { load(null) }
        store.getKey(KEY_ALIAS, null) as? SecretKey
    } catch (e: Exception) {
        null
    }

    private fun createKey(): Boolean = try {
        deleteKey()
        val generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, KEYSTORE)
        val builder = KeyGenParameterSpec.Builder(
            KEY_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .setUserAuthenticationRequired(true)
            .setInvalidatedByBiometricEnrollment(true)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // Timeout 0 means "authenticate for every single use", which is
            // what binds the Cipher to one successful prompt.
            builder.setUserAuthenticationParameters(
                0,
                KeyProperties.AUTH_BIOMETRIC_STRONG,
            )
        } else {
            @Suppress("DEPRECATION")
            builder.setUserAuthenticationValidityDurationSeconds(-1)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P &&
            activity.packageManager.hasSystemFeature(
                android.content.pm.PackageManager.FEATURE_STRONGBOX_KEYSTORE,
            )
        ) {
            builder.setIsStrongBoxBacked(true)
        }

        generator.init(builder.build())
        generator.generateKey()
        true
    } catch (e: Exception) {
        // StrongBox can refuse generation on some devices; retry without it.
        retryWithoutStrongBox()
    }

    private fun retryWithoutStrongBox(): Boolean = try {
        val generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, KEYSTORE)
        val builder = KeyGenParameterSpec.Builder(
            KEY_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .setUserAuthenticationRequired(true)
            .setInvalidatedByBiometricEnrollment(true)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            builder.setUserAuthenticationParameters(0, KeyProperties.AUTH_BIOMETRIC_STRONG)
        } else {
            @Suppress("DEPRECATION")
            builder.setUserAuthenticationValidityDurationSeconds(-1)
        }
        generator.init(builder.build())
        generator.generateKey()
        true
    } catch (e: Exception) {
        false
    }

    private fun deleteKey() {
        try {
            KeyStore.getInstance(KEYSTORE).apply { load(null) }.deleteEntry(KEY_ALIAS)
        } catch (e: Exception) {
            // Nothing to delete.
        }
    }

    private fun crypt(call: MethodCall, result: MethodChannel.Result, encrypt: Boolean) {
        val data = call.argument<ByteArray>("data")
        val title = call.argument<String>("title") ?: "Authenticate"
        if (data == null) {
            result.error("bad_args", "data is required", null)
            return
        }

        val key = loadKey()
        if (key == null) {
            result.error("no_key", "Biometric key is not set up", null)
            return
        }

        val cipher: Cipher
        try {
            cipher = Cipher.getInstance(TRANSFORMATION)
            if (encrypt) {
                cipher.init(Cipher.ENCRYPT_MODE, key)
            } else {
                if (data.size <= IV_LENGTH) {
                    result.error("bad_blob", "Ciphertext is too short", null)
                    return
                }
                cipher.init(
                    Cipher.DECRYPT_MODE,
                    key,
                    GCMParameterSpec(TAG_BITS, data, 0, IV_LENGTH),
                )
            }
        } catch (e: KeyPermanentlyInvalidatedException) {
            deleteKey()
            result.error("invalidated", "Biometric enrollment changed", null)
            return
        } catch (e: Exception) {
            result.error("cipher_init", e.message, null)
            return
        }

        val prompt = BiometricPrompt(
            activity,
            ContextCompat.getMainExecutor(activity),
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationSucceeded(
                    authResult: BiometricPrompt.AuthenticationResult,
                ) {
                    val bound = authResult.cryptoObject?.cipher
                    if (bound == null) {
                        result.error("no_cipher", "Prompt returned no cipher", null)
                        return
                    }
                    try {
                        val output = if (encrypt) {
                            // Store the IV with the ciphertext; GCM needs it back.
                            bound.iv + bound.doFinal(data)
                        } else {
                            bound.doFinal(data, IV_LENGTH, data.size - IV_LENGTH)
                        }
                        result.success(output)
                    } catch (e: Exception) {
                        result.error("crypto_failed", e.message, null)
                    }
                }

                override fun onAuthenticationError(code: Int, message: CharSequence) {
                    // Cancellation is a normal outcome, not an error: Dart maps
                    // null onto "fall back to the PIN".
                    if (code == BiometricPrompt.ERROR_NEGATIVE_BUTTON ||
                        code == BiometricPrompt.ERROR_USER_CANCELED ||
                        code == BiometricPrompt.ERROR_CANCELED
                    ) {
                        result.success(null)
                    } else {
                        result.error("auth_error", message.toString(), code)
                    }
                }
            },
        )

        prompt.authenticate(
            BiometricPrompt.PromptInfo.Builder()
                .setTitle(title)
                .setSubtitle("Cloudflare Mobile")
                .setNegativeButtonText("Use PIN")
                .setAllowedAuthenticators(AUTHENTICATORS)
                .setConfirmationRequired(false)
                .build(),
            BiometricPrompt.CryptoObject(cipher),
        )
    }
}
