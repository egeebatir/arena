# 🏛️ BOL GOL FUTBOL: ÇOKLU-AJAN MECLİSİ (COUNCIL BOARD)
> **Ekosistem Durum ve Karar Masası (Blackboard)**  
> *Son Güncelleme: 2026-09-27* | *Durum: v1.1.2 (Build 32) Ekosistem Sürümü Google Play & Git'e Dağıtıldı — Jeton Tüketimi, Resmi Jeton İkonu, Sabit Mağaza Başlığı, Tablet Kaydırma & Yön Kilidi*

---

## 🧭 EKOSİSTEM VE PROJE HARİTASI

| Proje | Konum / Repo | Odak Alanı | Canlı Durum |
| :--- | :--- | :--- | :--- |
| **⚽ Mobil Oyun (futbol)** | `c:\Users\egebatir\Documents\futbol`<br>*(arena.git - master)* | Godot 4.6 GDScript, UI/UX, AdMob, Google Play | ✅ 100% Hazır (v1.1.2 Build 32 Dağıtıldı) |
| **🎬 Otomasyon (futbol_automation)** | `c:\Users\egebatir\Documents\futbol_automation`<br>*(bolgolfutbolotonom.git - main)* | 9:16 Shorts/Reels Video, AI Metadata, Rastgele Tema & Skin | ✅ 100% Hazır (46 Milli Takım, 232 Takım Eşleşmesi) |
| **🌐 Web & Landing (webfutbol)** | `c:\Users\egebatir\Documents\Bol Gol Futbol\webfutbol`<br>*(webfutbol.git - main / ebstudyo.com)* | Canlı Web Sitesi (HTML5/WASM), On-Demand Yükleme, Kapalı Beta Hunisi & SEO | ✅ v1.1.0 Hazır (Canlı Sunucuya Dağıtıldı) |
| **📱 Google Play Store** | *Console / ASO (com.ebstudyo.bolgol)* | 5 Dil (TR, EN, ES, PT, IT), İkon, Tanıtım, Güncelleme Notları | 🟢 v1.1.2 Paketi Yayında (Build 32) |

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

### v1.0.28 Dinamik Liderlik, Pro VIP Üst Bar & %80 Hafifletilmiş Armalar (2026-09-24):
- [x] **Hızlı Maç Çıkışında Alt Banner Sızıntı Koruması (`main_menu.gd` & `pitch.gd`):** Maçtan hızlı çıkış yapıldığında maçın `BOTTOM` banner reklamının ana menüde görünmesi sorunu çözüldü; `_clean_match_banner()` içinde `remove_banner_ad` çağrısı düzeltildi, `main_menu.gd` banner yüklendiğinde pozisyon kontrolü yapılarak alt banner derhal imha edilip yerine üst banner istendi.
- [x] **Web Canlı Liderlik Tablosu ve Skor Senkronizasyon Koruması:**
  - `webfutbol/liderlik-tablosu/index.html` içindeki tüm mock/sahte oyuncu ve kulüp satırları kaldırıldı; tablo doğrudan `api/sync_score.php` (ve `leaderboard.json`) üzerinden gerçek oyuncularla dinamik dolduruldu.
  - Oyunda favori takım seçmeden veya boş kadroyla "Skoru Senkronize Et" butonuna basan oyunculara 5 dilde (TR, ENG, ESP, POR, ITA) uyarı bildirimi (`_show_toast`) gösterildi.
  - `webfutbol/deploy.py` içindeki `IGNORE_FILES` listesine `leaderboard.json` eklenerek canlı oyuncu verilerinin deploy sırasında silinmesi engellendi.
- [x] **Saha Butonlarında Sabit Tema Rengi (`pitch.gd`):** Maça başlarken temanın rastgele seçilmesi (`active_theme` override) kaldırıldı; saha içi butonlar ve arayüz kesin olarak kullanıcının seçtiği aktif tema rengini benimsedi.
- [x] **Pro VIP Özel Üst Bar (`main_menu.gd`):** Reklam alanı kapalı olan Pro üyeler için ana menünün üst boşluğuna özel etkileşimli altın kart yerleştirildi; Kaptan Adı, Favori Kulüp ve 5 dilde aktif VIP avantajları dinamik olarak gösterildi.
- [x] **Şanslı Çark Tekli Çevirme Güvencesi (`main_menu.gd`):** Ödüllü reklam izlendikten sonra çark dönerken tekrar çevirme butonuna basılması ve hakların karışması engellendi; çark dönmeye başladığı anda buton kilitlendi ve ad spin hakkı anında tüketildi.
- [x] **Kusursuz 800x800 Kulüp Arması Sıkıştırması (%80 Boyut Tasarrufu):** 5 yeni kulüp arması (`bar1`, `psg1`, `bay1`, `bvb1`, `mia1`) ve 300 KB üzeri ağır armalar, 800x800 tuval boyutu ve görsel keskinlik korunarak, iç şeffaflık sıfır (%100 opak) ve dış şeffaflık %100 olacak şekilde 256 renk palet optimizasyonuyla ~1 MB'tan 140-250 KB seviyesine düşürüldü.
- [x] **Versiyon Yükseltmesi (v1.0.28):** Sürüm kodu 28, sürüm adı "1.0.28" (`export_presets.cfg`, `welcome_screen.gd`, `COUNCIL_BOARD.md`).

