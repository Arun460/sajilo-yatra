buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.9.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.0.20")
        // classpath("com.google.gms:google-services:4.4.0")  // ✅ COMMENTED OUT
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}