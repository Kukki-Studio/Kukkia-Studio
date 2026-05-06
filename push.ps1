# ============================================
# push.ps1 — Script push otomatis Kukkia
#
# Cara pakai:
#   .\push.ps1                          → commit bebas, tanya pesan
#   .\push.ps1 "pesan commit"           → commit dengan pesan
#   .\push.ps1 -version 1.0.1           → update versi + commit bebas
#   .\push.ps1 -version 1.0.1 "pesan"  → update versi + pesan custom
# ============================================

param(
    [string]$Message = "",
    [string]$version = ""
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Kukkia — Auto Push to GitHub" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ── Update versi di pubspec.yaml jika -version diberikan ─────────────────────
if ($version -ne "") {
    $pubspec = "pubspec.yaml"
    $content = Get-Content $pubspec -Raw

    # Ambil versionCode lama (angka setelah +)
    if ($content -match 'version:\s*[\d\.]+\+(\d+)') {
        $oldBuild = [int]$Matches[1]
        $newBuild = $oldBuild + 1
    } else {
        $newBuild = 1
    }

    # Ganti versi
    $newVersion = "version: $version+$newBuild"
    $content = $content -replace 'version:\s*[\d\.]+\+\d+', $newVersion
    Set-Content $pubspec $content -Encoding UTF8

    Write-Host "Versi diupdate: $version+$newBuild" -ForegroundColor Magenta
    Write-Host ""

    # Default pesan commit kalau tidak ada
    if ($Message -eq "") {
        $Message = "release: v$version"
    }
}

# ── Cek apakah ada perubahan ──────────────────────────────────────────────────
$status = git status --porcelain
if (-not $status) {
    Write-Host "Tidak ada perubahan untuk di-push." -ForegroundColor Yellow
    exit 0
}

# Tampilkan file yang berubah
Write-Host "File yang berubah:" -ForegroundColor White
git status --short
Write-Host ""

# Minta pesan commit kalau masih kosong
if ($Message -eq "") {
    $Message = Read-Host "Pesan commit (Enter untuk pakai default)"
    if ($Message -eq "") {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        $Message = "update: $timestamp"
    }
}

Write-Host ""
Write-Host "Commit: $Message" -ForegroundColor Green
Write-Host ""

# ── Git add, commit, push ─────────────────────────────────────────────────────
git add .
git commit -m $Message
git push

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   Berhasil di-push ke GitHub!" -ForegroundColor Green
    if ($version -ne "") {
        Write-Host "   Versi: v$version" -ForegroundColor Green
        Write-Host "   GitHub Actions akan build APK v$version" -ForegroundColor Green
    } else {
        Write-Host "   GitHub Actions akan build APK otomatis" -ForegroundColor Green
    }
    Write-Host "   Cek: github.com/Kukki-Studio/Kukkia-Studio/actions" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
} else {
    Write-Host "Push gagal. Cek error di atas." -ForegroundColor Red
}
Write-Host ""