### v1.0.29 Web SEO Güçlendirmesi, Kapalı Beta Test Dönüşümü & On-Demand Web Oyun Yükleme (2026-09-25):
- [x] **Web Sitesi SEO & App Indexing Güçlendirmesi:**
  - Google App Indexing için `.well-known/assetlinks.json` eklendi; `deploy.py` FTP filtrelemesi `.well-known` dizinini aktaracak şekilde güncellendi.
  - Tüm subpageler (`/liderlik-tablosu/`, `/devlog/`, `/hakkimizda/`, `/nasil-oynanir/`, `/gizlilik-politikasi/` vb.) taranabilir `sitemap.xml` haritasına eklendi.
  - 5 dilli hreflang etiketleri (`tr`, `en`, `es`, `x-default`) ve dürüst `MobileApplication` Schema.org yapılandırılmış verisi entegre edildi.
- [x] **50 MB WASM/PCK On-Demand Yükleme (Site Hafifletme):**
  - Sayfa açılışında otomatik 50 MB indiren `engine.startGame` çağrısı, tuval üzeri "Web Sürümünü Başlat" etkileşimine bağlandı; ilk sayfa yükleme boyutu %99 hafifletildi (<500 KB).
  - `#game-wrap`, canvas, fullscreen ve mobil dokunmatik kontroller hiçbir özellik kaybı yaşanmadan %100 korundu.
- [x] **Ana Ekran (Hero) ve Navigasyon Kapalı Beta Dönüşümü:**
  - Birincil odak Google Play 14 günlük kapalı beta sürecine (12 testçi gereksinimi) çevrildi.
  - 1. Test Grubuna Katıl (`bol-gol-futbol-test`) ve 2. Google Play'de İndir (`play.google.com/apps/testing/...`) 2 adımlı net başvuru kurgulandı; webde oynama seçeneği ikincil buton olarak korundu.
- [x] **Versiyon Yükseltmesi (v1.0.29):** Sürüm kodu 29, sürüm adı "1.0.29" (`export_presets.cfg`, `welcome_screen.gd`, `webfutbol`, `COUNCIL_BOARD.md`).
### v1.1.0 40 Yeni Milli Takım, Küresel Fikstür Uyumu & v1.1.0 Sürüm Yükseltmesi (2026-09-25):
- [x] **40 Yeni Milli Takım Entegrasyonu (Toplam 46 Milli Takım):**
  - Fransa, İspanya, Almanya, Belçika, Hollanda, Hırvatistan, Danimarka, İsviçre, Avusturya, Polonya, Sırbistan, Çekya, İskoçya, Norveç, Brezilya, Uruguay, Kolombiya, Şili, Paraguay, Ekvador, Nijerya, Fas, Mısır, Senegal, Cezayir, Kamerun, Gana, Japonya, Güney Kore, Suudi Arabistan, İran, Avustralya, Katar, Meksika, Kanada, Gürcistan, İsveç, Yunanistan, Romanya, Galler oyuna dahil edildi.
  - Her takımın orijinal bayrak ve forma renk kombinasyonları `Global.gd` içine `Color8()` paletleriyle tanımlandı; armasız toplarda olduğu gibi dinamik şeritli ve estetik renklerle çizilmesi sağlandı.
  - Takım seçim ekranında (`main_menu.gd`) "Milli Takımlar" (`NATIONAL`) filtresi seçildiğinde 46 milli takımın tamamı dinamik olarak listelenip hem Ev Sahibi hem Deplasman tarafında seçilebilir hale geldi.
- [x] **Otomasyon & Veritabanı Eşleşmesi (`team_mapping.json` & `star_players.json`):**
  - `team_mapping.json` içine 40 yeni milli takımın tüm uluslararası takma adları, resmi kodları ve yerel adları (Fransa/France/Les Bleus, Brezilya/Brazil/Seleção, vb.) eklendi; toplam takım sayısı 232'ye ulaştı.
  - `star_players.json` ve `fixtures.json` içine 40 ülkenin en güncel 3 yıldız oyuncusu ve kaptanları mühürlendi (Mbappé, Yamal, Musiala, De Bruyne, Haaland, Vinícius Jr., Salah, Osimhen, Son Heung-min vb.).
