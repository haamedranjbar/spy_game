# ساخت android/key.properties با تأیید keystore
# اجرا: .\scripts\setup_key_properties.ps1

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$keystorePath = Join-Path $projectRoot "android\app\upload-keystore.jks"
$keyPropertiesPath = Join-Path $projectRoot "android\key.properties"
$keyAlias = "upload"

if (-not (Test-Path $keystorePath)) {
    Write-Host ""
    Write-Host "خطا: keystore پیدا نشد:" -ForegroundColor Red
    Write-Host "  $keystorePath"
    Write-Host ""
    Write-Host "اول keystore بسازید:"
    Write-Host "  keytool -genkey -v -keystore android\app\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload"
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "=== تنظیم key.properties ===" -ForegroundColor Cyan
Write-Host "همان رمزی که موقع ساخت keystore وارد کردید را بزنید."
Write-Host ""

$securePassword = Read-Host "رمز keystore (storePassword / keyPassword)" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
)

if ([string]::IsNullOrWhiteSpace($password)) {
    Write-Host "رمز خالی است." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "در حال بررسی keystore..." -ForegroundColor Yellow

$keytoolOutput = & keytool -list -v -keystore $keystorePath -alias $keyAlias -storepass $password -keypass $password 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "رمز یا alias اشتباه است." -ForegroundColor Red
    Write-Host $keytoolOutput
    Write-Host ""
    exit 1
}

# مسیر نسبت به android/app/ — همان جایی که build.gradle.kts هست
$content = @"
storePassword=$password
keyPassword=$password
keyAlias=$keyAlias
storeFile=upload-keystore.jks
"@

# بدون BOM — Set-Content -Encoding UTF8 در PowerShell BOM می‌گذارد
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($keyPropertiesPath, $content, $utf8NoBom)

Write-Host ""
Write-Host "فایل ساخته شد:" -ForegroundColor Green
Write-Host "  $keyPropertiesPath"
Write-Host ""
Write-Host "حالا بیلد بگیرید:"
Write-Host "  .\scripts\build_release_apk.ps1"
Write-Host ""
