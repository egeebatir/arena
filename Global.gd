extends Node

var bg_music_player: AudioStreamPlayer
var click_player: AudioStreamPlayer
var goal_music_player: AudioStreamPlayer

var current_lang = "TR"
var home_team_name = "GALATA FK"
var away_team_name = "FENER FK"
var LANG = {
	"TR": {
		"GOAL": "GOL!", "HT": "IY", "FT": "MS"
	},
	"ENG": {
		"GOAL": "GOAL!", "HT": "HT", "FT": "FT"
	},
	"ESP": {
		"GOAL": "¡GOL!", "HT": "MT", "FT": "FINAL"
	},
	"POR": {
		"GOAL": "GOLO!", "HT": "INT", "FT": "FIM"
	}
}

# --- NEW SETTINGS & THEMES ---
var master_vol = 1.0
var vol_settings = {
	"stadium": 0.3,
	"menu_music": 0.4,
	"music": 0.6,
	"collision": 0.02,
	"whistle": 0.4
}

var current_theme = "Turkuaz"
var shake_enabled = true
var vibration_enabled = true
var match_duration = 1 # 0 = Kısa (24s), 1 = Normal (36s), 2 = Uzun (48s)
var match_history: Array = [] # [{home, away, home_score, away_score}]

# --- PROGRESSION & ADS ---
var ad_credits: int = 0
var unlocked_ball_skins: Array = ["default"]
var equipped_ball_skin: String = "default"
var unlocked_hats: Array = []
var equipped_hat: String = "none" # "none", "kings_crown", "queens_crown"
var favorite_team: String = ""
var login_method: String = ""
var matches_played_since_prompt: int = 0
var is_premium: bool = false
var premium_price_formatted: String = ""
var home_selected: bool = true
var away_selected: bool = true
var custom_player_names: Dictionary = {}
var unlocked_achievements: Array = []
var favorite_team_goals_scored: int = 0

# --- DAILY QUESTS & LUCKY WHEEL ---
var daily_date: String = ""
var lucky_wheel_free_spins_used: int = 0
var lucky_wheel_ad_spins_used: int = 0
var lucky_wheel_pending_ad_spins: int = 0
var daily_quests: Array = []

func get_formatted_premium_price() -> String:
	if premium_price_formatted != "":
		var p = premium_price_formatted.replace("₺", "").strip_edges()
		if current_lang == "TR":
			return p + " TL" if not p.ends_with("TL") else p
		return premium_price_formatted
	if current_lang == "TR":
		return "49.99 TL"
	elif current_lang == "ESP" or current_lang == "POR":
		return "0.99 €"
	return "$0.99"

func is_skin_unlocked(skin_id: String) -> bool:
	return is_premium or (skin_id in unlocked_ball_skins)

func is_hat_unlocked(hat_id: String) -> bool:
	return is_premium or (hat_id in unlocked_hats)

func set_premium(val: bool):
	is_premium = val
	save_progression()

# --- GOOGLE PLAY GAMES & ACHIEVEMENTS ---
var play_games_sign_in_client: Node = null
var play_games_achievements_client: Node = null
var play_games_leaderboards_client: Node = null

const ACHIEVEMENTS = {
	"FIRST_WIN": {
		"id": "CgkI2eP165kXEAIQAQ",
		"title": {"TR": "İlk Galibiyet", "ENG": "First Victory", "ESP": "Primera Victoria", "POR": "Primeira Vitória"},
		"desc": {"TR": "İlk maçını kazan", "ENG": "Win your first match", "ESP": "Gana tu primer partido", "POR": "Vença sua primeira partida"}
	},
	"CLEAN_SHEET": {
		"id": "CgkI2eP165kXEAIQAg",
		"title": {"TR": "Gol Yemeden", "ENG": "Clean Sheet", "ESP": "Valla Invicta", "POR": "Sem Sofrer Golos"},
		"desc": {"TR": "Gol yemeden maç kazan", "ENG": "Win without conceding", "ESP": "Gana sin recibir goles", "POR": "Vença sem sofrer golos"}
	},
	"FIVE_GOALS": {
		"id": "CgkI2eP165kXEAIQAw",
		"title": {"TR": "Gol Yağmuru", "ENG": "Goal Rain", "ESP": "Lluvia de Goles", "POR": "Chuva de Golos"},
		"desc": {"TR": "Bir maçta 5 veya daha fazla gol at", "ENG": "Score 5+ goals in a match", "ESP": "Anota 5+ goles en un partido", "POR": "Marque 5+ golos numa partida"}
	},
	"HAT_TRICK": {
		"id": "CgkI2eP165kXEAIQBA",
		"title": {"TR": "Hat-Trick", "ENG": "Hat-Trick", "ESP": "Hat-Trick", "POR": "Hat-Trick"},
		"desc": {"TR": "Aynı oyuncuyla bir maçta 3 gol at", "ENG": "Score 3 goals with the same player", "ESP": "Anota 3 goles con el mismo jugador", "POR": "Marque 3 golos com o mesmo jogador"}
	},
	"COMEBACK_KING": {
		"id": "CgkI2eP165kXEAIQBQ",
		"title": {"TR": "Geri Dönüş Kralı", "ENG": "Comeback King", "ESP": "Rey de la Remontada", "POR": "Rei da Reviravolta"},
		"desc": {"TR": "Geriye düştüğün maçı kazan", "ENG": "Win after trailing behind", "ESP": "Gana tras ir perdiendo", "POR": "Vença após estar a perder"}
	},
	"ROYALTY": {
		"id": "CgkI2eP165kXEAIQBg",
		"title": {"TR": "Kraliyet Tacı", "ENG": "Royalty", "ESP": "Realeza", "POR": "Realeza"},
		"desc": {"TR": "Favori takımına bir taç kuşandır", "ENG": "Equip a crown on your favorite team", "ESP": "Equipa una corona a tu equipo", "POR": "Equipe uma coroa na sua equipa"}
	},
	"COLLECTOR": {
		"id": "CgkI2eP165kXEAIQBw",
		"title": {"TR": "Koleksiyoncu", "ENG": "Collector", "ESP": "Coleccionista", "POR": "Colecionador"},
		"desc": {"TR": "3 farklı top görünümü aç", "ENG": "Unlock 3 ball skins", "ESP": "Desbloquea 3 balones", "POR": "Desbloqueie 3 bolas"}
	},
	"TEN_MATCHES": {
		"id": "CgkI2eP165kXEAIQCA",
		"title": {"TR": "Sadık Futbolcu", "ENG": "Dedicated Player", "ESP": "Jugador Dedicado", "POR": "Jogador Dedicado"},
		"desc": {"TR": "10 maç tamamla", "ENG": "Complete 10 matches", "ESP": "Completa 10 partidos", "POR": "Complete 10 partidas"}
	},
	"FAVORITE_CHAMPION": {
		"id": "CgkI2eP165kXEAIQCQ",
		"title": {"TR": "Sadık Taraftar", "ENG": "True Supporter", "ESP": "Verdadero Hincha", "POR": "Verdadeiro Adepto"},
		"desc": {"TR": "Favori takımınla maç kazan", "ENG": "Win a match with your favorite team", "ESP": "Gana con tu equipo favorito", "POR": "Vença com a sua equipa favorita"}
	}
}

func init_google_play_services():
	if Engine.has_singleton("GodotPlayGameServices"):
		var gps = Engine.get_singleton("GodotPlayGameServices")
		var gps_autoload = get_node_or_null("/root/GodotPlayGameServices")
		if is_instance_valid(gps_autoload) and gps_autoload.has_method("initialize"):
			gps_autoload.initialize()
		elif gps and gps.has_method("initialize"):
			gps.initialize()
		
		if not play_games_sign_in_client and ResourceLoader.exists("res://addons/GodotPlayGameServices/scripts/sign_in/sign_in_client.gd"):
			var sign_in_script = load("res://addons/GodotPlayGameServices/scripts/sign_in/sign_in_client.gd")
			if sign_in_script:
				play_games_sign_in_client = sign_in_script.new()
				add_child(play_games_sign_in_client)
		
		if not play_games_achievements_client and ResourceLoader.exists("res://addons/GodotPlayGameServices/scripts/achievements/achievements_client.gd"):
			var ach_script = load("res://addons/GodotPlayGameServices/scripts/achievements/achievements_client.gd")
			if ach_script:
				play_games_achievements_client = ach_script.new()
				add_child(play_games_achievements_client)
				print("[Global] Google Play Achievements client initialized successfully.")
		
		if not play_games_leaderboards_client and ResourceLoader.exists("res://addons/GodotPlayGameServices/scripts/leaderboards/leaderboards_client.gd"):
			var lead_script = load("res://addons/GodotPlayGameServices/scripts/leaderboards/leaderboards_client.gd")
			if lead_script:
				play_games_leaderboards_client = lead_script.new()
				add_child(play_games_leaderboards_client)
				print("[Global] Google Play Leaderboards client initialized successfully.")

func unlock_achievement(achievement_key: String):
	if not ACHIEVEMENTS.has(achievement_key):
		return
	if not unlocked_achievements.has(achievement_key):
		unlocked_achievements.append(achievement_key)
		save_progression()
	
	var ach_id = ACHIEVEMENTS[achievement_key]["id"]
	if play_games_achievements_client and play_games_achievements_client.has_method("unlock_achievement"):
		play_games_achievements_client.unlock_achievement(ach_id)
		print("[Global] Unlocked Google Play Achievement: ", achievement_key, " (", ach_id, ")")
	elif Engine.has_singleton("GodotPlayGameServices"):
		var gps = Engine.get_singleton("GodotPlayGameServices")
		if gps.has_method("unlockAchievement"):
			gps.unlockAchievement(ach_id)

