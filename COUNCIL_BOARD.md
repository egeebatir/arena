# 🏛️ BOL GOL FUTBOL: ÇOKLU-AJAN MECLİSİ (COUNCIL BOARD)
> **Ekosistem Durum ve Karar Masası (Blackboard)**  
> *Son Güncelleme: 2026-09-24* | *Durum: v1.0.27 Ekosistem Sürümü Tamamlandı — Katı/Opak İçerikli 5 Yeni Kulüp Arması, Büyütülmüş Top İçi Logo & Arma Boyutlandırması, Akıllı Boyut Kısıtlamalı Takım Seçim Kaydırma Alanı, Şapka/Taç Boşluk Rahatlatmaları, Ferah Skorbord & Buton Mesafesi, Dokunsal Ayarlar Sliderları & Scroll Grabber, Sadeleştirilmiş Tek Buton Web Liderlik Tablosu Entegrasyonu (%100 Kusursuz QA Onayı)*

---

## 🧭 EKOSİSTEM VE PROJE HARİTASI

| Proje | Konum / Repo | Odak Alanı | Canlı Durum |
| :--- | :--- | :--- | :--- |
| **⚽ Mobil Oyun (futbol)** | `c:\Users\egebatir\Documents\futbol`<br>*(arena.git - master)* | Godot 4.6 GDScript, UI/UX, AdMob, Google Play | ✅ 100% Hazır (v1.0.27 Build 27 Testleri Başarılı) |
| **🎬 Otomasyon (futbol_automation)** | `c:\Users\egebatir\Documents\futbol_automation`<br>*(bolgolfutbolotonom.git - main)* | 9:16 Shorts/Reels Video, AI Metadata, Rastgele Tema & Skin | ✅ 100% Hazır (Rastgele Temalar & Top Skinleri) |
| **🌐 Web & Landing (webfutbol)** | `c:\Users\egebatir\Documents\Bol Gol Futbol\webfutbol`<br>*(webfutbol.git - main / ebstudyo.com)* | Canlı Web Sitesi (HTML5/WASM), AdSense & SEO DevLog, 136 Takım, Canlı Liderlik Tablosu | ✅ v1.0.27 Hazır (Web Liderlik Tablosu & 1-Tıkla Beta Katılım) |
| **📱 Google Play Store** | *Console / ASO (com.ebstudyo.bolgol)* | 5 Dil (TR, EN, ES, PT, IT), İkon, Tanıtım, Güncelleme Notları | 🟢 v1.0.27 Paketi Hazır (Build 27) |

---

## 👥 MECLİS AJANLARI VE SORUMLULUKLARI

1. **👑 Üst Akıl / Genel Koordinatör (`orchestrator`):**
   - Genel ekosistem stratejisini belirler, ajanlar arası görev dağıtımını yönetir.
   - Kullanıcıya yalnızca filtrelenmiş, karar gerektiren özetler sunar.

2. **⚙️ Mobil Oyun Motoru Lideri (`engine_master`):**
   - Godot 4.6, GDScript, mobil ergonomi (48x48dp, safe area, AdMob banner payları).
   - Android APK/AAB build, Android Studio AVD (x86_64/arm64) ve performans optimizasyonları.

3. **🚀 Viral Büyüme ve İçerik Direktörü (`viral_growth`):**
   - `futbol_automation` boru hattını yönetir.
   - 2026 ESPN takvim tabanlı fikstürlerinden reklamsız tam maç simülasyonları ve 9:16 dikey video üretimi.
   - YouTube Shorts, TikTok ve Instagram Reels için kancalar, müzikler ve etiketler üretir.

4. **🌐 Web ve Dağıtım Mimarı (`web_architect`):**
   - `webfutbol` (`ebstudyo.com`) HTML5 build ve web landing sayfasını yönetir.
   - Webden Google Play Store indirmelerine organik köprü kurar. AdSense onay içeriklerini zenginleştirir.

5. **🔍 Kusur Avcıları Meclisi (`adversarial_qa` - 4 Bağımsız Müfettiş):**
   - **KUSURSUZLUK İLLÜZYONUNU KIRANLAR:** Yüzeyde yeşil yanan testlerin arkasındaki gizli kusurları ararlar.
   - `inspector_engine_core`: Bellek sızıntıları, dokunmatik safe area, AdMob çökme koruması.
   - `inspector_pipeline_media`: Kırık linkler, render bozulmaları, API kota sınırları.
   - `inspector_growth_localization`: 5 dilli metin taşmaları, karakter limitleri, placeholder hataları.
   - `inspector_ecosystem_sync`: Paket adı, sürüm kodları ve çapraz repo sözleşme uyumu.

