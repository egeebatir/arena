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
	},
	"ITA": {
		"GOAL": "GOL!", "HT": "PT", "FT": "FINALE"
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

var current_theme = "Mavi"
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
	elif current_lang == "ESP" or current_lang == "POR" or current_lang == "ITA":
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
		"title": {"TR": "İlk Galibiyet", "ENG": "First Victory", "ESP": "Primera Victoria", "POR": "Primeira Vitória", "ITA": "Prima Vittoria"},
		"desc": {"TR": "İlk maçını kazan", "ENG": "Win your first match", "ESP": "Gana tu primer partido", "POR": "Vença sua primeira partida", "ITA": "Vinci la tua prima partita"}
	},
	"CLEAN_SHEET": {
		"id": "CgkI2eP165kXEAIQAg",
		"title": {"TR": "Gol Yemeden", "ENG": "Clean Sheet", "ESP": "Valla Invicta", "POR": "Sem Sofrer Golos", "ITA": "Porta Inviolata"},
		"desc": {"TR": "Gol yemeden maç kazan", "ENG": "Win without conceding", "ESP": "Gana sin recibir goles", "POR": "Vença sem sofrer golos", "ITA": "Vinci una partita senza subire gol"}
	},
	"FIVE_GOALS": {
		"id": "CgkI2eP165kXEAIQAw",
		"title": {"TR": "Gol Yağmuru", "ENG": "Goal Rain", "ESP": "Lluvia de Goles", "POR": "Chuva de Golos", "ITA": "Pioggia di Gol"},
		"desc": {"TR": "Bir maçta 5 veya daha fazla gol at", "ENG": "Score 5+ goals in a match", "ESP": "Anota 5+ goles en un partido", "POR": "Marque 5+ golos numa partida", "ITA": "Segna 5 o più gol in una partita"}
	},
	"HAT_TRICK": {
		"id": "CgkI2eP165kXEAIQBA",
		"title": {"TR": "Hat-Trick", "ENG": "Hat-Trick", "ESP": "Hat-Trick", "POR": "Hat-Trick", "ITA": "Tripletta"},
		"desc": {"TR": "Aynı oyuncuyla bir maçta 3 gol at", "ENG": "Score 3 goals with the same player", "ESP": "Anota 3 goles con el mismo jugador", "POR": "Marque 3 golos com o mesmo jogador", "ITA": "Segna 3 gol con lo stesso giocatore"}
	},
	"COMEBACK_KING": {
		"id": "CgkI2eP165kXEAIQBQ",
		"title": {"TR": "Geri Dönüş Kralı", "ENG": "Comeback King", "ESP": "Rey de la Remontada", "POR": "Rei da Reviravolta", "ITA": "Re della Rimonta"},
		"desc": {"TR": "Geriye düştüğün maçı kazan", "ENG": "Win after trailing behind", "ESP": "Gana tras ir perdiendo", "POR": "Vença após estar a perder", "ITA": "Vinci una partita dopo essere andato sotto"}
	},
	"ROYALTY": {
		"id": "CgkI2eP165kXEAIQBg",
		"title": {"TR": "Kraliyet Tacı", "ENG": "Royalty", "ESP": "Realeza", "POR": "Realeza", "ITA": "Corona Reale"},
		"desc": {"TR": "Favori takımına bir taç kuşandır", "ENG": "Equip a crown on your favorite team", "ESP": "Equipa una corona a tu equipo", "POR": "Equipe uma coroa na sua equipa", "ITA": "Equipaggia una corona alla tua squadra"}
	},
	"COLLECTOR": {
		"id": "CgkI2eP165kXEAIQBw",
		"title": {"TR": "Koleksiyoncu", "ENG": "Collector", "ESP": "Coleccionista", "POR": "Colecionador", "ITA": "Collezionista"},
		"desc": {"TR": "3 farklı top görünümü aç", "ENG": "Unlock 3 ball skins", "ESP": "Desbloquea 3 balones", "POR": "Desbloqueie 3 bolas", "ITA": "Sblocca 3 aspetti pallone differenti"}
	},
	"TEN_MATCHES": {
		"id": "CgkI2eP165kXEAIQCA",
		"title": {"TR": "Sadık Futbolcu", "ENG": "Dedicated Player", "ESP": "Jugador Dedicado", "POR": "Jogador Dedicado", "ITA": "Giocatore Fedele"},
		"desc": {"TR": "10 maç tamamla", "ENG": "Complete 10 matches", "ESP": "Completa 10 partidos", "POR": "Complete 10 partidas", "ITA": "Completa 10 partite"}
	},
	"FAVORITE_CHAMPION": {
		"id": "CgkI2eP165kXEAIQCQ",
		"title": {"TR": "Sadık Taraftar", "ENG": "True Supporter", "ESP": "Verdadero Hincha", "POR": "Verdadeiro Adepto", "ITA": "Tifoso Autentico"},
		"desc": {"TR": "Favori takımınla maç kazan", "ENG": "Win a match with your favorite team", "ESP": "Gana con tu equipo favorito", "POR": "Vença com a sua equipa favorita", "ITA": "Vinci una partita con la tua squadra preferita"}
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
		
		# Fallback timeout in case ad UI doesn't trigger callback (wall-clock time, ignores time_scale)
		get_tree().create_timer(2.5, true, false, true).timeout.connect(cleanup_and_callback)
		
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
	"viking_helmet": {
		"id": "viking_helmet",
		"price": 1250,
		"texture_path": "res://hat_viking.png",
		"name": {
			"TR": "Viking Miğferi",
			"ENG": "Viking Helmet",
			"ESP": "Casco Vikingo",
			"POR": "Capacete Viking",
			"ITA": "Elmo Vichingo"
		}
	},
	"magic_hat": {
		"id": "magic_hat",
		"price": 1500,
		"texture_path": "res://hat_magic.png",
		"name": {
			"TR": "Büyücü Şapkası",
			"ENG": "Magic Hat",
			"ESP": "Sombrero Mágico",
			"POR": "Chapéu Mágico",
			"ITA": "Cappello Magico"
		}
	},
	"kings_crown": {
		"id": "kings_crown",
		"price": 500,
		"texture_path": "res://hat_kings_crown.png",
		"name": {
			"TR": "Kral Tacı",
			"ENG": "King's Crown",
			"ESP": "Corona de Rey",
			"POR": "Coroa de Rei",
			"ITA": "Corona del Re"
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
			"POR": "Coroa de Rainha",
			"ITA": "Corona della Regina"
		}
	}
}

func increment_matches_played():
	if login_method == "guest":
		matches_played_since_prompt += 1
		save_progression()


