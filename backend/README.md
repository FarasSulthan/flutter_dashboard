# Farasha Dummy JSON API

Backend ini adalah mock API baca-saja. Semua data langsung dibaca dari [`data/dashboard.seed.json`](data/dashboard.seed.json); tidak ada database, autentikasi, operasi CRUD, atau file data runtime.

Jalankan dari root proyek setelah Dart SDK tersedia:

```bash
dart run backend/bin/server.dart
```

API tersedia di `http://localhost:8080` dan sudah mengirim header CORS untuk Flutter Web. Hanya `GET` dan `OPTIONS` yang didukung. Setiap `POST`, `PUT`, `PATCH`, atau `DELETE` akan menerima respons `405`.

| Method | Endpoint | Keterangan |
| --- | --- | --- |
| GET | `/health` | Health check |
| GET | `/api/dashboard` | Metrik, grafik 7 hari, dan transaksi terbaru |
| GET | `/api/products?search=&category=&status=` | Daftar produk (filter opsional) |
| GET | `/api/products/:id` | Detail produk |
| GET | `/api/customers?search=&tier=` | Daftar pelanggan (filter opsional) |
| GET | `/api/customers/:id` | Detail pelanggan |
| GET | `/api/orders?search=&status=` | Daftar pesanan (filter opsional) |
| GET | `/api/orders/:id` | Detail pesanan |
| GET | `/api/reports?period=Bulan%20Ini` | Semua data laporan atau satu periode |
| GET | `/api/settings` | Pengaturan dummy |

Semua respons berhasil memakai bentuk `{ "data": ... }`; respons koleksi juga menyertakan `meta.count`. Error memakai `{ "error": { "message": "..." } }`.

Ubah isi `data/dashboard.seed.json` untuk mengganti dummy data. Gunakan `PORT=8081` untuk mengganti port atau `DATA_FILE=path/file.json` untuk memakai file dummy lain.
