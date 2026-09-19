"""
Master Automation Pipeline for Bol Gol Futbol
Orchestrates: Validation -> Build -> Deploy -> AI Studio Sync
"""
import os
import sys
import subprocess
import argparse

TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_DIR = os.path.dirname(TOOLS_DIR)

def run_pipeline(deploy=False, track="internal", bump=True, no_bump=False):
    print("========================================")
    print("  ⚽ BOL GOL FUTBOL AUTOMATION PIPELINE ")
    print("========================================")
    
    # Step 1: Validate
    print("\n[Step 1/3] Validating Godot Project...")
    cmd_val = [sys.executable, os.path.join(TOOLS_DIR, "godot_cli.py"), "--action", "validate"]
    subprocess.run(cmd_val, check=True)

    # Step 2: Build AAB
    print("\n[Step 2/3] Exporting Android Release AAB...")
    cmd_build = [sys.executable, os.path.join(TOOLS_DIR, "godot_cli.py"), "--action", "export-aab"]
    if no_bump or not bump:
        cmd_build.append("--no-bump")
    
    res = subprocess.run(cmd_build)
    if res.returncode != 0:
        print("[Pipeline Failed] AAB build failed.")
        return False

    # Find the latest generated AAB
    build_dir = os.path.join(PROJECT_DIR, "build")
    aab_files = [os.path.join(build_dir, f) for f in os.listdir(build_dir) if f.endswith(".aab")]
    if not aab_files:
        print("[Pipeline Warning] No AAB found in build directory.")
        return True
    
    latest_aab = max(aab_files, key=os.path.getctime)
    print(f"[Pipeline] Ready AAB: {latest_aab}")

    # Step 3: Deploy (if requested)
    if deploy:
        print(f"\n[Step 3/3] Deploying to Google Play Console ({track})...")
        cmd_deploy = [
            sys.executable,
            os.path.join(TOOLS_DIR, "play_console_deploy.py"),
            "--action", "upload",
            "--aab", latest_aab,
            "--track", track
        ]
        subprocess.run(cmd_deploy)
    else:
        print("\n[Step 3/3] Build completed! (To deploy automatically to Play Store, pass --deploy)")

    print("\n========================================")
    print("  ✅ PIPELINE EXECUTION FINISHED")
    print("========================================")
    return True

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Master Automation Pipeline")
    parser.add_argument("--deploy", action="store_true", help="Automatically upload build to Play Console")
    parser.add_argument("--track", type=str, default="internal", choices=["internal", "alpha", "beta", "production"])
    parser.add_argument("--no-bump", action="store_true", help="Do not increment version number")
    args = parser.parse_args()

    run_pipeline(deploy=args.deploy, track=args.track, no_bump=args.no_bump)