func show_achievements():
	if play_games_achievements_client and play_games_achievements_client.has_method("show_achievements"):
		play_games_achievements_client.show_achievements()
	elif Engine.has_singleton("GodotPlayGameServices"):
		var gps = Engine.get_singleton("GodotPlayGameServices")
		if gps.has_method("showAchievements"):
			gps.showAchievements()
	else:
		print("[Global] Play Games Achievements not available on this platform.")

func show_leaderboards():
	if play_games_leaderboards_client and play_games_leaderboards_client.has_method("show_all_leaderboards"):
		play_games_leaderboards_client.show_all_leaderboards()
	elif Engine.has_singleton("GodotPlayGameServices"):
		var gps = Engine.get_singleton("GodotPlayGameServices")
		if gps.has_method("showAllLeaderboards"):
			gps.showAllLeaderboards()
	else:
		print("[Global] Play Games Leaderboards not available on this platform.")

func submit_score(score: int):
	# Leaderboard score submission
	var leaderboard_id = "CgkI2eP165kXEAIQCg"
	if play_games_leaderboards_client and play_games_leaderboards_client.has_method("submit_score"):
		play_games_leaderboards_client.submit_score(leaderboard_id, score)
		print("[Global] Score submitted to Google Play Leaderboard: ", score)
	elif Engine.has_singleton("GodotPlayGameServices"):
		var gps = Engine.get_singleton("GodotPlayGameServices")
		if gps.has_method("submitScore"):
			gps.submitScore(leaderboard_id, score)

# --- ADMOB & INTERSTITIAL ADS ---
var admob_instance: Node = null

func get_admob() -> Node:
	if not admob_instance or not is_instance_valid(admob_instance):
		return init_admob()
	return admob_instance

func init_admob() -> Node:
	if not Engine.has_singleton("PoingGodotAdMob") and not (OS.get_name() in ["Android", "iOS"]):
		return null
	if admob_instance and is_instance_valid(admob_instance):
		return admob_instance
	if has_node("Admob"):
		admob_instance = get_node("Admob")
		return admob_instance
	var admob_scene = load("res://admob.tscn")
	if admob_scene:
		admob_instance = admob_scene.instantiate()
		admob_instance.name = "Admob"
		add_child(admob_instance)
		admob_instance.initialization_completed.connect(_on_admob_initialized)
		admob_instance.initialize()
		print("[Global] AdMob node instanced as child of Global")
	return admob_instance

func _on_admob_initialized(_status):
	print("[Global] AdMob initialized globally! Status: ", _status)
	var admob_node = get_admob()
	if admob_node:
		if not admob_node.is_connected("interstitial_ad_dismissed_full_screen_content", Callable(self, "_on_interstitial_dismissed")):
			admob_node.connect("interstitial_ad_dismissed_full_screen_content", Callable(self, "_on_interstitial_dismissed"))
		if not admob_node.is_connected("interstitial_ad_failed_to_show_full_screen_content", Callable(self, "_on_interstitial_failed_to_show")):
			admob_node.connect("interstitial_ad_failed_to_show_full_screen_content", Callable(self, "_on_interstitial_failed_to_show"))
		if not admob_node.is_connected("interstitial_ad_loaded", Callable(self, "_on_interstitial_loaded")):
			admob_node.connect("interstitial_ad_loaded", Callable(self, "_on_interstitial_loaded"))
		if not admob_node.is_connected("interstitial_ad_failed_to_load", Callable(self, "_on_interstitial_failed_to_load")):
			admob_node.connect("interstitial_ad_failed_to_load", Callable(self, "_on_interstitial_failed_to_load"))
		preload_interstitial_ad()

func preload_interstitial_ad():
	if is_premium: return
	var admob_node = get_admob()
	if admob_node and admob_node.has_method("load_interstitial_ad"):
		if admob_node.has_method("is_interstitial_ad_loaded") and admob_node.is_interstitial_ad_loaded():
			return
		print("[Global] Preloading Interstitial ad...")
		admob_node.load_interstitial_ad()

func _on_interstitial_loaded(_ad_info = null, _response_info = null):
	print("[Global] Interstitial ad successfully loaded into cache!")

func _on_interstitial_failed_to_load(_ad_info = null, error_data = null):
	var err_msg = error_data.get_message() if (error_data != null and error_data.has_method("get_message")) else str(error_data)
	print("[Global] Interstitial ad failed to load: ", err_msg)
	# Retry loading after 10 seconds
	get_tree().create_timer(10.0).timeout.connect(func():
		if not is_premium:
			preload_interstitial_ad()
	)

func _on_interstitial_dismissed(_ad_info = null):
	print("[Global] Interstitial ad dismissed. Preloading next one.")
	preload_interstitial_ad()

func _on_interstitial_failed_to_show(_ad_info = null, _error_data = null):
	print("[Global] Interstitial ad failed to show. Preloading next one.")
	preload_interstitial_ad()

func show_interstitial_ad(on_complete: Callable = Callable()):
	if is_premium:
		if on_complete.is_valid():
			on_complete.call()
		return
	
	var admob_node = get_admob()
	if admob_node and admob_node.has_method("is_interstitial_ad_loaded") and admob_node.is_interstitial_ad_loaded():
		var handled = false
		var cleanup_and_callback = func():
			if handled: return
			handled = true
			if on_complete.is_valid():
				on_complete.call()
		
		var dis_callable = func(_ad_info = null): cleanup_and_callback.call()
		var fail_callable = func(_ad_info = null, _err = null): cleanup_and_callback.call()
		
		admob_node.connect("interstitial_ad_dismissed_full_screen_content", dis_callable, CONNECT_ONE_SHOT)
		admob_node.connect("interstitial_ad_failed_to_show_full_screen_content", fail_callable, CONNECT_ONE_SHOT)
		
		# Fallback timeout in case ad UI doesn't trigger callback
		get_tree().create_timer(10.0).timeout.connect(cleanup_and_callback)
		
		print("[Global] Showing Interstitial ad...")
		admob_node.show_interstitial_ad()
	else:
		print("[Global] Interstitial ad not ready or platform not supported. Proceeding...")
		preload_interstitial_ad()
		if on_complete.is_valid():
			on_complete.call()

func remove_all_banners():
	var admob_node = get_admob()
	if admob_node:
		if admob_node.has_method("remove_banner_ad"):
			var active_dict = admob_node.get("_active_banner_ads")
			if active_dict != null and active_dict.has_method("all_keys"):
				var keys = active_dict.all_keys()
				for k in keys:
					admob_node.remove_banner_ad(k)
			elif admob_node.has_method("is_banner_ad_loaded") and admob_node.is_banner_ad_loaded():
				admob_node.remove_banner_ad()
		elif admob_node.has_method("hide_banner_ad"):
			admob_node.hide_banner_ad()


const HATS = {
	"kings_crown": {
		"id": "kings_crown",
		"price": 500,
		"texture_path": "res://hat_kings_crown.png",
		"name": {
			"TR": "Kral Tacı",
			"ENG": "King's Crown",
			"ESP": "Corona de Rey",
			"POR": "Coroa de Rei"
		}
	},
	"queens_crown": {
		"id": "queens_crown",
		"price": 500,
		"texture_path": "res://hat_queens_crown.png",
		"name": {
			"TR": "Kraliçe Tacı",
			"ENG": "Queen's Crown",
			"ESP": "Corona de Reina",
			"POR": "Coroa de Rainha"
		}
	}
}

func increment_matches_played():
	if login_method == "guest":
		matches_played_since_prompt += 1
		save_progression()


var THEMES = {
	"Buz": {
		"bg_top": Color8(250, 255, 255), "bg_bottom": Color8(180, 210, 240),
		"pitch_1": Color8(200, 220, 245), "pitch_2": Color8(220, 240, 255),
		"panel": Color8(150, 180, 200, 230), "accent": Color8(0, 255, 255)
	},
	"Pembe": {
		"bg_top": Color8(255, 180, 200), "bg_bottom": Color8(60, 10, 30),
		"pitch_1": Color8(90, 20, 50), "pitch_2": Color8(120, 30, 70),
		"panel": Color8(30, 5, 15, 230), "accent": Color8(255, 0, 150)
	},
	"Turkuaz": {
		"bg_top": Color8(150, 230, 230), "bg_bottom": Color8(0, 50, 50),
		"pitch_1": Color8(0, 80, 80), "pitch_2": Color8(0, 110, 110),
		"panel": Color8(5, 25, 25, 230), "accent": Color8(0, 255, 200)
	},
	"Sarı": {
		"bg_top": Color8(220, 210, 150), "bg_bottom": Color8(50, 40, 10),
		"pitch_1": Color8(80, 65, 15), "pitch_2": Color8(110, 90, 25),
		"panel": Color8(30, 25, 5, 230), "accent": Color8(173, 255, 47)
	},
	"Yeşil": {
		"bg_top": Color8(160, 200, 160), "bg_bottom": Color8(10, 40, 15),
		"pitch_1": Color8(15, 60, 20), "pitch_2": Color8(25, 80, 30),
		"panel": Color8(5, 20, 10, 230), "accent": Color8(0, 250, 154)
	},
	"Mavi": {
		"bg_top": Color8(150, 170, 200), "bg_bottom": Color8(0, 18, 40),
		"pitch_1": Color8(0, 18, 40), "pitch_2": Color8(0, 35, 75),
		"panel": Color8(5, 10, 20, 230), "accent": Color8(255, 100, 0)
	},
	"Turuncu": {
		"bg_top": Color8(255, 180, 120), "bg_bottom": Color8(80, 25, 0),
		"pitch_1": Color8(120, 40, 0), "pitch_2": Color8(150, 60, 10),
		"panel": Color8(40, 10, 5, 230), "accent": Color8(255, 255, 0)
	},
	"Bordo": {
		"bg_top": Color8(200, 100, 120), "bg_bottom": Color8(50, 0, 10),
		"pitch_1": Color8(70, 10, 20), "pitch_2": Color8(100, 20, 30),
		"panel": Color8(25, 5, 10, 230), "accent": Color8(255, 105, 180)
	},
	"Mor": {
		"bg_top": Color8(180, 150, 220), "bg_bottom": Color8(30, 10, 50),
		"pitch_1": Color8(45, 15, 80), "pitch_2": Color8(60, 25, 110),
		"panel": Color8(20, 5, 30, 230), "accent": Color8(0, 255, 255)
	},
	"Kırmızı": {
		"bg_top": Color8(210, 160, 160), "bg_bottom": Color8(40, 10, 15),
		"pitch_1": Color8(60, 15, 20), "pitch_2": Color8(90, 25, 30),
		"panel": Color8(25, 5, 10, 230), "accent": Color8(255, 255, 0)
	},
	"Kahverengi": {
		"bg_top": Color8(160, 130, 110), "bg_bottom": Color8(50, 30, 15),
		"pitch_1": Color8(60, 40, 20), "pitch_2": Color8(80, 50, 30),
		"panel": Color8(30, 20, 10, 230), "accent": Color8(255, 215, 0)
	},
	"Siyah": {
		"bg_top": Color8(100, 100, 100), "bg_bottom": Color8(10, 10, 10),
		"pitch_1": Color8(20, 20, 20), "pitch_2": Color8(40, 40, 40),
		"panel": Color8(15, 15, 15, 230), "accent": Color8(0, 255, 255)
	}
}

