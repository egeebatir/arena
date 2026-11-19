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
                    "text": "• Elit Kulüp Düzeltmesi: Google Play satın almaları artık anında aktifleşir, otomatik onaylanır ve Geri Yükle ile her cihazda tanınır.\n• Kulüp & Bayrak Düzeltmesi: Porto, Brann, Marsilya gibi kısaltması çakışan kulüplerde yanlış milli bayrak çıkması giderildi.\n• Şans Çarkı & Reklamlar: Çark reklamının ekstra jeton/bekleme tetiklemesi çözüldü; mağaza reklam süresi 60 sn oldu.\n• Güncelleme Bildirimi & Görsel: Yeni sürüm uyarısı, yenilenen logo ve temiz açılış."
                },
                {
                    "language": "en-US",
                    "text": "• Elite Club Fix: Google Play purchases now activate instantly, acknowledge automatically, and restore reliably across devices.\n• Club Crest & Flag Fix: Fixed national flags appearing on clubs with matching short codes (Porto, Brann, Marseille, etc.).\n• Lucky Wheel & Ads: Isolated wheel ad spins from shop coin rewards and lowered shop ad cooldown to 60s.\n• Update Notice & Polish: Added an in-game update banner, ball-forward app logo, and clean startup splash."
                },
                {
                    "language": "es-ES",
                    "text": "• Club Élite: Las compras de Google Play se activan al instante, se confirman automáticamente y se restauran sin fallos.\n• Escudos y Banderas: Corregido el error de banderas en clubes con siglas iguales (Porto, Brann, Marsella, etc.).\n• Ruleta y Anuncios: Giros de ruleta separados de las recompensas de tienda y espera reducida a 60s.\n• Aviso y Pulido: Nuevo aviso de actualización en el menú, logotipo renovado e inicio limpio."
                },
                {
                    "language": "pt-BR",
                    "text": "• Clube Elite: Compras no Google Play ativam na hora, confirmam automaticamente e restauram em qualquer dispositivo.\n• Escudos e Bandeiras: Corrigido o erro de bandeiras em clubes com siglas iguais (Porto, Brann, Marselha, etc.).\n• Roda da Sorte e Anúncios: Giros da roleta isolados dos prêmios da loja e espera reduzida para 60s.\n• Aviso e Polimento: Novo aviso de atualização no menu, ícone renovado e início limpo."
                },
                {
                    "language": "it-IT",
                    "text": "• Club Élite: Gli acquisti Google Play si attivano subito, si confermano in automatico e si ripristinano senza errori.\n• Stemmi e Bandiere: Risolto l'errore delle bandiere nazionali su club con sigle uguali (Porto, Brann, Marsiglia, ecc.).\n• Ruota e Annunci: Giri della ruota separati dai premi del negozio e attesa ridotta a 60s.\n• Avviso e Rifiniture: Nuovo avviso di aggiornamento nel menu, logo aggiornato e avvio pulito."
                }
            ]

        rel_name = release_name or f"{version_code} (1.1.6)"

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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Google Play Console Deploy Tool")
    parser.add_argument("--action", choices=["check", "upload", "update_graphics"], default="check")
    parser.add_argument("--aab", type=str, help="Path to AAB file to upload")
    parser.add_argument("--track", type=str, default="internal,alpha", help="Comma-separated list of tracks (internal, alpha, beta, production)")
    parser.add_argument("--name", type=str, default=None, help="Release name e.g. '8 (1.0.8)'")
    parser.add_argument("--icon", type=str, default=r"c:\Users\egebatir\Documents\futbol\store_assets\icon_512x512.png")
    parser.add_argument("--feature", type=str, default=r"c:\Users\egebatir\Documents\futbol\store_assets\feature_graphic_1024x500.png")
    parser.add_argument("--screenshots", type=str, default=None, help="Directory of phoneScreenshots to upload")
    parser.add_argument("--lang", type=str, default="tr-TR")
    parser.add_argument("--key", type=str, help="Path to Service Account JSON key")
    args = parser.parse_args()

    if args.action == "check":
        check_credentials(args.key)
    elif args.action == "upload":
        if not args.aab or not os.path.exists(args.aab):
            print(f"Error: AAB file not found at '{args.aab}'")
            sys.exit(1)
        upload_aab(args.aab, tracks=args.track, release_name=args.name, key_path=args.key)
    elif args.action == "update_graphics":
        update_graphics(icon_path=args.icon, feature_graphic_path=args.feature, screenshots_dir=args.screenshots, language=args.lang, key_path=args.key)

