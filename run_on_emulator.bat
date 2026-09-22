@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   BOL GOL FUTBOL - ANDROID EMULATOR & STUDIO RUNNER
echo ========================================================
echo.

set ANDROID_SDK=C:\Users\egebatir\AppData\Local\Android\Sdk
set EMULATOR=%ANDROID_SDK%\emulator\emulator.exe
set ADB=%ANDROID_SDK%\platform-tools\adb.exe
set AVD_NAME=Medium_Phone_API_36.1
set GODOT_EXE="C:\Users\egebatir\Desktop\developer shit\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe"

if not exist "%ADB%" (
    echo [HATA] ADB bulunamadi: %ADB%
    pause
    exit /b 1
)

if not exist "%EMULATOR%" (
    echo [HATA] Emulator bulunamadi: %EMULATOR%
    pause
    exit /b 1
)

echo [1/4] Android Emulator (AVD: %AVD_NAME%) kontrol ediliyor...
"%ADB%" devices | findstr /R "emulator-[0-9]" >nul
if %errorlevel% neq 0 (
    echo [BILGI] Emulator henuz acik degil. Baslatiliyor...
    start "" "%EMULATOR%" -avd %AVD_NAME% -netdelay none -netspeed full
    echo [BILGI] Emulator cihazinin acilmasi bekleniyor...
    "%ADB%" wait-for-device
    echo [BILGI] Emulator baglantisi kuruldu.
) else (
    echo [OK] Emulator zaten calisiyor.
)

echo.
echo [2/4] Cihazin tamamen boot etmesi bekleniyor...
:WAIT_BOOT
for /f "tokens=*" %%a in ('"%ADB%" shell getprop sys.boot_completed 2^>nul') do set BOOT_STATE=%%a
if not "!BOOT_STATE!"=="1" (
    timeout /t 2 >nul
    goto WAIT_BOOT
)
echo [OK] Cihaz hazir ve ana ekranda!

echo.
echo [3/4] Godot ile Debug APK derleniyor...
cd /d "c:\Users\egebatir\Documents\futbol"
%GODOT_EXE% --headless --export-debug "Bol Gol Futbol 2.1" "c:\Users\egebatir\Documents\futbol\android\build\build\outputs\apk\debug\bol_gol_futbol_debug.apk"
if %errorlevel% neq 0 (
    echo [UYARI] Godot CLI export tamamlanamadi veya template bekleniyor.
    echo Mevcut APK veya Android Studio build deneniyor...
)

set TARGET_APK=c:\Users\egebatir\Documents\futbol\android\build\build\outputs\apk\debug\bol_gol_futbol_debug.apk
if exist "%TARGET_APK%" (
    echo.
    echo [4/4] APK Emulatore yukleniyor ve baslatiliyor...
    "%ADB%" install -r "%TARGET_APK%"
    "%ADB%" shell am start -n com.ebstudyo.bolgol/com.godot.game.GodotApp
    echo [BASARILI] Bol Gol Futbol emulatorde baslatildi!
) else (
    echo.
    echo [IPUCU] Android Studio'dan acmak icin:
    echo 1. Android Studio'yu acin.
    echo 2. "Open Existing Project" secip su klasoru secin:
    echo    c:\Users\egebatir\Documents\futbol\android\build
    echo 3. Ustteki "Run" (Yesil Play) butonuna basarak Medium_Phone_API_36.1 uzerinde calistirin!
)

echo.
echo ========================================================
pause