const LEAGUES = {
	"TURKEY": {
		"id": "TURKEY",
		"name": {"TR": "Türkiye Ligi", "ENG": "Turkish League", "ESP": "Liga Turca", "POR": "Liga Turca"}
	},
	"ENGLAND": {
		"id": "ENGLAND",
		"name": {"TR": "İngiltere Ligi", "ENG": "English League", "ESP": "Liga Inglesa", "POR": "Liga Inglesa"}
	},
	"SPAIN": {
		"id": "SPAIN",
		"name": {"TR": "İspanya Ligi", "ENG": "Spanish League", "ESP": "Liga Española", "POR": "Liga Espanhola"}
	},
	"GERMANY": {
		"id": "GERMANY",
		"name": {"TR": "Almanya Ligi", "ENG": "German League", "ESP": "Liga Alemana", "POR": "Liga Alemã"}
	},
	"ITALY": {
		"id": "ITALY",
		"name": {"TR": "İtalya Ligi", "ENG": "Italian League", "ESP": "Liga Italiana", "POR": "Liga Italiana"}
	},
	"FRANCE": {
		"id": "FRANCE",
		"name": {"TR": "Fransa Ligi", "ENG": "French League", "ESP": "Liga Francesa", "POR": "Liga Francesa"}
	},
	"USA": {
		"id": "USA",
		"name": {"TR": "Amerika Ligi", "ENG": "American League", "ESP": "Liga Americana", "POR": "Liga Americana"}
	},
	"SAUDI": {
		"id": "SAUDI",
		"name": {"TR": "Suudi Ligi", "ENG": "Saudi League", "ESP": "Liga Saudí", "POR": "Liga Saudita"}
	},
	"WORLD": {
		"id": "WORLD",
		"name": {"TR": "Dünya Kulüpleri", "ENG": "World Clubs", "ESP": "Clubes del Mundo", "POR": "Clubes do Mundo"}
	}
}

var TEAM_LOGOS = {}