var THEMES = {
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
	"Mor": {
		"bg_top": Color8(180, 150, 220), "bg_bottom": Color8(30, 10, 50),
		"pitch_1": Color8(45, 15, 80), "pitch_2": Color8(60, 25, 110),
		"panel": Color8(20, 5, 30, 230), "accent": Color8(0, 255, 255)
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
		"name": {"TR": "Türkiye Ligi", "ENG": "Turkish League", "ESP": "Liga Turca", "POR": "Liga Turca", "ITA": "Campionato Turco"}
	},
	"ENGLAND": {
		"id": "ENGLAND",
		"name": {"TR": "İngiltere Ligi", "ENG": "English League", "ESP": "Liga Inglesa", "POR": "Liga Inglesa", "ITA": "Campionato Inglese"}
	},
	"SPAIN": {
		"id": "SPAIN",
		"name": {"TR": "İspanya Ligi", "ENG": "Spanish League", "ESP": "Liga Española", "POR": "Liga Espanhola", "ITA": "Campionato Spagnolo"}
	},
	"GERMANY": {
		"id": "GERMANY",
		"name": {"TR": "Almanya Ligi", "ENG": "German League", "ESP": "Liga Alemana", "POR": "Liga Alemã", "ITA": "Campionato Tedesco"}
	},
	"ITALY": {
		"id": "ITALY",
		"name": {"TR": "İtalya Ligi", "ENG": "Italian League", "ESP": "Liga Italiana", "POR": "Liga Italiana", "ITA": "Campionato Italiano"}
	},
	"FRANCE": {
		"id": "FRANCE",
		"name": {"TR": "Fransa Ligi", "ENG": "French League", "ESP": "Liga Francesa", "POR": "Liga Francesa", "ITA": "Campionato Francese"}
	},
	"USA": {
		"id": "USA",
		"name": {"TR": "Amerika Ligi", "ENG": "American League", "ESP": "Liga Americana", "POR": "Liga Americana", "ITA": "Campionato Americano"}
	},
	"SAUDI": {
		"id": "SAUDI",
		"name": {"TR": "Suudi Ligi", "ENG": "Saudi League", "ESP": "Liga Saudí", "POR": "Liga Saudita", "ITA": "Campionato Saudita"}
	},
	"WORLD": {
		"id": "WORLD",
		"name": {"TR": "Dünya Kulüpleri", "ENG": "World Clubs", "ESP": "Clubes del Mundo", "POR": "Clubes do Mundo", "ITA": "Club Mondiali"}
	}
}

var TEAM_LOGOS = {}

