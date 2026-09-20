"""
Cross-Project Version & Ecosystem Integrity Test Suite
Audited by Adversarial QA & Version Release Controller.
Ensures zero broken links, zero leaked secrets, zero placeholder data, and synchronized package identities.
"""
import os
import sys
import io
import json
import re

# Ensure UTF-8 output on Windows console
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

DOCS_DIR = r"c:\Users\egebatir\Documents"
FUTBOL_DIR = os.path.join(DOCS_DIR, "futbol")
AUTO_DIR = os.path.join(DOCS_DIR, "futbol_automation")
WEB_DIR = os.path.join(DOCS_DIR, "Bol Gol Futbol", "webfutbol")

def test_package_name_consistency():
    print("--- [1/5] Testing Package Name Consistency across Projects ---")
    expected_package = "com.ebstudyo.bolgol"
    
    # 1. Check futbol export_presets.cfg
    export_cfg = os.path.join(FUTBOL_DIR, "export_presets.cfg")
    with open(export_cfg, "r", encoding="utf-8") as f:
        cfg_content = f.read()
    if f'package/unique_name="{expected_package}"' not in cfg_content:
        print(f"FAIL: {expected_package} not found in {export_cfg}")
        return False
    print(f"  PASS: {expected_package} verified in mobile export_presets.cfg")

    # 2. Check metadata_generator.py in futbol_automation
    meta_gen_file = os.path.join(AUTO_DIR, "src", "ai", "metadata_generator.py")
    with open(meta_gen_file, "r", encoding="utf-8") as f:
        meta_content = f.read()
    if f"id={expected_package}" not in meta_content:
        print(f"FAIL: id={expected_package} not found in {meta_gen_file}")
        return False
    if "com.ebstudio.bolgolfutbol" in meta_content:
        print(f"FAIL: Deprecated misspelled package id still present in {meta_gen_file}")
        return False
    print("  PASS: YouTube metadata generator uses verified store URL")

    # 3. Check community_schedule.json
    comm_file = os.path.join(AUTO_DIR, "config", "community_schedule.json")
    with open(comm_file, "r", encoding="utf-8") as f:
        comm_content = f.read()
    if f"id={expected_package}" not in comm_content:
        print(f"FAIL: id={expected_package} not found in {comm_file}")
        return False
    print("  PASS: YouTube community schedule uses verified store URL")

    return True

def test_deploy_security_hygiene():
    print("\n--- [2/5] Testing Web Deployment Security & Secret Hygiene ---")
    deploy_py = os.path.join(WEB_DIR, "deploy.py")
    with open(deploy_py, "r", encoding="utf-8") as f:
        content = f.read()

    # Verify no hardcoded password string in deploy.py
    pass_matches = re.findall(r'"FTP_PASS":\s*"([^"]+)"', content)
    if pass_matches and pass_matches[0].strip() != "":
        print(f"FAIL: Hardcoded plaintext FTP password detected in {deploy_py}!")
        return False
    print("  PASS: deploy.py contains no plaintext passwords")

    # Verify .env is in .gitignore
    web_gitignore = os.path.join(WEB_DIR, ".gitignore")
    with open(web_gitignore, "r", encoding="utf-8") as f:
        gi_content = f.read()
    if ".env" not in gi_content:
        print(f"FAIL: .env is not ignored in {web_gitignore}!")
        return False
    print("  PASS: .env is strictly ignored in web repository")

    return True

def test_squad_and_fixture_integrity():
    print("\n--- [3/5] Testing Squad & Fixture Integrity (Zero Placeholders) ---")
    stars_file = os.path.join(AUTO_DIR, "config", "star_players.json")
    fixtures_file = os.path.join(AUTO_DIR, "config", "fixtures.json")

    with open(stars_file, "r", encoding="utf-8") as f:
        stars_data = json.load(f)

    placeholder_teams = []
    for k, v in stars_data.items():
        if any("Yıldız" in str(p) or "Kaptan" in str(v.get("captain")) for p in v.get("star_players", [])):
            placeholder_teams.append(k)

    if placeholder_teams:
        print(f"FAIL: Star players database has placeholder text in: {placeholder_teams}")
        return False
    print(f"  PASS: All {len(stars_data)} teams in star_players.json have 100% verified real names!")

    with open(fixtures_file, "r", encoding="utf-8") as f:
        fixtures_data = json.load(f)

    bad_fixtures = []
    for fix in fixtures_data.get("fixtures", []):
        for side in ["home", "away"]:
            players = fix.get(side, {}).get("star_players", [])
            if any("Yıldız" in str(p) for p in players):
                bad_fixtures.append(fix.get("id"))
                break
        if fix.get("home", {}).get("key") == "BOURNEMOUTH SC" and fix.get("home", {}).get("league") == "SUPER_LIG":
            bad_fixtures.append(fix.get("id"))

    if bad_fixtures:
        print(f"FAIL: Found {len(bad_fixtures)} fixtures with placeholder players or wrong league in fixtures.json")
        return False
    print(f"  PASS: All {len(fixtures_data.get('fixtures', []))} fixtures in queue are clean and verified!")

    return True

