"""
Google Play Console & Play Games Services Automation
Uploads AAB builds to Play Console tracks and syncs Play Games achievements.
"""
import os
import sys
import json
import argparse
import subprocess

PROJECT_DIR = r"c:\Users\egebatir\Documents\futbol"
PACKAGE_NAME = "com.ebstudyo.bolgol"
SERVICE_ACCOUNT_KEY_DEFAULT = os.path.join(PROJECT_DIR, "tools", "service_account.json")

def check_credentials(key_path=None):
    path = key_path or os.environ.get("GOOGLE_PLAY_KEY_FILE", SERVICE_ACCOUNT_KEY_DEFAULT)
    if not os.path.exists(path):
        print(f"[Play Console] Service Account JSON key not found at: {path}")
        print("To enable full Play Console automation:")
        print("1. Create a Service Account in Google Cloud Console with Google Play Developer API enabled.")
        print("2. Download the JSON key file and place it at: " + SERVICE_ACCOUNT_KEY_DEFAULT)
        print("   or set environment variable GOOGLE_PLAY_KEY_FILE=<path_to_key.json>")
        return None
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
        client_email = data.get("client_email", "")
        print(f"[Play Console] Validated Service Account key for: {client_email}")
        return path
    except Exception as e:
        print(f"[Play Console] Error reading Service Account key: {e}")
        return None