var TEAMS = {
	# --- MİLLİ TAKIMLAR (Hazırlık) ---
	"TÜRKİYE":        {"colors": [Color8(227, 10, 23), Color8(255, 255, 255)], "short": "TUR", "league": "NATIONAL", "type": "national"},
	"ARJANTİN":       {"colors": [Color8(116, 172, 223), Color8(255, 255, 255)], "short": "ARG", "league": "NATIONAL", "type": "national"},
	"PORTEKİZ":       {"colors": [Color8(255, 0, 0), Color8(0, 102, 0)], "short": "POR", "league": "NATIONAL", "type": "national"},
	# --- TÜRKİYE LİGİ ---
	"GALATA FK":      {"colors": [Color8(169, 4, 50), Color8(253, 185, 18)], "short": "GAL", "league": "TURKEY", "type": "club"},
	"FENER FK":       {"colors": [Color8(255, 255, 0), Color8(0, 0, 128)],   "short": "FEN", "league": "TURKEY", "type": "club"},
	"BEŞIKTAŞ FK":    {"colors": [Color8(255, 255, 255), Color8(10, 10, 10)],"short": "BJK", "league": "TURKEY", "type": "club"},
	"TRABZON FK":     {"colors": [Color8(128, 0, 0), Color8(0, 191, 255)],   "short": "TRA", "league": "TURKEY", "type": "club"},
	"BAŞAKŞEHIR FK":  {"colors": [Color8(255, 102, 0), Color8(0, 0, 102)],   "short": "BFK", "league": "TURKEY", "type": "club"},
	"KASIMPAŞA SK":   {"colors": [Color8(255, 255, 255), Color8(0, 0, 128)], "short": "KAS", "league": "TURKEY", "type": "club"},
	"SIVAS FK":       {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "SVS", "league": "TURKEY", "type": "club"},
	"ALANYA FK":      {"colors": [Color8(255, 165, 0), Color8(0, 128, 0)],   "short": "ALN", "league": "TURKEY", "type": "club"},
	"RIZE FK":        {"colors": [Color8(0, 128, 0), Color8(0, 0, 255)],     "short": "RIZ", "league": "TURKEY", "type": "club"},
	"ANTALYA FK":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "ANT", "league": "TURKEY", "type": "club"},
	"ANTEP SC":       {"colors": [Color8(200, 16, 46), Color8(10, 10, 10)],  "short": "GFK", "league": "TURKEY", "type": "club"},
	"KONYA FK":       {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)], "short": "KON", "league": "TURKEY", "type": "club"},
	"KAYSERI FK":     {"colors": [Color8(255, 204, 0), Color8(255, 0, 0)],   "short": "KAY", "league": "TURKEY", "type": "club"},
	"BODRUM SC":      {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)], "short": "BOD", "league": "TURKEY", "type": "club"},
	"EYÜP FK":        {"colors": [Color8(230, 230, 250), Color8(255, 215, 0)],"short": "EYP", "league": "TURKEY", "type": "club"},
	"GÖZTEPE FC":     {"colors": [Color8(255, 215, 0), Color8(255, 0, 0)],   "short": "GÖZ", "league": "TURKEY", "type": "club"},
	"SAMSUN FK":      {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)], "short": "SAM", "league": "TURKEY", "type": "club"},
	"KOCAELI FK":     {"colors": [Color8(0, 128, 0), Color8(10, 10, 10)],    "short": "KOC", "league": "TURKEY", "type": "club"},
	"KARAGÜMRÜK SC":  {"colors": [Color8(255, 0, 0), Color8(10, 10, 10)],    "short": "FKG", "league": "TURKEY", "type": "club"},
	"GENÇLER FK":     {"colors": [Color8(200, 16, 46), Color8(10, 10, 10)],  "short": "GEN", "league": "TURKEY", "type": "club"},
	"HATAY FK":       {"colors": [Color8(128, 0, 0), Color8(255, 255, 255)], "short": "HAT", "league": "TURKEY", "type": "club"},
	"ADANA D. FC":    {"colors": [Color8(0, 0, 255), Color8(173, 216, 230)], "short": "ADS", "league": "TURKEY", "type": "club"},

	# --- İNGİLTERE LİGİ ---
	"N. FOREST":      {"colors": [Color8(229, 30, 42), Color8(255, 255, 255)],"short": "NFO", "league": "ENGLAND", "type": "club"},
	"MANCHESTER C.":  {"colors": [Color8(108, 171, 221), Color8(255, 255, 255)],"short": "MCI", "league": "ENGLAND", "type": "club"},
	"LIVERPOOL SC":   {"colors": [Color8(200, 16, 46), Color8(255, 255, 255)],  "short": "LIV", "league": "ENGLAND", "type": "club"},
	"ARSENAL SC":     {"colors": [Color8(239, 1, 7), Color8(255, 255, 255)],    "short": "ARS", "league": "ENGLAND", "type": "club"},
	"ASTON V.":       {"colors": [Color8(103, 14, 54), Color8(149, 191, 229)],  "short": "AVL", "league": "ENGLAND", "type": "club"},
	"TOTTENHAM L.":   {"colors": [Color8(255, 255, 255), Color8(19, 34, 87)],   "short": "TOT", "league": "ENGLAND", "type": "club"},
	"MANCHESTER U.":  {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)],  "short": "MUN", "league": "ENGLAND", "type": "club"},
	"CHELSEA SC":     {"colors": [Color8(3, 70, 148), Color8(255, 255, 255)],   "short": "CHE", "league": "ENGLAND", "type": "club"},
	"NEWCASTLE U.":   {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],    "short": "NEW", "league": "ENGLAND", "type": "club"},
	"BOURNEMOUTH SC": {"colors": [Color8(200, 16, 46), Color8(0, 0, 0)],        "short": "BOU", "league": "ENGLAND", "type": "club"},
	"BRENTFORD SC":   {"colors": [Color8(227, 6, 19), Color8(255, 255, 255)],   "short": "BRE", "league": "ENGLAND", "type": "club"},
	"BRIGHTON C.":    {"colors": [Color8(0, 87, 184), Color8(255, 255, 255)],   "short": "BHA", "league": "ENGLAND", "type": "club"},
	"BURNLEY SC":     {"colors": [Color8(108, 29, 69), Color8(153, 214, 234)],  "short": "BUR", "league": "ENGLAND", "type": "club"},
	"EVERTON SC":     {"colors": [Color8(0, 51, 153), Color8(255, 255, 255)],   "short": "EVE", "league": "ENGLAND", "type": "club"},
	"FULHAM SC":      {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],      "short": "FUL", "league": "ENGLAND", "type": "club"},
	"LEEDS U.":       {"colors": [Color8(255, 255, 255), Color8(29, 66, 138)],  "short": "LEE", "league": "ENGLAND", "type": "club"},
	"C. PALACE":      {"colors": [Color8(27, 69, 143), Color8(196, 18, 46)],    "short": "CRY", "league": "ENGLAND", "type": "club"},
	"SUNDERLAND SC":  {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],    "short": "SUN", "league": "ENGLAND", "type": "club"},
	"WEST HAM L.":    {"colors": [Color8(122, 38, 58), Color8(27, 177, 231)],   "short": "WHU", "league": "ENGLAND", "type": "club"},
	"WOLVES SC":      {"colors": [Color8(253, 185, 19), Color8(0, 0, 0)],       "short": "WOL", "league": "ENGLAND", "type": "club"},

	# --- İSPANYA LİGİ ---
	"R. MADRID":      {"colors": [Color8(255, 255, 255), Color8(255, 215, 0)],"short": "RMA", "league": "SPAIN", "type": "club"},
	"BARSELONA SC":   {"colors": [Color8(0, 77, 152), Color8(165, 0, 68)],    "short": "BAR", "league": "SPAIN", "type": "club"},
	"A. MADRID":      {"colors": [Color8(203, 53, 36), Color8(255, 255, 255)],"short": "ATM", "league": "SPAIN", "type": "club"},
	"GIRONA SC":      {"colors": [Color8(200, 16, 46), Color8(255, 255, 255)],"short": "GIR", "league": "SPAIN", "type": "club"},
	"C. VIGO":        {"colors": [Color8(138, 195, 238), Color8(255, 255, 255)],"short": "CEL", "league": "SPAIN", "type": "club"},
	"BILBAO CF":      {"colors": [Color8(237, 28, 36), Color8(255, 255, 255)], "short": "ATH", "league": "SPAIN", "type": "club"},
	"R. SOCIEDAD":    {"colors": [Color8(0, 103, 177), Color8(255, 255, 255)], "short": "RSO", "league": "SPAIN", "type": "club"},
	"VILLARREAL SC":  {"colors": [Color8(255, 230, 0), Color8(0, 0, 102)],     "short": "VIL", "league": "SPAIN", "type": "club"},
	"VALENCIA SC":    {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],     "short": "VAL", "league": "SPAIN", "type": "club"},
	"SEVILLA SC":     {"colors": [Color8(255, 255, 255), Color8(218, 41, 28)], "short": "SEV", "league": "SPAIN", "type": "club"},
	"R. BETIS":       {"colors": [Color8(0, 148, 72), Color8(255, 255, 255)],  "short": "BET", "league": "SPAIN", "type": "club"},
	"OSASUNA SC":     {"colors": [Color8(193, 29, 39), Color8(0, 27, 73)],     "short": "OSA", "league": "SPAIN", "type": "club"},
	"MALLORCA SC":    {"colors": [Color8(226, 0, 26), Color8(0, 0, 0)],        "short": "MLL", "league": "SPAIN", "type": "club"},
	"ALAVES SC":      {"colors": [Color8(0, 68, 148), Color8(255, 255, 255)],  "short": "ALA", "league": "SPAIN", "type": "club"},
	"R. VALLECANO":   {"colors": [Color8(255, 255, 255), Color8(227, 6, 19)],  "short": "RAY", "league": "SPAIN", "type": "club"},
	"GETAFE SC":      {"colors": [Color8(0, 75, 151), Color8(255, 255, 255)],  "short": "GET", "league": "SPAIN", "type": "club"},
	"ESPANYOL BC":    {"colors": [Color8(0, 122, 195), Color8(255, 255, 255)], "short": "ESP", "league": "SPAIN", "type": "club"},
	"ELCHE SC":       {"colors": [Color8(0, 100, 0), Color8(255, 255, 255)],   "short": "ELC", "league": "SPAIN", "type": "club"},
	"OVIEDO SC":      {"colors": [Color8(0, 51, 160), Color8(255, 255, 255)],  "short": "OVI", "league": "SPAIN", "type": "club"},
	"LEVANTE SC":     {"colors": [Color8(0, 51, 102), Color8(153, 0, 51)],     "short": "LEV", "league": "SPAIN", "type": "club"},

	# --- ALMANYA LİGİ ---
	"MÜNIH B.":       {"colors": [Color8(220, 5, 45), Color8(255, 255, 255)], "short": "BAY", "league": "GERMANY", "type": "club"},
	"DORTMUND SC":    {"colors": [Color8(253, 225, 0), Color8(10, 10, 10)],   "short": "BVB", "league": "GERMANY", "type": "club"},
	"LEVERKUSEN SC":  {"colors": [Color8(10, 10, 10), Color8(227, 34, 25)],   "short": "B04", "league": "GERMANY", "type": "club"},
	"LEIPZIG SC":     {"colors": [Color8(255, 255, 255), Color8(221, 5, 43)], "short": "RBL", "league": "GERMANY", "type": "club"},
	"STUTTGART SC":   {"colors": [Color8(255, 255, 255), Color8(227, 34, 25)],"short": "VFB", "league": "GERMANY", "type": "club"},
	"AUGSBURG SC":    {"colors": [Color8(255, 255, 255), Color8(186, 32, 38)], "short": "AUG", "league": "GERMANY", "type": "club"},
	"FRANKFURT SC":   {"colors": [Color8(0, 0, 0), Color8(227, 34, 25)],       "short": "FRA", "league": "GERMANY", "type": "club"},
	"FREIBURG SC":    {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)], "short": "FRE", "league": "GERMANY", "type": "club"},
	"HAMBURG C.":     {"colors": [Color8(0, 85, 164), Color8(255, 255, 255)],  "short": "HSV", "league": "GERMANY", "type": "club"},
	"HEIDENHEIM SC":  {"colors": [Color8(227, 34, 25), Color8(0, 51, 160)],    "short": "HEI", "league": "GERMANY", "type": "club"},
	"HOFFENHEIM SC":  {"colors": [Color8(0, 92, 169), Color8(255, 255, 255)],  "short": "HOF", "league": "GERMANY", "type": "club"},
	"KÖLN SC":        {"colors": [Color8(227, 34, 25), Color8(255, 255, 255)], "short": "KÖL", "league": "GERMANY", "type": "club"},
	"MAINZ SC":       {"colors": [Color8(237, 28, 36), Color8(255, 255, 255)], "short": "MAI", "league": "GERMANY", "type": "club"},
	"M. GLADBACH":    {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "BMG", "league": "GERMANY", "type": "club"},
	"ST. PAULI SC":   {"colors": [Color8(105, 57, 4), Color8(255, 255, 255)],  "short": "STP", "league": "GERMANY", "type": "club"},
	"U. BERLIN":      {"colors": [Color8(218, 41, 28), Color8(255, 255, 255)], "short": "UNB", "league": "GERMANY", "type": "club"},
	"W. BREMEN":      {"colors": [Color8(29, 162, 83), Color8(255, 255, 255)], "short": "WER", "league": "GERMANY", "type": "club"},
	"WOLFSBURG SC":   {"colors": [Color8(98, 179, 48), Color8(255, 255, 255)], "short": "WOB", "league": "GERMANY", "type": "club"},

	# --- İTALYA LİGİ ---
	"INTER M.":       {"colors": [Color8(0, 102, 187), Color8(10, 10, 10)],   "short": "INT", "league": "ITALY", "type": "club"},
	"AC MILANO":      {"colors": [Color8(251, 9, 11), Color8(10, 10, 10)],    "short": "MIL", "league": "ITALY", "type": "club"},
	"JUVE SC":        {"colors": [Color8(255, 255, 255), Color8(10, 10, 10)], "short": "JUV", "league": "ITALY", "type": "club"},
	"ATALANTA B.":    {"colors": [Color8(30, 113, 184), Color8(10, 10, 10)],  "short": "ATA", "league": "ITALY", "type": "club"},
	"ROMA SC":        {"colors": [Color8(134, 38, 51), Color8(240, 188, 66)], "short": "ROM", "league": "ITALY", "type": "club"},
	"LAZIO SC":       {"colors": [Color8(135, 206, 235), Color8(255, 255, 255)],"short": "LAZ", "league": "ITALY", "type": "club"},
	"BOLOGNA SC":     {"colors": [Color8(158, 27, 50), Color8(26, 35, 66)],   "short": "BOL", "league": "ITALY", "type": "club"},
	"CAGLIARI SC":    {"colors": [Color8(163, 19, 51), Color8(0, 35, 80)],     "short": "CAG", "league": "ITALY", "type": "club"},
	"COMO SC":        {"colors": [Color8(0, 71, 169), Color8(255, 255, 255)],  "short": "COM", "league": "ITALY", "type": "club"},
	"CREMONESE SC":   {"colors": [Color8(130, 130, 130), Color8(227, 34, 25)], "short": "CRE", "league": "ITALY", "type": "club"},
	"FIRENZE SC":     {"colors": [Color8(72, 46, 146), Color8(255, 255, 255)], "short": "FIO", "league": "ITALY", "type": "club"},
	"GENOA SC":       {"colors": [Color8(166, 28, 49), Color8(0, 36, 81)],     "short": "GNO", "league": "ITALY", "type": "club"},
	"LECCE SC":       {"colors": [Color8(255, 217, 0), Color8(227, 34, 25)],   "short": "LEC", "league": "ITALY", "type": "club"},
	"NAPOLI SC":      {"colors": [Color8(18, 160, 215), Color8(255, 255, 255)],"short": "NAP", "league": "ITALY", "type": "club"},
	"PARMA SC":       {"colors": [Color8(255, 204, 0), Color8(0, 51, 153)],    "short": "PAR", "league": "ITALY", "type": "club"},
	"PISA SC":        {"colors": [Color8(0, 0, 0), Color8(0, 84, 166)],       "short": "PIS", "league": "ITALY", "type": "club"},
	"SASSUOLO SC":    {"colors": [Color8(0, 160, 90), Color8(0, 0, 0)],        "short": "SAS", "league": "ITALY", "type": "club"},
	"TORINO SC":      {"colors": [Color8(138, 30, 50), Color8(255, 255, 255)], "short": "TOR", "league": "ITALY", "type": "club"},
	"UDINESE C.":     {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "UDI", "league": "ITALY", "type": "club"},
	"VERONA SC":      {"colors": [Color8(0, 51, 102), Color8(255, 204, 0)],    "short": "VER", "league": "ITALY", "type": "club"},

	# --- FRANSA LİGİ ---
	"PARIS SC":       {"colors": [Color8(0, 65, 112), Color8(218, 41, 28)],   "short": "PSG", "league": "FRANCE", "type": "club"},
	"LILLE SC":       {"colors": [Color8(238, 36, 54), Color8(0, 51, 102)],   "short": "LIL", "league": "FRANCE", "type": "club"},
	"MONACO SC":      {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],  "short": "ASM", "league": "FRANCE", "type": "club"},
	"MARSILYA SC":    {"colors": [Color8(255, 255, 255), Color8(0, 150, 214)], "short": "MAR", "league": "FRANCE", "type": "club"},
	"LYON SC":        {"colors": [Color8(255, 255, 255), Color8(218, 41, 28)], "short": "LYO", "league": "FRANCE", "type": "club"},
	"LENS SC":        {"colors": [Color8(237, 28, 36), Color8(255, 215, 0)],   "short": "RCL", "league": "FRANCE", "type": "club"},
	"NICE SC":        {"colors": [Color8(218, 41, 28), Color8(0, 0, 0)],       "short": "NIC", "league": "FRANCE", "type": "club"},
	"RENNES SC":      {"colors": [Color8(227, 34, 25), Color8(0, 0, 0)],       "short": "REN", "league": "FRANCE", "type": "club"},
	"STRASBOURG SC":  {"colors": [Color8(0, 82, 159), Color8(255, 255, 255)],  "short": "STR", "league": "FRANCE", "type": "club"},
	"REIMS SC":       {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "SDR", "league": "FRANCE", "type": "club"},
	"TOULOUSE SC":    {"colors": [Color8(92, 45, 145), Color8(255, 255, 255)], "short": "TFC", "league": "FRANCE", "type": "club"},
	"NANTES SC":      {"colors": [Color8(253, 233, 34), Color8(0, 100, 50)],   "short": "FCN", "league": "FRANCE", "type": "club"},
	"MONTPELLIER SC": {"colors": [Color8(0, 35, 96), Color8(243, 108, 33)],    "short": "MHS", "league": "FRANCE", "type": "club"},
	"ANGERS SC":      {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "SCO", "league": "FRANCE", "type": "club"},
	"BREST SC":       {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "SB2", "league": "FRANCE", "type": "club"},
	"LE HAVRE C.":    {"colors": [Color8(111, 172, 222), Color8(0, 31, 73)],   "short": "HAC", "league": "FRANCE", "type": "club"},
	"AUXERRE SC":     {"colors": [Color8(255, 255, 255), Color8(0, 68, 148)],  "short": "AJA", "league": "FRANCE", "type": "club"},
	"ST. ETIENNE C.": {"colors": [Color8(0, 102, 51), Color8(255, 255, 255)],  "short": "ASE", "league": "FRANCE", "type": "club"},

	# --- AMERİKA LİGİ ---
	"MIAMI INTER":    {"colors": [Color8(244, 181, 205), Color8(0, 0, 0)],     "short": "MIA", "league": "USA", "type": "club"},
	"LA SC":          {"colors": [Color8(0, 0, 0), Color8(195, 158, 109)],     "short": "LAF", "league": "USA", "type": "club"},
	"LA GALAKSI":     {"colors": [Color8(0, 36, 93), Color8(255, 210, 0)],     "short": "LAG", "league": "USA", "type": "club"},
	"COLUMBUS C.":    {"colors": [Color8(255, 223, 0), Color8(0, 0, 0)],       "short": "CCW", "league": "USA", "type": "club"},
	"CINCINNATI C.":  {"colors": [Color8(240, 83, 35), Color8(38, 59, 128)],   "short": "CIN", "league": "USA", "type": "club"},
	"SEATTLE S.":     {"colors": [Color8(93, 151, 50), Color8(0, 85, 149)],    "short": "SEA", "league": "USA", "type": "club"},
	"NY CITY":        {"colors": [Color8(108, 172, 228), Color8(4, 30, 66)],   "short": "NYC", "league": "USA", "type": "club"},
	"NY BULLS":       {"colors": [Color8(226, 24, 54), Color8(255, 255, 255)], "short": "NYR", "league": "USA", "type": "club"},
	"ATLANTA U.":     {"colors": [Color8(128, 0, 0), Color8(0, 0, 0)],         "short": "ATL", "league": "USA", "type": "club"},
	"PORTLAND T.":    {"colors": [Color8(0, 72, 39), Color8(234, 170, 0)],     "short": "PTL", "league": "USA", "type": "club"},
	"ORLANDO C.":     {"colors": [Color8(99, 52, 146), Color8(255, 255, 255)], "short": "ORL", "league": "USA", "type": "club"},
	"HOUSTON D.":     {"colors": [Color8(255, 107, 0), Color8(0, 0, 0)],       "short": "HOU", "league": "USA", "type": "club"},
	"R. SALT LAKE":   {"colors": [Color8(179, 11, 34), Color8(1, 31, 91)],     "short": "RSL", "league": "USA", "type": "club"},
	"PHILA U.":       {"colors": [Color8(0, 45, 85), Color8(179, 163, 105)],   "short": "PHI", "league": "USA", "type": "club"},
	"KANSAS CITY S.": {"colors": [Color8(145, 176, 213), Color8(0, 42, 92)],   "short": "SKC", "league": "USA", "type": "club"},
	"NEW ENGLAND R.": {"colors": [Color8(226, 24, 54), Color8(0, 43, 92)],     "short": "NER", "league": "USA", "type": "club"},
	"NASHVILLE C.":   {"colors": [Color8(236, 232, 58), Color8(31, 22, 70)],   "short": "NSC", "league": "USA", "type": "club"},
	"DALLAS SC":      {"colors": [Color8(226, 24, 54), Color8(0, 62, 126)],    "short": "DAL", "league": "USA", "type": "club"},
	"VANCOUVER C.":   {"colors": [Color8(0, 36, 94), Color8(255, 255, 255)],   "short": "VAN", "league": "USA", "type": "club"},
	"MINNESOTA U.":   {"colors": [Color8(135, 142, 144), Color8(122, 184, 237)],"short": "MIN", "league": "USA", "type": "club"},
	"COLORADO R.":    {"colors": [Color8(134, 38, 51), Color8(139, 171, 204)], "short": "COL", "league": "USA", "type": "club"},
	"CHARLOTTE SC":   {"colors": [Color8(0, 133, 202), Color8(0, 0, 0)],       "short": "CHR", "league": "USA", "type": "club"},
	"SAN JOSE E.":    {"colors": [Color8(0, 0, 0), Color8(0, 81, 186)],        "short": "SJE", "league": "USA", "type": "club"},
	"AUSTIN SC":      {"colors": [Color8(0, 180, 81), Color8(0, 0, 0)],        "short": "AUS", "league": "USA", "type": "club"},
	"CHICAGO F.":     {"colors": [Color8(255, 0, 0), Color8(0, 42, 92)],       "short": "CHI", "league": "USA", "type": "club"},
	"WASHINGTON DC":  {"colors": [Color8(0, 0, 0), Color8(239, 62, 66)],       "short": "DCU", "league": "USA", "type": "club"},
	"MONTREAL SC":    {"colors": [Color8(0, 51, 160), Color8(0, 0, 0)],        "short": "MTL", "league": "USA", "type": "club"},
	"ST. LOUIS C.":   {"colors": [Color8(226, 24, 54), Color8(0, 43, 92)],     "short": "STL", "league": "USA", "type": "club"},
	"TORONTO SC":     {"colors": [Color8(227, 38, 54), Color8(32, 42, 68)],    "short": "TFC", "league": "USA", "type": "club"},
	"SAN DIEGO SC":   {"colors": [Color8(0, 193, 213), Color8(0, 0, 0)],       "short": "SDF", "league": "USA", "type": "club"},

	# --- SUUDİ LİGİ ---
	"HILAL SC":       {"colors": [Color8(0, 94, 184), Color8(255, 255, 255)],  "short": "HIL", "league": "SAUDI", "type": "club"},
	"NASSR SC":       {"colors": [Color8(254, 209, 65), Color8(0, 52, 120)],   "short": "NAS", "league": "SAUDI", "type": "club"},
	"AHLI SC":        {"colors": [Color8(0, 166, 81), Color8(255, 255, 255)],  "short": "AHL", "league": "SAUDI", "type": "club"},
	"ITTIHAD SC":     {"colors": [Color8(255, 215, 0), Color8(0, 0, 0)],       "short": "ITT", "league": "SAUDI", "type": "club"},
	"SHABAB SC":      {"colors": [Color8(255, 255, 255), Color8(0, 0, 0)],     "short": "SHA", "league": "SAUDI", "type": "club"},
	"TAAWOUN SC":     {"colors": [Color8(255, 215, 0), Color8(0, 51, 153)],    "short": "TAA", "league": "SAUDI", "type": "club"},
	"ETTIFAQ SC":     {"colors": [Color8(0, 128, 64), Color8(255, 255, 255)],  "short": "ETT", "league": "SAUDI", "type": "club"},
	"DAMAC SC":       {"colors": [Color8(255, 0, 0), Color8(255, 215, 0)],     "short": "DAM", "league": "SAUDI", "type": "club"},
	"FAYHA SC":       {"colors": [Color8(255, 165, 0), Color8(0, 0, 255)],     "short": "FAY", "league": "SAUDI", "type": "club"},
	"FATEH SC":       {"colors": [Color8(0, 100, 0), Color8(255, 255, 255)],   "short": "FAT", "league": "SAUDI", "type": "club"},
	"RIYADH SC":      {"colors": [Color8(255, 0, 0), Color8(0, 0, 0)],         "short": "RIY", "league": "SAUDI", "type": "club"},
	"WEHDA SC":       {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "WEH", "league": "SAUDI", "type": "club"},
	"KHALEEJ SC":     {"colors": [Color8(255, 255, 0), Color8(0, 128, 0)],     "short": "KHA", "league": "SAUDI", "type": "club"},
	"RAED SC":        {"colors": [Color8(255, 0, 0), Color8(0, 0, 0)],         "short": "RAE", "league": "SAUDI", "type": "club"},
	"QADSIAH SC":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 0)],     "short": "QAD", "league": "SAUDI", "type": "club"},
	"OKHDOOD SC":     {"colors": [Color8(0, 191, 255), Color8(255, 255, 255)], "short": "OKH", "league": "SAUDI", "type": "club"},
	"NEOM SC":        {"colors": [Color8(0, 0, 139), Color8(255, 215, 0)],     "short": "NEO", "league": "SAUDI", "type": "club"},
	"KHOLOOD SC":     {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "KHO", "league": "SAUDI", "type": "club"},

	# --- DÜNYA KULÜPLERİ ---
	"BRUGGE SC":      {"colors": [Color8(0, 0, 0), Color8(0, 116, 217)],       "short": "CLB", "league": "WORLD", "type": "club"},
	"KARABAĞ SC":     {"colors": [Color8(0, 0, 128), Color8(227, 141, 26)],    "short": "QFK", "league": "WORLD", "type": "club"},
	"OLYMPIAKOS SC":  {"colors": [Color8(255, 255, 255), Color8(221, 0, 0)],   "short": "OLY", "league": "WORLD", "type": "club"},
	"BODO SC":        {"colors": [Color8(255, 220, 0), Color8(0, 0, 0)],       "short": "BOD", "league": "WORLD", "type": "club"},
	"BENFICA SC":     {"colors": [Color8(232, 48, 48), Color8(255, 255, 255)], "short": "SLB", "league": "WORLD", "type": "club"},
	"SPORTING L.":    {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)],   "short": "SCP", "league": "WORLD", "type": "club"},
	"PORTO SC":       {"colors": [Color8(0, 0, 255), Color8(255, 255, 255)],   "short": "POR", "league": "WORLD", "type": "club"},
	"AJAX A.":        {"colors": [Color8(255, 255, 255), Color8(210, 18, 46)], "short": "AJX", "league": "WORLD", "type": "club"},
	"PSV E.":         {"colors": [Color8(255, 0, 0), Color8(255, 255, 255)],   "short": "PSV", "league": "WORLD", "type": "club"},
	"ROTTERDAM SC":   {"colors": [Color8(255, 255, 255), Color8(255, 0, 0)],   "short": "FEY", "league": "WORLD", "type": "club"},
	"ATINA Y.":       {"colors": [Color8(0, 123, 58), Color8(255, 255, 255)],  "short": "PAO", "league": "WORLD", "type": "club"},
	"V. PLZEN":       {"colors": [Color8(237, 27, 36), Color8(0, 77, 152)],    "short": "PLZ", "league": "WORLD", "type": "club"},
	"D. ZAGREB":      {"colors": [Color8(0, 51, 153), Color8(255, 255, 255)],  "short": "DZG", "league": "WORLD", "type": "club"},
	"GENK SC":        {"colors": [Color8(0, 71, 156), Color8(255, 255, 255)],  "short": "GNK", "league": "WORLD", "type": "club"},
	"BRANN SC":       {"colors": [Color8(226, 0, 26), Color8(255, 255, 255)],  "short": "BRA", "league": "WORLD", "type": "club"},
	"PAOK SC":        {"colors": [Color8(0, 0, 0), Color8(255, 255, 255)],     "short": "PAOK", "league": "WORLD", "type": "club"},
	"LUDOGORETS SC":  {"colors": [Color8(13, 104, 56), Color8(255, 255, 255)], "short": "LUD", "league": "WORLD", "type": "club"},
	"FERENCVAROS SC": {"colors": [Color8(28, 127, 55), Color8(255, 255, 255)], "short": "FER", "league": "WORLD", "type": "club"},
	"KIZILYILDIZ":    {"colors": [Color8(208, 16, 35), Color8(255, 255, 255)], "short": "CZV", "league": "WORLD", "type": "club"},
	"CELTIC SC":      {"colors": [Color8(0, 128, 0), Color8(255, 255, 255)],   "short": "CLT", "league": "WORLD", "type": "club"}
}

