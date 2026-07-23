# PANDUAN PENGGUNA (USER GUIDE)
**Sistem Temujanji Servis Kereta — Pusat Servis Kereta**

Selamat datang ke Panduan Pengguna **Sistem Temujanji Servis Kereta**. Dokumen ini menyediakan panduan langkah demi langkah untuk staf bengkel dan pelanggan dalam menggunakan aplikasi web ini bagi menguruskan temujanji servis kenderaan.

---

## ISI KANDUNGAN
1. [Prasyarat & Cara Memulakan Sistem](#1-prasyarat--cara-memulakan-sistem)
2. [Halaman Utama: Senarai Temujanji (`index.php`)](#2-halaman-utama-senarai-temujanji-indexphp)
3. [Borang Tempahan Temujanji (`book.php`)](#3-borang-tempahan-temujanji-bookphp)
4. [Penjelasan Status Temujanji](#4-penjelasan-status-temujanji)
5. [Penyelesaian Masalah Ringkas (Troubleshooting)](#5-penyelesaian-masalah-ringkas-troubleshooting)

---

## 1. Prasyarat & Cara Memulakan Sistem

Sebelum membuka laman web dalam pelayar, pastikan persekitaran pembangunan tempatan (*development environment*) telah dijalankan melalui peranti anda:

1. Jalankan Perkhidmatan Pangkalan Data (MariaDB):

    ```Bash
    cd ~/src/xawad
    devenv up
    ```

2. Buka Laman Web dalam Pelayar:

    Layari pautan berikut di Chrome, Firefox, atau pelayar pilihan anda:

    `http://127.0.0.1:8001` atau `http://localhost:8001`

## 2. Halaman Utama: Senarai Temujanji (index.php)

Halaman utama bertindak sebagai papan pemuka (dashboard) untuk memaparkan kesemua rekod temujanji yang telah didaftarkan.

(Gambaran Visual)

Ciri-ciri Utama Halaman Utama:

    Bar Navigasi Atas: Memaparkan tajuk pusat servis.

    Butang + Buat Temujanji Baharu: Butang berwarna hijau di bahagian atas kanan untuk membawa anda ke borang tempahan.

    Jadual Rekod Temujanji:

        ID: Nombor rujukan unik bagi setiap tempahan.

        Nama Pelanggan: Nama penuh pemilik kenderaan.

        No. Plat Kereta: Nombor pendaftaran kenderaan (diformat dalam huruf besar).

        Jenis Servis: Kategori servis yang dipilih (cth: Penukaran Minyak Enjin Asas).

        Tarikh: Tarikh temujanji yang dijadualkan.

        Status: Lencana visual dinamik menunjukkan keadaan tempahan (Pending / Confirmed).

## 3. Borang Tempahan Temujanji (book.php)

Halaman ini digunakan oleh pelanggan atau staf bengkel untuk melerekodkan tempahan temujanji baharu.

Langkah-langkah Membina Tempahan:

1. Klik butang `+ Buat Temujanji Baharu` di halaman utama atau layari terus `http://localhost:8001/book.php`.

2. Isi maklumat berikut pada borang yang disediakan:

    Nama Penuh: Masukkan nama pelanggan (Contoh: *Ahmad Razak*).

    Nombor Plat Kereta: Masukkan nombor plat kenderaan (Contoh: *WYY 8899*). Sistem akan menukarkan teks ini kepada huruf besar secara automatik.

    Jenis Servis: Pilih salah satu daripada pilihan susur keluar (dropdown):

        Penukaran Minyak Enjin Asas

        Servis Major Penuh

        Penukaran Pad Brek

        Imbangan & Jajaran Tayar

    Tarikh Temujanji: Pilih tarikh dari kalendar. (Nota: Anda tidak boleh memilih tarikh yang telah berlalu).

3. Klik butang Hantar Tempahan.

4. Setelah berjaya, sistem akan memproses data dan menaik taraf maklumat ke pangkalan data, seterusnya melencongkan anda kembali ke halaman utama secara automatik untuk melihat rekod baharu tersebut.

## 4. Penjelasan Status Temujanji

Sistem menggunakan lencana warna (badges) untuk membezakan status setiap temujanji dengan jelas:

| Lencana Visual | Status       | Penerangan |
|----------------|--------------|------------|
| Pending | Pending | Tempahan baharu yang dibuat oleh pelanggan. Memerlukan pengesahan lanjut daripada pihak pelanggan/bengkel. |
| Confirmed | Confirmed | Temujanji yang telah disahkan oleh pihak pengurusan bengkel dan sedia untuk servis. |

## 5. Penyelesaian Masalah Ringkas (Troubleshooting)

### Q1: Laman web memaparkan ralat "Database Connection Failed"?

- Sebab: Perkhidmatan MariaDB belum dijalankan atau terhenti.

- Penyelesaian: Pastikan anda telah menjalankan arahan devenv up di dalam terminal dan soket pangkalan data diisi dengan betul dalam db.php.

### Q2: Mengapa tarikh semalam tidak boleh dipilih dalam borang tempahan?

- Sebab: Ini ialah ciri kawalan kualiti (validation) pada input tarikh (min="<?php echo date('Y-m-d'); ?>") bagi mengelakkan tempahan dibuat pada tarikh yang telah berlalu.

### Q3: Bagaimana jika saya hendak menyemak isi pangkalan data secara terus?

- Layari phpMyAdmin tempatan anda di: http://127.0.0.1:8000 (jika perkhidmatan phpMyAdmin diaktifkan).
