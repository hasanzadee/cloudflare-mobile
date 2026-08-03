import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing comes from android/key.properties, which is gitignored.
// Without it the release build falls back to debug signing so contributors can
// still run `flutter build apk --release` locally.
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}
val hasReleaseSigning = keystoreProperties.getProperty("storeFile") != null

android {
    namespace = "io.cfmgr.cfmgr_app"

    // Pinned rather than inherited from `flutter.*`: the toolchain moving under
    // us should be a deliberate commit, not a side effect of a Flutter upgrade.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "io.cfmgr.app"
        // 26 is the floor for the Keystore GCM + setUserAuthenticationRequired
        // semantics the biometric vault depends on.
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                // rootProject, not the app module: a relative storeFile in
                // key.properties should mean "next to key.properties", not
                // "inside android/app". Absolute paths pass through unchanged,
                // which is what the release workflow writes.
                //
                // Use forward slashes in key.properties even on Windows — it is
                // a java.util.Properties file, so `\r` and `\U` in a path like
                // C:\rm\Users are read as escape sequences and eaten.
                storeFile = rootProject.file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

dependencies {
    // BiometricPrompt + CryptoObject for the hardware-bound vault key.
    implementation("androidx.biometric:biometric:1.1.0")
}

flutter {
    source = "../.."
}