func _ready():
	for team_name in TEAMS:
		var short_name = TEAMS[team_name]["short"]
		
		# ASSET MAPPING LAYER (Copyright/DMCA protection)
		# Load generic logo based on team colors instead of official badges, preserving savegame keys.
		var generic_fallback = "res://generic_logo.png"
		var mapped_path = "res://assets/generic_" + short_name.to_lower() + ".png"
		
		if ResourceLoader.exists(mapped_path):
			TEAM_LOGOS[team_name] = load(mapped_path)
		elif ResourceLoader.exists("res://assets/" + short_name.to_lower() + ".png"):
			TEAM_LOGOS[team_name] = load("res://assets/" + short_name.to_lower() + ".png")
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
		elif ResourceLoader.exists(generic_fallback):
			TEAM_LOGOS[team_name] = load(generic_fallback)
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


const SAVE_SALT = "bol_gol_futbol_anti_cheat_salt_2026"
func generate_save_hash(data_str: String) -> String:
	return (data_str + SAVE_SALT).sha256_text()

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
		var json_str = JSON.stringify(data)
		var hash_val = generate_save_hash(json_str)
		var secure_data = {
			"payload": json_str,
			"signature": hash_val
		}
		file.store_string(JSON.stringify(secure_data))
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
			print("[Global] Corrupted progression.json detected.")
			DirAccess.copy_absolute("user://progression.json", "user://progression.json.corrupted")
			check_daily_reset()
			return
		
		var data_to_load = parsed
		if parsed.has("signature") and parsed.has("payload"):
			var expected = generate_save_hash(parsed["payload"])
			if expected != parsed["signature"]:
				print("[Global] SECURITY ERROR: Savegame tampering detected! Resetting ad_credits.")
				var tmp = JSON.parse_string(parsed["payload"])
				if typeof(tmp) == TYPE_DICTIONARY:
					tmp["ad_credits"] = 0
					parsed["payload"] = JSON.stringify(tmp)
			data_to_load = JSON.parse_string(parsed["payload"])
		
		parsed = data_to_load