def upload_aab(aab_path, tracks=["internal", "alpha"], release_name=None, release_notes=None, key_path=None):
    key = check_credentials(key_path)
    if not key:
        return False
    
    # Try importing googleapiclient
    try:
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
        from googleapiclient.http import MediaFileUpload
    except ImportError:
        print("[Play Console] Installing required dependencies: google-api-python-client google-auth...")
        subprocess.run([sys.executable, "-m", "pip", "install", "--quiet", "google-api-python-client", "google-auth"])
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
        from googleapiclient.http import MediaFileUpload

    if isinstance(tracks, str):
        tracks = [t.strip() for t in tracks.split(",") if t.strip()]

    import socket
    socket.setdefaulttimeout(300)

    print(f"[Play Console] Starting deployment of '{aab_path}' to tracks: {tracks} for package: {PACKAGE_NAME}...")
    credentials = service_account.Credentials.from_service_account_file(
        key,
        scopes=["https://www.googleapis.com/auth/androidpublisher"]
    )
    service = build("androidpublisher", "v3", credentials=credentials)

    # 1. Create edit transaction
    edit_req = service.edits().insert(packageName=PACKAGE_NAME, body={})
    edit = edit_req.execute()
    edit_id = edit["id"]
    print(f"[Play Console] Created edit transaction: {edit_id}")

    try:
        # 2. Upload bundle
        chunk_size = 10 * 1024 * 1024  # 10MB chunks
        media = MediaFileUpload(aab_path, mimetype="application/octet-stream", chunksize=chunk_size, resumable=True)
        request = service.edits().bundles().upload(
            packageName=PACKAGE_NAME,
            editId=edit_id,
            media_body=media
        )
        print(f"[Play Console] Uploading bundle ({os.path.getsize(aab_path):,} bytes)...")
        sys.stdout.flush()
        
        response = None
        while response is None:
            status, response = request.next_chunk()
            if status:
                print(f"[Play Console] Upload progress: {int(status.progress() * 100)}%")
                sys.stdout.flush()

        bundle_upload = response
        version_code = bundle_upload["versionCode"]
        sha256 = bundle_upload.get("sha256", "N/A")
        print(f"[Play Console] Uploaded bundle successfully!")
        print(f"  - Version Code: {version_code}")
        print(f"  - SHA256: {sha256}")
        sys.stdout.flush()

        # Default release notes if none provided (strictly <= 500 chars per language for Play Console API)
        if not release_notes:
            release_notes = [
                {
                    "language": "tr-TR",
                    "text": "• Google Play Bulut Kayıt: Hesabınıza bağlandığınızda maç istatistikleriniz, favori takımınız, jetonlarınız ve kozmetikleriniz otomatik geri yüklenir.\n• Satın Alımları Geri Yükle: Elit Kulüp üyelik doğrulaması ve hesap değiştirme altyapısı yenilendi.\n• İstatistik Ekranı & Vektörel İkonlar: Boş durum ekranı sade tematik SVG ikonlarla yenilendi ve doğrudan takım seçimine bağlandı."
                },
                {
                    "language": "en-US",
                    "text": "• Google Play Cloud Save: Sign in to restore your match statistics, favorite team, coins, and unlocked cosmetics across devices.\n• Restore Purchases & Account Switch: Upgraded Google Play Billing entitlement verification and seamless account switching.\n• Stats UI & Vector Icons: Refreshed empty stats screen with crisp theme-matched SVG icons and direct favorite team navigation."
                },
                {
                    "language": "es-ES",
                    "text": "• Guardado en la Nube de Google Play: Conéctate para restaurar tus estadísticas, equipo favorito, monedas y cosméticos.\n• Restaurar Compras y Cambio de Cuenta: Verificación mejorada de Club Élite y gestión de cuentas.\n• Interfaz de Estadísticas e Iconos SVG: Pantalla inicial renovada con iconos vectoriales limpios y acceso directo a la selección de equipo."
                },
                {
                    "language": "pt-BR",
                    "text": "• Nuvem Google Play: Conecte sua conta para restaurar estatísticas de partidas, equipa favorita, moedas e cosméticos.\n• Restaurar Compras e Troca de Conta: Verificação aprimorada do Clube Elite e gestão de sessão.\n• Estatísticas e Ícones SVG: Tela inicial renovada com ícones vetoriais minimalistas e atalho direto para a seleção de equipa."
                },
                {
                    "language": "it-IT",
                    "text": "• Salvataggio Cloud Google Play: Accedi per ripristinare statistiche, squadra preferita, monete e cosmetici sbloccati.\n• Ripristina Acquisti e Cambio Account: Verifica migliorata per il Club Élite e gestione account.\n• Statistiche e Icone SVG: Schermata iniziale rinnovata con icone vettoriali pulite e collegamento diretto alla selezione squadra."
                }
            ]

        rel_name = release_name or f"{version_code} (1.1.8)"

        # 3. Assign bundle to each requested track
        for track in tracks:
            track_body = {
                "track": track,
                "releases": [
                    {
                        "name": rel_name,
                        "versionCodes": [str(version_code)],
                        "status": "completed",
                        "releaseNotes": release_notes
                    }
                ]
            }
            service.edits().tracks().update(
                packageName=PACKAGE_NAME,
                editId=edit_id,
                track=track,
                body=track_body
            ).execute()
            print(f"[Play Console] Assigned version {version_code} ({rel_name}) to track '{track}' with localized release notes.")

        # 4. Commit edit transaction
        commit_res = service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
        print(f"[Play Console] Successfully committed and published to tracks: {tracks}!")
        print(f"[Play Console] Edit Commit ID: {commit_res.get('id', edit_id)}")
        return True

    except Exception as e:
        print(f"[Play Console Error] Deployment failed: {e}")
        try:
            service.edits().delete(packageName=PACKAGE_NAME, editId=edit_id).execute()
            print("[Play Console] Rolled back uncommitted edit transaction.")
        except Exception:
            pass
        return False

