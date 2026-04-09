plugins {
    id("com.android.library") version "8.11.1"
}

group = "com.fluttercandies.flutter_ali_auth"
version = "1.0"

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

android {
    namespace = "com.fluttercandies.flutter_ali_auth"

    compileSdk = 36

    androidResources {
        noCompress += "mov"  // 表示不让aapt压缩的文件后缀
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        minSdk = 24
    }

    testOptions {
        unitTests.all {
            it.outputs.upToDateWhen { false }

            it.testLogging {
                events("passed", "skipped", "failed", "standardOut", "standardError")
                showStandardStreams = true
            }
        }
    }
}

dependencies {
    testImplementation("junit:junit:4.13.2")
    testImplementation("org.mockito:mockito-core:5.0.0")

    // https://mvnrepository.com/artifact/com.google.code.gson/gson
    implementation("com.google.code.gson:gson:2.9.0")

    // ConstraintLayout
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // 阿里云一键登录本地 aar 依赖 (compileOnly: 编译时需要，运行时由应用提供)
    compileOnly(files("libs/auth_number_product-2.14.19-log-online-standard-cuum-release.aar"))
    compileOnly(files("libs/crashshield-2.1.4-release.aar"))
    compileOnly(files("libs/main-2.2.3-release.aar"))
    compileOnly(files("libs/logger-2.2.2-release.aar"))
}
