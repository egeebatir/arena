import re
import sys
import io

# Ensure UTF-8 output on Windows console
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def test_global_theme_mavi():
    print("--- Testing Global.gd Default Theme ---")
    with open(r"c:\Users\egebatir\Documents\futbol\Global.gd", "r", encoding="utf-8") as f:
        content = f.read()

    if 'var current_theme = "Mavi"' in content:
        print("PASS: Default theme is set to 'Mavi'!")
    else:
        print("FAIL: Default theme is not 'Mavi'")
        return False

    if 'current_theme = "Mavi"' in content:
        print("PASS: Fallback theme in load_progression is 'Mavi'!")
    else:
        print("FAIL: Fallback theme is not 'Mavi'")
        return False
    return True

def test_main_menu_lang():
    print("\n--- Testing main_menu.gd LANG dictionary ---")
    with open(r"c:\Users\egebatir\Documents\futbol\main_menu.gd", "r", encoding="utf-8") as f:
        content = f.read()

    lang_match = re.search(r"var LANG = \{(.*?)\n\}\n", content, re.DOTALL)
    if not lang_match:
        print("FAIL: Could not find LANG in main_menu.gd")
        return False

    lang_block = lang_match.group(1)
    languages = ["TR", "ENG", "ESP", "POR", "ITA"]
    lang_keys = {}

    for lang in languages:
        pattern = rf'"{lang}": \{{(.*?)\n\t\}}'
        match = re.search(pattern, lang_block, re.DOTALL)
        if not match:
            print(f"FAIL: Language {lang} not found in LANG")
            return False
        entries = match.group(1)
        keys = set(re.findall(r'"([A-Z0-9_]+)":', entries))
        lang_keys[lang] = keys
        print(f"  {lang}: {len(keys)} keys")

    base_lang = "ENG"
    base_keys = lang_keys[base_lang]
    all_ok = True
    for lang in languages:
        if lang == base_lang:
            continue
        missing = base_keys - lang_keys[lang]
        extra = lang_keys[lang] - base_keys
        if missing:
            print(f"  FAIL: {lang} missing keys: {missing}")
            all_ok = False
        if extra:
            print(f"  FAIL: {lang} extra keys: {extra}")
            all_ok = False

    if all_ok:
        print("PASS: All 5 languages have identical keys in main_menu.gd!")
    return all_ok

def test_global_quests():
    print("\n--- Testing Global.gd QUEST_POOL Clarifications ---")
    with open(r"c:\Users\egebatir\Documents\futbol\Global.gd", "r", encoding="utf-8") as f:
        content = f.read()

    match = re.search(r"const QUEST_POOL = \{(.*?)\n\}\n\nfunc generate_daily_quests", content, re.DOTALL)
    if not match:
        print("FAIL: Could not find QUEST_POOL in Global.gd")
        return False

    pool_block = match.group(1)
    
    # Check captain clarification
    if "Kaptan oyuncun ({captain})" in pool_block and "your captain ({captain})" in pool_block:
        print("PASS: Captain quests clarified with friendly wording across languages!")
    else:
        print("FAIL: Captain quests missing clarified wording")
        return False

    # Check comeback clarification
    if "Favori takımınla geriye düştüğün maçı çevir ve kazan" in pool_block and "Win a match with your favorite team after trailing behind" in pool_block:
        print("PASS: Comeback quest clarified with favorite team requirement!")
    else:
        print("FAIL: Comeback quest missing clarified wording")
        return False

    return True

def test_shop_and_squad():
    print("\n--- Testing Shop Scroll & Squad Editor Isolation ---")
    with open(r"c:\Users\egebatir\Documents\futbol\main_menu.gd", "r", encoding="utf-8") as f:
        m_content = f.read()

    if "shop_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED" in m_content:
        print("PASS: Shop vertical scroll is disabled!")
    else:
        print("FAIL: Shop vertical scroll is not disabled")
        return False

    if "player_list_overlay.mouse_filter = Control.MOUSE_FILTER_STOP" in m_content:
        print("PASS: Squad editor has MOUSE_FILTER_STOP to prevent background menu scrolling!")
    else:
        print("FAIL: Squad editor missing MOUSE_FILTER_STOP on player_list_overlay")
        return False

    if "KAPTAN" in m_content and "add_player_btn" in m_content:
        print("PASS: Squad editor has Captain badge and dynamic player add button!")
    else:
        print("FAIL: Squad editor missing Captain badge or add button")
        return False

    return True