var TEAMS = {
	# --- TÜRKİYE LİGİ ---
	"GALATA FK":      {"colors": [Color8(169, 4, 50), Color8(253, 185, 18)], "short": "GAL", "league": "TURKEY"},
	"FENER FK":       {"colors": [Color8(255, 255, 0), Color8(0, 0, 128)],   "short": "FEN", "league": "TURKEY"},
	"BEŞIKTAŞ FK":    {"colors": [Color8(255, 255, 255), Color8(10, 10, 10)],"short": "BJK", "league": "TURKEY"},
	"TRABZON FK":     {"colors": [Color8(128, 0, 0), Color8(0, 191, 255)],   "short": "TRA", "league": "TURKEY"},
	"BAŞAKŞEHIR FK":  {"colors": [Color8(255, 102, 0), Color8(0, 0, 102)],   "short": "BFK", "league": "TURKEY"},
	"KASIMPAŞA SK":   {"colors": [Color8(255, 255, 255), Color8(0, 0, 128)], "short": "KAS", "league": "TURKEY"},
	"SIVAS FK":       {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "SVS", "league": "TURKEY"},
	"ALANYA FK":      {"colors": [Color8(255, 165, 0), Color8(0, 128, 0)],   "short": "ALN", "league": "TURKEY"},
	"RIZE FK":        {"colors": [Color8(0, 128, 0), Color8(0, 0, 255)],     "short": "RIZ", "league": "TURKEY"},
	"ANTALYA FK":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "ANT", "league": "TURKEY"},
	"ANTEP SC":       {"colors": [Color8(200, 16, 46), Color8(10, 10, 10)],  "short": "GFK", "league": "TURKEY"},
	"KONYA FK":       {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)], "short": "KON", "league": "TURKEY"},
	"KAYSERI FK":     {"colors": [Color8(255, 204, 0), Color8(255, 0, 0)],   "short": "KAY", "league": "TURKEY"},
	"BODRUM SC":      {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)], "short": "BOD", "league": "TURKEY"},
	"EYÜP FK":        {"colors": [Color8(230, 230, 250), Color8(255, 215, 0)],"short": "EYP", "league": "TURKEY"},
	"GÖZTEPE FC":     {"colors": [Color8(255, 215, 0), Color8(255, 0, 0)],   "short": "GÖZ", "league": "TURKEY"},
	"SAMSUN FK":      {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "SAM", "league": "TURKEY"},
	"KOCAELI FK":     {"colors": [Color8(0, 128, 0), Color8(10, 10, 10)],    "short": "KOC", "league": "TURKEY"},
	"KARAGÜMRÜK SC":  {"colors": [Color8(255, 0, 0), Color8(10, 10, 10)],    "short": "FKG", "league": "TURKEY"},
	"GENÇLER FK":     {"colors": [Color8(200, 16, 46), Color8(10, 10, 10)],  "short": "GEN", "league": "TURKEY"},
	"HATAY FK":       {"colors": [Color8(128, 0, 0), Color8(255, 255, 255)], "short": "HAT", "league": "TURKEY"},
	"ADANA D. FC":    {"colors": [Color8(0, 0, 255), Color8(173, 216, 230)], "short": "ADS", "league": "TURKEY"},

	# --- İNGİLTERE LİGİ ---
	"N. FOREST":      {"colors": [Color8(229, 30, 42), Color8(255, 255, 255)],"short": "NFO", "league": "ENGLAND"},
	"MANCHESTER C.":  {"colors": [Color8(108, 171, 221), Color8(255, 255, 255)],"short": "MCI", "league": "ENGLAND"},
	"LIVERPOOL SC":   {"colors": [Color8(200, 16, 46), Color8(255, 255, 255)],  "short": "LIV", "league": "ENGLAND"},
	"ARSENAL SC":     {"colors": [Color8(239, 1, 7), Color8(255, 255, 255)],    "short": "ARS", "league": "ENGLAND"},
	"ASTON V.":       {"colors": [Color8(103, 14, 54), Color8(149, 191, 229)],  "short": "AVL", "league": "ENGLAND"},
	"TOTTENHAM L.":   {"colors": [Color8(255, 255, 255), Color8(19, 34, 87)],   "short": "TOT", "league": "ENGLAND"},
	"MANCHESTER U.":  {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)],  "short": "MUN", "league": "ENGLAND"},
	"CHELSEA SC":     {"colors": [Color8(3, 70, 148), Color8(255, 255, 255)],   "short": "CHE", "league": "ENGLAND"},
	"NEWCASTLE U.":   {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],    "short": "NEW", "league": "ENGLAND"},
	"BOURNEMOUTH SC": {"colors": [Color8(200, 16, 46), Color8(0, 0, 0)],        "short": "BOU", "league": "ENGLAND"},
	"BRENTFORD SC":   {"colors": [Color8(227, 6, 19), Color8(255, 255, 255)],   "short": "BRE", "league": "ENGLAND"},
	"BRIGHTON C.":    {"colors": [Color8(0, 87, 184), Color8(255, 255, 255)],   "short": "BHA", "league": "ENGLAND"},
	"BURNLEY SC":     {"colors": [Color8(108, 29, 69), Color8(153, 214, 234)],  "short": "BUR", "league": "ENGLAND"},
	"EVERTON SC":     {"colors": [Color8(0, 51, 153), Color8(255, 255, 255)],   "short": "EVE", "league": "ENGLAND"},
	"FULHAM SC":      {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],      "short": "FUL", "league": "ENGLAND"},
	"LEEDS U.":       {"colors": [Color8(255, 255, 255), Color8(29, 66, 138)],  "short": "LEE", "league": "ENGLAND"},
	"C. PALACE":      {"colors": [Color8(27, 69, 143), Color8(196, 18, 46)],    "short": "CRY", "league": "ENGLAND"},
	"SUNDERLAND SC":  {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],    "short": "SUN", "league": "ENGLAND"},
	"WEST HAM L.":    {"colors": [Color8(122, 38, 58), Color8(27, 177, 231)],   "short": "WHU", "league": "ENGLAND"},
	"WOLVES SC":      {"colors": [Color8(253, 185, 19), Color8(0, 0, 0)],       "short": "WOL", "league": "ENGLAND"},

	# --- İSPANYA LİGİ ---
	"R. MADRID":      {"colors": [Color8(255, 255, 255), Color8(255, 215, 0)],"short": "RMA", "league": "SPAIN"},
	"BARSELONA SC":   {"colors": [Color8(0, 77, 152), Color8(165, 0, 68)],    "short": "BAR", "league": "SPAIN"},
	"A. MADRID":      {"colors": [Color8(203, 53, 36), Color8(255, 255, 255)],"short": "ATM", "league": "SPAIN"},
	"GIRONA SC":      {"colors": [Color8(200, 16, 46), Color8(255, 255, 255)],"short": "GIR", "league": "SPAIN"},
	"C. VIGO":        {"colors": [Color8(138, 195, 238), Color8(255, 255, 255)],"short": "CEL", "league": "SPAIN"},
	"BILBAO CF":      {"colors": [Color8(237, 28, 36), Color8(255, 255, 255)], "short": "ATH", "league": "SPAIN"},
	"R. SOCIEDAD":    {"colors": [Color8(0, 103, 177), Color8(255, 255, 255)], "short": "RSO", "league": "SPAIN"},
	"VILLARREAL SC":  {"colors": [Color8(255, 230, 0), Color8(0, 0, 102)],     "short": "VIL", "league": "SPAIN"},
	"VALENCIA SC":    {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],     "short": "VAL", "league": "SPAIN"},
	"SEVILLA SC":     {"colors": [Color8(255, 255, 255), Color8(218, 41, 28)], "short": "SEV", "league": "SPAIN"},
	"R. BETIS":       {"colors": [Color8(0, 148, 72), Color8(255, 255, 255)],  "short": "BET", "league": "SPAIN"},
	"OSASUNA SC":     {"colors": [Color8(193, 29, 39), Color8(0, 27, 73)],     "short": "OSA", "league": "SPAIN"},
	"MALLORCA SC":    {"colors": [Color8(226, 0, 26), Color8(0, 0, 0)],        "short": "MLL", "league": "SPAIN"},
	"ALAVES SC":      {"colors": [Color8(0, 68, 148), Color8(255, 255, 255)],  "short": "ALA", "league": "SPAIN"},
	"R. VALLECANO":   {"colors": [Color8(255, 255, 255), Color8(227, 6, 19)],  "short": "RAY", "league": "SPAIN"},
	"GETAFE SC":      {"colors": [Color8(0, 75, 151), Color8(255, 255, 255)],  "short": "GET", "league": "SPAIN"},
	"ESPANYOL BC":    {"colors": [Color8(0, 122, 195), Color8(255, 255, 255)], "short": "ESP", "league": "SPAIN"},
	"ELCHE SC":       {"colors": [Color8(0, 100, 0), Color8(255, 255, 255)],   "short": "ELC", "league": "SPAIN"},
	"OVIEDO SC":      {"colors": [Color8(0, 51, 160), Color8(255, 255, 255)],  "short": "OVI", "league": "SPAIN"},
	"LEVANTE SC":     {"colors": [Color8(0, 51, 102), Color8(153, 0, 51)],     "short": "LEV", "league": "SPAIN"},

	# --- ALMANYA LİGİ ---
	"MÜNIH B.":       {"colors": [Color8(220, 5, 45), Color8(255, 255, 255)], "short": "BAY", "league": "GERMANY"},
	"DORTMUND SC":    {"colors": [Color8(253, 225, 0), Color8(10, 10, 10)],   "short": "BVB", "league": "GERMANY"},
	"LEVERKUSEN SC":  {"colors": [Color8(10, 10, 10), Color8(227, 34, 25)],   "short": "B04", "league": "GERMANY"},
	"LEIPZIG SC":     {"colors": [Color8(255, 255, 255), Color8(221, 5, 43)], "short": "RBL", "league": "GERMANY"},
	"STUTTGART SC":   {"colors": [Color8(255, 255, 255), Color8(227, 34, 25)],"short": "VFB", "league": "GERMANY"},
	"AUGSBURG SC":    {"colors": [Color8(255, 255, 255), Color8(186, 32, 38)], "short": "AUG", "league": "GERMANY"},
	"FRANKFURT SC":   {"colors": [Color8(0, 0, 0), Color8(227, 34, 25)],       "short": "FRA", "league": "GERMANY"},
	"FREIBURG SC":    {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)], "short": "FRE", "league": "GERMANY"},
	"HAMBURG C.":     {"colors": [Color8(0, 85, 164), Color8(255, 255, 255)],  "short": "HSV", "league": "GERMANY"},
	"HEIDENHEIM SC":  {"colors": [Color8(227, 34, 25), Color8(0, 51, 160)],    "short": "HEI", "league": "GERMANY"},
	"HOFFENHEIM SC":  {"colors": [Color8(0, 92, 169), Color8(255, 255, 255)],  "short": "HOF", "league": "GERMANY"},
	"KÖLN SC":        {"colors": [Color8(227, 34, 25), Color8(255, 255, 255)], "short": "KÖL", "league": "GERMANY"},
	"MAINZ SC":       {"colors": [Color8(237, 28, 36), Color8(255, 255, 255)], "short": "MAI", "league": "GERMANY"},
	"M. GLADBACH":    {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "BMG", "league": "GERMANY"},
	"ST. PAULI SC":   {"colors": [Color8(105, 57, 4), Color8(255, 255, 255)],  "short": "STP", "league": "GERMANY"},
	"U. BERLIN":      {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)], "short": "UNB", "league": "GERMANY"},
	"W. BREMEN":      {"colors": [Color8(29, 162, 83), Color8(255, 255, 255)], "short": "WER", "league": "GERMANY"},
	"WOLFSBURG SC":   {"colors": [Color8(98, 179, 48), Color8(255, 255, 255)], "short": "WOB", "league": "GERMANY"},

	# --- İTALYA LİGİ ---
	"INTER M.":       {"colors": [Color8(0, 102, 187), Color8(10, 10, 10)],   "short": "INT", "league": "ITALY"},
	"AC MILANO":      {"colors": [Color8(251, 9, 11), Color8(10, 10, 10)],    "short": "MIL", "league": "ITALY"},
	"JUVE SC":        {"colors": [Color8(255, 255, 255), Color8(10, 10, 10)], "short": "JUV", "league": "ITALY"},
	"ATALANTA B.":    {"colors": [Color8(30, 113, 184), Color8(10, 10, 10)],  "short": "ATA", "league": "ITALY"},
	"ROMA SC":        {"colors": [Color8(134, 38, 51), Color8(240, 188, 66)], "short": "ROM", "league": "ITALY"},
	"LAZIO SC":       {"colors": [Color8(135, 206, 235), Color8(255, 255, 255)],"short": "LAZ", "league": "ITALY"},
	"BOLOGNA SC":     {"colors": [Color8(158, 27, 50), Color8(26, 35, 66)],   "short": "BOL", "league": "ITALY"},
	"CAGLIARI SC":    {"colors": [Color8(163, 19, 51), Color8(0, 35, 80)],     "short": "CAG", "league": "ITALY"},
	"COMO SC":        {"colors": [Color8(0, 71, 169), Color8(255, 255, 255)],  "short": "COM", "league": "ITALY"},
	"CREMONESE SC":   {"colors": [Color8(130, 130, 130), Color8(227, 34, 25)], "short": "CRE", "league": "ITALY"},
	"FIRENZE SC":     {"colors": [Color8(72, 46, 146), Color8(255, 255, 255)], "short": "FIO", "league": "ITALY"},
	"GENOA SC":       {"colors": [Color8(166, 28, 49), Color8(0, 36, 81)],     "short": "GNO", "league": "ITALY"},
	"LECCE SC":       {"colors": [Color8(255, 217, 0), Color8(227, 34, 25)],   "short": "LEC", "league": "ITALY"},
	"NAPOLI SC":      {"colors": [Color8(18, 160, 215), Color8(255, 255, 255)],"short": "NAP", "league": "ITALY"},
	"PARMA SC":       {"colors": [Color8(255, 204, 0), Color8(0, 51, 153)],    "short": "PAR", "league": "ITALY"},
	"PISA SC":        {"colors": [Color8(0, 0, 0), Color8(0, 84, 166)],       "short": "PIS", "league": "ITALY"},
	"SASSUOLO SC":    {"colors": [Color8(0, 160, 90), Color8(0, 0, 0)],        "short": "SAS", "league": "ITALY"},
	"TORINO SC":      {"colors": [Color8(138, 30, 50), Color8(255, 255, 255)], "short": "TOR", "league": "ITALY"},
	"UDINESE C.":     {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "UDI", "league": "ITALY"},
	"VERONA SC":      {"colors": [Color8(0, 51, 102), Color8(255, 204, 0)],    "short": "VER", "league": "ITALY"},

	# --- FRANSA LİGİ ---
	"PARIS SC":       {"colors": [Color8(0, 65, 112), Color8(218, 41, 28)],   "short": "PSG", "league": "FRANCE"},
	"LILLE SC":       {"colors": [Color8(238, 36, 54), Color8(0, 51, 102)],   "short": "LIL", "league": "FRANCE"},
	"MONACO SC":      {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],  "short": "ASM", "league": "FRANCE"},
	"MARSILYA SC":    {"colors": [Color8(255, 255, 255), Color8(0, 150, 214)], "short": "MAR", "league": "FRANCE"},
	"LYON SC":        {"colors": [Color8(255, 255, 255), Color8(218, 41, 28)], "short": "LYO", "league": "FRANCE"},
	"LENS SC":        {"colors": [Color8(237, 28, 36), Color8(255, 215, 0)],   "short": "RCL", "league": "FRANCE"},
	"NICE SC":        {"colors": [Color8(218, 41, 28), Color8(0, 0, 0)],       "short": "NIC", "league": "FRANCE"},
	"RENNES SC":      {"colors": [Color8(227, 34, 25), Color8(0, 0, 0)],       "short": "REN", "league": "FRANCE"},
	"STRASBOURG SC":  {"colors": [Color8(0, 82, 159), Color8(255, 255, 255)],  "short": "STR", "league": "FRANCE"},
	"REIMS SC":       {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "SDR", "league": "FRANCE"},
	"TOULOUSE SC":    {"colors": [Color8(92, 45, 145), Color8(255, 255, 255)], "short": "TFC", "league": "FRANCE"},
	"NANTES SC":      {"colors": [Color8(253, 233, 34), Color8(0, 100, 50)],   "short": "FCN", "league": "FRANCE"},
	"MONTPELLIER SC": {"colors": [Color8(0, 35, 96), Color8(243, 108, 33)],    "short": "MHS", "league": "FRANCE"},
	"ANGERS SC":      {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "SCO", "league": "FRANCE"},
	"BREST SC":       {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "SB2", "league": "FRANCE"},
	"LE HAVRE C.":    {"colors": [Color8(111, 172, 222), Color8(0, 31, 73)],   "short": "HAC", "league": "FRANCE"},
	"AUXERRE SC":     {"colors": [Color8(255, 255, 255), Color8(0, 68, 148)],  "short": "AJA", "league": "FRANCE"},
	"ST. ETIENNE C.": {"colors": [Color8(0, 102, 51), Color8(255, 255, 255)],  "short": "ASE", "league": "FRANCE"},

	# --- AMERİKA LİGİ ---
	"MIAMI INTER":    {"colors": [Color8(244, 181, 205), Color8(0, 0, 0)],     "short": "MIA", "league": "USA"},
	"LA SC":          {"colors": [Color8(0, 0, 0), Color8(195, 158, 109)],     "short": "LAF", "league": "USA"},
	"LA GALAKSI":     {"colors": [Color8(0, 36, 93), Color8(255, 210, 0)],     "short": "LAG", "league": "USA"},
	"COLUMBUS C.":    {"colors": [Color8(255, 223, 0), Color8(0, 0, 0)],       "short": "CCW", "league": "USA"},
	"CINCINNATI C.":  {"colors": [Color8(240, 83, 35), Color8(38, 59, 128)],   "short": "CIN", "league": "USA"},
	"SEATTLE S.":     {"colors": [Color8(93, 151, 50), Color8(0, 85, 149)],    "short": "SEA", "league": "USA"},
	"NY CITY":        {"colors": [Color8(108, 172, 228), Color8(4, 30, 66)],   "short": "NYC", "league": "USA"},
	"NY BULLS":       {"colors": [Color8(226, 24, 54), Color8(255, 255, 255)], "short": "NYR", "league": "USA"},
	"ATLANTA U.":     {"colors": [Color8(128, 0, 0), Color8(0, 0, 0)],         "short": "ATL", "league": "USA"},
	"PORTLAND T.":    {"colors": [Color8(0, 72, 39), Color8(234, 170, 0)],     "short": "PTL", "league": "USA"},
	"ORLANDO C.":     {"colors": [Color8(99, 52, 146), Color8(255, 255, 255)], "short": "ORL", "league": "USA"},
	"HOUSTON D.":     {"colors": [Color8(255, 107, 0), Color8(0, 0, 0)],       "short": "HOU", "league": "USA"},
	"R. SALT LAKE":   {"colors": [Color8(179, 11, 34), Color8(1, 31, 91)],     "short": "RSL", "league": "USA"},
	"PHILA U.":       {"colors": [Color8(0, 45, 85), Color8(179, 163, 105)],   "short": "PHI", "league": "USA"},
	"KANSAS CITY S.": {"colors": [Color8(145, 176, 213), Color8(0, 42, 92)],   "short": "SKC", "league": "USA"},
	"NEW ENGLAND R.": {"colors": [Color8(226, 24, 54), Color8(0, 43, 92)],     "short": "NER", "league": "USA"},
	"NASHVILLE C.":   {"colors": [Color8(236, 232, 58), Color8(31, 22, 70)],   "short": "NSC", "league": "USA"},
	"DALLAS SC":      {"colors": [Color8(226, 24, 54), Color8(0, 62, 126)],    "short": "DAL", "league": "USA"},
	"VANCOUVER C.":   {"colors": [Color8(0, 36, 94), Color8(255, 255, 255)],   "short": "VAN", "league": "USA"},
	"MINNESOTA U.":   {"colors": [Color8(135, 142, 144), Color8(122, 184, 237)],"short": "MIN", "league": "USA"},
	"COLORADO R.":    {"colors": [Color8(134, 38, 51), Color8(139, 171, 204)], "short": "COL", "league": "USA"},
	"CHARLOTTE SC":   {"colors": [Color8(0, 133, 202), Color8(0, 0, 0)],       "short": "CHR", "league": "USA"},
	"SAN JOSE E.":    {"colors": [Color8(0, 0, 0), Color8(0, 81, 186)],        "short": "SJE", "league": "USA"},
	"AUSTIN SC":      {"colors": [Color8(0, 180, 81), Color8(0, 0, 0)],        "short": "AUS", "league": "USA"},
	"CHICAGO F.":     {"colors": [Color8(255, 0, 0), Color8(0, 42, 92)],       "short": "CHI", "league": "USA"},
	"WASHINGTON DC":  {"colors": [Color8(0, 0, 0), Color8(239, 62, 66)],       "short": "DCU", "league": "USA"},
	"MONTREAL SC":    {"colors": [Color8(0, 51, 160), Color8(0, 0, 0)],        "short": "MTL", "league": "USA"},
	"ST. LOUIS C.":   {"colors": [Color8(226, 24, 54), Color8(0, 43, 92)],     "short": "STL", "league": "USA"},
	"TORONTO SC":     {"colors": [Color8(227, 38, 54), Color8(32, 42, 68)],    "short": "TFC", "league": "USA"},
	"SAN DIEGO SC":   {"colors": [Color8(0, 193, 213), Color8(0, 0, 0)],       "short": "SDF", "league": "USA"},

	# --- SUUDİ LİGİ ---
	"HILAL SC":       {"colors": [Color8(0, 94, 184), Color8(255, 255, 255)],  "short": "HIL", "league": "SAUDI"},
	"NASSR SC":       {"colors": [Color8(254, 209, 65), Color8(0, 52, 120)],   "short": "NAS", "league": "SAUDI"},
	"AHLI SC":        {"colors": [Color8(0, 166, 81), Color8(255, 255, 255)],  "short": "AHL", "league": "SAUDI"},
	"ITTIHAD SC":     {"colors": [Color8(255, 215, 0), Color8(0, 0, 0)],       "short": "ITT", "league": "SAUDI"},
	"SHABAB SC":      {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],     "short": "SHA", "league": "SAUDI"},
	"TAAWOUN SC":     {"colors": [Color8(255, 215, 0), Color8(0, 51, 153)],    "short": "TAA", "league": "SAUDI"},
	"ETTIFAQ SC":     {"colors": [Color8(0, 128, 64), Color8(255, 255, 255)],  "short": "ETT", "league": "SAUDI"},
	"DAMAC SC":       {"colors": [Color8(255, 0, 0), Color8(255, 215, 0)],     "short": "DAM", "league": "SAUDI"},
	"FAYHA SC":       {"colors": [Color8(255, 165, 0), Color8(0, 0, 255)],     "short": "FAY", "league": "SAUDI"},
	"FATEH SC":       {"colors": [Color8(0, 100, 0), Color8(255, 255, 255)],   "short": "FAT", "league": "SAUDI"},
	"RIYADH SC":      {"colors": [Color8(255, 0, 0), Color8(0, 0, 0)],         "short": "RIY", "league": "SAUDI"},
	"WEHDA SC":       {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "WEH", "league": "SAUDI"},
	"KHALEEJ SC":     {"colors": [Color8(255, 255, 0), Color8(0, 128, 0)],     "short": "KHA", "league": "SAUDI"},
	"RAED SC":        {"colors": [Color8(255, 0, 0), Color8(0, 0, 0)],         "short": "RAE", "league": "SAUDI"},
	"QADSIAH SC":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 0)],     "short": "QAD", "league": "SAUDI"},
	"OKHDOOD SC":     {"colors": [Color8(0, 191, 255), Color8(255, 255, 255)], "short": "OKH", "league": "SAUDI"},
	"NEOM SC":        {"colors": [Color8(0, 0, 139), Color8(255, 215, 0)],     "short": "NEO", "league": "SAUDI"},
	"KHOLOOD SC":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "KHO", "league": "SAUDI"},

	# --- DÜNYA KULÜPLERİ ---
	"BRUGGE SC":      {"colors": [Color8(0, 0, 0), Color8(0, 116, 217)],       "short": "CLB", "league": "WORLD"},
	"KARABAĞ SC":     {"colors": [Color8(0, 0, 128), Color8(227, 141, 26)],    "short": "QFK", "league": "WORLD"},
	"OLYMPIAKOS SC":  {"colors": [Color8(255, 255, 255), Color8(221, 0, 0)],   "short": "OLY", "league": "WORLD"},
	"BODO SC":        {"colors": [Color8(255, 220, 0), Color8(0, 0, 0)],       "short": "BOD", "league": "WORLD"},
	"BENFICA SC":     {"colors": [Color8(232, 48, 48), Color8(255, 255, 255)], "short": "SLB", "league": "WORLD"},
	"SPORTING L.":    {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)],   "short": "SCP", "league": "WORLD"},
	"PORTO SC":       {"colors": [Color8(0, 0, 255), Color8(255, 255, 255)],   "short": "POR", "league": "WORLD"},
	"AJAX A.":        {"colors": [Color8(255, 255, 255), Color8(210, 18, 46)], "short": "AJX", "league": "WORLD"},
	"PSV E.":         {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "PSV", "league": "WORLD"},
	"ROTTERDAM SC":   {"colors": [Color8(255, 255, 255), Color8(255, 0, 0)],   "short": "FEY", "league": "WORLD"},
	"ATINA Y.":       {"colors": [Color8(0, 123, 58), Color8(255, 255, 255)],  "short": "PAO", "league": "WORLD"},
	"V. PLZEN":       {"colors": [Color8(237, 27, 36), Color8(0, 77, 152)],    "short": "PLZ", "league": "WORLD"},
	"D. ZAGREB":      {"colors": [Color8(0, 51, 153), Color8(255, 255, 255)],  "short": "DZG", "league": "WORLD"},
	"GENK SC":        {"colors": [Color8(0, 71, 156), Color8(255, 255, 255)],  "short": "GNK", "league": "WORLD"},
	"BRANN SC":       {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "BRA", "league": "WORLD"},
	"PAOK SC":        {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "PAOK", "league": "WORLD"},
	"LUDOGORETS SC":  {"colors": [Color8(13, 104, 56), Color8(255, 255, 255)], "short": "LUD", "league": "WORLD"},
	"FERENCVAROS SC": {"colors": [Color8(28, 127, 55), Color8(255, 255, 255)], "short": "FER", "league": "WORLD"},
	"KIZILYILDIZ":    {"colors": [Color8(208, 16, 35), Color8(255, 255, 255)], "short": "CZV", "league": "WORLD"},
	"CELTIC SC":      {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)],   "short": "CLT", "league": "WORLD"}
}

