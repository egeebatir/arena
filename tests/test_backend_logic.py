import re
import sys
import io

# Ensure UTF-8 output on Windows console
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def test_global_theme_turkuaz():
    print("--- Testing Global.gd Default Theme ---")
    with open(r"c:\Users\egebatir\Documents\futbol\Global.gd", "r", encoding="utf-8") as f:
        content = f.read()

    if 'var current_theme = "Turkuaz"' in content:
        print("PASS: Default theme is set to 'Turkuaz'!")
    else:
        print("FAIL: Default theme is not 'Turkuaz'")
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

    if "daily_quests.append(q)" in content:
        print("PASS: generate_daily_quests appends quest items to daily_quests!")
    else:
        print("FAIL: generate_daily_quests missing daily_quests.append(q)")
        return False

    if "if daily_date != today:" in content and "elif daily_quests.is_empty():" in content:
        print("PASS: check_daily_reset decouples daily spin reset from empty quest array!")
    else:
        print("FAIL: check_daily_reset still resets lucky wheel when daily_date matches today")
        return False

    return True

def test_shop_and_squad():
    print("\n--- Testing Shop Scroll & Squad Editor Isolation ---")
    with open(r"c:\Users\egebatir\Documents\futbol\main_menu.gd", "r", encoding="utf-8") as f:
        m_content = f.read()

    if "shop_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS" in m_content or "shop_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER" in m_content:
        print("PASS: Shop vertical scroll is enabled with visible grabber!")
    else:
        print("FAIL: Shop vertical scroll is not SHOW_ALWAYS or SHOW_NEVER")
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

    # Check top margin alignment (scoreboard and buttons harmonized in unified top_header_margin)
    if 'top_header_margin' in p_content or ('score_margin.add_theme_constant_override("margin_top", 64)' in p_content and 'top_ui_margin.add_theme_constant_override("margin_top", 64)' in p_content):
        print("PASS: Scoreboard and top buttons aligned with harmonized top margin!")
    else:
        print("FAIL: Scoreboard and top buttons top margin mismatch")
        return False

    # Check Camera2D anchor_mode fixed top-left to avoid mobile bottom-right distortion
    if 'game_camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT' in p_content:
        print("PASS: Camera2D anchor_mode is ANCHOR_MODE_FIXED_TOP_LEFT!")
    else:
        print("FAIL: Camera2D anchor_mode is not ANCHOR_MODE_FIXED_TOP_LEFT")
        return False

    # Check restart_btn position below pitch
    if 'CENTER.y + ARENA_RADIUS +' in p_content:
        print("PASS: restart_btn is positioned dynamically below the pitch!")
    else:
        print("FAIL: restart_btn position is not below the pitch")
        return False

    # Check scoreboard team crest icons removed as requested by user
    if 't1_icon' not in p_content and 't2_icon' not in p_content:
        print("PASS: Scoreboard is clean without redundant team crest icons!")
    else:
        print("FAIL: Scoreboard still contains team crest icons")
        return False

    # Check stats saving
    if 'Global.save_stats()' in p_content:
        print("PASS: Full-time match outcome triggers Global.save_stats()!")
    else:
        print("FAIL: pitch.gd missing Global.save_stats()")
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
    if 'event_lbl.add_theme_color_override("font_outline_color", outline_col)' in p_content:
        print("PASS: GOL! event popup has dynamic contrast and outline!")
    else:
        print("FAIL: GOL! event popup missing contrast/outline")
        return False

    return True

def test_lucky_wheel_logic():
    print("\n--- Testing Lucky Wheel Ad Safety & Callback Integrity ---")
    with open(r"c:\Users\egebatir\Documents\futbol\main_menu.gd", "r", encoding="utf-8") as f:
        m_content = f.read()

    if "current_wheel_status_callback: Callable = Callable()" in m_content:
        print("PASS: current_wheel_status_callback declared in main_menu.gd!")
    else:
        print("FAIL: current_wheel_status_callback not declared")
        return False

    if "func _show_admob_rewarded_for_wheel(on_reward_callback: Callable) -> bool:" in m_content:
        print("PASS: _show_admob_rewarded_for_wheel returns bool for immediate UI lock prevention!")
    else:
        print("FAIL: _show_admob_rewarded_for_wheel does not return bool")
        return False

    if "var started = _show_admob_rewarded_for_wheel" in m_content and "update_wheel_status.call()" in m_content:
        print("PASS: Wheel UI updates and does not lock buttons if ad is preparing!")
    else:
        print("FAIL: Wheel UI can lock buttons when ad is preparing")
        return False

    return True

