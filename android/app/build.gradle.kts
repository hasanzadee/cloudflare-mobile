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

// One ABI per APK without Flutter's --split-per-abi.
//
// --split-per-abi makes the Flutter plugin add 1000/2000/4000 to each split
// APK's versionCode but nothing to the universal one. 2.0.0 shipped arm64 as
// 2004 and the universal APK as 4, so anyone who had installed a split APK —
// which the README recommends — got "App not installed" from the universal
// one: Android read it as a downgrade.
//
// The release workflow instead builds each ABI on its own with
// `--target-platform` and `-P onlyAbi=<abi>`, so every APK of a release
// carries the plain build number from pubspec.yaml. That number must stay
// above 4004, the highest code a split APK ever had.
//
// The other ABIs' native libraries are excluded at packaging time. Without
// that an arm64 APK also carried plugin stubs for armeabi-v7a and x86_64, and
// a 32-bit phone would pick armeabi-v7a and crash for want of libflutter.so.
// Packaging excludes rather than abiFilters: the Flutter plugin rewrites
// abiFilters itself — on the build types in 3.38, on defaultConfig in 3.44 —
// and the sets are unioned, so 2.0.1 shipped with all three ABIs anyway.
val onlyAbi = project.findProperty("onlyAbi")?.toString()
if (onlyAbi != null) {
    val others = listOf("armeabi-v7a", "arm64-v8a", "x86_64", "x86") - onlyAbi
    android.packaging.jniLibs.excludes += others.map { "lib/$it/**" }
}
