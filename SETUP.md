# 🛠️ Setup & Compile Guide — Kukkia

Panduan lengkap untuk menjalankan dan build Kukkia di Android dan iOS.

---

## ✅ Prasyarat

### Semua Platform
```bash
# Cek semua requirement Flutter
flutter doctor -v
```
Pastikan semua centang hijau sebelum lanjut.

| Tool | Versi Minimum |
|------|--------------|
| Flutter | 3.x |
| Dart | 3.x |
| Android Studio | Hedgehog (2023.1) |
| Xcode | 15+ (Mac only) |
| Java/JDK | 17 |

---

## 🤖 Android

### 1. Install dependency
```bash
flutter pub get
```

### 2. Jalankan di emulator / device
```bash
# Debug mode
flutter run -d android

# Pilih device jika ada lebih dari satu
flutter devices
flutter run -d <device-id>
```

### 3. Build APK (untuk testing / sideload)
```bash
# Debug APK
flutter build apk --debug

# Release APK (ukuran lebih kecil)
flutter build apk --release --split-per-abi

# Android APK
flutter build apk --release --split-per-abi

# iOS (di Mac)
flutter build ipa --release

# Output: build/app/outputs/flutter-apk/
```

### 4. Build App Bundle (untuk Google Play Store)
```bash
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### 5. Setup Signing (wajib untuk Play Store)

Buat keystore baru:
```bash
keytool -genkey -v -keystore android/app/kukkia-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias kukkia
```

Buat file `android/key.properties` (jangan di-commit ke git!):
```properties
storePassword=<password_kamu>
keyPassword=<password_kamu>
keyAlias=kukkia
storeFile=kukkia-release.jks
```

Update `android/app/build.gradle.kts` — ganti bagian `signingConfigs`:
```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true
        isShrinkResources = true
    }
}
```

Tambahkan ke `.gitignore`:
```
android/key.properties
android/app/*.jks
```

---

## 🍎 iOS (Mac only)

### Prasyarat iOS
- Mac dengan macOS 13+
- Xcode 15+ (dari App Store)
- CocoaPods: `sudo gem install cocoapods`
- Apple Developer Account (untuk device fisik & App Store)

### 1. Install pods
```bash
cd ios
pod install
cd ..
```

### 2. Jalankan di simulator
```bash
# Lihat simulator yang tersedia
flutter devices

# Jalankan
flutter run -d ios
```

### 3. Jalankan di device fisik
1. Buka `ios/Runner.xcworkspace` di Xcode
2. Pilih team di **Signing & Capabilities**
3. Pilih device fisik
4. Klik Run atau:
```bash
flutter run -d <device-id>
```

### 4. Build IPA (untuk App Store / TestFlight)
```bash
flutter build ipa --release

# Output: build/ios/ipa/
```

### 5. Setup Bundle ID
Di Xcode → Runner → Signing & Capabilities:
- Bundle Identifier: `com.kukkia.app`
- Team: pilih Apple Developer account kamu

---

## 🌐 Web (sudah berjalan)
```bash
flutter run -d chrome
flutter build web --release
```

---

## 📋 Checklist Sebelum Release

### Android
- [ ] Ganti `applicationId` dari `com.kukkia.app` ke ID unik kamu
- [ ] Buat keystore dan setup signing config
- [ ] Ganti icon app (`android/app/src/main/res/mipmap-*/`)
- [ ] Update `versionCode` dan `versionName` di `pubspec.yaml`
- [ ] Test di minimal 2 device berbeda

### iOS
- [ ] Ganti Bundle ID di Xcode
- [ ] Setup Apple Developer Team
- [ ] Ganti icon app di `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- [ ] Test di simulator dan device fisik
- [ ] Pastikan semua permission description sudah benar di `Info.plist`

---

## ⚠️ Catatan Penting

### Permission yang sudah dikonfigurasi

| Permission | Android | iOS | Kegunaan |
|-----------|---------|-----|---------|
| INTERNET | ✅ | otomatis | API backend |
| READ_MEDIA_IMAGES | ✅ | ✅ | Pilih background dari galeri |
| POST_NOTIFICATIONS | ✅ | perlu setup | Notifikasi alarm |
| SCHEDULE_EXACT_ALARM | ✅ | - | Alarm tepat waktu |

### Fitur yang butuh setup tambahan sebelum production
- **Alarm suara** — butuh package `flutter_local_notifications` + `just_audio`
- **API backend** — update base URL di kode
- **AdMob** — daftarkan App ID di `AndroidManifest.xml` dan `Info.plist`

---

## 🐛 Troubleshooting

### `flutter doctor` error
```bash
# Android licenses
flutter doctor --android-licenses

# Xcode command line tools
xcode-select --install
sudo xcodebuild -license accept
```

### Gradle build gagal
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### CocoaPods error
```bash
cd ios
pod deintegrate
pod install --repo-update
cd ..
```

### `image_picker` tidak bisa buka galeri di Android
Pastikan permission `READ_MEDIA_IMAGES` (Android 13+) atau `READ_EXTERNAL_STORAGE` (Android 12-) sudah ada di `AndroidManifest.xml`. Sudah dikonfigurasi otomatis.
