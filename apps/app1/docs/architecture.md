# DOKUMENTASI PROJEK: SISTEM TEMUJANJI SERVIS KERETA

Sains Komputer Tingkatan 4 (Pembangunan Modul Pangkalan Data & Web)

## 1. Pengenalan Projek

Sistem Temujanji Servis Kereta ialah sebuah aplikasi web berasaskan seni bina Client-Server (Klien-Pelayan) yang dibina menggunakan HTML, CSS (Bootstrap 5), JavaScript, PHP, dan MariaDB.

Sistem ini membolehkan pelanggan membuat tempahan servis kereta secara dalam talian dan membolehkan pihak bengkel melihat senarai temujanji terkini secara dinamik.

## 2. Seni Bina Sistem (Full-Stack Architecture)

Sistem ini terbahagi kepada tiga lapisan utama:

```
+-----------------------------------------------------------------------------------+
|                                 1. FRONT-END (Klien)                              |
|   - Antaramuka pengguna (UI) dibina menggunakan HTML5 & Bootstrap 5 CSS.          |
|   - Mengumpul input pengguna menerusi borang (book.php).                          |
|   - Memaparkan senarai rekod dalam bentuk jadual interaktif (index.php).          |
+-----------------------------------------------------------------------------------+
                                          │
                                          │  HTTP Request (POST / GET)
                                          ▼
+-----------------------------------------------------------------------------------+
|                                 2. BACK-END (Pelayan PHP)                         |
|   - Menguruskan logik perniagaan (Business Logic).                                |
|   - Menyaring & menyemak data (Data Sanitization & Validation).                   |
|   - Mengendalikan keselamatan pangkalan data menerusi Prepared Statements.        |
|   - Fail terlibat: db.php, process-book.php, index.php.                           |
+-----------------------------------------------------------------------------------+
                                          │
                                          │  SQL Query (SELECT / INSERT)
                                          ▼
+-----------------------------------------------------------------------------------+
|                               3. PANGKALAN DATA (MariaDB)                         |
|   - Menyimpan rekod secara kekal dalam jadual 'appointments'.                     |
+-----------------------------------------------------------------------------------+
```

## 3. Struktur & Susunan Fail Projek

Fail-fail projek disusun secara sistematik di dalam folder utama:

```
xawad/
└── apps/
    └── app1/
        ├── db/
        │   ├── db/schema.sql                       # Initial database table structure & sample data
        │   └── db/db.php                           # (Back-End) Sambungan pangkalan data MariaDB
        └── public/                                 # Accessible Web Root
            ├── assets/
            │   ├── css/
            │   │   └── bootstrap.min.css           # (Front-End) Fail gaya & susun atur
            │   └── js/
            │       └── bootstrap.bundle.min.js     # (Front-End) Skrip interaktif Bootstrap
            ├── index.php                           # (Front-End + Back-End) Paparan senarai temujanji
            ├── book.php                            # (Front-End) Borang tempahan temujanji
            └── process-book.php                    # (Back-End) Pemprosesan data borang & simpanan SQL
```

## 4. Aliran Kerja & Interaksi Antara Fail (Data Flow)

### 4.1. Aliran Membaca Data (Data Fetching / Read Flow)

1. Pengguna membuka `index.php`: Pelayar membuat *HTTP GET* Request.

2. PHP memanggil `db.php`: Menggunakan `require_once` untuk membuka sambungan pangkalan data.

3. Pelaksanaan SQL: Skrip menjalankan arahan `SELECT * FROM appointments ORDER BY appointment_date ASC`.

4. Penterjemahan ke HTML: PHP menukarkan data hasil carian (result set) kepada baris-baris jadual HTML (`<tr>` dan `<td>`) menggunakan gegelung `while` dan `fetch_assoc()`.

5. Gaya Bootstrap: Class CSS memproses jadual supaya kelihatan kemas dan responsif sebelum dipaparkan pada skrin pengguna.

### 4.2. Aliran Menyimpan Data (Data Submission / Write Flow)

1. Pengguna mengisi book.php: Pengguna memasukkan nama, nombor plat, jenis servis, dan tarikh.

2. Penghantaran Borang: Apabila butang Hantar ditekan, borang dihantar menerusi kaedah POST ke process-book.php.

3. Penyaringan & Pengesahan (Sanitization & Validation):

   - $_POST['key'] dibaca.

   - trim() membuang ruang kosong.

   - strtoupper() menukarkan plat kereta ke huruf besar.

   - empty() menyemak jika ada medan yang terlepas pandang.

4. Perlindungan SQL Injection: process-book.php menyediakan penyataan bersedia (Prepared Statement) dengan simbol pemegang tempat (?) dan mengikat parameter menggunakan bind_param("sssss", ...).

5. Simpan & Lencongan (Execute & Redirect):

   - Arahan INSERT INTO dijalankan.

   - Setelah berjaya, skrip memanggil header("Location: index.php?status=success") untuk membawa pengguna kembali ke halaman utama.

## 5. Jadual Pemetaan Pemboleh Ubah (Data Mapping)

Jadual ini menunjukkan bagaimana satu-satu data bergerak dari elemen HTML di bahagian Front-End, diproses oleh PHP di bahagian Back-End, dan akhirnya disimpan ke dalam Pangkalan Data:

| Komponen Front-End (book.php)    | Pemboleh Ubah Back-End (process-book.php) | Lajur Pangkalan Data (MariaDB) | Tipe Data (SQL) |
|----------------------------------|-------------------------------------------|--------------------------------|-----------------|
| \<input name="customer_name">    | $_POST['customer_name']                   | customer_name                  | VARCHAR(100)    |
| \<input name="car_plate">        | $_POST['car_plate']                       | car_plate                      | VARCHAR(15)     |
| \<select name="service_type">    | $_POST['service_type']                    | service_type                   | VARCHAR(100)    |
| \<input name="appointment_date"> | $_POST['appointment_date']                | appointment_date               | DATE            |
| (Tetapan Automatik)              | $status = 'Pending'                       | status                         | VARCHAR(20)     |


## 6. Senarai Istilah & Konsep Keselamatan Utama

| Istilah / Konsep        | Penerangan / Fungsi                                                   |
|-------------------------|-----------------------------------------------------------------------|
| `require_once`          | Mengimport fail PHP lain (seperti db.php) SEKALI sahaja untuk mengelakkan ralat pembentukan semula fungsi/pemboleh ubah. |
| `htmlspecialchars()`    | Mencegah serangan XSS (Cross-Site Scripting) dengan menukarkan aksara khas HTML kepada bentuk entiti selamat sebelum dipaparkan. |
| `Prepared Statements`   | Mencegah serangan SQL Injection dengan mengasingkan arahan SQL daripada data input pengguna. |
| `$_POST` vs `$_GET`     | POST menghantar data secara tersembunyi (sesuai untuk penyimpanan data), manakala GET menghantar data menerusi pautan URL. |
| `header("Location: ...")` | Mengarahkan pelayar web pengguna berpindah ke halaman lain secara automatik selepas proses pemprosesan selesai. |

> Nota Pembelajaran SPM: Dokumentasi ini merangkumi keseluruhan Standard Kandungan bagi tajuk Pembangunan Kod dan Pangkalan Data Sains Komputer Tingkatan 4. Murid disarankan memahami aliran pemboleh ubah dari borang HTML hingga ke perancangan jadual SQL.