func _ready():
	for team_name in TEAMS:
		var short_name = TEAMS[team_name]["short"]
		var logo_path = "res://assets/" + short_name.to_lower() + ".png"
		if ResourceLoader.exists(logo_path):
			TEAM_LOGOS[team_name] = load(logo_path)
		elif ResourceLoader.exists("res://" + short_name.to_lower() + "1.png"):
			TEAM_LOGOS[team_name] = load("res://" + short_name.to_lower() + "1.png")
		elif (short_name == "FEN" or short_name == "FB") and ResourceLoader.exists("res://fb1.png"):
			TEAM_LOGOS[team_name] = load("res://fb1.png")
		elif (short_name == "GAL" or short_name == "GS") and ResourceLoader.exists("res://gs1.png"):
			TEAM_LOGOS[team_name] = load("res://gs1.png")
		elif (short_name == "TRA" or short_name == "TS") and ResourceLoader.exists("res://ts1.png"):
			TEAM_LOGOS[team_name] = load("res://ts1.png")
		elif (short_name == "MCI" or short_name == "MC") and ResourceLoader.exists("res://mc1.png"):
			TEAM_LOGOS[team_name] = load("res://mc1.png")
		else:
			TEAM_LOGOS[team_name] = null

	bg_music_player = AudioStreamPlayer.new()
	bg_music_player.stream = preload("res://main_menu.mp3")
	if bg_music_player.stream is AudioStreamMP3:
		bg_music_player.stream.loop = true
	add_child(bg_music_player)
	_update_bg_music_volume()
	
	click_player = AudioStreamPlayer.new()
	click_player.stream = preload("res://click.ogg")
	add_child(click_player)
	
	goal_music_player = AudioStreamPlayer.new()
	var g_stream = null
	for path in ["res://goal1.wav", "res://goal1.ogg", "res://goal1.mp3", "res://goal1.m4a"]:
		if ResourceLoader.exists(path):
			g_stream = load(path)
			if g_stream != null:
				break
	if g_stream:
		goal_music_player.stream = g_stream
	add_child(goal_music_player)
	_update_goal_music_volume()
	
	# Initial delay before starting menu music
	get_tree().create_timer(0.5).timeout.connect(func():
		if is_instance_valid(bg_music_player) and not bg_music_player.playing:
			bg_music_player.play()
	)
	
	load_progression()
	load_stats()
	init_google_play_services()
	init_admob()