func check_daily_reset():
	var today = Time.get_date_string_from_system()
	if daily_date != today or daily_quests.is_empty():
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

const QUEST_POOL = {
	"easy": [
		{
			"id": "easy_play_1",
			"type": "play_matches",
			"target": 1,
			"reward": 25,
			"desc": {
				"TR": "1 maç oyna",
				"ENG": "Play 1 match",
				"ESP": "Juega 1 partido",
				"POR": "Joga 1 partida",
				"ITA": "Gioca 1 partita"
			}
		},
		{
			"id": "easy_play_2",
			"type": "play_matches",
			"target": 2,
			"reward": 30,
			"desc": {
				"TR": "2 maç oyna",
				"ENG": "Play 2 matches",
				"ESP": "Juega 2 partidos",
				"POR": "Joga 2 partidas",
				"ITA": "Gioca 2 partite"
			}
		},
		{
			"id": "easy_wheel_spin",
			"type": "wheel_spin",
			"target": 1,
			"reward": 25,
			"desc": {
				"TR": "Şans çarkını 1 kez çevir",
				"ENG": "Spin the lucky wheel 1 time",
				"ESP": "Gira la ruleta de la suerte 1 vez",
				"POR": "Gira a roleta da sorte 1 vez",
				"ITA": "Gira la ruota della fortuna 1 volta"
			}
		},
		{
			"id": "easy_fav_goal",
			"type": "fav_goals",
			"target": 1,
			"reward": 30,
			"desc": {
				"TR": "{fav} ile 1 gol at",
				"ENG": "Score 1 goal with {fav}",
				"ESP": "Marca 1 gol con {fav}",
				"POR": "Marca 1 golo com {fav}",
				"ITA": "Segna 1 gol con {fav}"
			}
		},
		{
			"id": "easy_captain_goal",
			"type": "captain_goals",
			"target": 1,
			"reward": 30,
			"desc": {
				"TR": "Kaptan oyuncun ({captain}) ile 1 gol at",
				"ENG": "Score 1 goal with your captain ({captain})",
				"ESP": "Marca 1 gol con tu capitán ({captain})",
				"POR": "Marca 1 golo com o teu capitão ({captain})",
				"ITA": "Segna 1 gol con il tuo capitano ({captain})"
			}
		},
		{
			"id": "easy_win_1",
			"type": "win_match",
			"target": 1,
			"reward": 35,
			"desc": {
				"TR": "1 maç kazan",
				"ENG": "Win 1 match",
				"ESP": "Gana 1 partido",
				"POR": "Vence 1 partida",
				"ITA": "Vinci 1 partita"
			}
		},
		{
			"id": "easy_score_2",
			"type": "total_goals",
			"target": 2,
			"reward": 30,
			"desc": {
				"TR": "Toplam 2 gol at",
				"ENG": "Score 2 total goals",
				"ESP": "Marca 2 goles en total",
				"POR": "Marca 2 golos no total",
				"ITA": "Segna 2 gol in totale"
			}
		}
	],
	"medium": [
		{
			"id": "med_fav_win",
			"type": "fav_win",
			"target": 1,
			"reward": 45,
			"desc": {
				"TR": "{fav} ile 1 maç kazan",
				"ENG": "Win 1 match with {fav}",
				"ESP": "Gana 1 partido con {fav}",
				"POR": "Vence 1 partida com {fav}",
				"ITA": "Vinci 1 partita con {fav}"
			}
		},
		{
			"id": "med_captain_goals_2",
			"type": "captain_goals",
			"target": 2,
			"reward": 45,
			"desc": {
				"TR": "Kaptan oyuncun ({captain}) ile 2 gol at",
				"ENG": "Score 2 goals with your captain ({captain})",
				"ESP": "Marca 2 goles con tu capitán ({captain})",
				"POR": "Marca 2 golos com o teu capitão ({captain})",
				"ITA": "Segna 2 gol con il tuo capitano ({captain})"
			}
		},
		{
			"id": "med_win_margin_2",
			"type": "win_margin",
			"target": 2,
			"reward": 45,
			"desc": {
				"TR": "En az 2 farkla maç kazan",
				"ENG": "Win a match by at least 2 goals margin",
				"ESP": "Gana un partido por al menos 2 goles de diferencia",
				"POR": "Vence uma partida por pelo menos 2 golos de diferença",
				"ITA": "Vinci una partita con almeno 2 gol di scarto"
			}
		},
		{
			"id": "med_goals_in_match_3",
			"type": "goals_in_match",
			"target": 3,
			"reward": 40,
			"desc": {
				"TR": "Bir maçta 3 veya daha fazla gol at",
				"ENG": "Score 3 or more goals in a single match",
				"ESP": "Marca 3 o más goles en un solo partido",
				"POR": "Marca 3 ou mais golos numa única partida",
				"ITA": "Segna 3 o più gol in una singola partita"
			}
		},
		{
			"id": "med_fav_goals_3",
			"type": "fav_goals",
			"target": 3,
			"reward": 45,
			"desc": {
				"TR": "{fav} ile toplam 3 gol at",
				"ENG": "Score 3 total goals with {fav}",
				"ESP": "Marca 3 goles en total con {fav}",
				"POR": "Marca 3 golos no total com {fav}",
				"ITA": "Segna 3 gol in totale con {fav}"
			}
		},
		{
			"id": "med_clean_sheet",
			"type": "clean_sheet",
			"target": 1,
			"reward": 50,
			"desc": {
				"TR": "Gol yemeden maç kazan (Kalesini Koru)",
				"ENG": "Win a match without conceding (Clean Sheet)",
				"ESP": "Gana un partido sin recibir goles (Valla Invicta)",
				"POR": "Vence uma partida sem sofrer golos (Sem Sofrer Golos)",
				"ITA": "Vinci una partita senza subire gol (Porta Inviolata)"
			}
		},
		{
			"id": "med_win_2",
			"type": "win_match",
			"target": 2,
			"reward": 50,
			"desc": {
				"TR": "2 maç kazan",
				"ENG": "Win 2 matches",
				"ESP": "Gana 2 partidos",
				"POR": "Vence 2 partidas",
				"ITA": "Vinci 2 partite"
			}
		}
	],
	"hard": [
		{
			"id": "hard_comeback_win",
			"type": "comeback_win",
			"target": 1,
			"reward": 65,
			"desc": {
				"TR": "Favori takımınla geriye düştüğün maçı çevir ve kazan (Geri Dönüş)",
				"ENG": "Win a match with your favorite team after trailing behind (Comeback)",
				"ESP": "Remonta y gana un partido con tu equipo favorito tras ir perdiendo",
				"POR": "Vira o jogo e vence com a tua equipa favorita após estar a perder",
				"ITA": "Rimonta e vinci una partita con la tua squadra preferita dopo essere andato sotto"
			}
		},
		{
			"id": "hard_goals_in_match_4",
			"type": "goals_in_match",
			"target": 4,
			"reward": 60,
			"desc": {
				"TR": "Bir maçta 4 veya daha fazla gol at",
				"ENG": "Score 4 or more goals in a single match",
				"ESP": "Marca 4 o más goles en un solo partido",
				"POR": "Marca 4 ou mais golos numa única partida",
				"ITA": "Segna 4 o più gol in una singola partita"
			}
		},
		{
			"id": "hard_goals_in_match_5",
			"type": "goals_in_match",
			"target": 5,
			"reward": 75,
			"desc": {
				"TR": "Bir maçta 5 veya daha fazla gol at (Gol Yağmuru)",
				"ENG": "Score 5 or more goals in a single match (Goal Rain)",
				"ESP": "Marca 5 o más goles en un solo partido (Lluvia de Goles)",
				"POR": "Marca 5 ou mais golos numa única partida (Chuva de Golos)",
				"ITA": "Segna 5 o più gol in una singola partita (Pioggia di Gol)"
			}
		},
		{
			"id": "hard_captain_hat_trick",
			"type": "captain_goals",
			"target": 3,
			"reward": 70,
			"desc": {
				"TR": "Kaptan oyuncun ({captain}) ile 3 gol at (Hat-Trick)",
				"ENG": "Score a hat-trick (3 goals) with your captain ({captain})",
				"ESP": "Marca un hat-trick (3 goles) con tu capitán ({captain})",
				"POR": "Marca um hat-trick (3 golos) com o teu capitão ({captain})",
				"ITA": "Segna una tripletta (3 gol) con il tuo capitano ({captain})"
			}
		},
		{
			"id": "hard_win_margin_3",
			"type": "win_margin",
			"target": 3,
			"reward": 70,
			"desc": {
				"TR": "En az 3 farkla maç kazan (Ezici Galibiyet)",
				"ENG": "Win a match by at least 3 goals margin (Dominant Win)",
				"ESP": "Gana un partido por al menos 3 goles de diferencia",
				"POR": "Vence uma partida por pelo menos 3 golos de diferença",
				"ITA": "Vinci una partita con almeno 3 gol di scarto"
			}
		},
		{
			"id": "hard_clean_sheet_margin_2",
			"type": "clean_sheet_margin",
			"target": 2,
			"reward": 65,
			"desc": {
				"TR": "Gol yemeden en az 2 farkla maç kazan",
				"ENG": "Win by at least 2 goals with a clean sheet",
				"ESP": "Gana por al menos 2 goles y con la valla invicta",
				"POR": "Vence por pelo menos 2 golos sem sofrer golos",
				"ITA": "Vinci con almeno 2 gol di scarto senza subire gol"
			}
		},
		{
			"id": "hard_fav_win_2",
			"type": "fav_win",
			"target": 2,
			"reward": 75,
			"desc": {
				"TR": "{fav} ile 2 maç kazan",
				"ENG": "Win 2 matches with {fav}",
				"ESP": "Gana 2 partidos con {fav}",
				"POR": "Vence 2 partidas com {fav}",
				"ITA": "Vinci 2 partite con {fav}"
			}
		}
	]
}