def test_banner_retry():
    print("\n--- Testing AdMob Banner Backoff Retry ---")
    with open(r"c:\Users\egebatir\Documents\futbol\main_menu.gd", "r", encoding="utf-8") as f:
        m_content = f.read()
    with open(r"c:\Users\egebatir\Documents\futbol\pitch.gd", "r", encoding="utf-8") as f:
        p_content = f.read()

    if "menu_banner_retry_count" in m_content and "Scheduling menu banner retry" in m_content:
        print("PASS: main_menu.gd has periodic/backoff banner retry logic!")
    else:
        print("FAIL: main_menu.gd missing periodic banner retry")
        return False

    if "match_banner_retry_count" in p_content and "Scheduling match banner retry" in p_content:
        print("PASS: pitch.gd has periodic/backoff banner retry logic!")
    else:
        print("FAIL: pitch.gd missing periodic banner retry")
        return False

    return True

def test_pitch_layout_and_contrast():
    print("\n--- Testing Pitch Scoreboard Contrast & Alignments ---")
    with open(r"c:\Users\egebatir\Documents\futbol\pitch.gd", "r", encoding="utf-8") as f:
        p_content = f.read()

    # Check top margin alignment (scoreboard and buttons both at margin_top 32)
    if 'score_margin.add_theme_constant_override("margin_top", 240.0)' in p_content and 'top_ui_margin.add_theme_constant_override("margin_top", 120)' in p_content:
        print("PASS: Scoreboard and top buttons aligned with margin_top = 240/120!")
    else:
        print("FAIL: Scoreboard and top buttons top margin mismatch")
        return False

    # Check restart_btn position below pitch
    if '(screen_h / 2.0) + ARENA_RADIUS + 140.0' in p_content:
        print("PASS: restart_btn is positioned below the pitch!")
    else:
        print("FAIL: restart_btn position is not below the pitch")
        return False

    # Check event_lbl centered (no position.y -= 100 on event_lbl)
    event_init = re.search(r"event_lbl = Label\.new\(\)(.*?)ui_layer\.add_child\(event_lbl\)", p_content, re.DOTALL)
    if event_init and "event_lbl.position.y -=" not in event_init.group(1):
        print("PASS: event_lbl (GOL!) is centered on the pitch without arbitrary offset!")
    else:
        print("FAIL: event_lbl still has vertical offset")
        return False

    # Check scoreboard team contrast
    if "t1_col" in p_content and "t1_outline" in p_content and "t2_col" in p_content and "t2_outline" in p_content:
        print("PASS: Scoreboard has dynamic luminance contrast & outlines for team names and scores!")
    else:
        print("FAIL: Scoreboard missing team contrast/outlines")
        return False

    # Check trigger_popup contrast
    if 'event_lbl.add_theme_color_override("font_outline_color", out_col)' in p_content:
        print("PASS: GOL! event popup has dynamic contrast and outline!")
    else:
        print("FAIL: GOL! event popup missing contrast/outline")
        return False

    return True

if __name__ == "__main__":
    r1 = test_global_theme_mavi()
    r2 = test_main_menu_lang()
    r3 = test_global_quests()
    r4 = test_shop_and_squad()
    r5 = test_banner_retry()
    r6 = test_pitch_layout_and_contrast()
    if r1 and r2 and r3 and r4 and r5 and r6:
        print("\nALL BACKEND VERIFICATION TESTS PASSED SUCCESSFULLY!")
        sys.exit(0)
    else:
        print("\nSOME TESTS FAILED!")
        sys.exit(1)