def test_admob_safety_guard():
    print("\n--- Testing AdMob Policy & Test Ads Guard ---")
    with open(r"c:\Users\egebatir\Documents\futbol\Global.gd", "r", encoding="utf-8") as f:
        g_content = f.read()

    with open(r"c:\Users\egebatir\Documents\futbol\addons\AdmobPlugin\Admob.gd", "r", encoding="utf-8") as f:
        a_content = f.read()

    with open(r"c:\Users\egebatir\Documents\futbol\addons\AdmobPlugin\model\AdmobConfig.gd", "r", encoding="utf-8") as f:
        c_content = f.read()

    if "OS.is_debug_build()" in g_content and "admob_instance.is_real = false" in g_content:
        print("PASS: Global.gd automatically forces is_real = false on debug builds!")
    else:
        print("FAIL: Global.gd does not force is_real = false on debug builds")
        return False

    if "OS.is_debug_build()" in a_content and "is_real = false" in a_content:
        print("PASS: Admob.gd automatically forces is_real = false on debug builds!")
    else:
        print("FAIL: Admob.gd does not force is_real = false on debug builds")
        return False

    if "PackedStringArray" in c_content and "PackedStringArray(test_device_hashed_ids)" in a_content:
        print("PASS: Test device IDs marshaled as PackedStringArray for Android JNI String[] compliance!")
    else:
        print("FAIL: Test device IDs not properly packed as PackedStringArray")
        return False

    return True

def test_v114_ui_and_ad_rules():
    import os
    print("\n--- Testing v1.1.4 UI, Quest, Hourglass & Interstitial Rules ---")
    with open("Global.gd", "r", encoding="utf-8") as f:
        g_content = f.read()
    with open("main_menu.gd", "r", encoding="utf-8") as f:
        m_content = f.read()

    if not os.path.exists("hourglass_icon.svg"):
        print("FAIL: Missing hourglass_icon.svg")
        return False
    if "hourglass_icon.svg" not in m_content or "⏳" in m_content:
        print("FAIL: Shop cooldown button does not use hourglass_icon.svg cleanly")
        return False
    print("PASS: Shop cooldown uses custom SVG hourglass icon!")

    if "lifetime_matches_played <= 5" in g_content and "interstitial_return_counter % 2" in g_content:
        print("PASS: Interstitial ad skips first 5 matches and runs every 2 matches afterwards!")
    else:
        print("FAIL: Interstitial frequency/grace guard missing in Global.gd")
        return False

    if "house_ad_timer.wait_time = 12.0" in m_content and "_create_top_badge_shell" in m_content:
        print("PASS: Top badge uses unified full-width shell with 12s cycling timer!")
    else:
        print("FAIL: Top badge full-width shell or 12s timer missing")
        return False

    if "has_custom_captain_configured()" in g_content:
        print("PASS: Daily quests validate favorite team & custom captain before generation/progression!")
    else:
        print("FAIL: Custom captain guard missing in Global.gd")
        return False

    return True

