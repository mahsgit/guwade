# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Flutter WebView
-keep class io.flutter.plugins.webviewflutter.** { *; }

# Play Core
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Multidex
-keep class androidx.multidex.** { *; }

# Keep your application classes that use Flutter plugins
-keep class com.guawade.app.** { *; }

# Keep TTS
-keep class com.google.android.tts.** { *; }

# Keep HTTP
-keep class org.apache.http.** { *; }
-dontwarn org.apache.http.**
-dontwarn android.net.http.**

# Keep Camera
-keep class androidx.camera.** { *; }

# Keep SharedPreferences
-keep class android.app.** { *; }

# Keep JavaScript Interface
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep all native methods, their classes and any classes in the packages
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable classes (serialization)
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep custom exceptions
-keep public class * extends java.lang.Exception

# Keep Window Manager
-keep class androidx.window.** { *; }

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
} 