def update_graphics(icon_path=None, feature_graphic_path=None, screenshots_dir=None, language="tr-TR", key_path=None):
    key = check_credentials(key_path)
    if not key:
        return False
    
    try:
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
        from googleapiclient.http import MediaFileUpload
    except ImportError:
        print("[Play Console] Installing required dependencies: google-api-python-client google-auth...")
        subprocess.run([sys.executable, "-m", "pip", "install", "--quiet", "google-api-python-client", "google-auth"])
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
        from googleapiclient.http import MediaFileUpload

    print(f"[Play Console] Updating Store Listing graphics for package: {PACKAGE_NAME} (Language: {language})...")
    credentials = service_account.Credentials.from_service_account_file(
        key,
        scopes=["https://www.googleapis.com/auth/androidpublisher"]
    )
    service = build("androidpublisher", "v3", credentials=credentials)

    # 1. Create edit
    edit_req = service.edits().insert(packageName=PACKAGE_NAME, body={})
    edit = edit_req.execute()
    edit_id = edit["id"]
    print(f"[Play Console] Created edit transaction: {edit_id}")

    try:
        # 2. Upload icon if specified
        if icon_path and os.path.exists(icon_path):
            print(f"[Play Console] Uploading icon from {icon_path}...")
            # First clear existing icon
            try:
                service.edits().images().deleteall(
                    packageName=PACKAGE_NAME, editId=edit_id, language=language, imageType="icon"
                ).execute()
            except Exception:
                pass
            media = MediaFileUpload(icon_path, mimetype="image/png")
            service.edits().images().upload(
                packageName=PACKAGE_NAME, editId=edit_id, language=language, imageType="icon", media_body=media
            ).execute()
            print("[Play Console] Icon uploaded successfully.")

        # 3. Upload feature graphic if specified
        if feature_graphic_path and os.path.exists(feature_graphic_path):
            print(f"[Play Console] Uploading feature graphic from {feature_graphic_path}...")
            try:
                service.edits().images().deleteall(
                    packageName=PACKAGE_NAME, editId=edit_id, language=language, imageType="featureGraphic"
                ).execute()
            except Exception:
                pass
            media = MediaFileUpload(feature_graphic_path, mimetype="image/png")
            service.edits().images().upload(
                packageName=PACKAGE_NAME, editId=edit_id, language=language, imageType="featureGraphic", media_body=media
            ).execute()
            print("[Play Console] Feature graphic uploaded successfully.")

        # 4. Upload phone screenshots if specified
        if screenshots_dir and os.path.isdir(screenshots_dir):
            ss_files = sorted(
                [
                    os.path.join(screenshots_dir, f)
                    for f in os.listdir(screenshots_dir)
                    if f.lower().endswith((".png", ".jpg", ".jpeg"))
                ]
            )[:8]
            if ss_files:
                print(f"[Play Console] Uploading {len(ss_files)} phoneScreenshots from {screenshots_dir}...")
                try:
                    service.edits().images().deleteall(
                        packageName=PACKAGE_NAME, editId=edit_id, language=language, imageType="phoneScreenshots"
                    ).execute()
                except Exception:
                    pass
                for ss_file in ss_files:
                    mime = "image/jpeg" if ss_file.lower().endswith((".jpg", ".jpeg")) else "image/png"
                    media = MediaFileUpload(ss_file, mimetype=mime)
                    service.edits().images().upload(
                        packageName=PACKAGE_NAME, editId=edit_id, language=language, imageType="phoneScreenshots", media_body=media
                    ).execute()
                    print(f"  - Uploaded screenshot: {os.path.basename(ss_file)}")

        # 5. Commit edit
        service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
        print("[Play Console] Successfully committed and published graphic changes!")
        return True
    except Exception as e:
        print(f"[Play Console] Error updating graphics: {e}")
        try:
            service.edits().delete(packageName=PACKAGE_NAME, editId=edit_id).execute()
        except Exception:
            pass
        return False

def check_store_version():
    import urllib.request
    import re
    url = f"https://play.google.com/store/apps/details?id={PACKAGE_NAME}&hl=en&gl=US"
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=15) as resp:
            html = resp.read().decode("utf-8", errors="ignore")
        m = re.search(r'\[\[\["(\d+\.\d+\.\d+)"\]\]', html)
        live_ver = m.group(1) if m else None
        print(f"[Play Store] Live public store version for {PACKAGE_NAME}: {live_ver or 'Not publicly listed / Closed Beta only'}")
        return live_ver
    except Exception as e:
        print(f"[Play Store] Could not query store page ({e})")
        return None

