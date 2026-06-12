# بیلد release با split-per-abi → سه APK: armeabi-v7a، arm64-v8a، x86_64
# استفاده: .\scripts\build_release_apk.ps1
#         .\scripts\build_release_apk.ps1 -Flavor bazaar

param(
    [ValidateSet("bazaar", "myket", "google")]
    [string]$Flavor = "myket"
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$keyProperties = Join-Path $projectRoot "android\key.properties"
if (-not (Test-Path $keyProperties)) {
    Write-Host ""
    Write-Host "خطا: فایل android\key.properties پیدا نشد." -ForegroundColor Red
    Write-Host "keystore ساخته شده؛ key.properties را هم بسازید و دوباره بیلد بگیرید."
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "=== بیلد release — flavor: $Flavor — split-per-abi ===" -ForegroundColor Cyan
Write-Host ""

flutter build apk `
    --flavor $Flavor `
    --dart-define=APP_MARKET=$Flavor `
    --release `
    --split-per-abi

if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$apkDir = Join-Path $projectRoot "build\app\outputs\flutter-apk"
$abis = @(
    @{ Name = "armeabi-v7a"; File = "app-armeabi-v7a-$Flavor-release.apk" },
    @{ Name = "arm64-v8a";   File = "app-arm64-v8a-$Flavor-release.apk" },
    @{ Name = "x86_64";      File = "app-x86_64-$Flavor-release.apk" }
)

Write-Host ""
Write-Host "=== خروجی‌ها ===" -ForegroundColor Green
foreach ($abi in $abis) {
    $path = Join-Path $apkDir $abi.File
    Write-Host "  $($abi.Name): $path"
}
Write-Host ""