- [x] **Kalıcı Kurallar Güncellemesi (`rules.md` & `GEMINI.md`):**
  - UEFA Uluslar Ligi ve Dünya Kupası Elemeleri için 46 milli takımın tüm maçları zorunlu kapsam haline getirildi.
- [x] **Versiyon Yükseltmesi (v1.1.0):** Sürüm kodu 30, sürüm adı "1.1.0" (`export_presets.cfg`, `welcome_screen.gd`, `COUNCIL_BOARD.md`).

---

## 🛡️ ADVERSARIAL QA ONAY GÜNLÜĞÜ (AUDIT LOG)

* **2026-09-24 20:03:** `futbol`: `python tests/verify_ecosystem_hard.py` çalıştırıldı — **4 GATEDE %100 BAŞARI (Zero Defects, 120 Frame Headless Godot, Web 200, Medya, Shop & Armalar PASS)**.
* **2026-09-24 20:03:** `futbol`: `python tests/test_backend_logic.py` çalıştırıldı — **Tüm Motor, Menü, Görev, Kontrast ve Tema Testleri Başarılı (%100 PASS)**.
* **2026-09-24 20:03:** `futbol`: `python tests/test_ecosystem_health.py` çalıştırıldı — **4/4 Ekosistem Testi Başarılı (%100 PASS)**.
* **2026-09-24 20:03:** `futbol`: `python tests/test_version_integrity.py` çalıştırıldı — **6/6 Sürüm ve Paket Bütünlüğü Başarılı (%100 PASS)**.
* **2026-09-24 23:55:** `futbol_automation`: Sentetik ve kaydırılmış fikstür kalıntıları tamamen çöpe atıldı. 2026-09-24 sonrası tamamen oynanmamış, doğrudan ESPN REST API scoreboard takvimlerinden (Game ID onaylı) çekilen kesin 30 maçlık fikstür kuyruğu oluşturuldu (11 Yıldız Kulüp, Milli Takımlar, UCL/UEL ve Süper Lig Wildcard kuralları %100 uygulandı).
* **2026-09-25 00:28:** `futbol_automation`: Sıralı arşiv kodlama sistemi (`0001` - `0030`) devreye alındı. İlk maç olan Inter Miami maçı `0001` kodu ile simüle edildi, arşive işlendi ve sistem otomatik olarak sıradaki maçı `0002` (Galatasaray vs Kasımpaşa) olarak sıraya aldı (%100 End-to-End PASS).
* **2026-09-25 00:32:** `futbol_automation`: Yeni fikstürün ilk iki maçı (`0001` Columbus Crew vs Inter Miami & `0002` Galatasaray vs Kasımpaşa) başarıyla simüle edildi; 60 FPS reklamsız Godot kayıtları, 9:16 dikey dinamik zoom hook video kurguları, özel kapak görselleri ve AI metadataları üretilip arşive mühürlendi (%100 PASS).
* **2026-09-25 01:40:** `futbol_automation`: 6 maç simüle edilip YouTube'a yüklendi (`0003` - `0008`).
* **2026-09-25 01:55:** `futbol_automation`: Fikstür mimarisi ve etiket/yayın kuralları revize edildi:
  - **Eksik Avrupa & Milli Maçlar Giderildi:** ESPN scraper'ının sadece 5 yerel lig çekip 30 maçta durması sorunu çözüldü; UEFA Champions League, UEFA Europa League, Türk Milli Takımı ve Avrupa Marquee Gösteri maçları (Barcelona vs Galatasaray & Real Madrid vs Fenerbahçe) dahil 124 maçlık kusursuz master fikstür takvimi oluşturuldu (`0009` - `0124`).
  - **Maç Günü Maç Öncesi Yayın Kuralı (Kickoff - 2 Saat):** Videoların rastgele günlere yayılması durduruldu; tüm yayınlar resmi maç günü başlama düdüğünden tam 2 saat önce (`kickoff - 2 saat`) yayına girecek şekilde otomatik kurgulandı.
  - **Maç-Öncelikli Etiket Hiyerarşisi:** Açıklamalardan ve YouTube etiketlerinden silinen takım, golcü ve turnuva etiketleri en başa alındı; jenerik stüdyo etiketleri en sona taşındı ve spamsizleştirildi.
  - `sync_uploaded_videos.py` hazırlandı; `GEMINI.md` ve `config/rules.md` belgelerine yeni kurallar işlendi.