def sync_web_version(version_code: int, version_name: str, force: bool = False):
    live_ver = check_store_version()
    if not force and live_ver != version_name:
        print(f"[Sync Guard] Aborting ebstudyo.com/api/version.json update: Play Store live version is '{live_ver}', not '{version_name}'.")
        print("[Sync Guard] Re-run with --force after Play Console review completes and the update is live.")
        return False
    web_ver_path = r"C:\Users\egebatir\Documents\Bol Gol Futbol\webfutbol\api\version.json"
    payload = {
        "version_code": int(version_code),
        "version_name": str(version_name),
        "store_url": f"https://play.google.com/store/apps/details?id={PACKAGE_NAME}"
    }
    with open(web_ver_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2)
    print(f"[Sync] Updated {web_ver_path} -> {version_name} ({version_code})")
    return True

def validate_aso_listings_data(data: dict) -> list:
    errors = []
    locales = data.get("locales", {})
    if not locales:
        errors.append("No 'locales' dictionary found in ASO listings JSON.")
        return errors

    banned_substrings = ["—", "--"]
    for lang, item in locales.items():
        title = item.get("title", "").strip()
        short_desc = item.get("shortDescription", "").strip()
        full_desc = item.get("fullDescription", "").strip()

        if not title or len(title) > 30:
            errors.append(f"[{lang}] Title length invalid ({len(title)}/30): '{title}'")
        if not short_desc or len(short_desc) > 80:
            errors.append(f"[{lang}] shortDescription length invalid ({len(short_desc)}/80): '{short_desc}'")
        if len(full_desc) < 400 or len(full_desc) > 4000:
            errors.append(f"[{lang}] fullDescription length invalid ({len(full_desc)}/4000)")

        combined = f"{title}\n{short_desc}\n{full_desc}"
        for bad in banned_substrings:
            if bad in combined:
                errors.append(f"[{lang}] Contains forbidden punctuation '{bad}'")
        if "ebstudyo.com" not in full_desc:
            errors.append(f"[{lang}] Missing ebstudyo.com web ecosystem bridge in fullDescription")

    return errors


def fetch_listings(key_path=None):
    key = check_credentials(key_path)
    if not key:
        return False
    from google.oauth2 import service_account
    from googleapiclient.discovery import build

    credentials = service_account.Credentials.from_service_account_file(
        key, scopes=["https://www.googleapis.com/auth/androidpublisher"]
    )
    service = build("androidpublisher", "v3", credentials=credentials)
    edit = service.edits().insert(packageName=PACKAGE_NAME, body={}).execute()
    edit_id = edit["id"]
    try:
        res = service.edits().listings().list(packageName=PACKAGE_NAME, editId=edit_id).execute()
        listings = res.get("listings", [])
        print(f"[Play Console] Found {len(listings)} live store listing(s):")
        for item in listings:
            lang = item.get("language")
            title = item.get("title", "")
            short_d = item.get("shortDescription", "")
            full_d = item.get("fullDescription", "")
            print(f"  - {lang}: title='{title}' ({len(title)}c), short={len(short_d)}c, full={len(full_d)}c")
        return True
    finally:
        try:
            service.edits().delete(packageName=PACKAGE_NAME, editId=edit_id).execute()
        except Exception:
            pass


