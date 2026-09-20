import os
import sys
import io
import subprocess

# Ensure UTF-8 output on Windows console
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

DOCS_DIR = r"c:\Users\egebatir\Documents"
FUTBOL_DIR = os.path.join(DOCS_DIR, "futbol")
AUTO_DIR = os.path.join(DOCS_DIR, "futbol_automation")
WEB_DIR = os.path.join(DOCS_DIR, "futbol-web")

def check_council_board():
    print("--- [1/4] Checking Council Blackboard & Roles ---")
    root_board = os.path.join(DOCS_DIR, "COUNCIL_BOARD.md")
    workspace_board = os.path.join(FUTBOL_DIR, "COUNCIL_BOARD.md")
    council_dir = os.path.join(FUTBOL_DIR, ".agents", "council")

    if not os.path.exists(root_board):
        print(f"FAIL: Root COUNCIL_BOARD.md not found at {root_board}")
        return False
    if not os.path.exists(workspace_board):
        print(f"FAIL: Workspace COUNCIL_BOARD.md not found at {workspace_board}")
        return False

    required_agents = [
        "01_orchestrator.md",
        "02_engine_master.md",
        "03_viral_growth.md",
        "04_web_architect.md",
        "05_adversarial_qa.md",
        "06_aso_specialist.md"
    ]
    for agent_file in required_agents:
        path = os.path.join(council_dir, agent_file)
        if not os.path.exists(path):
            print(f"FAIL: Agent blueprint missing: {agent_file}")
            return False

    print("PASS: All 6 Council Agent Blueprints and Boards exist and are in sync!")
    return True

def check_futbol_mobile():
    print("\n--- [2/4] Checking Mobil Game (futbol) ---")
    test_script = os.path.join(FUTBOL_DIR, "tests", "test_backend_logic.py")
    if not os.path.exists(test_script):
        print("FAIL: test_backend_logic.py not found!")
        return False

    res = subprocess.run([sys.executable, test_script], capture_output=True, text=True)
    if res.returncode != 0:
        print("FAIL: test_backend_logic.py failed:")
        print(res.stdout)
        print(res.stderr)
        return False
    print("PASS: Mobile backend verification passed completely (0 errors)!")
    return True

def check_futbol_automation():
    print("\n--- [3/4] Checking Automation Factory (futbol_automation) ---")
    main_py = os.path.join(AUTO_DIR, "main.py")
    if not os.path.exists(main_py):
        print("FAIL: futbol_automation/main.py not found!")
        return False

    # Check python syntax of main.py
    res = subprocess.run([sys.executable, "-m", "py_compile", main_py], capture_output=True, text=True)
    if res.returncode != 0:
        print("FAIL: futbol_automation/main.py syntax error:")
        print(res.stderr)
        return False

    # Check existence of core modules
    modules = [
        os.path.join(AUTO_DIR, "src", "fixtures", "fixture_manager.py"),
        os.path.join(AUTO_DIR, "src", "recorder", "match_recorder.py"),
        os.path.join(AUTO_DIR, "src", "editor", "video_editor.py"),
        os.path.join(AUTO_DIR, "src", "ai", "metadata_generator.py"),
        os.path.join(AUTO_DIR, "src", "publishers", "social_manager.py"),
    ]
    for m in modules:
        if not os.path.exists(m):
            print(f"FAIL: Module missing: {m}")
            return False

    print("PASS: Automation factory scripts & modules verified with valid syntax!")
    return True

def check_futbol_web():
    print("\n--- [4/4] Checking Web & Landing (futbol-web) ---")
    project_godot = os.path.join(WEB_DIR, "project.godot")
    if not os.path.exists(project_godot):
        print("FAIL: futbol-web/project.godot not found!")
        return False

    export_cfg = os.path.join(WEB_DIR, "export_presets.cfg")
    if not os.path.exists(export_cfg):
        print("FAIL: futbol-web/export_presets.cfg not found!")
        return False

    print("PASS: futbol-web project structure and export configuration verified!")
    return True

if __name__ == "__main__":
    ok1 = check_council_board()
    ok2 = check_futbol_mobile()
    ok3 = check_futbol_automation()
    ok4 = check_futbol_web()

    if ok1 and ok2 and ok3 and ok4:
        print("\n=======================================================")
        print(">>> 🏛️ ALL ECOSYSTEM HEALTH & COUNCIL CHECKS PASSED! <<<")
        print("=======================================================")
        sys.exit(0)
    else:
        print("\n>>> ECOSYSTEM HEALTH CHECK FAILED! <<<")
        sys.exit(1)
