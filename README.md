# 🌸 Kukkia — Your AI Anime Companion

<p align="center">
  <img src="lib/assets/img/LOGO 2.png" alt="Kukkia Logo" width="120"/>
</p>

<p align="center">
  <strong>Temukan teman AI anime-mu. Ngobrol, tertawa, dan jalani hari bersama.</strong>
</p>

---

## ✨ Tentang Kukkia

**Kukkia** (くっきあ) adalah aplikasi AI companion berbasis karakter anime yang dirancang untuk menemani penggunanya setiap hari. Nama *Kukkia* terinspirasi dari kata Jepang yang berarti "ruang kosong yang menunggu untuk diisi" — sebuah metafora untuk hubungan yang tumbuh antara pengguna dan karakter AI mereka.

Kukkia bukan sekadar chatbot. Setiap karakter memiliki kepribadian unik, cara bicara khas, dan respons emosional yang berbeda. Mulai dari yang tsundere hingga yang penuh semangat, kamu bebas memilih siapa yang paling cocok menemanimu.

---

## 🎌 Fitur Utama

### 🏠 Beranda (Dashboard)
Tampilan utama yang menampilkan karakter aktifmu, sapaan sesuai waktu hari, dan akses cepat ke semua fitur. Karakter menyapamu dengan kalimat pembuka yang sesuai kepribadiannya.

### 💬 Ngobrol — 2 Mode Interaksi
- **Mode Chat** — Percakapan teks klasik dengan karakter AI pilihanmu. Karakter merespons dengan gaya bicara sesuai tipe kepribadiannya.
- **Mode Bersama Anime** — Tampilan immersive layar penuh dengan karakter besar dan speech bubble. Rasakan pengalaman ngobrol yang lebih personal dan visual.

### ⏰ Alarm dengan Suara Karakter
Set alarm kapanpun kamu mau. Pilih karakter yang akan membangunkanmu — setiap karakter punya cara unik untuk menyapa di pagi hari. *(Suara karakter akan aktif setelah integrasi backend selesai.)*

### 🎭 Pilih Model Anime
10 karakter anime dengan kepribadian berbeda:

| Karakter | Tipe | Status |
|----------|------|--------|
| **Kukki** | Deredere | ✅ Bebas |
| **Yuki** | Tsundere | ✅ Bebas |
| **Hana** | Kuudere | ✅ Bebas |
| **Sakura** | Dandere | 🔒 Iklan |
| **Rena** | Genki | 🔒 Iklan |
| **Kira** | Yandere | 🔒 Iklan |
| **Miku** | Himedere | 🔒 Iklan |
| **Nami** | Onee-san | 🔒 Iklan |
| **Rei** | Mysterious | 🔒 Iklan |
| **Sora** | Kunoichi | 🔒 Iklan |

Karakter terkunci dapat dibuka dengan menonton iklan singkat — gratis, tanpa pembelian.

### 🖼️ Background Chat Kustom
Ganti latar belakang percakapan langsung dari dalam layar chat. Tersedia 6 tema: Default, Sakura, Ocean, Forest, Sunset, dan Night — semua mendukung dark mode.

### 🌙 Dark Mode
Aktifkan dark mode dari menu Pengaturan. Seluruh tampilan aplikasi menyesuaikan secara instan.

---

## 🗺️ Roadmap

- [ ] Integrasi API backend untuk respons AI yang sesungguhnya
- [ ] Suara karakter saat alarm berbunyi (TTS per karakter)
- [ ] Ekspresi karakter berubah sesuai mood percakapan
- [ ] Sistem level & kedekatan dengan karakter
- [ ] Notifikasi harian dari karakter aktif
- [ ] Lebih banyak karakter & kostum (wardrobe)
- [ ] Mode cerita / visual novel

---

## 🛠️ Teknologi

- **Framework:** Flutter (Dart)
- **Platform:** Android, iOS, Web
- **State Management:** StatefulWidget + ChangeNotifier
- **Backend:** *(Coming Soon — REST API)*
- **AI Engine:** *(Coming Soon — LLM Integration)*

---

## 🚀 Cara Menjalankan

```bash
# Clone project
git clone https://github.com/your-username/kukkia.git
cd kukkia

# Install dependencies
flutter pub get

# Jalankan di browser
flutter run -d chrome

# Jalankan di Android
flutter run -d android

# Build APK
flutter build apk --release
```

---

## 📁 Struktur Project

```
lib/
├── models/          # Data model karakter anime
├── providers/       # Theme provider (dark mode)
├── splash/          # Splash screen
├── shell/           # Main navigation shell (4 tab)
├── dashboard/       # Beranda — karakter aktif & quick actions
├── ngobrol/         # Ngobrol — mode chat & bersama anime
├── chat/            # Chat screen (teks + background kustom)
├── alarm/           # Alarm dengan pilihan suara karakter
├── pilih_model/     # Pilih model anime (10 karakter)
├── pengaturan/      # Pengaturan — dark mode, profil, dll
├── set_latar/       # Set latar belakang app
├── widgets/         # Widget reusable (coming soon dialog, dll)
└── assets/img/      # Aset gambar & logo
```

---

## 📄 Lisensi

© 2025 Kukkia. All rights reserved.

---

<p align="center">
  Dibuat dengan ❤️ untuk para penggemar dunia anime dan waifu culture.<br/>
  <em>"Setiap hari lebih menyenangkan bersama Kukkia."</em>
</p>