def update_listings(aso_json_path=None, dry_run=False, include_video=False, only_lang=None, key_path=None):
    aso_path = aso_json_path or os.path.join(PROJECT_DIR, "store_assets", "aso_listings.json")
    if not os.path.exists(aso_path):
        print(f"[Play Console] ASO JSON file not found: {aso_path}")
        return False

    with open(aso_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    errors = validate_aso_listings_data(data)
    if errors:
        print("[ASO Validation FAILED]:")
        for err in errors:
            print("  -", err)
        return False

    locales = data.get("locales", {})
    if only_lang:
        wanted = {x.strip() for x in only_lang.split(",") if x.strip()}
        locales = {k: v for k, v in locales.items() if k in wanted}
        if not locales:
            print(f"[Play Console] No matching locales found for --lang '{only_lang}'")
            return False

    promo_video = data.get("promo_video_url", "") if include_video else ""

    print(f"[ASO Validation PASS] Prepared {len(locales)} locale(s):")
    for lang, item in locales.items():
        t = item["title"].strip()
        s = item["shortDescription"].strip()
        fd = item["fullDescription"].strip()
        print(f"  * {lang:6s} | Title ({len(t):2d}/30): {t} | Short ({len(s):2d}/80) | Full ({len(fd):4d}/4000)")

    if dry_run:
        print("[Dry Run] Skipping Google Play Console API write (--dry-run enabled).")
        return True

    key = check_credentials(key_path)
    if not key:
        return False

    from google.oauth2 import service_account
    from googleapiclient.discovery import build

    credentials = service_account.Credentials.from_service_account_file(
        key, scopes=["https://www.googleapis.com/auth/androidpublisher"]
    )
    service = build("androidpublisher", "v3", credentials=credentials)
    edit = service.edits().insert(packageName=PACKAGE_NAME, body={}).execute()
    edit_id = edit["id"]
    print(f"[Play Console] Created edit transaction: {edit_id}")

    try:
        for lang, item in locales.items():
            body = {
                "language": lang,
                "title": item["title"].strip(),
                "shortDescription": item["shortDescription"].strip(),
                "fullDescription": item["fullDescription"].strip(),
            }
            if promo_video:
                body["video"] = promo_video
            service.edits().listings().update(
                packageName=PACKAGE_NAME,
                editId=edit_id,
                language=lang,
                body=body
            ).execute()
            print(f"  - Staged listing update for {lang}")

        commit_res = service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
        print(f"[Play Console] Committed store listings for {len(locales)} locale(s)! Edit ID: {commit_res.get('id', edit_id)}")
        return True
    except Exception as e:
        print(f"[Play Console Error] Failed updating store listings: {e}")
        try:
            service.edits().delete(packageName=PACKAGE_NAME, editId=edit_id).execute()
            print("[Play Console] Rolled back uncommitted edit transaction.")
        except Exception:
            pass
        return False


def update_screenshots_batch(captioned_root=None, dry_run=False, only_lang=None, key_path=None):
    root_dir = captioned_root or os.path.join(PROJECT_DIR, "store_assets", "screenshots_captioned")
    if not os.path.isdir(root_dir):
        print(f"[Play Console] Captioned screenshots root not found: {root_dir}")
        return False

    locales = sorted([d for d in os.listdir(root_dir) if os.path.isdir(os.path.join(root_dir, d))])
    if only_lang:
        wanted = {x.strip() for x in only_lang.split(",") if x.strip()}
        locales = [l for l in locales if l in wanted]

    if not locales:
        print("[Play Console] No locale screenshot directories found.")
        return False

    for loc in locales:
        loc_dir = os.path.join(root_dir, loc)
        pngs = sorted([f for f in os.listdir(loc_dir) if f.lower().endswith(".png")])[:8]
        if len(pngs) < 2:
            print(f"[Screenshot Check FAILED] {loc} has fewer than 2 PNGs.")
            return False
        print(f"  * {loc:6s} | {len(pngs)} screenshots ready ({', '.join(pngs[:2])} ...)")

    if dry_run:
        print(f"[Dry Run] Verified {len(locales)} locale screenshot packs locally (--dry-run enabled).")
        return True

    key = check_credentials(key_path)
    if not key:
        return False

    from google.oauth2 import service_account
    from googleapiclient.discovery import build
    from googleapiclient.http import MediaFileUpload

    credentials = service_account.Credentials.from_service_account_file(
        key, scopes=["https://www.googleapis.com/auth/androidpublisher"]
    )
    service = build("androidpublisher", "v3", credentials=credentials)
    edit = service.edits().insert(packageName=PACKAGE_NAME, body={}).execute()
    edit_id = edit["id"]
    print(f"[Play Console] Created batch screenshot edit transaction: {edit_id}")

    try:
        for loc in locales:
            loc_dir = os.path.join(root_dir, loc)
            ss_files = sorted([os.path.join(loc_dir, f) for f in os.listdir(loc_dir) if f.lower().endswith(".png")])[:8]
            try:
                service.edits().images().deleteall(
                    packageName=PACKAGE_NAME, editId=edit_id, language=loc, imageType="phoneScreenshots"
                ).execute()
            except Exception:
                pass
            for ss_file in ss_files:
                media = MediaFileUpload(ss_file, mimetype="image/png")
                service.edits().images().upload(
                    packageName=PACKAGE_NAME, editId=edit_id, language=loc, imageType="phoneScreenshots", media_body=media
                ).execute()
            print(f"  - Uploaded {len(ss_files)} phoneScreenshots for {loc}")

        commit_res = service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
        print(f"[Play Console] Committed screenshots for {len(locales)} locale(s)! Edit ID: {commit_res.get('id', edit_id)}")
        return True
    except Exception as e:
        print(f"[Play Console Error] Batch screenshot upload failed: {e}")
        try:
            service.edits().delete(packageName=PACKAGE_NAME, editId=edit_id).execute()
        except Exception:
            pass
        return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Google Play Console Deploy Tool")
    parser.add_argument("--action", choices=["check", "upload", "update_graphics", "update_screenshots_batch", "update_listings", "fetch_listings", "check_store", "sync_web_version"], default="check")
    parser.add_argument("--aab", type=str, help="Path to AAB file to upload")
    parser.add_argument("--track", type=str, default="internal,alpha", help="Comma-separated list of tracks (internal, alpha, beta, production)")
    parser.add_argument("--name", type=str, default=None, help="Release name e.g. '8 (1.0.8)'")
    parser.add_argument("--version-code", type=int, default=39, help="Version code for sync_web_version")
    parser.add_argument("--version-name", type=str, default="1.1.8", help="Version name for sync_web_version")
    parser.add_argument("--force", action="store_true", help="Force sync_web_version even if public Play Store listing differs (e.g. approved closed beta)")
    parser.add_argument("--icon", type=str, default=r"c:\Users\egebatir\Documents\futbol\store_assets\icon_512x512.png")
    parser.add_argument("--feature", type=str, default=r"c:\Users\egebatir\Documents\futbol\store_assets\feature_graphic_1024x500.png")
    parser.add_argument("--screenshots", type=str, default=None, help="Directory of phoneScreenshots to upload")
    parser.add_argument("--aso-json", type=str, default=r"c:\Users\egebatir\Documents\futbol\store_assets\aso_listings.json", help="Path to ASO localized listings JSON")
    parser.add_argument("--dry-run", action="store_true", help="Validate without committing changes to Play Console")
    parser.add_argument("--include-video", action="store_true", help="Include promo_video_url when updating store listings")
    parser.add_argument("--lang", type=str, default=None, help="Locale code (e.g. tr-TR) or comma-separated locales for update_listings")
    parser.add_argument("--key", type=str, help="Path to Service Account JSON key")
    args = parser.parse_args()

    if args.action == "check":
        check_credentials(args.key)
    elif args.action == "check_store":
        check_store_version()
    elif args.action == "fetch_listings":
        fetch_listings(key_path=args.key)
    elif args.action == "update_listings":
        ok = update_listings(aso_json_path=args.aso_json, dry_run=args.dry_run, include_video=args.include_video, only_lang=args.lang, key_path=args.key)
        if not ok:
            sys.exit(1)
    elif args.action == "update_screenshots_batch":
        ok = update_screenshots_batch(captioned_root=args.screenshots, dry_run=args.dry_run, only_lang=args.lang, key_path=args.key)
        if not ok:
            sys.exit(1)
    elif args.action == "sync_web_version":
        sync_web_version(args.version_code, args.version_name, force=args.force)
    elif args.action == "upload":
        if not args.aab or not os.path.exists(args.aab):
            print(f"Error: AAB file not found at '{args.aab}'")
            sys.exit(1)
        upload_aab(args.aab, tracks=args.track, release_name=args.name, key_path=args.key)
    elif args.action == "update_graphics":
        target_lang = args.lang or "tr-TR"
        update_graphics(icon_path=args.icon, feature_graphic_path=args.feature, screenshots_dir=args.screenshots, language=target_lang, key_path=args.key)


