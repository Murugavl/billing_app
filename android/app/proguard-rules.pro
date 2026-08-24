# Flutter Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.**  { *; }
-keep class io.flutter.provider.**  { *; }
-keep class io.flutter.plugin.editing.**  { *; }
-keep class io.flutter.plugin.common.**  { *; }
-keep class io.flutter.plugin.text.**  { *; }
-keep class io.flutter.plugin.platform.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Drift & SQLite3 FFI Keep Rules
-keep class com.simonbinder.sqlite3.** { *; }
-keep class org.sqlite.** { *; }
-dontwarn com.simonbinder.sqlite3.**

# Keep dynamic native libraries / FFI entry points
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

# Path Provider Keep Rules
-keep class io.flutter.plugins.pathprovider.** { *; }

# Google Sign-In & Google APIs Keep Rules
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.**

# WorkManager Keep Rules
-keep class androidx.work.** { *; }

# Google Play Core Dontwarn Rules
-dontwarn com.google.android.play.core.**