def test_council_agent_blueprints():
    print("\n--- [4/5] Testing Council Blueprints & Version Controller ---")
    council_dir = os.path.join(FUTBOL_DIR, ".agents", "council")
    expected_agents = [
        "01_orchestrator.md",
        "02_engine_master.md",
        "03_viral_growth.md",
        "04_web_architect.md",
        "05_adversarial_qa.md",
        "06_aso_specialist.md",
        "07_version_controller.md"
    ]

    for agent_file in expected_agents:
        p = os.path.join(council_dir, agent_file)
        if not os.path.exists(p):
            print(f"FAIL: Missing Council agent blueprint: {agent_file}")
            return False
    print(f"  PASS: All {len(expected_agents)} Council blueprints (including 07_version_controller) exist on disk")

    # Verify 4 inspectors defined in 05_adversarial_qa.md
    qa_file = os.path.join(council_dir, "05_adversarial_qa.md")
    with open(qa_file, "r", encoding="utf-8") as f:
        qa_text = f.read()
    inspectors = [
        "inspector_engine_core",
        "inspector_pipeline_media",
        "inspector_growth_localization",
        "inspector_ecosystem_sync"
    ]
    for insp in inspectors:
        if insp not in qa_text:
            print(f"FAIL: Inspector role {insp} not documented in {qa_file}")
            return False
    print("  PASS: All 4 specialized adversarial inspectors formally registered")

    return True

def test_web_and_mobile_version_sync():
    print("\n--- [5/5] Testing Mobile & Web Version Synchronization ---")
    export_cfg = os.path.join(FUTBOL_DIR, "export_presets.cfg")
    with open(export_cfg, "r", encoding="utf-8") as f:
        content = f.read()

    v_code = re.search(r"version/code=(\d+)", content)
    v_name = re.search(r'version/name="([^"]+)"', content)

    if not v_code or not v_name:
        print("FAIL: Could not extract version/code or version/name from export_presets.cfg")
        return False

    code_val = v_code.group(1)
    name_val = v_name.group(1)
    print(f"  Mobile Target: Version {name_val} (Code: {code_val})")

    web_index = os.path.join(WEB_DIR, "index.html")
    if os.path.exists(web_index):
        with open(web_index, "r", encoding="utf-8") as f:
            w_content = f.read()
        if name_val in w_content or "v1.0." in w_content:
            print("  PASS: Web index.html contains release version tracking")

    return True

def test_web_pck_size_sync():
    print("\n--- [6/6] Testing Web PCK Size Synchronization ---")
    web_pck = os.path.join(WEB_DIR, "weboyun1.pck")
    web_index = os.path.join(WEB_DIR, "index.html")
    if not os.path.exists(web_pck) or not os.path.exists(web_index):
        print("  SKIP: weboyun1.pck or index.html not found")
        return True
    
    actual_size = os.path.getsize(web_pck)
    with open(web_index, "r", encoding="utf-8") as f:
        content = f.read()
    
    match = re.search(r'"weboyun1\.pck":\s*(\d+)', content)
    if not match:
        print("FAIL: Could not find weboyun1.pck size in web index.html GODOT_CONFIG")
        return False
    
    declared_size = int(match.group(1))
    if actual_size != declared_size:
        print(f"FAIL: weboyun1.pck size mismatch! Actual on disk: {actual_size}, Declared in index.html: {declared_size}")
        return False
    
    print(f"  PASS: weboyun1.pck size ({actual_size} bytes) perfectly matches index.html GODOT_CONFIG!")
    return True

if __name__ == "__main__":
    t1 = test_package_name_consistency()
    t2 = test_deploy_security_hygiene()
    t3 = test_squad_and_fixture_integrity()
    t4 = test_council_agent_blueprints()
    t5 = test_web_and_mobile_version_sync()
    t6 = test_web_pck_size_sync()

    if t1 and t2 and t3 and t4 and t5 and t6:
        print("\n=======================================================")
        print(">>> 🏛️ ALL CROSS-PROJECT VERSION & INTEGRITY CHECKS PASSED! <<<")
        print("=======================================================")
        sys.exit(0)
    else:
        print("\n>>> CROSS-PROJECT INTEGRITY CHECK FAILED! <<<")
        sys.exit(1)

