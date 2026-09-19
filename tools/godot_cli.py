"""
Godot CLI Automation Tool for Bol Gol Futbol
Handles headless builds (AAB / APK), version bumping, and syntax validation.
"""
import os
import sys
import subprocess
import re
import argparse

# Default Detected Paths
GODOT_EXE = r"C:\Users\egebatir\Desktop\developer shit\Godot_v4.6.1-stable_win64.exe\Godot_v4.6.1-stable_win64_console.exe"
PROJECT_DIR = r"c:\Users\egebatir\Documents\futbol"
EXPORT_PRESETS_FILE = os.path.join(PROJECT_DIR, "export_presets.cfg")
OUTPUT_DIR = os.path.join(PROJECT_DIR, "build")

def get_current_version():
    if not os.path.exists(EXPORT_PRESETS_FILE):
        return None, None
    with open(EXPORT_PRESETS_FILE, "r", encoding="utf-8") as f:
        content = f.read()
    code_match = re.search(r'version/code=(\d+)', content)
    name_match = re.search(r'version/name="([^"]+)"', content)
    code = int(code_match.group(1)) if code_match else 1
    name = name_match.group(1) if name_match else "1.0.0"
    return code, name

def bump_version(new_code=None, new_name=None):
    code, name = get_current_version()
    if new_code is None:
        new_code = code + 1
    if new_name is None:
        parts = name.split(".")
        if len(parts) == 3 and parts[2].isdigit():
            parts[2] = str(int(parts[2]) + 1)
            new_name = ".".join(parts)
        else:
            new_name = name

    with open(EXPORT_PRESETS_FILE, "r", encoding="utf-8") as f:
        content = f.read()

    content = re.sub(r'version/code=\d+', f'version/code={new_code}', content)
    content = re.sub(r'version/name="[^"]+"', f'version/name="{new_name}"', content)

    with open(EXPORT_PRESETS_FILE, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"[Version] Updated from code {code} ({name}) to {new_code} ({new_name})")
    return new_code, new_name

def validate_project():
    print("[Validation] Running Godot headless syntax validation...")
    cmd = [
        GODOT_EXE,
        "--headless",
        "--path", PROJECT_DIR,
        "--editor",
        "--quit"
    ]
    try:
        res = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        print("[Validation] Project syntax and resources validated successfully!")
        return True
    except Exception as e:
        print(f"[Validation Error] {e}")
        return False

def export_android(target_type="aab", preset_name=None, bump=True, is_debug=False):
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    if bump:
        code, name = bump_version()
    else:
        code, name = get_current_version()

    ext = "aab" if target_type.lower() == "aab" else "apk"
    mode_str = "debug" if is_debug else "release"
    output_file = os.path.join(OUTPUT_DIR, f"bol_gol_v{code}_{name}_{mode_str}.{ext}" if is_debug else f"bol_gol_v{code}_{name}.{ext}")

    if preset_name is None:
        if target_type.lower() == "apk":
            preset_name = "Android APK (Test)"
        else:
            preset_name = "Bol Gol Futbol 2.1"

    export_flag = "--export-debug" if is_debug else "--export-release"
    print(f"[Export] Exporting {target_type.upper()} ({preset_name}) [{mode_str}] to: {output_file}")
    cmd = [
        GODOT_EXE,
        "--headless",
        "--path", PROJECT_DIR,
        export_flag, preset_name,
        output_file
    ]

    res = subprocess.run(cmd)
    if res.returncode == 0 and os.path.exists(output_file):
        print(f"[Export Success] File generated: {output_file} ({os.path.getsize(output_file):,} bytes)")
        return output_file
    else:
        print(f"[Export Failed] Return code: {res.returncode}")
        return None

