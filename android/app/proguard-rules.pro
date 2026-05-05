# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# image_picker
-keep class androidx.core.content.FileProvider { *; }

# Keep app entry points
-keep class com.kukkia.app.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keepclassmembers class **$WhenMappings { *; }
