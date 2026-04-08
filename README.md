# 📖 Dokumentasi WireGuard Scheduled Task Scripts

Dokumentasi lengkap untuk script PowerShell yang digunakan untuk membuat dan membatalkan Scheduled Task WireGuard Failsafe di Windows.

---

## 📋 Daftar Isi

1. [Deskripsi](#-deskripsi)
2. [File-File yang Tersedia](#-file-file-yang-tersedia)
3. [Prasyarat](#-prasyarat)
4. [Solusi Error Execution Policy](#-solusi-error-execution-policy)
5. [Cara Penggunaan](#-cara-penggunaan)
6. [Konfigurasi](#-konfigurasi)
7. [Troubleshooting](#-troubleshooting)
8. [Perintah Manual](#-perintah-manual)

---

## 🎯 Deskripsi

Script-script ini digunakan untuk mengotomasi pembuatan dan pembatalan Scheduled Task di Windows yang menjalankan script WireGuard Failsafe. Script ini berguna untuk:

- **Membuat task terjadwal** yang akan menjalankan script failsafe WireGuard pada waktu tertentu
- **Membatalkan task** yang sudah dijadwalkan jika Anda berubah pikiran
- **Menghindari pengetikan perintah panjang** di PowerShell

---

## 📖 Konteks & Kasus Penggunaan

### Masalah yang Diselesaikan

Saat mengelola **VPS Windows dengan akses RDP** dan menggunakan **WireGuard full tunneling**, ada risiko kehilangan akses RDP ketika WireGuard diaktifkan. Berikut skenarionya:

1. **Situasi Awal:**
   - Anda terhubung ke VPS Windows melalui RDP
   - WireGuard sudah terinstall dengan konfigurasi full tunneling
   - Saat WireGuard diaktifkan, **semua traffic** dialihkan melalui tunnel

2. **Masalah:**
   - Ketika WireGuard diaktifkan, koneksi RDP **terputus** karena routing berubah
   - Anda **tidak bisa konek kembali** ke VPS via RDP
   - VPS menjadi tidak dapat diakses kecuali melalui console provider

3. **Solusi dengan Script Ini:**
   - **SEBELUM** mengaktifkan WireGuard, jalankan `wg-failsafe-task.ps1`
   - Script akan membuat task yang otomatis **mematikan WireGuard** setelah waktu tertentu (default: 1 jam)
   - Aktifkan WireGuard dan test koneksi RDP
   - **Jika RDP masih aman:** Jalankan `wg-cancel-task.ps1` untuk membatalkan failsafe
   - **Jika RDP terputus:** Tunggu task failsafe berjalan (1 jam), WireGuard akan dimatikan otomatis, dan Anda bisa RDP lagi

### Workflow Penggunaan

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Terhubung ke VPS via RDP                                 │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Jalankan wg-failsafe-task.ps1                            │
│    (Failsafe akan aktif dalam 1 jam)                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. Aktifkan WireGuard                                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    ┌───────┴───────┐
                    ↓               ↓
        ┌───────────────────┐   ┌───────────────────┐
        │ RDP Masih Aman ✅  │   │ RDP Terputus ❌    │
        └───────────────────┘   └───────────────────┘
                    ↓               ↓
        ┌───────────────────┐   ┌───────────────────┐
        │ Jalankan          │   │ Tunggu 1 jam      │
        │ wg-cancel-task    │   │ WireGuard mati    │
        │ untuk batalkan    │   │ otomatis          │
        └───────────────────┘   └───────────────────┘
                    ↓               ↓
        ┌───────────────────┐   ┌───────────────────┐
        │ WireGuard tetap   │   │ Bisa RDP lagi     │
        │ aktif, aman ✅     │   │ dan coba fix ✅    │
        └───────────────────┘   └───────────────────┘
```

### Mengapa Script Ini Penting?

- 🛡️ **Safety Net:** Mencegah kehilangan akses total ke VPS
- ⏰ **Otomatis:** Tidak perlu manual login ke console provider
- 🚀 **Cepat:** Cukup tunggu task berjalan, akses kembali normal
- 💰 **Hemat Biaya:** Tidak perlu membuka tiket support atau menggunakan console berbayar
- 😌 **Peace of Mind:** Anda bisa eksperimen dengan WireGuard tanpa takut terkunci

---

## 📁 File-File yang Tersedia

### 1. `wg-failsafe-task.ps1`
**Fungsi:** Membuat Scheduled Task untuk menjalankan WireGuard Failsafe

**Fitur:**
- ✅ Validasi otomatis apakah file script failsafe ada
- ✅ Konfigurasi waktu eksekusi (default: 1 jam dari sekarang)
- ✅ Output berwarna untuk kemudahan membaca
- ✅ Error handling dengan pesan yang jelas
- ✅ Informasi detail task yang dibuat
- ✅ Dijalankan dengan hak akses Administrator (RunLevel Highest)

**Hasil:**
Task terjadwal bernama `WireGuard-Failsafe` akan dibuat dan dijalankan sekali pada waktu yang ditentukan.

---

### 2. `wg-cancel-task.ps1`
**Fungsi:** Membatalkan/menghapus Scheduled Task WireGuard Failsafe

**Fitur:**
- ✅ Pengecekan apakah task ada sebelum menghapus
- ✅ Menampilkan informasi task sebelum dihapus
- ✅ Konfirmasi pengguna sebelum penghapusan
- ✅ Pencarian task WireGuard lain jika task target tidak ditemukan
- ✅ Output berwarna dan informatif
- ✅ Verifikasi keberhasilan penghapusan

**Hasil:**
Task terjadwal akan dihapus dan WireGuard tidak akan dimatikan.

---

## ⚙️ Prasyarat

1. **Windows Operating System** (Windows 10/11 atau Windows Server)
2. **PowerShell 5.1 atau lebih baru**
3. **Akses Administrator** untuk membuat/menghapus Scheduled Task
4. **File script failsafe** harus ada di lokasi yang ditentukan (untuk `wg-failsafe-task.ps1`)

---

## 🔧 Solusi Error Execution Policy

### ❌ Error yang Sering Muncul

```
.\wg-failsafe-task.ps1 : File C:\Users\Administrator\Desktop\wg-failsafe-task.ps1 cannot be loaded 
because running scripts is disabled on this system.
```

### ✅ Solusi: Ubah Execution Policy (Permanen)

**Langkah 1:** Buka PowerShell sebagai Administrator
- Klik kanan pada icon PowerShell
- Pilih **"Run as Administrator"**

**Langkah 2:** Jalankan perintah berikut:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Langkah 3:** Ketik `Y` atau `A` untuk konfirmasi

**Langkah 4:** Sekarang Anda dapat menjalankan script dengan normal:

```powershell
.\wg-failsafe-task.ps1
```

atau

```powershell
.\wg-cancel-task.ps1
```

### 📝 Penjelasan Execution Policy

- **RemoteSigned**: Mengizinkan script lokal berjalan, script dari internet harus ditandatangani
- **CurrentUser**: Hanya berlaku untuk user saat ini, tidak mempengaruhi user lain
- Ini adalah pengaturan **permanen** dan hanya perlu dilakukan **sekali**

---

## 🚀 Cara Penggunaan

### A. Membuat Scheduled Task WireGuard Failsafe

**Langkah 1:** Buka PowerShell sebagai Administrator

**Langkah 2:** Navigasi ke folder tempat script berada:
```powershell
cd C:\Users\Administrator\Desktop
```

**Langkah 3:** Jalankan script:
```powershell
.\wg-failsafe-task.ps1
```

**Langkah 4:** Script akan menampilkan:
- Path script yang akan dijadwalkan
- Waktu eksekusi (default: 1 jam dari sekarang)
- Status pembuatan task (sukses/gagal)

**Output Contoh:**
```
========================================
  Membuat Scheduled Task WireGuard
========================================

[INFO] Script yang akan dijadwalkan:
       C:\Users\Administrator\Desktop\wireguard-failsafe.ps1

[INFO] Waktu eksekusi dijadwalkan pada:
       08/04/2026 09:00:00

[PROSES] Membuat action task...
[PROSES] Membuat trigger task...
[PROSES] Mendaftarkan Scheduled Task...

[SUKSES] Scheduled Task berhasil dibuat!

Detail Task:
  - Nama Task    : WireGuard-Failsafe
  - Waktu Run    : 08/04/2026 09:00:00
  - User         : Administrator
  - Run Level    : Highest (Administrator)
```

---

### B. Membatalkan Scheduled Task WireGuard Failsafe

**Langkah 1:** Buka PowerShell sebagai Administrator

**Langkah 2:** Navigasi ke folder tempat script berada:
```powershell
cd C:\Users\Administrator\Desktop
```

**Langkah 3:** Jalankan script:
```powershell
.\wg-cancel-task.ps1
```

**Langkah 4:** Script akan menampilkan informasi task dan meminta konfirmasi:
```
Apakah Anda yakin ingin menghapus task ini? (Y/N):
```

**Langkah 5:** Ketik `Y` dan tekan Enter untuk menghapus, atau `N` untuk membatalkan

**Output Contoh:**
```
========================================
  Membatalkan Scheduled Task WireGuard
========================================

[INFO] Memeriksa apakah task 'WireGuard-Failsafe' ada...

[DITEMUKAN] Informasi Task:
  - Nama Task     : WireGuard-Failsafe
  - Status        : Ready
  - Last Run Time : 
  - Next Run Time : 08/04/2026 09:00:00

Apakah Anda yakin ingin menghapus task ini? (Y/N): Y

[PROSES] Menghapus Scheduled Task...

[SUKSES] Task 'WireGuard-Failsafe' berhasil dihapus!

✅ WireGuard TIDAK akan dimatikan
✅ Scheduled Task sudah dibatalkan
```

---

## ⚙️ Konfigurasi

### Konfigurasi `wg-failsafe-task.ps1`

Buka file dengan text editor (Notepad, VS Code, dll) dan ubah bagian konfigurasi:

```powershell
# ======== KONFIGURASI ========

# Path ke script wireguard-failsafe.ps1
$scriptPath = "C:\Users\Administrator\Desktop\wireguard-failsafe.ps1"

# Berapa jam dari sekarang task akan dijalankan
$jamDariSekarang = 1  # Ubah sesuai kebutuhan (1 = 1 jam, 2 = 2 jam, dst)

# Nama task yang akan dibuat
$namaTask = "WireGuard-Failsafe"

# Username yang menjalankan task
$username = "Administrator"  # Ubah jika menggunakan user lain
```

### Konfigurasi `wg-cancel-task.ps1`

```powershell
# ======== KONFIGURASI ========

# Nama task yang akan dihapus (harus sama dengan yang dibuat)
$namaTask = "WireGuard-Failsafe"
```

**⚠️ Penting:** Pastikan `$namaTask` di kedua script sama agar pembatalan berfungsi dengan benar.

---

## 🛠️ Troubleshooting

### 1. **Error: File script tidak ditemukan**

**Penyebab:** Path ke `wireguard-failsafe.ps1` tidak benar

**Solusi:**
- Pastikan file `wireguard-failsafe.ps1` ada di lokasi yang ditentukan
- Cek path di variabel `$scriptPath` dalam file `wg-failsafe-task.ps1`
- Ubah path sesuai lokasi sebenarnya

**Contoh:**
```powershell
# Jika file ada di folder Documents
$scriptPath = "C:\Users\Administrator\Documents\wireguard-failsafe.ps1"
```

---

### 2. **Error: Access Denied**

**Penyebab:** PowerShell tidak dijalankan sebagai Administrator

**Solusi:**
- Tutup PowerShell
- Klik kanan icon PowerShell
- Pilih **"Run as Administrator"**
- Jalankan script lagi

---

### 3. **Task tidak ditemukan saat membatalkan**

**Penyebab:** 
- Task sudah dihapus sebelumnya
- Nama task tidak sama

**Solusi:**
- Script akan menampilkan daftar task WireGuard lain jika ada
- Periksa Task Scheduler manual untuk melihat task yang ada
- Ubah variabel `$namaTask` jika nama task berbeda

---

### 4. **Script tidak menampilkan warna**

**Penyebab:** PowerShell versi lama atau console tidak support warna

**Solusi:**
- Update PowerShell ke versi terbaru
- Gunakan Windows Terminal untuk tampilan lebih baik
- Script tetap berfungsi normal meski tanpa warna

---

### 5. **Task tidak berjalan pada waktu yang ditentukan**

**Penyebab:** 
- Komputer dalam keadaan sleep/hibernate
- Task Scheduler service tidak berjalan
- User tidak login

**Solusi:**
- Pastikan komputer tetap menyala pada waktu task dijadwalkan
- Cek Task Scheduler service: `Get-Service -Name "Schedule"`
- Jika service stopped, jalankan: `Start-Service -Name "Schedule"`

---

## 📝 Perintah Manual

Jika Anda lebih suka menggunakan perintah PowerShell langsung tanpa script:

### Membuat Task Manual

```powershell
# Set waktu eksekusi (1 jam dari sekarang)
$time = (Get-Date).AddHours(1)

# Buat action
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File C:\Users\Administrator\Desktop\wireguard-failsafe.ps1"

# Buat trigger
$trigger = New-ScheduledTaskTrigger -Once -At $time

# Daftarkan task
Register-ScheduledTask -TaskName "WireGuard-Failsafe" -Action $action -Trigger $trigger -User "Administrator" -RunLevel Highest -Force
```

### Melihat Task yang Ada

```powershell
# Lihat task spesifik
Get-ScheduledTask -TaskName "WireGuard-Failsafe"

# Lihat semua task WireGuard
Get-ScheduledTask | Where-Object { $_.TaskName -like "*WireGuard*" }

# Lihat detail task termasuk waktu next run
Get-ScheduledTask -TaskName "WireGuard-Failsafe" | Get-ScheduledTaskInfo
```

### Menghapus Task Manual

```powershell
# Hapus tanpa konfirmasi
Unregister-ScheduledTask -TaskName "WireGuard-Failsafe" -Confirm:$false

# Hapus dengan konfirmasi
Unregister-ScheduledTask -TaskName "WireGuard-Failsafe"
```

### Menonaktifkan/Mengaktifkan Task

```powershell
# Nonaktifkan task (tidak menghapus)
Disable-ScheduledTask -TaskName "WireGuard-Failsafe"

# Aktifkan kembali
Enable-ScheduledTask -TaskName "WireGuard-Failsafe"
```

### Menjalankan Task Sekarang (Manual)

```powershell
# Jalankan task segera tanpa menunggu waktu terjadwal
Start-ScheduledTask -TaskName "WireGuard-Failsafe"
```

---

## 📊 Informasi Tambahan

### File yang Diperlukan

```
C:\Users\Administrator\Desktop\
│
├── wg-failsafe-task.ps1        # Script pembuat task
└── wg-cancel-task.ps1          # Script pembatal task
```

### Lokasi Task di Windows

Task yang dibuat dapat dilihat di:
- **GUI:** Task Scheduler → Task Scheduler Library
- **PowerShell:** `Get-ScheduledTask -TaskName "WireGuard-Failsafe"`

### Hak Akses

Script-script ini memerlukan:
- **Administrator privileges** untuk membuat/menghapus Scheduled Task
- **Execution Policy** minimal RemoteSigned

---

## 📞 Bantuan Lebih Lanjut

Jika Anda mengalami masalah yang tidak tercantum di dokumentasi ini:

1. Periksa error message yang muncul
2. Pastikan semua prasyarat terpenuhi
3. Coba jalankan perintah manual untuk debugging
4. Periksa Windows Event Viewer untuk log task scheduler

---

## 📝 Catatan Penting

- ⚠️ Task hanya akan berjalan **sekali** pada waktu yang ditentukan
- ⚠️ Komputer harus **tetap menyala** pada waktu eksekusi
- ⚠️ Jika komputer sleep, task akan berjalan saat komputer bangun (jika opsi diaktifkan)
- ⚠️ Task berjalan dengan **hak akses Administrator penuh**
- ✅ Task dapat dibatalkan kapan saja sebelum waktu eksekusi
- ✅ Script aman dijalankan berulang kali (akan menimpa task lama)

---

## 📄 Lisensi & Kredit

Script ini dibuat untuk mempermudah manajemen WireGuard Scheduled Task di Windows.

**Dibuat:** April 2026  
**Platform:** Windows PowerShell 5.1+  
**Bahasa:** Bahasa Indonesia

---

**Dokumentasi Terakhir Diperbarui:** 08 April 2026