func generate_daily_quests():
	var fav = favorite_team if favorite_team != "" else home_team_name
	if fav == "":
		fav = "GALATA FK"
	var captain = get_active_custom_player_name()

	var easy_pool = QUEST_POOL.get("easy", [])
	var med_pool = QUEST_POOL.get("medium", [])
	var hard_pool = QUEST_POOL.get("hard", [])

	var selected_easy = easy_pool[randi() % easy_pool.size()] if easy_pool.size() > 0 else {}
	var selected_med = med_pool[randi() % med_pool.size()] if med_pool.size() > 0 else {}
	var selected_hard = hard_pool[randi() % hard_pool.size()] if hard_pool.size() > 0 else {}

	daily_quests = []

	for raw_template in [selected_easy, selected_med, selected_hard]:
		if raw_template.is_empty():
			continue
		var q = raw_template.duplicate(true)
		q["progress"] = 0
		q["claimed"] = false

		# Format dynamic placeholders in all languages
		var formatted_desc = {}
		var desc_dict = q.get("desc", {})
		for lang_key in desc_dict:
			var s = String(desc_dict[lang_key])
			s = s.replace("{fav}", fav)
			s = s.replace("{captain}", captain)
			s = s.replace("{target}", str(q.get("target", 1)))
			formatted_desc[lang_key] = s
		q["desc"] = formatted_desc

		daily_quests.append(q)

