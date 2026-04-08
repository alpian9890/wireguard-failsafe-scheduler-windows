# Script untuk membatalkan/menghapus Scheduled Task WireGuard Failsafe
# Dibuat untuk membatalkan task yang sudah dijadwalkan

# ======== KONFIGURASI ========
# Nama task yang akan dihapus (harus sama dengan yang dibuat)
$namaTask = "WireGuard-Failsafe"

# ======== PROSES PEMBATALAN TASK ========

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Membatalkan Scheduled Task WireGuard" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Cek apakah task ada
Write-Host "[INFO] Memeriksa apakah task '$namaTask' ada..." -ForegroundColor Yellow
$task = Get-ScheduledTask -TaskName $namaTask -ErrorAction SilentlyContinue

if ($null -eq $task) {
    Write-Host ""
    Write-Host "[INFO] Task '$namaTask' tidak ditemukan." -ForegroundColor Yellow
    Write-Host "       Kemungkinan task sudah dihapus atau belum pernah dibuat." -ForegroundColor Yellow
    Write-Host ""
    
    # Tampilkan daftar task WireGuard jika ada
    Write-Host "Mencari task lain yang mengandung kata 'WireGuard'..." -ForegroundColor Cyan
    $wireguardTasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "*WireGuard*" }
    
    if ($wireguardTasks) {
        Write-Host ""
        Write-Host "Task WireGuard yang ditemukan:" -ForegroundColor Green
        foreach ($wgTask in $wireguardTasks) {
            Write-Host "  - $($wgTask.TaskName)" -ForegroundColor White
        }
        Write-Host ""
        Write-Host "Jika Anda ingin menghapus task di atas, ubah variabel `$namaTask" -ForegroundColor Yellow
        Write-Host "di dalam script ini sesuai dengan nama task yang ingin dihapus." -ForegroundColor Yellow
    } else {
        Write-Host "Tidak ada task WireGuard yang ditemukan." -ForegroundColor Gray
    }
    
    Write-Host ""
    exit 0
}

# Tampilkan informasi task yang akan dihapus
Write-Host ""
Write-Host "[DITEMUKAN] Informasi Task:" -ForegroundColor Green
Write-Host "  - Nama Task     : $($task.TaskName)" -ForegroundColor White
Write-Host "  - Status        : $($task.State)" -ForegroundColor White
Write-Host "  - Last Run Time : $($task.LastRunTime)" -ForegroundColor White
Write-Host "  - Next Run Time : $($task.NextRunTime)" -ForegroundColor White
Write-Host ""

# Konfirmasi penghapusan
$konfirmasi = Read-Host "Apakah Anda yakin ingin menghapus task ini? (Y/N)"

if ($konfirmasi -ne "Y" -and $konfirmasi -ne "y") {
    Write-Host ""
    Write-Host "[DIBATALKAN] Penghapusan task dibatalkan." -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

# Hapus task
Write-Host ""
Write-Host "[PROSES] Menghapus Scheduled Task..." -ForegroundColor Green

try {
    Unregister-ScheduledTask -TaskName $namaTask -Confirm:$false
    
    Write-Host ""
    Write-Host "[SUKSES] Task '$namaTask' berhasil dihapus!" -ForegroundColor Green
    Write-Host ""
    Write-Host "✅ WireGuard TIDAK akan dimatikan" -ForegroundColor Green
    Write-Host "✅ Scheduled Task sudah dibatalkan" -ForegroundColor Green
    Write-Host ""
    Write-Host "Anda dapat memverifikasi dengan perintah:" -ForegroundColor Yellow
    Write-Host "  Get-ScheduledTask -TaskName '$namaTask'" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Gagal menghapus Scheduled Task!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Coba jalankan PowerShell sebagai Administrator" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
