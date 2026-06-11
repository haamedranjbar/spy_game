plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.spy_game"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildFeatures {
        buildConfig = true
    }

    flavorDimensions += "store"

    productFlavors {
        create("bazaar") {
            dimension = "store"
            applicationIdSuffix = ".bazaar"
            resValue("string", "app_name", "بازی جاسوس")
        }
        create("myket") {
            dimension = "store"
            applicationIdSuffix = ".myket"
            resValue("string", "app_name", "بازی جاسوس")
        }
        create("google") {
            dimension = "store"
            resValue("string", "app_name", "Spy Game")
        }
    }

    defaultConfig {
        applicationId = "com.example.spy_game"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
