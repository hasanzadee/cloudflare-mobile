# R8 is enabled for release builds. Most Flutter plugins ship consumer rules,
# so this file only covers what is reached reflectively from our own code.

# BiometricPrompt resolves fragments and callbacks by name.
-keep class androidx.biometric.** { *; }

# The two MethodChannel handlers are instantiated from MainActivity, but the
# channel names are strings and R8 cannot see the Dart side.
-keep class io.cfmgr.cfmgr_app.BiometricCryptoPlugin { *; }
-keep class io.cfmgr.cfmgr_app.SecureFlagPlugin { *; }

# flutter_secure_storage touches the Keystore through reflection on some OEMs.
-keep class androidx.security.crypto.** { *; }

# Keep exception names so a crash report is readable after obfuscation.
-keepattributes SourceFile,LineNumberTable,Signature,Exceptions