func play_click():
	if is_instance_valid(click_player):
		var target_vol = master_vol * vol_settings.get("collision", 0.4) * 8.64 # Boost volume by 8x + 8%
		click_player.volume_db = linear_to_db(clamp(target_vol, 0.0, 1.0))
		click_player.play()

func _update_bg_music_volume():
	if is_instance_valid(bg_music_player):
		var target_vol = master_vol * vol_settings.get("menu_music", 0.4) * 1.06
		if target_vol <= 0.01:
			bg_music_player.volume_db = -80.0
		else:
			bg_music_player.volume_db = linear_to_db(target_vol)

func _update_goal_music_volume():
	if is_instance_valid(goal_music_player):
		var target_vol = master_vol * vol_settings.get("music", 0.6) * 1.10
		if target_vol <= 0.01:
			goal_music_player.volume_db = -80.0
		else:
			goal_music_player.volume_db = linear_to_db(clamp(target_vol, 0.0001, 1.0))

func play_goal_music():
	if is_instance_valid(goal_music_player) and goal_music_player.stream != null:
		_update_goal_music_volume()
		if goal_music_player.playing:
			goal_music_player.stop()
		goal_music_player.play()

func trigger_vibration(duration_ms: int = 500):
	if vibration_enabled:
		Input.vibrate_handheld(duration_ms)

# ======================================================
# STATS PERSISTENCE  (user://stats.json)
# ======================================================
func save_stats():
	if match_history.size() > 100:
		match_history = match_history.slice(match_history.size() - 100)
	var tmp_path = "user://stats.json.tmp"
	var final_path = "user://stats.json"
	var file = FileAccess.open(tmp_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(match_history))
		file.close()
		DirAccess.rename_absolute(tmp_path, final_path)

func load_stats():
	if OS.get_name() == "Web":
		await get_tree().process_frame
	if not FileAccess.file_exists("user://stats.json"):
		return
	var file = FileAccess.open("user://stats.json", FileAccess.READ)
	if file:
		var raw = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(raw)
		if parsed is Array:
			match_history = parsed
			if match_history.size() > 100:
				match_history = match_history.slice(match_history.size() - 100)

func save_progression():
	var tmp_path = "user://progression.json.tmp"
	var final_path = "user://progression.json"
	var file = FileAccess.open(tmp_path, FileAccess.WRITE)
	if file:
		var data = {
			"ad_credits": ad_credits,
			"unlocked_ball_skins": unlocked_ball_skins,
			"equipped_ball_skin": equipped_ball_skin,
			"unlocked_hats": unlocked_hats,
			"equipped_hat": equipped_hat,
			"favorite_team": favorite_team,
			"login_method": login_method,
			"matches_played_since_prompt": matches_played_since_prompt,
			"is_premium": is_premium,
			"vibration_enabled": vibration_enabled,
			"home_team_name": home_team_name,
			"away_team_name": away_team_name,
			"home_selected": home_selected,
			"away_selected": away_selected,
			"custom_player_names": custom_player_names,
			"unlocked_achievements": unlocked_achievements,
			"favorite_team_goals_scored": favorite_team_goals_scored,
			"daily_date": daily_date,
			"lucky_wheel_free_spins_used": lucky_wheel_free_spins_used,
			"lucky_wheel_ad_spins_used": lucky_wheel_ad_spins_used,
			"lucky_wheel_pending_ad_spins": lucky_wheel_pending_ad_spins,
			"daily_quests": daily_quests,
			"current_lang": current_lang,
			"master_vol": master_vol,
			"vol_settings": vol_settings,
			"current_theme": current_theme,
			"shake_enabled": shake_enabled,
			"match_duration": match_duration
		}
		file.store_string(JSON.stringify(data))
		file.close()
		DirAccess.rename_absolute(tmp_path, final_path)