6. **📈 ASO ve Mağaza Uzmanı (`aso_specialist`):**
   - Google Play Store için 5 dilde (TR, ENG, ESP, POR, ITA) anahtar kelimeleri ve mağaza metinlerini optimize eder.
   - Sürüm güncelleme notlarını (What's New) hazırlar.

7. **📦 Sürüm & Dağıtım Bütünlük Lideri (`version_release_controller`):**
   - Yeni bir versiyon üretildiğinde 7 halkayı (Presets, Schema Migration, Web Badges, WASM Build, Automation Links, Release Notes, Git Tags) denetler ve senkronize eder.

---

## 📊 GÜNCEL PROJE DURUMU VE SON GELİŞMELER (2026-09-24)

### v1.0.25 Kapsamlı Güncellemeler ve Düzeltmeler:
- [x] **Tablet & Mobil Dikey Oryantasyon Kilidi:** Android 12L+ ve API 35 tabletlerde serbest dönmeyi engellemek adına `AndroidManifest.xml` içinde `android:resizeableActivity="false"` ve `android:screenOrientation="portrait"` tanımlandı; `Global.gd` açılışında `DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)` devreye sokularak oyun her cihazda kusursuz dikey modda sabitlendi.
- [x] **AdMob Adaptive Banner & Genişletilmiş House Ads Barı:** Tablet ve geniş ekranlarda 320x50'lik ufak kalan banner istekleri `LoadAdRequest.RequestedAdSize.ADAPTIVE` boyutuna geçirilerek tam genişliğe oturtuldu. House Ads paneli `SIZE_EXPAND_FILL` ile ekran genişliğine dinamik uyarlandı.
- [x] **Gizlilik Politikası 404 Kırık Link Onarımı:** Karşılama ekranı ve ana menüdeki gizlilik linki `https://ebstudyo.com/privacy.html` olarak düzeltildi; web tarafında `/gizlilik-politikasi` dizini kalıcı olarak `/privacy.html` sayfasına yönlendirildi.
- [x] **Açılış ve Fizik Performans Optimizasyonları:**
  - `Global.gd` içindeki 136 takım logosunun senkron yükleme döngüsü lazy on-demand loader (`Global.get_team_logo()`) ile değiştirildi; açılış süresi ve RAM tüketimi minimize edildi.
  - `ball.gd` içindeki 113 adımlık dikey çizgi ve `sqrt()` çizim döngüsü 3 adet poligon çizim çağrısına (`draw_colored_polygon`) indirgendi.
- [x] **Tribün Taraftar Mimarisi Revizyonu (`StadiumCrowd`):**
  - Taraftarlar ~1.8 kat büyütüldü (16-18px gövde, 6.5-7.5px kafa).
  - Ev sahibi (sağ tribün) ve deplasman (sol tribün) olarak canlı forma renklerine ayrıldı.
  - Saat 12 ve 6 yönlerine çelik güvenlik bariyerleri ve neon yelekli güvenlik görevlileri eklendi.
  - Taraftarların ellerine çift renkli atkılar ve dalgalanan takım bayrakları yerleştirildi.
  - Saha yarıçapı (279px) ile taraftarlar (319-347px) arasında 32px güvenlik marjı bırakılarak sahaya taşma sıfırlandı.
  - 60 FPS CPU çizim döngüsü yerine ambient modda ~11 FPS, gol sevincinde ~30 FPS dinamik hızlandırma entegre edilerek CPU yükü %80 azaltıldı.
- [x] **Gol Popup ("GOL!") Matematiksel Merkezleme:** `event_lbl` etiketinin gerçek metin boyutları üzerinden `pivot_offset = act_size / 2.0` hesaplanarak sahanın tam merkez noktasına (`CENTER`) kilitlendi.
- [x] **Ghost Screen (İskelet Yükleme Ekranı):** Sekmeler arasında geçiş yapılırken veya ilk yüklemede aktif temayla uyumlu parıldayan iskelet şablonları gösterildi; sekme hazır olunca 0.15s yumuşak geçişle açıldı.
- [x] **Otomasyon Rastgele Tema ve Top Skinleri:** `match_recorder.py` içine rastgele tema ve `Global.BALL_SKINS` rastgele skin desteği entegre edildi; aksesuarlar/şapkalar kapalı tutuldu.
- [x] **Web Canlı Maç Sayacı Koruması:** `deploy.py` scriptindeki `IGNORE_FILES` listesine `stats.json` eklenerek canlı sunucu sayacının deploy sırasında ezilmesi engellendi.
### v1.0.26 Kapsamlı İyileştirmeler ve Mobil/Web Entegrasyonu (2026-09-24):
- [x] **Tribün Taraftarlarının Askıya Alınması (`pitch.gd`):** Kullanıcı geri bildirimi ve cihaz performans testleri doğrultusunda `StadiumCrowd` sahadan askıya alındı (`add_child` devre dışı); sıfır performans kaybı garantiye alınırken tasarımcı ajanlar için estetik prototip havuzu oluşturuldu.
- [x] **Top İçi Takım Armaları & 5 Yeni Orijinal Arma:**
  - `ball.gd` içinde `logo_size` (70x70) ve `badge_size` (74x74) boyutlarına çıkarılarak 113px'lik topların tam ortasına net ve okunaklı biçimde oturtuldu. `main_menu.gd` önizleme toplarında 70x70 merkezli çizim uygulandı.
  - Barcelona için 1:1 kopyayı önleyen orijinal arcade tarzı kalkan arması (`bar1.png`) üretildi ve entegre edildi.
  - **PSG** (`psg1.png`), **Bayern Münih** (`bay1.png`), **BvB** (`bvb1.png`) ve **Miami Inter** (`mia1.png`) için 800x800 şeffaf alfa kanallı Bol Gol stilinde armalar üretilip `BADGE_MAP` ve menü önizlemelerine eklendi.
- [x] **Seçili Ligin Kalıcı Olarak Saklanması:** Maçtan ana menüye dönüldüğünde lig filtresinin Türkiye Ligi'ne sıfırlanması sorunu çözüldü; `Global.last_selected_league_home` ve `Global.last_selected_league_away` değişkenleri ile en son seçilen lig menü yeniden açıldığında otomatik olarak geri yüklendi.
- [x] **Maç Ekranı Skorbord, Buton Hizalamaları ve Çizgi Uyumları:**
  - Skorbord, çıkış (`<`) ve durdurma (`||`) butonları `top_header_margin` (margin_top = 58) altında tek bir merkezlenmiş `HBoxContainer` içine toplandı (aralarındaki mesafe 16px'e çekilerek tabletlerdeki devasa boşluk yok edildi).
  - Skorbord paneli, çıkış ve durdurma butonlarının çerçeveleri `active_theme.accent` ile tam tema uyumlu hale getirildi; metin kenarlıklarında uyumsuz beyaz yerine koyu kontrast (`Color8(12, 18, 28, 240)`) uygulandı.
  - Saha dikey konumu (`CENTER.y`) 34px yukarı kaydırıldı.
  - Maç sonu "Yeniden Oyna" butonu sahadan daha uzağa (`ARENA_RADIUS + 115.0`) taşınarak saha çemberiyle buton arasındaki mesafe genişletildi.
- [x] **Ana Menü Alt Banner Sızıntı Koruması:** Hızlı çıkışlarda maç ekranından kalan in-flight `BOTTOM` banner reklamlarının ana menüde belirmesi engellendi; `pitch.gd` ve `main_menu.gd` içine sahne ve `AdPosition.BOTTOM` denetimleri eklenerek gereksiz alt banner'lar anında imha edildi.
- [x] **Web Küresel Liderlik Tablosu & Oyun İçi Köprü:** `webfutbol` üzerinde responsive, karanlık cam tasarımında `liderlik-tablosu/index.html` oluşturuldu; ana menüdeki "DÜNYA SIRALAMASINI GÖR" ve yeni eklenen "CANLI WEB LİDERLİK TABLOSU" butonları bu sayfaya bağlandı.
- [x] **Tek Tıkla Beta Test Kullanıcısı Olma (Frictionless Opt-in):** Google Grubu linkinin karışıklığını gidermek için `api/join_test.php` uç noktası kuruldu; web sitesindeki test penceresine Gmail adresini girip tek tıkla katılım sağlayan form ve doğrudan Google Play indirme linki yerleştirildi.
- [x] **Tablet & Web Ekran Responsive Düzen Revizyonu:** Tablette "MAÇI BAŞLAT" butonunun ekran altına taşması ve maça girilememesi sorunu kökten çözüldü; `scroll_both` kapsayıcısı `SIZE_EXPAND_FILL` ve dinamik `max_w` ile esnetildi, sütun içi boşluklar sıkılaştırıldı ve `start_btn` `SIZE_SHRINK_END` ile alt gezinme çubuğunun hemen üzerine sabitlenerek her ekran boyunda %100 görünür kılındı.
- [x] **Kaydırma İpuçları (Scroll Grabber):** Takım listesi kaydırma çubuğuna tema renginde zarif 6px yuvarlatılmış grabber pill eklendi.
- [x] **Menü Fon Müziği Ses Seviyesi:** `Global.gd` ve `main_menu.gd` içindeki baz menü müziği çarpanı %5 artırılarak `1.06`'dan `1.113`'e yükseltildi.
- [x] **Versiyon Güncellemesi (v1.0.26):** Sürüm kodu 26, sürüm adı "1.0.26" (`export_presets.cfg` ve `welcome_screen.gd`) olarak yükseltildi.

### v1.0.27 Kapsamlı Kulüp Armaları, Mobil UI/UX Ferahlatmaları & Release Hazırlığı (2026-09-24):
- [x] **Arma İçi Opaklık Kusurunun Giderilmesi (%100 Solid Interiors):** 5 yeni armanın (`bar1`, `psg1`, `bay1`, `bvb1`, `mia1`) içindeki koyu renk detayların eşikleme yüzünden silinmesi/şeffaflaşması sorunu tamamen çözüldü; dış çevre kontur maskesi ve anti-aliased sınır yumuşatma ile armaların içi %100 katı/opak, dış arka planı ise %0 tam şeffaf hale getirilerek 800x800 RGBA olarak yeniden üretildi.
- [x] **Top İçi Logo & Arma Boyutlandırması:** 113px çapındaki toplarda armaların küçük kalmaması için `ball.gd` içindeki `badge_size` 82x82, `logo_size` 80x80; `main_menu.gd` önizlemesinde ise 78x78 ve 76x76 olarak büyütüldü ve tam merkezlendi.
- [x] **Takım Seçim Listesi Boyut Kısıtlaması & Başlık Boşlukları:** `scroll_both` kapsayıcısının mobil ekranı boydan boya kaplaması engellendi; mobilde ekran yüksekliğine göre (260-360px), tablette (280-520px) sınırlandırıldı. Takım başlığı ile top önizlemesi arasındaki boşluk 28px'e, top ile favorim yap arasındaki boşluk 14px'e çıkarılarak aksesuarların (taç/kask/şapka) takım isimleriyle çakışması sıfırlandı.
- [x] **Saha Skorbord ve Yan Buton Mesafesi:** Skorbord paneli iç yatay marjinleri 28px'e, skorbord içi öğeler arası boşluk 18px'e, çıkış (`<`) ve durdurma (`||`) butonlarıyla skorbord arası mesafe 24px'e çıkarılarak ferahlatıldı.
- [x] **Ayarlar Menüsü Scroll Grabber & Dokunsal Sliderlar:** Ayarlar menüsüne ana ekrandaki gibi 6px tema uyumlu scroll grabber eklendi. Ses, müzik ve maç süresi kaydırma çubukları (`HSlider`) modern ray yapısı ve yüksek DPI dokunsal yuvarlak tutamaç (grabber disc) ile yenilendi.
- [x] **Google Play Başarımları Entegrasyonu:** Ayarlardaki başarımlar butonuna otomatik servis başlatma ve oturum açma denetimi bağlandı.
- [x] **Liderlik Tablosu Tek Buton Sadeleştirmesi:** 2 ayrı buton yerine doğrudan web liderlik tablosuna (`https://www.ebstudyo.com/liderlik-tablosu/`) yönlendiren tek ve belirgin "KÜRESEL LİDERLİK TABLOSU ↗" butonu konumlandırıldı.
- [x] **Versiyon Yükseltmesi (v1.0.27):** Sürüm kodu 27, sürüm adı "1.0.27" (`export_presets.cfg`, `welcome_screen.gd`, `COUNCIL_BOARD.md`).

---

## 🛡️ ADVERSARIAL QA ONAY GÜNLÜĞÜ (AUDIT LOG)

* **2026-09-24 19:20:** `futbol`: `python tests/test_backend_logic.py` çalıştırıldı — **Tüm Motor, Menü, Kontrast ve Tema Testleri Başarılı (%100 PASS)**.
* **2026-09-24 19:20:** `futbol`: `python tests/test_ecosystem_health.py` çalıştırıldı — **4/4 Ekosistem Testi Başarılı (%100 PASS)**.
* **2026-09-24 19:20:** `futbol`: `python tests/test_version_integrity.py` çalıştırıldı — **6/6 Sürüm ve Paket Bütünlüğü Başarılı (%100 PASS)**.
* **2026-09-24 19:20:** 5 Kulüp Arması Şeffaflık Denetimi: `bar1`, `psg1`, `bay1`, `bvb1`, `mia1` için iç şeffaflık sıfır (0), tam katı opaklık (%100) doğrulandı.
* **Genel QA Statüsü:** 🏛️ **YEŞİL (v1.0.27 Sıfır Hata & Sıfır Nil ile Doğrulandı)**.