func record_match_result(home: String, away: String, home_score: int, away_score: int, match_data: Dictionary = {}):
	check_daily_reset()
	var fav = favorite_team if favorite_team != "" else home_team_name
	
	var is_fav_home = (home == fav)
	var is_fav_away = (away == fav)
	
	var fav_score = 0
	var opp_score = 0
	var fav_won = false
	var is_player_home = true
	
	if is_fav_home:
		fav_score = home_score
		opp_score = away_score
		fav_won = (home_score > away_score)
		is_player_home = true
	elif is_fav_away:
		fav_score = away_score
		opp_score = home_score
		fav_won = (away_score > home_score)
		is_player_home = false
	else:
		# Player was home team by default
		fav_score = home_score
		opp_score = away_score
		fav_won = (home_score > away_score)
		is_player_home = true
	
	var player_score = fav_score
	var player_won = fav_won
	var goal_margin = player_score - opp_score
	var clean_sheet = (player_won and opp_score == 0)
	
	# Determine Comeback status
	var is_comeback = false
	if match_data.has("is_comeback"):
		is_comeback = bool(match_data["is_comeback"])
	elif match_data.has("team1_trailed") or match_data.has("team2_trailed"):
		var trailed = match_data.get("team1_trailed", false) if is_player_home else match_data.get("team2_trailed", false)
		is_comeback = player_won and bool(trailed)
	
	# Captain goals scored (defaults to player_score if not explicitly specified)
	var captain_goals_scored = int(match_data.get("captain_goals", player_score))
	
	# Update Leaderboard goals
	if fav_score > 0:
		favorite_team_goals_scored += fav_score
	
	# Update Daily Quests
	for q in daily_quests:
		if q.get("claimed", false):
			continue
		var q_type = q.get("type", "")
		var cur_p = int(q.get("progress", 0))
		var tgt = int(q.get("target", 1))
		
		match q_type:
			"play_matches":
				q["progress"] = min(tgt, cur_p + 1)
			"win_match":
				if player_won:
					q["progress"] = min(tgt, cur_p + 1)
			"fav_win":
				if fav_won:
					q["progress"] = min(tgt, cur_p + 1)
			"fav_goals":
				if fav_score > 0:
					q["progress"] = min(tgt, cur_p + fav_score)
			"total_goals":
				if player_score > 0:
					q["progress"] = min(tgt, cur_p + player_score)
			"captain_goals", "player_goals":
				if captain_goals_scored > 0:
					q["progress"] = min(tgt, cur_p + captain_goals_scored)
			"clean_sheet":
				if clean_sheet:
					q["progress"] = min(tgt, cur_p + 1)
			"comeback_win":
				if is_comeback:
					q["progress"] = min(tgt, cur_p + 1)
			"goals_in_match":
				if player_score >= tgt:
					q["progress"] = tgt
				else:
					q["progress"] = max(cur_p, player_score)
			"win_margin":
				if player_won and goal_margin >= tgt:
					q["progress"] = tgt
				elif player_won:
					q["progress"] = max(cur_p, goal_margin)
			"clean_sheet_margin":
				if clean_sheet and goal_margin >= tgt:
					q["progress"] = tgt
				elif clean_sheet:
					q["progress"] = max(cur_p, goal_margin)
					
	save_progression()

func record_quest_wheel_spin():
	for q in daily_quests:
		if q.get("claimed", false):
			continue
		if q.get("type", "") == "wheel_spin":
			var tgt = int(q.get("target", 1))
			q["progress"] = min(tgt, int(q.get("progress", 0)) + 1)
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
	{"coins": 10,  "weight": 150, "color": Color8(20, 35, 55)},   # Deep Navy
	{"coins": 20,  "weight": 200, "color": Color8(30, 55, 85)},   # Dark Blue
	{"coins": 30,  "weight": 175, "color": Color8(45, 110, 140)}, # Cyan-ish
	{"coins": 50,  "weight": 200, "color": Color8(34, 160, 75)},  # Solid Green
	{"coins": 100, "weight": 150, "color": Color8(50, 225, 110)}, # Neon Green
	{"coins": 200, "weight": 50,  "color": Color8(255, 145, 0)},  # Neon Orange
	{"coins": 300, "weight": 50,  "color": Color8(255, 65, 80)},  # Neon Red
	{"coins": 500, "weight": 25,  "color": Color8(255, 215, 0)}   # Gold Jackpot
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
	record_quest_wheel_spin()
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