func load_progression():
	if not FileAccess.file_exists("user://progression.json"):
		check_daily_reset()
		return
	var file = FileAccess.open("user://progression.json", FileAccess.READ)
	if file:
		var raw = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(raw)
		if typeof(parsed) != TYPE_DICTIONARY:
			print("[Global] Corrupted or invalid progression.json detected. Backing up to progression.json.corrupted")
			DirAccess.copy_absolute("user://progression.json", "user://progression.json.corrupted")
			check_daily_reset()
			return
		
		if parsed.has("ad_credits"): ad_credits = int(parsed["ad_credits"])
		if parsed.has("unlocked_ball_skins") and parsed["unlocked_ball_skins"] is Array: unlocked_ball_skins = parsed["unlocked_ball_skins"]
		if parsed.has("equipped_ball_skin"): equipped_ball_skin = String(parsed["equipped_ball_skin"])
		if parsed.has("unlocked_hats") and parsed["unlocked_hats"] is Array: unlocked_hats = parsed["unlocked_hats"]
		if parsed.has("equipped_hat"): equipped_hat = String(parsed["equipped_hat"])
		if parsed.has("login_method"): login_method = String(parsed["login_method"])
		if parsed.has("matches_played_since_prompt"): matches_played_since_prompt = int(parsed["matches_played_since_prompt"])
		if parsed.has("is_premium"): is_premium = bool(parsed["is_premium"])
		if parsed.has("vibration_enabled"): vibration_enabled = bool(parsed["vibration_enabled"])
		if parsed.has("home_selected"): home_selected = bool(parsed["home_selected"])
		if parsed.has("away_selected"): away_selected = bool(parsed["away_selected"])
		if parsed.has("favorite_team"):
			favorite_team = String(parsed["favorite_team"])
		if parsed.has("home_team_name") and String(parsed["home_team_name"]) != "" and TEAMS.has(parsed["home_team_name"]):
			home_team_name = String(parsed["home_team_name"])
		elif favorite_team != "" and TEAMS.has(favorite_team):
			home_team_name = favorite_team
		if parsed.has("away_team_name") and String(parsed["away_team_name"]) != "" and TEAMS.has(parsed["away_team_name"]):
			away_team_name = String(parsed["away_team_name"])
		if parsed.has("custom_player_names") and typeof(parsed["custom_player_names"]) == TYPE_DICTIONARY:
			custom_player_names = parsed["custom_player_names"]
		if parsed.has("unlocked_achievements") and parsed["unlocked_achievements"] is Array:
			unlocked_achievements = parsed["unlocked_achievements"]
		if parsed.has("favorite_team_goals_scored"):
			favorite_team_goals_scored = int(parsed["favorite_team_goals_scored"])
		if parsed.has("daily_date"):
			daily_date = String(parsed["daily_date"])
		if parsed.has("lucky_wheel_free_spins_used"):
			lucky_wheel_free_spins_used = int(parsed["lucky_wheel_free_spins_used"])
		if parsed.has("lucky_wheel_ad_spins_used"):
			lucky_wheel_ad_spins_used = int(parsed["lucky_wheel_ad_spins_used"])
		if parsed.has("lucky_wheel_pending_ad_spins"):
			lucky_wheel_pending_ad_spins = int(parsed["lucky_wheel_pending_ad_spins"])
		if parsed.has("daily_quests") and parsed["daily_quests"] is Array:
			daily_quests = parsed["daily_quests"]
		if parsed.has("current_lang") and String(parsed["current_lang"]) in ["TR", "ENG", "ESP", "POR"]:
			current_lang = String(parsed["current_lang"])
		if parsed.has("master_vol"):
			master_vol = float(parsed["master_vol"])
		if parsed.has("vol_settings") and typeof(parsed["vol_settings"]) == TYPE_DICTIONARY:
			for k in parsed["vol_settings"]:
				vol_settings[k] = float(parsed["vol_settings"][k])
		if parsed.has("current_theme") and THEMES.has(parsed["current_theme"]):
			current_theme = String(parsed["current_theme"])
		if parsed.has("shake_enabled"):
			shake_enabled = bool(parsed["shake_enabled"])
		if parsed.has("match_duration"):
			match_duration = int(parsed["match_duration"])
	
	_update_bg_music_volume()
	_update_goal_music_volume()
	check_daily_reset()

# ======================================================
# DAILY QUESTS & LUCKY WHEEL SYSTEMS
# ======================================================
func check_daily_reset():
	var today = Time.get_date_string_from_system()
	if daily_date != today:
		daily_date = today
		lucky_wheel_free_spins_used = 0
		lucky_wheel_ad_spins_used = 0
		lucky_wheel_pending_ad_spins = 0
		generate_daily_quests()
		save_progression()

func get_active_custom_player_name() -> String:
	var team = favorite_team if favorite_team != "" else home_team_name
	if custom_player_names.has(team):
		var p_data = custom_player_names[team]
		if typeof(p_data) == TYPE_DICTIONARY:
			for key in p_data:
				var p_str = String(p_data[key]).strip_edges()
				if p_str != "":
					return p_str
		elif p_data is Array and p_data.size() > 0:
			for p in p_data:
				var p_str = String(p).strip_edges()
				if p_str != "":
					return p_str
	return "Kaptan"

func generate_daily_quests():
	var fav = favorite_team if favorite_team != "" else "GALATA FK"
	var p_name = get_active_custom_player_name()
	
	daily_quests = [
		{
			"id": "fav_team_win",
			"type": "fav_win",
			"desc": {
				"TR": fav + " ile 1 maç kazan",
				"ENG": "Win 1 match with " + fav,
				"ESP": "Gana 1 partido con " + fav,
				"POR": "Vença 1 jogo com " + fav
			},
			"target": 1,
			"progress": 0,
			"reward": 35,
			"claimed": false
		},
		{
			"id": "player_goals",
			"type": "player_goals",
			"desc": {
				"TR": p_name + " ile 2 gol at",
				"ENG": "Score 2 goals with " + p_name,
				"ESP": "Marca 2 goles con " + p_name,
				"POR": "Marque 2 golos com " + p_name
			},
			"target": 2,
			"progress": 0,
			"reward": 40,
			"claimed": false
		},
		{
			"id": "clean_sheet_match",
			"type": "clean_sheet",
			"desc": {
				"TR": "Gol yemeden maç tamamla",
				"ENG": "Complete a match without conceding",
				"ESP": "Completa un partido sin recibir goles",
				"POR": "Complete um jogo sem sofrer golos"
			},
			"target": 1,
			"progress": 0,
			"reward": 45,
			"claimed": false
		}
	]

func record_match_result(home: String, away: String, home_score: int, away_score: int):
	check_daily_reset()
	var fav = favorite_team if favorite_team != "" else home_team_name
	
	var is_fav_home = (home == fav)
	var is_fav_away = (away == fav)
	var is_fav_match = is_fav_home or is_fav_away
	
	var fav_score = 0
	var opp_score = 0
	var fav_won = false
	
	if is_fav_home:
		fav_score = home_score
		opp_score = away_score
		fav_won = (home_score > away_score)
	elif is_fav_away:
		fav_score = away_score
		opp_score = home_score
		fav_won = (away_score > home_score)
	else:
		# Player was home team by default
		fav_score = home_score
		opp_score = away_score
		fav_won = (home_score > away_score)
	
	# Track Leaderboard goals
	if fav_score > 0:
		favorite_team_goals_scored += fav_score
	
	# Update Quests
	for q in daily_quests:
		if q.get("claimed", false):
			continue
		var q_type = q.get("type", "")
		if q_type == "fav_win" and fav_won:
			q["progress"] = min(q["target"], int(q["progress"]) + 1)
		elif q_type == "player_goals" and fav_score > 0:
			q["progress"] = min(q["target"], int(q["progress"]) + fav_score)
		elif q_type == "clean_sheet" and opp_score == 0 and fav_won:
			q["progress"] = min(q["target"], int(q["progress"]) + 1)
		elif q_type == "play_matches":
			q["progress"] = min(q["target"], int(q["progress"]) + 1)
			
	save_progression()

func claim_quest_reward(quest_id: String) -> int:
	for q in daily_quests:
		if q["id"] == quest_id and not q.get("claimed", false) and int(q.get("progress", 0)) >= int(q.get("target", 1)):
			q["claimed"] = true
			var r = int(q.get("reward", 30))
			ad_credits += r
			save_progression()
			return r
	return 0

const WHEEL_SEGMENTS = [
	{"coins": 10,  "weight": 26, "color": Color8(229, 57, 53)},   # Crimson Red
	{"coins": 20,  "weight": 20, "color": Color8(30, 136, 229)},  # Azure Blue
	{"coins": 35,  "weight": 16, "color": Color8(67, 160, 71)},   # Emerald Green
	{"coins": 50,  "weight": 12, "color": Color8(251, 140, 0)},   # Amber Orange
	{"coins": 75,  "weight": 9,  "color": Color8(142, 36, 170)},  # Royal Purple
	{"coins": 100, "weight": 7,  "color": Color8(0, 172, 193)},   # Cyan / Teal
	{"coins": 150, "weight": 5,  "color": Color8(216, 27, 96)},   # Rose Magenta
	{"coins": 250, "weight": 3,  "color": Color8(244, 81, 30)},   # Deep Bronze
	{"coins": 500, "weight": 2,  "color": Color8(255, 215, 0)}    # Gold Jackpot
]

func spin_lucky_wheel() -> Dictionary:
	var total_weight = 0
	for seg in WHEEL_SEGMENTS:
		total_weight += int(seg["weight"])
	
	var roll = randi_range(1, total_weight)
	var cumulative = 0
	var chosen_idx = 0
	for i in range(WHEEL_SEGMENTS.size()):
		cumulative += int(WHEEL_SEGMENTS[i]["weight"])
		if roll <= cumulative:
			chosen_idx = i
			break
	
	var result = WHEEL_SEGMENTS[chosen_idx].duplicate()
	result["index"] = chosen_idx
	
	# Reward coins
	ad_credits += int(result["coins"])
	save_progression()
	return result

