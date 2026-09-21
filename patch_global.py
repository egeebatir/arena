import re

with open(r'c:\Users\egebatir\Documents\futbol\Global.gd', 'r', encoding='utf-8') as f:
    content = f.read()

secure_funcs = """
const SAVE_SALT = "bol_gol_futbol_anti_cheat_salt_2026"
func generate_save_hash(data_str: String) -> String:
\treturn (data_str + SAVE_SALT).sha256_text()

func save_progression():
\tvar tmp_path = "user://progression.json.tmp"
\tvar final_path = "user://progression.json"
\tvar file = FileAccess.open(tmp_path, FileAccess.WRITE)
\tif file:
\t\tvar data = {
\t\t\t"ad_credits": ad_credits,
\t\t\t"unlocked_ball_skins": unlocked_ball_skins,
\t\t\t"equipped_ball_skin": equipped_ball_skin,
\t\t\t"unlocked_hats": unlocked_hats,
\t\t\t"equipped_hat": equipped_hat,
\t\t\t"favorite_team": favorite_team,
\t\t\t"login_method": login_method,
\t\t\t"matches_played_since_prompt": matches_played_since_prompt,
\t\t\t"is_premium": is_premium,
\t\t\t"vibration_enabled": vibration_enabled,
\t\t\t"home_team_name": home_team_name,
\t\t\t"away_team_name": away_team_name,
\t\t\t"home_selected": home_selected,
\t\t\t"away_selected": away_selected,
\t\t\t"custom_player_names": custom_player_names,
\t\t\t"unlocked_achievements": unlocked_achievements,
\t\t\t"favorite_team_goals_scored": favorite_team_goals_scored,
\t\t\t"daily_date": daily_date,
\t\t\t"lucky_wheel_free_spins_used": lucky_wheel_free_spins_used,
\t\t\t"lucky_wheel_ad_spins_used": lucky_wheel_ad_spins_used,
\t\t\t"lucky_wheel_pending_ad_spins": lucky_wheel_pending_ad_spins,
\t\t\t"daily_quests": daily_quests,
\t\t\t"current_lang": current_lang,
\t\t\t"master_vol": master_vol,
\t\t\t"vol_settings": vol_settings,
\t\t\t"current_theme": current_theme,
\t\t\t"shake_enabled": shake_enabled,
\t\t\t"match_duration": match_duration
\t\t}
\t\tvar json_str = JSON.stringify(data)
\t\tvar hash_val = generate_save_hash(json_str)
\t\tvar secure_data = {
\t\t\t"payload": json_str,
\t\t\t"signature": hash_val
\t\t}
\t\tfile.store_string(JSON.stringify(secure_data))
\t\tfile.close()
\t\tDirAccess.rename_absolute(tmp_path, final_path)

func load_progression():
\tif not FileAccess.file_exists("user://progression.json"):
\t\tcheck_daily_reset()
\t\treturn
\tvar file = FileAccess.open("user://progression.json", FileAccess.READ)
\tif file:
\t\tvar raw = file.get_as_text()
\t\tfile.close()
\t\tvar parsed = JSON.parse_string(raw)
\t\tif typeof(parsed) != TYPE_DICTIONARY:
\t\t\tprint("[Global] Corrupted progression.json detected.")
\t\t\tDirAccess.copy_absolute("user://progression.json", "user://progression.json.corrupted")
\t\t\tcheck_daily_reset()
\t\t\treturn
\t\t
\t\tvar data_to_load = parsed
\t\tif parsed.has("signature") and parsed.has("payload"):
\t\t\tvar expected = generate_save_hash(parsed["payload"])
\t\t\tif expected != parsed["signature"]:
\t\t\t\tprint("[Global] SECURITY ERROR: Savegame tampering detected! Resetting ad_credits.")
\t\t\t\tvar tmp = JSON.parse_string(parsed["payload"])
\t\t\t\tif typeof(tmp) == TYPE_DICTIONARY:
\t\t\t\t\ttmp["ad_credits"] = 0
\t\t\t\t\tparsed["payload"] = JSON.stringify(tmp)
\t\t\tdata_to_load = JSON.parse_string(parsed["payload"])
\t\t
\t\tparsed = data_to_load
"""

# Find start of save_progression and start of check_daily_reset
pattern = r"func save_progression\(\):.*?func check_daily_reset\(\):"

new_content = re.sub(pattern, secure_funcs + "\nfunc check_daily_reset():", content, flags=re.DOTALL)

with open(r'c:\Users\egebatir\Documents\futbol\Global.gd', 'w', encoding='utf-8') as f:
    f.write(new_content)
print("Patched Global.gd successfully.")
