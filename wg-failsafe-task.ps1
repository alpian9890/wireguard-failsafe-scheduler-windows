# Script untuk membuat Scheduled Task WireGuard Failsafe
# Dibuat untuk mempermudah penjadwalan script failsafe tanpa mengetik panjang

# ======== KONFIGURASI ========
# Ubah nilai di bawah ini sesuai kebutuhan Anda

# Path ke script wireguard-failsafe.ps1
$scriptPath = "C:\Users\Administrator\Desktop\wireguard-failsafe.ps1"

# Berapa jam dari sekarang task akan dijalankan
$jamDariSekarang = 1

# Nama task yang akan dibuat
$namaTask = "WireGuard-Failsafe"

# Username yang menjalankan task
$username = "Administrator"

# ======== PROSES PEMBUATAN TASK ========

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Membuat Scheduled Task WireGuard" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Hitung waktu eksekusi
$waktuEksekusi = (Get-Date).AddHours($jamDariSekarang)

Write-Host "[INFO] Script yang akan dijadwalkan:" -ForegroundColor Yellow
Write-Host "       $scriptPath" -ForegroundColor White
Write-Host ""
Write-Host "[INFO] Waktu eksekusi dijadwalkan pada:" -ForegroundColor Yellow
Write-Host "       $($waktuEksekusi.ToString('dd/MM/yyyy HH:mm:ss'))" -ForegroundColor White
Write-Host ""

# Cek apakah file script ada
if (-Not (Test-Path $scriptPath)) {
    Write-Host "[ERROR] File script tidak ditemukan!" -ForegroundColor Red
    Write-Host "        Path: $scriptPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Silakan periksa path script Anda dan coba lagi." -ForegroundColor Yellow
    exit 1
}

Write-Host "[PROSES] Membuat action task..." -ForegroundColor Green
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

Write-Host "[PROSES] Membuat trigger task..." -ForegroundColor Green
$trigger = New-ScheduledTaskTrigger -Once -At $waktuEksekusi

Write-Host "[PROSES] Mendaftarkan Scheduled Task..." -ForegroundColor Green
try {
    Register-ScheduledTask -TaskName $namaTask -Action $action -Trigger $trigger -User $username -RunLevel Highest -Force | Out-Null
    
    Write-Host ""
    Write-Host "[SUKSES] Scheduled Task berhasil dibuat!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Detail Task:" -ForegroundColor Cyan
    Write-Host "  - Nama Task    : $namaTask" -ForegroundColor White
    Write-Host "  - Waktu Run    : $($waktuEksekusi.ToString('dd/MM/yyyy HH:mm:ss'))" -ForegroundColor White
    Write-Host "  - User         : $username" -ForegroundColor White
    Write-Host "  - Run Level    : Highest (Administrator)" -ForegroundColor White
    Write-Host ""
    Write-Host "Anda dapat melihat task di Task Scheduler atau dengan perintah:" -ForegroundColor Yellow
    Write-Host "  Get-ScheduledTask -TaskName '$namaTask'" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "[ERROR] Gagal membuat Scheduled Task!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
}