# ======================================================
# PROCEDURAL BALL SKIN RENDERER (ALL 5 SKINS)
# ======================================================
static func draw_ball_skin(canvas: CanvasItem, center: Vector2, radius: float, skin_id: String, time_sec: float = -1.0) -> void:
	if skin_id == "default" or skin_id == "":
		var scale = radius / 47.0
		canvas.draw_arc(center, radius - 1.5 * scale, 0, TAU, 64, Color.WHITE, 1.2 * scale, true)
		canvas.draw_arc(center, radius, 0, TAU, 64, Color.WHITE, 0.8 * scale, true)
		return

	var time = time_sec if time_sec >= 0.0 else (Time.get_ticks_msec() / 1000.0)
	var scale = radius / 47.0
	var c = center
	var r = radius

	match skin_id:
		"neon":
			var pulse = 0.5 + 0.5 * sin(time * 3.6)
			# 1. Multi-tier glowing bloom aura (Exterior)
			canvas.draw_arc(c, r + (6.0 + 3.0 * pulse) * scale, 0, TAU, 48, Color8(50, 255, 80, 35), 5.5 * scale, true)
			canvas.draw_arc(c, r + (3.5 + 2.0 * pulse) * scale, 0, TAU, 48, Color8(80, 255, 90, 70), 4.0 * scale, true)
			canvas.draw_arc(c, r + (1.5 + 1.0 * pulse) * scale, 0, TAU, 56, Color8(120, 255, 100, 110), 3.0 * scale, true)
			# 2. High-intensity laser rim (Edge)
			canvas.draw_arc(c, r - 1.2 * scale, 0, TAU, 64, Color8(80, 255, 50, 235), 3.8 * scale, true)
			canvas.draw_arc(c, r - 1.2 * scale, 0, TAU, 64, Color8(235, 255, 230, int(220 + 35 * pulse)), 1.4 * scale, true)
			# 3. 4-point laser lens flare on outer rim
			var fl_pos = c + Vector2(-r * 0.72, -r * 0.72)
			var fl_len = (7.0 + 2.5 * sin(time * 5.0)) * scale
			canvas.draw_circle(fl_pos, 4.0 * scale, Color8(100, 255, 120, 90))
			canvas.draw_line(fl_pos - Vector2(fl_len, 0), fl_pos + Vector2(fl_len, 0), Color8(210, 255, 210, 240), 1.4 * scale, true)
			canvas.draw_line(fl_pos - Vector2(0, fl_len), fl_pos + Vector2(0, fl_len), Color8(210, 255, 210, 240), 1.4 * scale, true)
			canvas.draw_circle(fl_pos, 2.0 * scale, Color.WHITE)

		"gold":
			# 1. Double-beveled 24K gold rim (Edge & Exterior)
			canvas.draw_arc(c, r + 0.6 * scale, 0, TAU, 64, Color8(130, 80, 10, 210), 2.0 * scale, true)
			canvas.draw_arc(c, r - 1.4 * scale, 0, TAU, 64, Color8(255, 195, 20), 4.6 * scale, true)
			canvas.draw_arc(c, r - 3.2 * scale, 0, TAU, 64, Color8(255, 238, 130, 190), 1.6 * scale, true)
			# 2. Outer rim gold shine arc
			var sw_a = int(180.0 * (0.5 + 0.5 * sin(time * 3.0)))
			canvas.draw_arc(c, r - 1.4 * scale, -0.85 * PI, -0.15 * PI, 24, Color8(255, 255, 230, sw_a), 2.2 * scale, true)
			# 3. Diamond sparkle glints on outer rim
			var sp_pos = c + Vector2(-r * 0.72, -r * 0.72)
			var rot = time * 1.2
			var gl_len = (7.5 + 2.0 * sin(time * 4.0)) * scale
			for i in range(2):
				var d1 = Vector2(cos(rot + i * PI * 0.5), sin(rot + i * PI * 0.5))
				canvas.draw_line(sp_pos - d1 * gl_len, sp_pos + d1 * gl_len, Color8(255, 255, 230, 240), 1.5 * scale, true)
				var d2 = Vector2(cos(rot + PI * 0.25 + i * PI * 0.5), sin(rot + PI * 0.25 + i * PI * 0.5))
				canvas.draw_line(sp_pos - d2 * (gl_len * 0.5), sp_pos + d2 * (gl_len * 0.5), Color8(255, 225, 100, 180), 1.0 * scale, true)
			canvas.draw_circle(sp_pos, 2.2 * scale, Color.WHITE)
			var sp2 = c + Vector2(r * 0.72, r * 0.72)
			var a2 = int(150 + 50 * cos(time * 3.0))
			canvas.draw_line(sp2 - Vector2(4.5 * scale, 0), sp2 + Vector2(4.5 * scale, 0), Color8(255, 235, 130, a2), 1.0 * scale, true)
			canvas.draw_line(sp2 - Vector2(0, 4.5 * scale), sp2 + Vector2(0, 4.5 * scale), Color8(255, 235, 130, a2), 1.0 * scale, true)

		"chrome":
			# 1. Mirror platinum rim (Edge & Exterior)
			canvas.draw_arc(c, r + 0.6 * scale, 0, TAU, 64, Color8(55, 65, 78, 220), 2.0 * scale, true)
			canvas.draw_arc(c, r - 1.4 * scale, 0, TAU, 64, Color8(242, 246, 252), 4.2 * scale, true)
			canvas.draw_arc(c, r - 3.2 * scale, 0, TAU, 64, Color8(115, 130, 150, 160), 1.4 * scale, true)
			# 2. Specular rim highlight arc
			canvas.draw_arc(c, r - 1.4 * scale, -0.90 * PI, -0.10 * PI, 32, Color8(255, 255, 255, 240), 2.4 * scale, true)
			canvas.draw_arc(c, r - 1.4 * scale, 0.20 * PI, 0.70 * PI, 24, Color8(180, 210, 240, 140), 1.8 * scale, true)
			# 3. Platinum star glint & flare on outer rim
			var ch_pos = c + Vector2(-r * 0.72, -r * 0.72)
			var ch_rot = time * 0.75
			var ch_len = (8.0 + 2.2 * sin(time * 4.2)) * scale
			for i in range(2):
				var d = Vector2(cos(ch_rot + i * PI * 0.5), sin(ch_rot + i * PI * 0.5))
				canvas.draw_line(ch_pos - d * ch_len, ch_pos + d * ch_len, Color.WHITE, 1.4 * scale, true)
			canvas.draw_line(ch_pos - Vector2(ch_len * 1.8, 0), ch_pos + Vector2(ch_len * 1.8, 0), Color8(190, 225, 255, 180), 1.0 * scale, true)
			canvas.draw_circle(ch_pos, 2.2 * scale, Color.WHITE)

		"lava":
			var heat_p = 0.5 + 0.5 * sin(time * 4.0)
			# 1. Molten heatwave aura & fiery outer rim (Exterior)
			canvas.draw_arc(c, r + (5.0 + 3.0 * heat_p) * scale, 0, TAU, 48, Color8(255, 45, 0, 36), 5.5 * scale, true)
			canvas.draw_arc(c, r + (2.5 + 1.5 * heat_p) * scale, 0, TAU, 48, Color8(255, 110, 0, 70), 4.0 * scale, true)
			canvas.draw_arc(c, r - 1.2 * scale, 0, TAU, 64, Color8(255, 75, 10), 4.5 * scale, true)
			canvas.draw_arc(c, r - 2.8 * scale, 0, TAU, 64, Color8(255, 210, 45, int(180 + 55 * heat_p)), 1.6 * scale, true)
			# 2. Floating orbiting ember sparks (Exterior Orbit)
			for i in range(5):
				var ea = i * (TAU / 5.0) + time * (1.2 + i * 0.3)
				var ed = r * (1.04 + 0.12 * sin(time * 3.0 + i))
				var ep = c + Vector2(cos(ea), sin(ea)) * ed
				var ea_alpha = int(160 + 95 * sin(time * 4.5 + i * 2.0))
				canvas.draw_circle(ep, 3.4 * scale, Color8(255, 80, 0, int(ea_alpha * 0.4)))
				canvas.draw_circle(ep, 1.8 * scale, Color8(255, 225, 70, ea_alpha))

		"ice":
			var frost_s = 0.5 + 0.5 * sin(time * 3.2)
			# 1. Cryogenic mist halo & frosty rim (Exterior)
			canvas.draw_arc(c, r + (5.0 + 2.5 * frost_s) * scale, 0, TAU, 48, Color8(70, 210, 255, 36), 5.0 * scale, true)
			canvas.draw_arc(c, r + (2.5 + 1.2 * frost_s) * scale, 0, TAU, 48, Color8(130, 235, 255, 70), 3.5 * scale, true)
			canvas.draw_arc(c, r - 1.2 * scale, 0, TAU, 64, Color8(95, 225, 255), 4.4 * scale, true)
			canvas.draw_arc(c, r - 2.8 * scale, 0, TAU, 64, Color8(220, 250, 255, int(190 + 50 * frost_s)), 1.5 * scale, true)
			# 2. Outward-radiating crystal frost spikes (Exterior Rim)
			for i in range(6):
				var a_sp = i * (TAU / 6.0) + time * 0.2
				var p_base = c + Vector2(cos(a_sp), sin(a_sp)) * (r - 1.0 * scale)
				var p_tip = c + Vector2(cos(a_sp), sin(a_sp)) * (r + (4.5 + 2.0 * sin(time * 3.0 + i)) * scale)
				canvas.draw_line(p_base, p_tip, Color8(210, 245, 255, 220), 1.5 * scale, true)
			# 3. Polar snowflake crystal glint on outer rim
			var ice_pos = c + Vector2(-r * 0.72, -r * 0.72)
			var ice_rot = time * 0.6
			var ice_len = (7.5 + 2.0 * sin(time * 4.0)) * scale
			for i in range(3):
				var d = Vector2(cos(ice_rot + i * PI / 3.0), sin(ice_rot + i * PI / 3.0))
				canvas.draw_line(ice_pos - d * ice_len, ice_pos + d * ice_len, Color8(235, 252, 255, 245), 1.4 * scale, true)
				var perp = Vector2(-d.y, d.x)
				var barb = ice_pos + d * (ice_len * 0.6)
				canvas.draw_line(barb - perp * (2.2 * scale), barb + perp * (2.2 * scale), Color8(200, 245, 255, 200), 1.0 * scale, true)
			canvas.draw_circle(ice_pos, 2.2 * scale, Color.WHITE)