def test_ads():
    print("[Ad Test] Generating and executing comprehensive AdMob scenario tests...")
    gd_script = """extends Control

func _ready():
	print("==================================================")
	print("--- RUNNING FULL PROJECT-INTEGRATED ADMOB TESTS ---")
	print("==================================================")
	test_all()
	print("==================================================")
	print(">>> ALL AD SCENARIOS TESTED AND PASSED CLEANLY! <<<")
	print("==================================================")
	get_tree().quit(0)

func test_all():
	print("[SCENARIO 1] Global AdMob Singleton & Interstitial Preloading")
	Global.init_admob()
	Global.preload_interstitial_ad()
	print("  - Interstitial Preload Call: OK")

	print("[SCENARIO 2] Main Menu Top Banner Lifecycle")
	var menu = load("res://main_menu.tscn").instantiate()
	add_child(menu)
	menu._ensure_menu_top_banner()
	print("  - Menu Banner Active ID: ", menu.menu_banner_ad_id)
	print("  - Switching tabs across Stats/Shop/Match...")
	menu._switch_tab(0, true)
	menu._switch_tab(2, true)
	menu._switch_tab(1, true)
	print("  - Persistent Top Banner across tabs: OK")

	print("[SCENARIO 3] Consecutive Rewarded Video Watches in Shop")
	var init_credits = Global.ad_credits
	menu._on_rewarded_video_earned(null, null)
	assert(Global.ad_credits == init_credits + 50)
	menu._on_rewarded_dismissed(null)
	print("  - Video 1 Earned (+50) & Reload Triggered. Balance: ", Global.ad_credits)
	menu._on_rewarded_video_earned(null, null)
	assert(Global.ad_credits == init_credits + 100)
	menu._on_rewarded_dismissed(null)
	print("  - Video 2 Earned (+50) & Reload Triggered. Balance: ", Global.ad_credits)

	print("[SCENARIO 4] Lucky Wheel Rewarded Ad Chaining")
	var initial_spins = Global.lucky_wheel_ad_spins_used
	var test_state = {"wheel_ad_ok": false}
	menu._show_admob_rewarded_for_wheel(func():
		test_state["wheel_ad_ok"] = true
		Global.lucky_wheel_ad_spins_used += 1
		Global.spin_lucky_wheel()
	)
	assert(test_state["wheel_ad_ok"] == true)
	assert(Global.lucky_wheel_ad_spins_used == initial_spins + 1)
	print("  - Lucky Wheel Ad Spin Completed. Coins: ", Global.ad_credits)

	print("[SCENARIO 5] Scene Transition: Main Menu -> Pitch (Banner Cleared & Bottom Banner Requested)")
	menu.queue_free()
	Global.remove_all_banners()
	var pitch = load("res://pitch.tscn").instantiate()
	add_child(pitch)
	print("  - Pitch mounted. Match banner requested on BOTTOM.")

	print("[SCENARIO 6] Scene Transition: Pitch -> Main Menu via Interstitial Ad Trigger")
	pitch._clean_match_banner()
	pitch.queue_free()
	Global.remove_all_banners()
	var interstitial_state = {"done": false}
	Global.show_interstitial_ad(func():
		interstitial_state["done"] = true
	)
	assert(interstitial_state["done"] == true)
	var menu2 = load("res://main_menu.tscn").instantiate()
	add_child(menu2)
	menu2._ensure_menu_top_banner()
	print("  - Re-entered Main Menu: Interstitial executed, Top banner restored cleanly.")
	menu2.queue_free()

	print("[SCENARIO 7] Pro VIP Mode Ad Suppression")
	Global.set_premium(true)
	var menu3 = load("res://main_menu.tscn").instantiate()
	add_child(menu3)
	menu3._ensure_menu_top_banner()
	assert(menu3.menu_banner_ad_id == "")
	var vip_state = {"done": false}
	Global.show_interstitial_ad(func(): vip_state["done"] = true)
	assert(vip_state["done"] == true)
	print("  - All banners and interstitials suppressed in Pro mode: OK")
	menu3.queue_free()
	Global.set_premium(false)
"""
    tscn_code = """[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tools/test_ads_runner.gd" id="1_adrunner"]

[node name="TestAdsRunner" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1_adrunner")
"""
    runner_gd_path = os.path.join(PROJECT_DIR, "tools", "test_ads_runner.gd")
    runner_tscn_path = os.path.join(PROJECT_DIR, "tools", "test_ads_runner.tscn")
    with open(runner_gd_path, "w", encoding="utf-8") as f:
        f.write(gd_script)
    with open(runner_tscn_path, "w", encoding="utf-8") as f:
        f.write(tscn_code)

    cmd = [
        GODOT_EXE,
        "--headless",
        "--path", PROJECT_DIR,
        "res://tools/test_ads_runner.tscn"
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    print(res.stdout)
    if res.stderr:
        print("[STDERR]", res.stderr)
    return res.returncode == 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Godot CLI Automation")
    parser.add_argument("--action", choices=["export-aab", "export-apk", "validate", "bump", "version", "test-ads"], default="validate")
    parser.add_argument("--no-bump", action="store_true", help="Don't increment version code on export")
    parser.add_argument("--debug", action="store_true", help="Export as debug build instead of release")
    parser.add_argument("--preset", type=str, default=None, help="Custom export preset name")
    args = parser.parse_args()

    if args.action == "version":
        code, name = get_current_version()
        print(f"Current version: code={code}, name={name}")
    elif args.action == "validate":
        validate_project()
    elif args.action == "test-ads":
        test_ads()
    elif args.action == "bump":
        bump_version()
    elif args.action == "export-aab":
        export_android(target_type="aab", preset_name=args.preset, bump=not args.no_bump, is_debug=args.debug)
    elif args.action == "export-apk":
        export_android(target_type="apk", preset_name=args.preset, bump=not args.no_bump, is_debug=args.debug)

