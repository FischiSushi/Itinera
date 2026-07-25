import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Signature de release : voir android/key.properties (jamais commité, voir
// android/.gitignore) et FIREBASE_SETUP.md pour le contexte. Absent en CI/sur
// une nouvelle machine -> repli sur la signature debug, comme avant.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreDisponible = keystorePropertiesFile.exists()
if (keystoreDisponible) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.itinera.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Requis par flutter_local_notifications (son module Android cible
        // minSdk 24 et active le desugaring des API Java 8+).
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.itinera.app"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystoreDisponible) {
            create("release") {
                storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystoreDisponible) {
                signingConfigs.getByName("release")
            } else {
                // Pas de android/key.properties sur cette machine (CI, autre
                // dev...) : repli sur la signature debug pour que le build
                // continue de fonctionner, `flutter run --release` inclus.
                signingConfigs.getByName("debug")
            }
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
