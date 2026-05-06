# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Fix: Missing Play Core classes
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-dontwarn io.flutter.embedding.android.FlutterPlayStoreSplitApplication
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# permission_handler
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# image_picker
-keep class androidx.core.content.FileProvider { *; }

# shared_preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep app
-keep class com.kukkia.app.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keepclassmembers class **$WhenMappings { *; }

-ignorewarnings
