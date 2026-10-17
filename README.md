# Farasha Dashboard

Contoh aplikasi dashboard Flutter yang responsif dengan data dari dummy JSON API.

Jalankan API dummy pada terminal pertama:

```bash
dart run backend/bin/server.dart
```

Lalu jalankan UI pada terminal kedua:

```bash
flutter pub get
flutter run
```

Untuk Android emulator, gunakan alamat host emulator agar UI dapat menjangkau API di komputer:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

Fitur utama:

- Ringkasan pemasukan, pesanan, pelanggan, dan produk.
- Grafik aktivitas penjualan tujuh hari terakhir.
- Daftar transaksi terbaru dan aksi cepat.
- Navigasi responsif untuk layar kecil dan besar.

## Backend lokal

Mock API berbasis Dart dan dummy JSON tersedia pada folder [`backend`](backend/README.md). Ia menyajikan data dashboard, produk, pelanggan, pesanan, laporan, dan pengaturan tanpa database atau perubahan data runtime.

```bash
dart run backend/bin/server.dart
```

Lihat [dokumentasi API](backend/README.md) untuk daftar endpoint dan format request.

Jika API dummy belum berjalan, UI tetap muncul memakai data fallback yang sama agar halaman tidak kosong.
