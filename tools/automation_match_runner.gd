extends Control

var config_path = "res://tools/automation_config.json"
var pitch_scene = preload("res://pitch.tscn")
var pitch_inst = null
var match_mode = "regular"
var max_seconds = 45.0
var elapsed_time = 0.0
var is_quitting = false

func _ready():
	print("==================================================")
	print("[Bol Gol Automation] Starting Match Runner...")
	print("==================================================")
	
	# Rule 1: STRICTLY NO ADS - Enable Premium Mode
	Global.set_premium(true)
	Global.remove_all_banners()

	# MUTE MENU MUSIC: Ensure main_menu.mp3 never plays during recording
	if is_instance_valid(Global.bg_music_player):
		Global.bg_music_player.stop()
		Global.bg_music_player.volume_db = -80.0
	Global.vol_settings["menu_music"] = 0.0
	# Enable ball bounce & goal sounds clearly (subtle bounce sound)
	Global.vol_settings["collision"] = 0.04
	Global.vol_settings["music"] = 1.0
	
	# Load automation configuration
	var home_team = "GALATA FK"
	var away_team = "FENER FK"
	var home_stars = ["Victor Osimhen", "Mauro Icardi", "Lucas Torreira"]
	var away_stars = ["Edin Dzeko", "Dusan Tadic", "Fred"]
	var target_lang = "TR"
	
	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		var json_str = file.get_as_text()
		file.close()
		var json = JSON.new()
		var parse_err = json.parse(json_str)
		if parse_err == OK and typeof(json.data) == TYPE_DICTIONARY:
			var d = json.data
			home_team = d.get("home_team", home_team)
			away_team = d.get("away_team", away_team)
			home_stars = d.get("home_stars", home_stars)
			away_stars = d.get("away_stars", away_stars)
			match_mode = d.get("mode", "regular")
			max_seconds = float(d.get("max_seconds", 45.0))
			target_lang = d.get("lang", "TR")
			print("[Bol Gol Automation] Config loaded successfully:")
			print("  Home: ", home_team, " Stars: ", home_stars)
			print("  Away: ", away_team, " Stars: ", away_stars)
			print("  Mode: ", match_mode, " Lang: ", target_lang)

	# Rule: Set Language (TR, ENG, ESP)
	Global.current_lang = target_lang

	# Rule 2: Configure 3 Star Players for Scorer Announcements
	Global.home_team_name = home_team
	Global.away_team_name = away_team
	
	var home_dict = {}
	for i in range(home_stars.size()):
		home_dict["p" + str(i + 1)] = home_stars[i]
	Global.custom_player_names[home_team] = home_dict
	
	var away_dict = {}
	for i in range(away_stars.size()):
		away_dict["p" + str(i + 1)] = away_stars[i]
	Global.custom_player_names[away_team] = away_dict

	# Rule 3: Fast and exciting match duration (0 = 24s total: 12s per half)
	Global.match_duration = 0
	
	# Instance the pitch
	pitch_inst = pitch_scene.instantiate()
	add_child(pitch_inst)

	# Rule: Exact mobile phone proportions (1.0x native scale)
	if pitch_inst.get("game_camera"):
		pitch_inst.game_camera.zoom = Vector2(1.0, 1.0)

	print("[Bol Gol Automation] Pitch scene instantiated with exact mobile phone proportions!")

func _process(delta: float):
	if is_quitting or not pitch_inst:
		return

	elapsed_time += delta

	# Ensure bg music stays stopped
	if is_instance_valid(Global.bg_music_player) and Global.bg_music_player.playing:
		Global.bg_music_player.stop()

	# Golden Goal mode: Only allow after at least 18s of excitement so no early cutoff
	if match_mode == "golden-goal" and elapsed_time >= 18.0:
		if pitch_inst.score1 > 0 or pitch_inst.score2 > 0:
			if pitch_inst.state != "FULLTIME":
				print("[Bol Gol Automation] Golden Goal scored! Triggering Full Time...")
				pitch_inst.state = "FULLTIME"
				pitch_inst.end_match_timer = 0

	# Normal Fulltime Check: Record from start to the very end
	if pitch_inst.state == "FULLTIME":
		# Wait 2.2 seconds of post-match screen to show final score clearly
		if pitch_inst.end_match_timer >= 2.2 * pitch_inst.FPS_TARGET:
			_finish_match("Match ended normally at Full Time.")
			return

	# Safety fallback timeout
	if elapsed_time >= max_seconds:
		_finish_match("Safety timeout reached (" + str(max_seconds) + "s).")


func _finish_match(reason: String):
	is_quitting = true
	var final_s1 = pitch_inst.score1 if pitch_inst else 0
	var final_s2 = pitch_inst.score2 if pitch_inst else 0
	print("==================================================")
	print("[Bol Gol Automation] " + reason)
	print("[Bol Gol Automation] Final Score: " + str(final_s1) + " - " + str(final_s2))
	print("==================================================")
	get_tree().quit(0)
