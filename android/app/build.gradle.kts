import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// خواندن اطلاعات keystore از key.properties (فایل محلی — داخل git نیست)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.reader(Charsets.UTF_8).use { reader ->
        keystoreProperties.load(reader)
    }
    // PowerShell گاهی UTF-8 BOM می‌گذارد و storePassword null می‌شود
    val bomKey = keystoreProperties.keys.firstOrNull { (it as String).startsWith("\uFEFF") } as String?
    if (bomKey != null) {
        keystoreProperties.setProperty(
            bomKey.removePrefix("\uFEFF"),
            keystoreProperties.getProperty(bomKey),
        )
        keystoreProperties.remove(bomKey)
    }
}

fun Properties.keystoreProp(name: String): String =
    getProperty(name)?.trim()
        ?: error("android/key.properties: '$name' پیدا نشد یا خالی است")

android {
    namespace = "ir.hamed.spygame"
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
            // پیکربندی billing مایکت — طبق مستند myket_iap
            manifestPlaceholders["marketApplicationId"] = "ir.mservices.market"
            manifestPlaceholders["marketBindAddress"] =
                "ir.mservices.market.InAppBillingService.BIND"
            manifestPlaceholders["marketPermission"] = "ir.mservices.market.BILLING"
        }
        create("google") {
            dimension = "store"
            resValue("string", "app_name", "Spy Game")
        }
    }

    defaultConfig {
        applicationId = "ir.hamed.spygame"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties.keystoreProp("keyAlias")
                keyPassword = keystoreProperties.keystoreProp("keyPassword")
                storeFile = file(keystoreProperties.keystoreProp("storeFile"))
                storePassword = keystoreProperties.keystoreProp("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