* **2026-09-26 00:53:** `webfutbol`: `v1.0.30` Akıllı Köprü Basitleştirmesi, Kalıcı Durum Takibi (localStorage) & GitHub Senkronizasyonu — **%100 BAŞARI (PASS)**:
  - **Sıfır Bilişsel Yük & Basitleştirilmiş Akış:** Kullanıcıların adımları tekrar tekrar görmemesi için `localStorage` tabanlı kalıcı durum yönetimi (`eb_beta_step1_done`) eklendi. Kullanıcı bir kez 1. Adımı tamamladığında veya geri döndüğünde 1. Adım otomatik olarak `✓ YETKİLENDİRİLDİ` durumunda kalır ve 2. Adım ("Hemen Google Play'den İndir ➔") doğrudan parlak yeşil odakla sunulur.
  - **Kutlama ve Doğrudan İndirme Kartı:** 1-tıkla Gmail kayıt formu gönderildiğinde form kaybolur; yerine büyük yeşil onay kartı ve doğrudan `Google Play'de Aç ve İndir ➔` butonu çıkar.
  - **Hero Rozet Entegrasyonu:** `founder-reward-badge` ("🎁 İlk 50 Testçiye Özel: 'Öncü Testçi' Altın Topu & Kurucu Rozeti Hediye!") Hero DOM yapısına tam entegre edildi.
  - **Tüm Doğrulamalar Tamam:** `validate_js.js` (4/4 script bloğu geçerli), `validate_html.py` (0 açık etiket), `verify_translations.py` (111/111 anahtar tam), canlı güvenlik ve DOM denetimleri %100 başarılı.
* **2026-09-26 01:20:** `futbol`: **Kritik Çökme Onarımı, Tablet/Mobil Responsive Mimari, 40 Milli Takım Bayrağı, Obsidyen Topu, Hızlı Yükleme & Web Senkronizasyon Revizyonu — %100 BAŞARI (PASS)**:
  - **Ödül Toplama Çökmesi Giderildi (Tween SIGSEGV Fix):** `main_menu.gd` `_show_prize_dialog` içinde oluşturulan coin döngü ve pop tween'leri `overlay.create_tween()` ile bağlanıp `coin_img` ve `overlay.tree_exiting` sinyallerine bağlandı; "HARİKA!" butonuna basıldığında tween'ler güvenle imha edilerek C++ `SceneTreeTween` null-pointer çökmesi sıfırlandı.
  - **Tablet & Mobil Responsive Düzen (Kökten Çözüm):** Samsung Galaxy Tab S6 Lite (16:10 / 5:3) ve dikey mobil cihazlar için dinamik oran denetimi (`is_tablet = vp_h / vp_w < 1.9`) getirildi. `scroll_both` kapsayıcısı `SIZE_EXPAND_FILL` ile dinamik esnetildi, takım seçim butonları 76px'den 52px (tablet) ve 64px (mobil) yüksekliğe çekildi. "MAÇI BAŞLAT" butonu `SIZE_SHRINK_END` ile alt navigasyon barının hemen üzerine sabitlendi; ekrandan taşma ve gizlenme sorunu tamamen ortadan kaldırıldı.
  - **İstatistik Ekranı Kaydırma Kilidi & Kart Orantısı:** `_build_stats_tab` içindeki `SCROLL_MODE_DISABLED` hatası `SCROLL_MODE_SHOW_NEVER` ile değiştirilerek dikey kaydırma aktif edildi. İstatistik kutucukları, font boyutları ve padding değerleri küçültülerek tek ekranda favori takım ve genel istatistiklerin bir arada görünmesi sağlandı.
  - **Mağaza Ekranı Carousel ve Kart Boyutlandırması:** Mağazadaki devasa 215x290 boyutundaki top ve taç kartları 168x225'e, önizleme topları 80x80'e küçültüldü. Pro Pass paneli ve hızlı ödül butonları optimize edildi; birden fazla ürün tek bakışta görünür hale getirildi.
  - **40 Yeni Milli Takım Bayrak Rozeti:** 40 ülkenin bayrakları FlagCDN üzerinden indirilip 512x512 antialiased yuvarlak alfa maskeli PNG olarak üretildi (`fra1.png`, `esp1.png`, ..., `wal1.png`). `ball.gd` `BADGE_MAP` ve menü önizlemelerine bağlandı.
  - **Açılış Hızlandırması & Yumuşak Sahne Geçişleri:** Açılışta 31 senkron `load()` çağrısı on-demand `get_badge_texture` önbelleği ile değiştirilerek 3-4 saniyelik açılış gecikmesi sıfırlandı. Sahneler arası neon futbol topu animasyonlu `Global.change_scene_with_loading` yükleme ekranı entegre edildi.
  - **Yeni Top Görünümü ("Obsidyen"):** Prosedürel mor lav/kristal parıltılı obsidyen topu `Global.gd` içine eklendi; 5 dilde (TR, ENG, ESP, POR, ITA) mağaza ve dil sözlüklerine kaydedildi.
  - **Google Play Pro Pass Satın Alım Geri Bildirimi & Debug Test Modu:** Satın alma penceresinde yanıt vermeme sorunu çözüldü; `ITEM_UNAVAILABLE` ve bağlantı hataları için bilgilendirici toast'lar eklendi, `OS.is_debug_build()` modunda test amaçlı tek tıkla Pro Pass açma butonu sunuldu.
  - **Web Liderlik Tablosu Senkronizasyonu:** Oyuncunun kadro düzenlemesi yapmamış olsa dahi favori takımıyla attığı golleri eşitleyebilmesi sağlandı; `recalculate_favorite_team_goals()` çağrısı, `User-Agent: BolGolFutbol-Android/1.1.0` başlığı ve başarılı/başarısız senkronizasyon toast bildirimleri eklendi.
  - **Tablet Debug Aracı:** `debug_tablet.bat` scripti oluşturuldu; USB ve Wi-Fi ADB durumu, cihaz yetkilendirme ve Godot Remote Deploy tek tıkla kullanıma hazırlandı.
  - **Doğrulamalar:** `python tests/test_backend_logic.py` (5 dil, 155 anahtar, AdMob, motor testleri %100 PASS) ve Godot 4.6.1 headless syntax kontrolü (0 hata) başarıyla tamamlandı.
