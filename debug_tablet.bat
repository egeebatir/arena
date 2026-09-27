@echo off
chcp 65001 >nul
title Bol Gol Futbol - Samsung Galaxy Tab S6 Lite Debug Yardimcisi
color 0b

echo ======================================================================
echo          BOL GOL FUTBOL - TABLET DEBUG VE ADB BAGLANTI ARACI
echo ======================================================================
echo.

set ADB_PATH=C:\Users\egebatir\AppData\Local\Android\Sdk\platform-tools\adb.exe

if not exist "%ADB_PATH%" (
    where adb >nul 2>nul
    if %errorlevel% neq 0 (
        echo [HATA] ADB bulunamadi! Android SDK platform-tools yuklu olmali.
        pause
        exit /b 1
    ) else (
        set ADB_PATH=adb
    )
)

echo [1/3] ADB Sunucusu baslatiliyor...
"%ADB_PATH%" start-server >nul 2>&1

echo.
echo [2/3] Bagli Android cihazlar araniyor...
echo.
"%ADB_PATH%" devices -l

echo.
echo ======================================================================
echo TABLETI BAGLAMA YOLLARI:
echo.
echo A) KABLO ILE (USB):
echo    1. Tablet Ayarlar -^> Gelistirici Secenekleri -^> 'USB Hata Ayiklama' acik olmali.
echo    2. Ekranda 'Bu bilgisayara her zaman izin ver' uyarisi cikarsa 'Tamam' deyin.
echo    3. Kablo sadece sarj kablosu degil veri kablosu olmalidir.
echo.
echo B) KABLOSUZ (WI-FI) - KABLO GEREKTIRMEZ (Android 11+):
echo    1. Tablet ve Bilgisayar ayni Wi-Fi agina bagli olmali.
echo    2. Tablet Ayarlar -^> Gelistirici Secenekleri -^> 'Kablosuz hata ayiklama' acin.
echo    3. 'Cihazi esleme koduyla esle' secenegine dokunun.
echo    4. Menuden [2] secenegini secip ekrandaki IP:Port ve 6 haneli kodu girin!
echo ======================================================================
echo.

:MENU
echo ----------------------------------------------------------------------
echo [1] Cihaz durumunu tekrar kontrol et (adb devices)
echo [2] KABLOSUZ ESLEME VE BAGLANMA (Wi-Fi Pair - Kablo Gerekmez!)
echo [3] Kayitli Wi-Fi IP ile Dogrudan Baglan (adb connect)
echo [4] Canli Godot / BolGol loglarini izle (Logcat)
echo [5] USB Baglanti ve Surucu Tehisisi Yap
echo [6] Cikis
echo ----------------------------------------------------------------------
echo.
set /p SEC="Seciminiz (1/2/3/4/5/6): "

if "%SEC%"=="1" (
    cls
    echo Bagli cihazlar:
    echo.
    "%ADB_PATH%" devices -l
    echo.
    goto MENU
)

if "%SEC%"=="2" (
    cls
    echo ======================================================================
    echo          KABLOSUZ WI-FI ESLEME (KABLO GEREKTIRMEZ)
    echo ======================================================================
    echo.
    echo 1. Tablette: Ayarlar -^> Gelistirici Secenekleri -^> Kablosuz hata ayiklama
    echo 2. 'Cihazi esleme koduyla esle' butonuna basin.
    echo 3. Tablet ekraninda beliren bilgileri girin:
    echo.
    set /p PAIR_IP="Tablette gosterilen IP:PORT (ornek: 192.168.1.45:37123): "
    set /p PAIR_CODE="Tablette gosterilen 6 haneli Wi-Fi esleme kodu: "
    echo.
    echo Esleme yapiliyor...
    "%ADB_PATH%" pair %PAIR_IP% %PAIR_CODE%
    echo.
    echo Simdi ana Kablosuz Hata Ayiklama ekranindaki 'IP adresi ve Baglanti Noktasi'
    echo kismina bakin (buradaki port esleme portundan farkli olabilir):
    set /p CONN_IP="Baglanti IP:PORT (ornek: 192.168.1.45:41235): "
    echo Baglaniliyor...
    "%ADB_PATH%" connect %CONN_IP%
    echo.
    echo Guncel Cihaz Durumu:
    "%ADB_PATH%" devices -l
    echo.
    echo [BILGI] Cihaz 'device' olarak listelendiyse Godot Editor sag ustundeki
    echo         Android (Remote Deploy) simgesine tiklayarak tablete yukleyebilirsiniz!
    echo.
    goto MENU
)

if "%SEC%"=="3" (
    echo.
    set /p TAB_IP="Tabletin Wi-Fi IP:PORT adresini girin (ornek: 192.168.1.45:5555): "
    echo Baglaniliyor...
    "%ADB_PATH%" connect %TAB_IP%
    echo.
    "%ADB_PATH%" devices -l
    echo.
    goto MENU
)

if "%SEC%"=="4" (
    echo.
    echo Canli log akisi baslatiliyor (Durdurmak icin Ctrl+C)...
    echo.
    "%ADB_PATH%" logcat -v time -s godot:V BolGol:V *:E
    goto MENU
)

if "%SEC%"=="5" (
    cls
    echo ======================================================================
    echo                USB VE SURUCU TEHISIS TESTI
    echo ======================================================================
    echo.
    echo 1. Windows Cihaz Yoneticisinde bagli Android/Samsung cihazlari araniyor...
    powershell -NoProfile -Command "Get-PnpDevice -PresentOnly | Where-Object { $_.FriendlyName -match 'Samsung|Android|Galaxy|MTP|ADB' } | Select-Object FriendlyName, Status, Class"
    echo.
    echo 2. ADB Server yeniden baslatiliyor...
    "%ADB_PATH%" kill-server
    "%ADB_PATH%" start-server
    echo.
    echo 3. Cihaz listesi:
    "%ADB_PATH%" devices -l
    echo.
    echo Eger liste hala bos ise:
    echo - Tablette Ayarlar -^> Gelistirici Secenekleri -^> 'USB Hata Ayiklama' kapali olabilir.
    echo - USB kablonuz sadece sarj kablosu olabilir (veri aktaran baska bir kablo deneyin).
    echo - VEYA en kolayi: Menuden [2] KABLOSUZ ESLEME ile kablosuz baglanin!
    echo.
    goto MENU
)

if "%SEC%"=="6" (
    exit /b 0
)

goto MENU
