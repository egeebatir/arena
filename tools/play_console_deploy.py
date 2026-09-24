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
        chunk_size = 5 * 1024 * 1024  # 5MB chunks
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

        # Default release notes if none provided
        if not release_notes:
            release_notes = [
                {
                    "language": "tr-TR",
                    "text": "• Küresel Canlı Liderlik Tablosu: Skorunu eşitle ve dünya sıralamasında yerini al!\n• Pro VIP Kartı: Reklamsız oyunculara özel altın VIP profil kartı ve ayrıcalıklar.\n• Yeni Kulüp Armaları: Barcelona, PSG, Bayern, Dortmund ve Miami Inter armaları optimize edildi.\n• Şanslı Çark Güvencesi: Tekli çevirme kilidi ve ödüllü reklam kontrolleri güçlendirildi.\n• Arayüz ve Performans: Skorbord düzeni ve dokunsal ayarlar yenilendi."
                },
                {
                    "language": "en-US",
                    "text": "• Live Global Leaderboard: Sync your score and climb worldwide rankings!\n• Pro VIP Experience: Exclusive Golden VIP card displaying Captain name, club, and perks.\n• Enhanced Club Crests: HD 800x800 crests for Barcelona, PSG, Bayern, Dortmund, and Miami Inter.\n• Lucky Wheel Polish: Single-spin lock guarantee and enhanced rewarded flow.\n• Performance & UI: Refined scoreboard spacing and tactile settings sliders."
                },
                {
                    "language": "es-ES",
                    "text": "• Clasificación Global: ¡Sincroniza tu puntuación y compite en el ranking mundial!\n• Experiencia Pro VIP: Tarjeta dorada exclusiva con nombre de Capitán, club y ventajas VIP.\n• Nuevos Escudos: Diseños 800x800 para Barcelona, PSG, Bayern, Dortmund e Inter Miami.\n• Ruleta de la Suerte: Control estricto de tirada única y recompensas garantizadas.\n• Rendimiento y UI: Marcador renovado y controles táctiles más fluidos."
                },
                {
                    "language": "pt-BR",
                    "text": "• Classificação Global: Sincronize a sua pontuação e dispute o topo do ranking mundial!\n• Experiência Pro VIP: Cartão dourado exclusivo com nome do Capitão, clube e vantagens VIP.\n• Emblemas de Clubes: Novos emblemas para Barcelona, PSG, Bayern, Dortmund e Miami Inter.\n• Roda da Sorte: Bloqueio de giro único e fluxo de anúncios premiados refinado.\n• Desempenho e UI: Marcador ajustado e seletores táteis aprimorados."
                },
                {
                    "language": "it-IT",
                    "text": "• Classifica Globale: Sincronizza il tuo punteggio e scala la classifica mondiale!\n• Esperienza Pro VIP: Esclusiva card dorata con nome Capitano, squadra e vantaggi premium.\n• Stemmi dei Club: Grafiche HD per Barcellona, PSG, Bayern, Dortmund e Inter Miami.\n• Ruota della Fortuna: Blocco giro singolo garantito e gestione premi potenziata.\n• Prestazioni e UI: Spaziature tabellone rifinite e slider tattili fluidi."
                }
            ]

        rel_name = release_name or f"{version_code} (1.0.{version_code})"

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

def update_graphics(icon_path=None, feature_graphic_path=None, language="tr-TR", key_path=None):
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

        # 4. Commit edit
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
        update_graphics(icon_path=args.icon, feature_graphic_path=args.feature, language=args.lang, key_path=args.key)