* **2026-09-26 03:36:** `webfutbol`: `v1.0.30` Ses İzolasyonu (Sıfır İstenmeyen Ses), Görsel Sadeleştirme & Tek Parça VIP Test Merkezi — **%100 BAŞARI (PASS)**:
  - **Kaydırırken Ses Çalma Hatası Kökten Çözüldü:** `weboyun1.js` (315 KB) `<head>` etiketinden tamamen kaldırıldı. Sayfa açılışında Godot motoru veya ses nesnesi kesinlikle yüklenmez; oyun motoru yalnızca `#oyna` bölümündeki "Web Sürümünü Başlat" butonuna tıklandığında dinamik olarak yüklenir. Sayfada kaydırma veya dokunma esnasında `AudioContext` tetikleyen tüm olay dinleyicileri kaldırıldı.
  - **Hero Alanı Temizlendi & Profesyonelleştirildi:** Sayfanın üst kısmını amatör gösteren 6 gri platform hap etiketi (`.hero-badges`) tamamen çöpe atıldı. 3 kafa karıştırıcı buton yerine 2 net ve kararlı buton (`[Test Sürümünü İndir]` ve `[Web'de Dene]`) bırakıldı. Alt başlık bürokratik dilden kurtarılıp oyuncu odaklı ve akıcı hale getirildi.
  - **Tek Parça VIP Beta İndirme Merkezi (`.gp-hub-card`):** Sayfada üst üste binen 2 ayrı form kutusu, devasa kafa karıştırıcı kartlar ve modal zorunluluğu kaldırıldı. Bunun yerine tek bir cam dokulu modern merkez kartı tasarlandı:
    - Kullanıcı tek satırda Gmail'ini yazıp **`Teste Katıl & İndir ➔`** butonuna basarak anında kaydolabiliyor.
    - Doğrudan link tercih edenler için alt kısımda zarif `[1. Gruba Katıl]` ve `[2. Google Play'den İndir]` butonları konumlandırıldı.
  - **Canlı Dağıtım & Git Push:** `deploy.py` ile canlı `ebstudyo.com` sunucusuna yüklendi; `861aaaa` commit'i GitHub `origin/main` deposuna başarıyla pushlandı. Canlı üretim denetimi (`verify_live_declutter.py`) %100 yeşil onaylandı.
