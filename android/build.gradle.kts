allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://maven.myket.ir") }
        maven { url = uri("https://jitpack.io") }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // رفع خطای isar_flutter_libs: android:attr/lStar not found
    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.application") ||
            project.plugins.hasPlugin("com.android.library")
        ) {
            val androidExt = project.extensions.findByName("android")
            if (androidExt != null) {
                (androidExt as com.android.build.gradle.BaseExtension).apply {
                    compileSdkVersion(36)
                }
            }
        }
    }
    
    // Override buildscript برای همه پلاگین‌های Flutter قبل از evaluation
    if (project.name != "app") {
        project.buildscript {
            repositories {
                google()
                mavenCentral()
                maven { url = uri("https://maven.myket.ir") }
            }
            dependencies {
                // Force استفاده از نسخه سازگار با Gradle 8
                classpath("com.android.tools.build:gradle:8.11.1")
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
