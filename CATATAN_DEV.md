# 📋 Catatan Developer — Kukkia
> Baca ini kalau lupa cara kerja project atau mau build ulang

---

## 🚀 Cara Jalankan App (Sehari-hari)

### Preview di Browser (paling cepat)
```powershell
flutter run -d chrome
```
Buka otomatis di Chrome. Ini yang paling sering dipakai saat development.

### Hot Reload (saat app sedang jalan)
- Tekan `r` di terminal → reload perubahan UI
- Tekan `R` (kapital) → restart penuh
- Tekan `q` → stop app

---

## 📱 Build APK Android

### WAJIB dilakukan setiap buka PowerShell baru:
```powershell
$env:JAVA_HOME = "C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot"
$env:PATH = "$env:JAVA_HOME\bin;" + $env:PATH
```
> ⚠️ Kalau lupa ini, build pasti gagal dengan error "JAVA_HOME is not set"

### Build APK:
```powershell
flutter build apk --release --split-per-abi
```

### Hasil APK ada di:
```
build\app\outputs\flutter-apk\
├── app-arm64-v8a-release.apk    ← PAKAI INI untuk HP modern
├── app-armeabi-v7a-release.apk  ← HP lama
└── app-x86_64-release.apk       ← Emulator
```

### Buka folder APK:
```powershell
explorer "build\app\outputs\flutter-apk"
```

### Estimasi waktu build:
- Pertama kali: 10-40 menit (tergantung laptop)
- Build berikutnya: 2-5 menit (sudah ada cache)

---

## 🧹 Kalau Ada Error / Aneh-aneh

```powershell
flutter clean          # hapus semua hasil build
flutter pub get        # install ulang semua package
flutter run -d chrome  # jalankan ulang
```

---

## 💾 Kenapa Memory Turun Saat Build?

Proses build Android makan RAM besar sementara:
- `java` (Gradle) → ~2GB
- `dart`, `gen_snapshot` → ~500MB

**Normal!** Setelah build selesai, semua proses mati sendiri dan RAM kembali.

Kalau build sudah selesai tapi RAM belum bebas:
```powershell
Stop-Process -Name "java" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "gen_snapshot" -Force -ErrorAction SilentlyContinue
```

---

## 📁 Struktur Folder Penting

```
kukkia/
├── lib/                    ← SEMUA kode Flutter ada di sini
│   ├── main.dart           ← Entry point app
│   ├── models/             ← Data model (AnimeModel, dll)
│   ├── providers/          ← State management (theme, preferences)
│   ├── splash/             ← Halaman splash screen
│   ├── shell/              ← Navigasi utama (4 tab)
│   ├── dashboard/          ← Halaman beranda
│   ├── ngobrol/            ← Pilih model anime
│   ├── chat/               ← Layar chat + mode berhadapan
│   ├── alarm/              ← Set alarm
│   ├── pengaturan/         ← Settings + dark mode
│   ├── pilih_model/        ← Grid pilih karakter
│   ├── set_latar/          ← Pilih background app
│   └── assets/img/         ← Gambar & logo
│
├── android/                ← JANGAN HAPUS - config Android
├── ios/                    ← JANGAN HAPUS - config iOS
├── web/                    ← JANGAN HAPUS - config Web
├── build/                  ← Boleh dihapus, hasil compile sementara
├── pubspec.yaml            ← Daftar package/dependency
├── SETUP.md                ← Panduan setup lengkap
└── CATATAN_DEV.md          ← File ini
```

---

## 📦 Package yang Dipakai

| Package | Kegunaan |
|---------|---------|
| `image_picker` | Pilih foto dari galeri (background chat) |
| `shared_preferences` | Simpan preferensi user (mode, background) |
| `cupertino_icons` | Icon iOS style |

Tambah package baru:
```powershell
flutter pub add nama_package
```

---

## 🎨 Warna Utama App

| Nama | Kode | Dipakai untuk |
|------|------|--------------|
| Orange Kukki | `#FF6B35` | Navbar, tombol utama, accent |
| Biru | `#4CC9F0` | Karakter Yuki |
| Ungu | `#9B5DE5` | Karakter Hana |
| Pink | `#FF6B9D` | Karakter Sakura |

---

## 🔧 Fitur yang Masih Dummy (Tunggu Backend)

- [ ] Respons AI karakter (sekarang pakai teks hardcoded)
- [ ] Suara karakter saat alarm
- [ ] Gambar karakter (sekarang semua pakai LOGO 2.png)
- [ ] Login / akun user
- [ ] Notifikasi dari karakter

Saat backend sudah siap, cari komentar `// nanti diganti URL dari API`
di file `lib/models/anime_model.dart` untuk ganti gambar karakter.

---

## 📱 Cara Install APK ke HP

1. Copy `app-arm64-v8a-release.apk` ke HP (via USB / WhatsApp / Drive)
2. Buka file manager di HP → cari file APK
3. Tap APK → muncul popup "Install dari sumber tidak dikenal"
4. Pergi ke Settings HP → izinkan install dari sumber tidak dikenal
5. Kembali → Install → selesai

---

## ⚡ Tips Cepat

| Situasi | Solusi |
|---------|--------|
| App tidak update setelah edit kode | Tekan `r` di terminal |
| Hot reload tidak mempan | Tekan `R` (hot restart) |
| Error aneh tidak jelas | `flutter clean` lalu `flutter run` |
| Build APK gagal | Set JAVA_HOME dulu, lalu build ulang |
| Memory penuh saat build | Tunggu build selesai, RAM akan bebas sendiri |
| Mau lihat error lebih detail | Tambah `--verbose` di perintah flutter |