* **2026-09-27 00:30:** `futbol`: **6 Milli Takım Bayrağı, Scroll Grabber Revizyonu, Şans Çarkı Reklam Koruması, Maç Token Ekonomisi & Mağaza Standardizasyonu — %100 BAŞARI (PASS)**:
  - **İlk 6 Milli Takım Bayrak Standardizasyonu:** Türkiye, Arjantin, Portekiz, İngiltere, ABD ve İtalya'nın eski kulüp tarzı armaları arşiv klasörüne (`archive/legacy_national_crests/`) yedeklendi; yerlerine 256x256 antialiased dairesel bayrak grafikleri entegre edildi. `ball.gd` ve `main_menu.gd` içindeki `is_original_national` istisnası kaldırılarak tüm 46 milli takımın aynı kural ve dairesel bayrakla topu kaplaması sağlandı.
  - **Scroll Grabber Küçültme:** Ana menü takım seçim listesi (`scroll_both`) ve Ayarlar menüsü (`v_sc_set`) kaydırma tutamaçları (grabber pill), negatif expand marjinleri (`expand_margin_top/bottom: -14` ve `-18`) ve inceltilmiş ray yapısı ile daha kompakt, zarif ve modern mobil standartlara getirildi.
  - **Şans Çarkı Döndürme & Reklam Çakışma Koruması:** GDScript lambda kapanımında ilkel tip kopyalama hatası (`is_spinning`) sözlük referans nesnesine (`spin_state["is_spinning"]`) dönüştürülerek çözüldü. Çark dönerken buton kilitlenip "ÇARK DÖNÜYOR..." durumuna geçer; ödül teslim edilip çark durana kadar asla yeni bir reklam tetiklenemez.
  - **Maç Token Ekonomisi & Günlük 5 Ücretsiz Hak:** Günlük 5 ücretsiz maç hakkı getirildi (her gece 00.00'da sıfırlanır). 5 hak bittikten sonraki her maç için 50 jeton istenir. Pro Pass üyelerine sınırsız ücretsiz maç hakkı tanınır. Maç hakkı/jeton tüketimi, maça giriş anında değil; oyuncunun mağdur olmaması adına **yalnızca maç sonuna kadar oynanıp FULLTIME düdüğü çaldığında** gerçekleşir.
  - **Mağaza Ekranı Jeton Butonu ve Ayırıcı Çizgi Standardizasyonu:** Sol üstteki jeton butonu, İstatistikler ve Takım Seçim menülerindeki buton mimarisine (`active_theme.bg_bottom.darkened(0.2)`, `active_theme.accent`, 125x56 boyut) uygun hale getirilerek temayla dinamik etkileşimli yapıldı. Mağaza başlığı ile alt butonlar arasına tema uyumlu `shop_sep` ayırıcı çizgisi eklendi; ekranlar arası görsel ritim eşitlendi.
  - **Ana Ekran Maçı Başlat Butonu & Nav Bar Mesafesi:** `post_start_spacer` mesafesi 16px'den 24px'e (mobilde) ve 12px'den 18px'e (tablette) çıkarılarak alt gezinme çubuğu ile buton arasındaki dokunma ve görüş mesafesi ferahlatıldı.
  - **Tüm Doğrulamalar:** `verify_ecosystem_hard.py` (4 Kapı %100 PASS, 120 Frame Godot simülasyonu, 0 NIL hatası), `test_backend_logic.py` (%100 PASS), `test_ecosystem_health.py` (%100 PASS) ve `test_version_integrity.py` (%100 PASS) eksiksiz onaylandı.
* **2026-09-27 01:20:** `webfutbol`: **Agar.io Esinlenmeli Canlı Arena Arkaplanı, Hero Metin Temizliği, Sadeleştirilmiş Navbar, Sürtünmesiz Google Play Akışı, PC Dikey Telefon Mockup'ı & Sosyal Medya/Simülasyon Trafik Hub'ı — %100 BAŞARI (PASS)**:
  - **Agar.io Tarzı Canlı Arena Simülatörü (`hero-arena-canvas`):**
    - Arka planda rastgele durağan görsel yerine oyunun gerçek dairesel sahalarından oluşan, takımların (GS, FB, BJK, TS, RMA, BAR, MCI, TUR, POR, BRA, ARG) birbirine karşı gerçek 2D elastik fizik ve top fiziğiyle maç yaptığı ultra hafif bir simülasyon motoru kodlandı.
    - Mobilde 2 arena, masaüstünde 4 arena konumlandırıldı; gol olduğunda şok dalgası ve mini skorbord güncellemesi entegre edildi.
    - **Sıfır Hantallık & Pil Tasarrufu:** 30 FPS kilit (`requestAnimationFrame`), `IntersectionObserver` ile hero ekrandan çıktığında anında durma ve sekme gizlendiğinde sıfır CPU tüketimi garantilendi.
  - **Hero Alanı Temizliği & Güncel Tanıtım:**
    - "İlk 50 testçi..." rozet bloku hem ana sayfadan hem de modal'dan tamamen temizlendi.
    - Üstteki `Google Play Kapalı Beta · 14 Günlük Test Süreci` ibaresinden 14 günlük test süreci atıldı; sadece `Google Play Kapalı Beta` bırakıldı.
    - Tanıtım metni son v1.1 sürümüne göre güncellendi: "232 takım, 46 milli takım, 7 dünya ligi ve yenilenen fizik motoruyla arcade futbol keyfi parmaklarınızın ucunda. Hemen Android erken erişime katılın veya tarayıcıda doğrudan deneyin!"
    - `translations.js` içinde TR, EN, ES dilleri tam senkronize edildi.
  - **Üst Bar (Navbar) Sadeleştirme:**
    - Kafa karıştıran ve kalabalık yapan "Özellikler", "Dev Log", "İletişim" ve "Web Oyunu" linkleri masaüstü üst bardan kaldırıldı.
    - Üst bar sadece: Logo, Liderlik Tablosu, Hakkımızda, parlayan "Erken Erişim" butonu ve Dil Seçici ile elit bir stüdyo görünümüne kavuşturuldu.
  - **Sürtünmesiz (Frictionless) 1-Tık Google Play İndirme Akışı:**
    - Kullanıcıları korkutan 2 adımlı "1. Gruba Katıl" jargonları yerine doğrudan büyük, güven verici `Google Play Üzerinden Hemen İndir & Teste Başla` birincil butonu ve alternatif tek tıkla Gmail yetkilendirme formu (`api/join_test.php`) yerleştirildi.
    - Güven rozetleri (Resmi Google Play, Sıfır Bekleme, Android 8.0+, %100 Ücretsiz) eklendi.
  - **Web Oyunu PC Smartphone Figürü (Mockup Frame) & Mobil Tam Ekran:**
    - PC ekranında oyunun yatay bozulması sorunu çözüldü; `aspect-ratio: 16/9` kaldırılarak oyun şık bir dikey amiral gemisi akıllı telefon gövdesi (`.phone-mockup-frame`, Dynamic Island, hoparlör ızgarası, kamera lensi, home indicator) içine oturtuldu.
    - Godot 450x900 (9:18.5) dikey portrait formatı masaüstünde kusursuz oranla çalışır hale geldi.
    - Mobilde telefon çerçevesi gizlenerek tek tıkla tüm ekranı dolduran `Tam Ekran Oyna (Sıfır Kayıp)` araç çubuğu ve `toggleFS()` API'si entegre edildi.
  - **Trafik & Büyüme: Sosyal Medya Sahnesi & Maç Simülasyonu Merkezi:**
    - Ana sayfaya YouTube TR (`@EB_Studyoo`), YouTube Global (`@EB_Studioo`), Instagram Reels (`@eb_studyo`) ve TikTok (`@eb_studyo`) canlı vitrin kartları (`#topluluk`) eklendi.
    - SEO odaklı `simulasyon/index.html` (Maç Simülasyonu & Skor Tahmin Merkezi) oluşturuldu; ziyaretçilerin derbi simülasyonları yapıp web oyununu başlatması ve Google Play'e yönlendirilmesi sağlandı. `sitemap.xml` güncellendi.
  - **Doğrulamalar:** Tüm HTML ve JS blokları Node.js ve Python syntax validator ile test edildi (%100 geçerli).
* **Genel QA Statüsü:** 🏛️ **YEŞİL (Web Modernizasyonu Tamamlandı, Agar.io Arkaplan Arenaları Aktif, PC Telefon Mockup Hazır, Trafik Hub Yayında)**.

### ⚽ v1.1.1 Mobil UI/UX ve Jeton Ekonomisi Ergonomi Paketi (2026-09-27):
- [x] **Türkiye Bayrağı Optik Merkezleme:** Hilal ve yıldız motifi, hilalin sol taraftaki kütle ağırlığı hesaba katılarak optik merkez dengesiyle `x = 131.0` noktasına oturtuldu; top üstünde sola basık durma sorunu tamamen giderildi.
- [x] **Google Play Bağlanma İstemi (Prompt) Zamanlaması:** Karşılama ekranından ana menüye geçer geçmez çıkan haksız Google Play penceresi engellendi; istem yalnızca misafir oyuncular en az 3 tamamlanmış maç oynayıp maçtan ana menüye döndüğünde (`came_from_completed_match`) devreye girecek şekilde revize edildi.
- [x] **Kadro Düzenleme Penceresi Top Önizleme & Kayıt Düzeltmesi:** GDScript 4 yerel değişkenlerinin closure/lambda içinde değere göre kopyalanması sebebiyle önizleme topunun ve kayıt hedefinin ev sahibi takımda kilitli kalması sorunu `squad_state` sözlüğüyle kökten çözüldü; seçilen takımın topu anında güncelleniyor ve kadro o takıma eksiksiz kaydediliyor.
- [x] **Giriş Ekranı Logo Köşe Temizliği:** `game_logo.png` dosyasındaki beyaz opak köşeler SciPy & Pillow de-matte matrisleriyle %100 şeffaf anti-aliased RGBA'ya dönüştürüldü; koyu cam zemin üzerindeki amatör beyaz köşe lekeleri tamamen sıfırlandı.
- [x] **Giriş Ekranı Google Play Bağlantı Geri Bildirimi:** Karşılama ekranı açılışında arayüz önce derlenerek butonun oturum kontrolüne hazır olması sağlandı; Google Play bağlıyken buton yeşil arkaplan, `checkmark_icon.svg` ve dokunsal ölçekleme animasyonuyla net onay sunar hale getirildi. Manuel tıklandığında kullanıcıya onayı görmesi için 0.85s pay tanındı.
- [x] **"MAÇI BAŞLAT" Metin Sadeleştirmesi & Statü Rozeti:** Tehditkar ve amatör duran `(50 Jeton)` ibaresi butondan kaldırıldı; buton saf ve iddialı `MAÇI BAŞLAT` metnini korurken, üstüne zarif bir maç hakkı rozeti (`⚽ 5/5 ÜCRETSİZ MAÇ` / `🪙 50 JETON` / `👑 PRO PASS`) eklendi. Alt nav bar ile aradaki mesafe 34px'e çıkarıldı.
- [x] **Kullanıcı Dostu "Daha Fazla Maç Oyna" Modalı:** Jetonu yetmeyen oyunculara doğrudan video izleyerek (+50 jeton), şans çarkını çevirerek veya mağazayı ziyaret ederek maça girme imkanı tanıyan şık bir diyalog entegre edildi.
- [x] **Doğrulamalar:** `test_latest_fixes.py`, `test_backend_logic.py`, `verify_ecosystem_hard.py` (tüm 4 kapı) ve Godot 120-frame runtime simülasyonları 0 hata ile %100 başarıyla tamamlandı.

### ⚽ v1.1.2 Jeton Tüketimi, Resmi Jeton İkonu, Sabit Mağaza Başlığı & Tablet Kaydırma Revizyonu (2026-09-27):
- [x] **50 Jeton Tüketim Senkronizasyonu:** Günlük 5 ücretsiz maç hakkı tükendikten sonra `_on_start_match()` ve `pitch.gd` replay adımlarında maç hakkının anında ve garantili olarak tüketilmesi sağlandı (`Global.consume_match_right()`). `Global.gd` içindeki `save_progression()` ve `save_stats()` fonksiyonları `user://` dosyalarını doğrudan yazacak şekilde optimize edilerek rename çarpışmaları ve gecikmeler sıfırlandı.
- [x] **Resmi Jeton Tasarımı Rozeti:** "MAÇI BAŞLAT" butonu üzerindeki maç ücreti rozetinde sistem yazı tipi emojisi (`🪙`) tamamen kaldırıldı; yerine oyunun resmi şık vektör jeton ikonu (`res://jeton_icon.svg`, 22x22) ve temayla uyumlu `HBoxContainer` mimarisi entegre edildi.
- [x] **Sabit Mağaza Başlığı (Pinned Header):** Mağaza sekmesi (`_build_shop_tab`) İstatistikler sekmesi standartlarına getirildi; Mağaza başlığı, jeton gösterge butonu ve ayırıcı çizgi ekranın en üstünde sabitlendi. Altındaki ürünler ve görevler bu başlığın altından bağımsız ve akıcı bir şekilde kaydırılabilir hale getirildi.
- [x] **Tablet & Geniş Ekran Dokunsal Kaydırma Çubukları:** İstatistikler ve Mağaza ekranlarındaki dikey `ScrollContainer` bileşenleri `SCROLL_MODE_SHOW_ALWAYS` moduna ve 8px genişliğinde zarif, yuvarlatılmış tema aksan renginde scroll grabber pill tutamaçlarına kavuşturuldu; listenin kaydırılabilirliği belirginleştirildi.
- [x] **Çift Yönlü Dokunmatik Kilit (Directional Gesture Lock):** Dikey kaydırma esnasında sekme değişimini tetikleyen yatay kaydırma çakışması çözüldü; 14px'lik ilk hareket eksenine göre dikey hareket tespit edildiğinde sekme geçişi anında kilitleniyor, oyuncu güvenle sayfayı yukarı-aşağı kaydırabiliyor.
- [x] **Top ve Taç Carousel Kaydırma Öğeleri:** Top görünümleri ve taçlar panellerine görünür yatay scrollbar'lar, başlık yanına tek tıkla kaydıran `◀` ve `▶` butonları eklendi; dikey kaydırma olayları ana mağaza kaydırma alanına yönlendirildi.
- [x] **Doğrulamalar & Dağıtım:** 
  - `python tests/test_latest_fixes.py` (%100 PASS)
  - `python tests/test_backend_logic.py` (%100 PASS)
  - `python tests/verify_ecosystem_hard.py` (4 Kapı %100 PASS, 120 Frame Godot simülasyonu)
  - `bol_gol_v32_1.1.2.aab` üretildi (100.6 MB)
  - Google Play Console `internal` ve `alpha` kanallarına 5 dilde (TR, ENG, ESP, POR, ITA) release notes ile yüklendi ve yayınlandı (Commit ID: `16644697819937373798`).