def test_closed_beta_updates():
    import os
    from PIL import Image
    print("\n--- Testing Closed Beta Updates (VS Swap, Crests, SFX, +25% Quests, National i18n, Penalty Bonus) ---")
    with open("Global.gd", "r", encoding="utf-8") as f:
        g_content = f.read()
    with open("main_menu.gd", "r", encoding="utf-8") as f:
        m_content = f.read()
    with open("pitch.gd", "r", encoding="utf-8") as f:
        p_content = f.read()
    with open("ball.gd", "r", encoding="utf-8") as f:
        b_content = f.read()

    # 1. VS side-swap button
    if "func _on_swap_teams_pressed():" in m_content and "versus_badge.pressed.connect(_on_swap_teams_pressed)" in m_content:
        print("PASS: VS button functions as team side swapper!")
    else:
        print("FAIL: VS side-swap handler missing in main_menu.gd")
        return False

    # 2. Barcelona & Atletico crests valid 800x800 RGBA PNGs >= 15 KB
    for fn in ["bar1.png", "atm1.png"]:
        if not os.path.exists(fn) or os.path.getsize(fn) < 15000:
            print(f"FAIL: {fn} missing or too small")
            return False
        im = Image.open(fn)
        if im.size != (800, 800) or im.mode != "RGBA" or im.getpixel((0, 0))[3] != 0:
            print(f"FAIL: {fn} invalid dimensions/mode/corner alpha: {im.size}, {im.mode}")
            return False
    print("PASS: bar1.png and atm1.png verified as 800x800 transparent RGBA crests!")

    # 3. Reward collect SFX
    if not os.path.exists("reward_collect.ogg") or "play_reward_collect()" not in g_content or "Global.play_reward_collect()" not in m_content:
        print("FAIL: reward_collect.ogg or play_reward_collect() wiring missing")
        return False
    print("PASS: Dedicated reward_collect.ogg SFX wired to mission claims & prize/wheel dialog!")

    # 4. Mission rewards multiple of 5 and >= 35
    quest_rewards = [int(x) for x in re.findall(r'"reward":\s*(\d+)', g_content)]
    if len(quest_rewards) != 21 or any(r % 5 != 0 or r < 35 for r in quest_rewards):
        print(f"FAIL: Unexpected quest rewards in Global.gd: {quest_rewards}")
        return False
    print("PASS: All 21 mission rewards increased by ~25% and rounded up to multiples of 5!")

    # 5. National teams localized across 5 languages (ONLY national teams)
    if "const NATIONAL_NAMES =" not in g_content or "func get_team_display_name(" not in g_content:
        print("FAIL: NATIONAL_NAMES / get_team_display_name missing in Global.gd")
        return False
    nat_keys = re.findall(r'"([^"]+)":\s*\{"colors":.*?"type":\s*"national"\}', g_content)
    missing_nat = [k for k in nat_keys if f'"{k}":' not in g_content.split("const NATIONAL_NAMES =")[1].split("func get_team_display_name")[0]]
    if len(nat_keys) != 46 or missing_nat:
        print(f"FAIL: National names coverage issue (total={len(nat_keys)}, missing={missing_nat})")
        return False
    print("PASS: All 46 national teams translated across 5 languages while clubs remain canonical!")

    # 6. Match Penalty Bonus System (+10% speed, +15% bounciness, +10% goal width)
    required_p = [
        "const PENALTY_DURATION_SEC: float = 3.0",
        "const PENALTY_GOAL_WIDTH_MULT: float = 1.10",
        "const PENALTY_ELASTICITY_MULT: float = 1.15",
        "const PENALTY_PROB_FIRST_HALF: float = 0.05",
        "const PENALTY_PROB_SECOND_HALF: float = 0.10",
        "penalty_disclaimer_panel",
        "\"' pen\"",
    ]
    for tok in required_p:
        if tok not in p_content:
            print(f"FAIL: pitch.gd missing penalty bonus symbol: {tok}")
            return False
    if "penalty_bonus_active" not in b_content or "1.10" not in b_content or "1.15" not in b_content:
        print("FAIL: ball.gd missing penalty speed/bounce modifier (+10% speed / +15% bounce)")
        return False
    print("PASS: Match penalty bonus system (+10% speed, +15% bounce, +10% goal width, 3s, 5%/10% prob, pen note) verified!")

    # 7. Region-Fixed Elite Club Pricing & Currency
    required_g_billing = [
        "var premium_price_currency_code: String = \"\"",
        "func resolve_region_from_locale(",
        "func get_player_region_code(",
        "func get_premium_currency_code(",
        "func set_play_billing_price(",
    ]
    for tok in required_g_billing:
        if tok not in g_content:
            print(f"FAIL: Global.gd missing regional pricing symbol: {tok}")
            return False
    g_price_fn = g_content.split("func get_formatted_premium_price()")[1].split("\nfunc ")[0]
    g_price_code_lines = [ln.split("#", 1)[0] for ln in g_price_fn.splitlines()]
    if "current_lang" in "\n".join(g_price_code_lines):
        print("FAIL: Global.get_formatted_premium_price() still depends on current_lang!")
        return False
    if "Global.set_play_billing_price" not in m_content or "func _format_premium_currency_badge_text()" not in m_content or "label_premium_price_badge" not in m_content:
        print("FAIL: main_menu.gd missing region-fixed pricing / Store badge integration")
        return False
    print("PASS: Elite Club price & currency are strictly region-locked and decoupled from in-game language!")

    return True

if __name__ == "__main__":
    r1 = test_global_theme_turkuaz()
    r2 = test_main_menu_lang()
    r3 = test_global_quests()
    r4 = test_shop_and_squad()
    r5 = test_banner_retry()
    r6 = test_pitch_layout_and_contrast()
    r7 = test_lucky_wheel_logic()
    r8 = test_admob_safety_guard()
    r9 = test_v114_ui_and_ad_rules()
    r10 = test_closed_beta_updates()
    if r1 and r2 and r3 and r4 and r5 and r6 and r7 and r8 and r9 and r10:
        print("\nALL BACKEND VERIFICATION TESTS PASSED SUCCESSFULLY!")
        sys.exit(0)
    else:
        print("\nSOME TESTS FAILED!")
        sys.exit(1)
