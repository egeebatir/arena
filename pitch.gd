extends Node2D

const ARENA_RADIUS = 264.0
var CENTER = Vector2.ZERO
const GOAL_WIDTH_RADIANS = 0.5
const POST_RADIUS = 4.8
const GOAL_DEPTH = 70
const INWARD_OFFSET = 30 
const ELASTICITY = 1.01 

var s1_lbl: Label
var s2_lbl: Label
var time_lbl: Label
var event_lbl: Label
var event_timer: float = 0.0
var screen_shake_timer: int = 0
var goal_cooldown_timer: float = 0.0
var intro_overlay: ColorRect
var stadium_player: AudioStreamPlayer
var game_camera: Camera2D

var goal_banner_panel: PanelContainer
var goal_banner_lbl: Label
var goal_banner_timer: float = 0.0

var abandon_btn: Button
var pause_btn: Button # YENI DURDURMA BUTONU
var is_paused: bool = false # DURUM DEĞIŞKENI

var restart_btn: Button
var main_ui_layer: CanvasLayer
var match_banner_ad_id: String = ""

var t1_yellow_box: Control
var t1_red_box: Control
var t2_red_box: Control
var t2_yellow_box: Control

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		Global.play_click()
		_toggle_pause()

const FPS_TARGET = 60
var FRAMES_PER_SIM_MINUTE = 16.0

var state = "INTRO"
var frame_counter = 0
var sim_minute = 0
var score1 = 0
var score2 = 0
var goal_angle = PI / 2.0
var goal_rotating = false
var goal_rot_speed = 0.02

var added_time_1 = 0
var added_time_2 = 0
var display_added_time = false
var halftime_timer = 0
var start_delay_timer = 0
var end_match_timer = 0
var intro_timer = 0

var team1_trailed: bool = false
var team2_trailed: bool = false

var active_cards = []
var red_cards_1 = 0
var red_cards_2 = 0
var yellow_cards_1 = 0
var yellow_cards_2 = 0
var red_card_spawned_this_half = false
var yellow_cards_spawned_this_half = 0
var target_yellow_cards = 0

var particles = []
var active_theme: Dictionary

var cream = Color.WHITE
var white = Color.WHITE
var net_color = Color8(200, 200, 200)

class StaticPitch extends Node2D:
	var theme_dict: Dictionary
	var scream: Color
	var swhite: Color
	
	func _draw():
		# Base pitch circle
		draw_circle(Vector2.ZERO, 264.0, theme_dict.pitch_1)
		
		# Classic 60px alternating turf stripes
		for y in range(-264, 264):
			if int(y + 264) % 60 < 30:
				var x = sqrt(max(0.0, 264.0 * 264.0 - float(y * y)))
				draw_line(Vector2(-x, float(y)), Vector2(x, float(y)), theme_dict.pitch_2, 1.0)
				
		# Boundary ring
		draw_arc(Vector2.ZERO, 264.0, 0, TAU, 128, scream, 5.0, true)
		
		# Center halfway line
		var line_len = 264.0 - 4.0
		draw_line(Vector2(-line_len, 0), Vector2(line_len, 0), swhite, 3.5, true)
		
		# Center circle
		draw_arc(Vector2.ZERO, 65, 0, TAU, 64, swhite, 3.5, true)
		
		# Center kick-off spot
		draw_circle(Vector2.ZERO, 5.0, swhite)

var static_pitch_node: StaticPitch

@onready var ball1 = $Ball1
@onready var ball2 = $Ball2

func _ready():
	Engine.time_scale = 1.0 # Remove raw time_scale speedup/slowdown 
	Global.preload_interstitial_ad()
	if is_instance_valid(Global.bg_music_player) and Global.bg_music_player.playing:
		Global.bg_music_player.stop()
	
	# Determine logical frame count per sim minute (90 min match)
	if Global.match_duration == 0:
		FRAMES_PER_SIM_MINUTE = 720.0 / 45.0 # 24s total = 12s per half. 12s * 60 FPS = 720
	elif Global.match_duration == 1:
		FRAMES_PER_SIM_MINUTE = 1080.0 / 45.0 # 36s total = 18s per half. 18s * 60 FPS = 1080
	else:
		FRAMES_PER_SIM_MINUTE = 1440.0 / 45.0 # 48s total = 24s per half. 24s * 60 FPS = 1440
		
	active_theme = Global.THEMES.get(Global.current_theme, Global.THEMES["Turkuaz"])
	
	var bg_layer = CanvasLayer.new()
	bg_layer.layer = -1 
	add_child(bg_layer)
	
	var bg_rect = TextureRect.new()
	var grad = Gradient.new()
	grad.set_color(0, active_theme.bg_top) 
	grad.set_color(1, active_theme.bg_bottom)
	
	var grad_tex = GradientTexture2D.new()
	grad_tex.gradient = grad
	grad_tex.fill_from = Vector2(0, 0)
	grad_tex.fill_to = Vector2(0, 1)
	grad_tex.width = 64
	grad_tex.height = 64
	
	bg_rect.texture = grad_tex
	bg_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg_layer.add_child(bg_rect)
	
	var screen_size = get_viewport_rect().size
	call_deferred("_init_center")
	
	static_pitch_node = StaticPitch.new()
	static_pitch_node.theme_dict = active_theme
	static_pitch_node.scream = cream
	static_pitch_node.swhite = white
	static_pitch_node.position = CENTER
	static_pitch_node.z_index = -1
	add_child(static_pitch_node)
	static_pitch_node.queue_redraw()
	
	added_time_1 = _generate_added_time_1()
	added_time_2 = _generate_added_time_2()
	target_yellow_cards = randi_range(1, 3)
	
	intro_timer = int(1.0 * FPS_TARGET)
	
	stadium_player = AudioStreamPlayer.new()
	stadium_player.stream = preload("res://bol gol stadyum ses 2.mp3")
	if stadium_player.stream is AudioStreamMP3:
		stadium_player.stream.loop = true
	add_child(stadium_player)
	
	game_camera = Camera2D.new()
	add_child(game_camera)
	
	var target_vol = Global.master_vol * Global.vol_settings.get("stadium", 0.2) * 1.07
	if target_vol <= 0.01:
		stadium_player.volume_db = -80.0
	else:
		stadium_player.volume_db = linear_to_db(target_vol)

	ball1.init_ball(Global.home_team_name, CENTER, ARENA_RADIUS)
	ball2.init_ball(Global.away_team_name, CENTER, ARENA_RADIUS, ball1.position)
	var themes_list = Global.THEMES.keys()
	var random_theme = themes_list[randi() % themes_list.size()]
	Global.active_theme = Global.THEMES[random_theme]
	setup_scoreboard()
	
	Global.remove_all_banners()
	if not Global.is_premium:
		_request_match_bottom_banner()

var match_banner_retry_count: int = 0

func _get_match_banner_ad_unit(admob_node: Node) -> String:
	if admob_node:
		if not admob_node.is_real:
			if OS.has_feature("ios"):
				if admob_node.ios_debug_banner_id != "":
					return admob_node.ios_debug_banner_id
				return "ca-app-pub-3940256099942544/2934735716"
			else:
				if admob_node.android_debug_banner_id != "":
					return admob_node.android_debug_banner_id
				return "ca-app-pub-3940256099942544/2014213617"
		else:
			if admob_node.android_real_banner_id != "":
				return admob_node.android_real_banner_id
			return "ca-app-pub-7323450546679743/4717442614"
	return "ca-app-pub-7323450546679743/4717442614"

func _request_match_bottom_banner():
	if Global.is_premium: return
	var admob_node = Global.get_admob()
	if not admob_node: return
	
	match_banner_retry_count = 0
	
	# Admob.gd defines is_initialization_completed as a boolean property, not a method
	var is_inited = admob_node.get("is_initialization_completed") == true
	if not is_inited:
		if not admob_node.is_connected("initialization_completed", Callable(self, "_on_admob_ready_for_banner")):
			admob_node.connect("initialization_completed", Callable(self, "_on_admob_ready_for_banner"), CONNECT_ONE_SHOT)
		return

	await get_tree().create_timer(0.3).timeout
	if not is_inside_tree() or Global.is_premium: return

	if admob_node.has_signal("banner_ad_loaded"):
		for conn in admob_node.get_signal_connection_list("banner_ad_loaded"):
			var target = conn.get("callable", null)
			if target and not is_instance_valid(target.get_object()):
				admob_node.disconnect("banner_ad_loaded", target)
		if not admob_node.is_connected("banner_ad_loaded", Callable(self, "_on_banner_ad_loaded")):
			admob_node.connect("banner_ad_loaded", Callable(self, "_on_banner_ad_loaded"))

	if admob_node.has_signal("banner_ad_failed_to_load"):
		for conn in admob_node.get_signal_connection_list("banner_ad_failed_to_load"):
			var target = conn.get("callable", null)
			if target and not is_instance_valid(target.get_object()):
				admob_node.disconnect("banner_ad_failed_to_load", target)
		if not admob_node.is_connected("banner_ad_failed_to_load", Callable(self, "_on_banner_ad_failed_to_load")):
			admob_node.connect("banner_ad_failed_to_load", Callable(self, "_on_banner_ad_failed_to_load"))

	var ad_unit = _get_match_banner_ad_unit(admob_node)
	if admob_node.has_method("set_banner_position"):
		admob_node.set_banner_position(LoadAdRequest.AdPosition.BOTTOM)
	if admob_node.has_method("set_banner_size"):
		admob_node.set_banner_size(LoadAdRequest.RequestedAdSize.BANNER)
	if admob_node.has_method("set_banner_collapsible_position"):
		admob_node.set_banner_collapsible_position(LoadAdRequest.CollapsiblePosition.DISABLED)
	if admob_node.has_method("set_banner_anchor_to_safe_area"):
		admob_node.set_banner_anchor_to_safe_area(true)
	
	if admob_node.has_method("create_banner_ad_request") and admob_node.has_method("load_banner_ad"):
		var req = admob_node.create_banner_ad_request()
		req.set_ad_unit_id(ad_unit)
		req.set_ad_position(LoadAdRequest.AdPosition.BOTTOM)
		req.set_ad_size(LoadAdRequest.RequestedAdSize.BANNER)
		if req.has_method("set_collapsible_position"):
			req.set_collapsible_position(LoadAdRequest.CollapsiblePosition.DISABLED)
		if req.has_method("set_anchor_to_safe_area"):
			req.set_anchor_to_safe_area(true)
		admob_node.load_banner_ad(req)
	elif admob_node.has_method("show_banner_ad"):
		admob_node.show_banner_ad()

func _on_admob_ready_for_banner(_status = null):
	if is_inside_tree() and not Global.is_premium:
		_request_match_bottom_banner()

func _on_banner_ad_loaded(ad_info, _response_info = null):
	if not is_inside_tree() or Global.is_premium: return
	var admob_node = Global.get_admob()
	match_banner_retry_count = 0
	if admob_node and ad_info:
		match_banner_ad_id = ad_info.get_ad_id()
		if admob_node.has_method("show_banner_ad"):
			admob_node.show_banner_ad(match_banner_ad_id)
		print("[Pitch] Match bottom banner loaded & shown: ", match_banner_ad_id)

func _on_banner_ad_failed_to_load(ad_info, error_data):
	var err_code = error_data.get_code() if error_data and error_data.has_method("get_code") else -1
	var err_msg = error_data.get_message() if error_data and error_data.has_method("get_message") else ""
	print("[Pitch] Match bottom banner failed to load. Code: ", err_code, " Msg: ", err_msg)
	if not is_inside_tree() or Global.is_premium: return
	
	match_banner_retry_count += 1
	var delay = min(20.0 + float(match_banner_retry_count * 15), 60.0)
	print("[Pitch] Scheduling match banner retry #", match_banner_retry_count, " in ", delay, " seconds...")
	await get_tree().create_timer(delay).timeout
	if not is_inside_tree() or Global.is_premium or match_banner_ad_id != "": return
	
	var admob_node = Global.get_admob()
	if admob_node and admob_node.has_method("create_banner_ad_request") and admob_node.has_method("load_banner_ad"):
		var ad_unit = _get_match_banner_ad_unit(admob_node)
		var req = admob_node.create_banner_ad_request()
		req.set_ad_unit_id(ad_unit)
		req.set_ad_position(LoadAdRequest.AdPosition.BOTTOM)
		req.set_ad_size(LoadAdRequest.RequestedAdSize.BANNER)
		if req.has_method("set_collapsible_position"):
			req.set_collapsible_position(LoadAdRequest.CollapsiblePosition.DISABLED)
		if req.has_method("set_anchor_to_safe_area"):
			req.set_anchor_to_safe_area(true)
		admob_node.load_banner_ad(req)

func _clean_match_banner():
	var admob_node = Global.get_admob()
	if admob_node:
		if admob_node.is_connected("banner_ad_loaded", Callable(self, "_on_banner_ad_loaded")):
			admob_node.disconnect("banner_ad_loaded", Callable(self, "_on_banner_ad_loaded"))
		if admob_node.is_connected("banner_ad_failed_to_load", Callable(self, "_on_banner_ad_failed_to_load")):
			admob_node.disconnect("banner_ad_failed_to_load", Callable(self, "_on_banner_ad_failed_to_load"))
		Global.remove_all_banners()
		match_banner_ad_id = ""
		if admob_node.has_method("set_banner_position"):
			admob_node.set_banner_position(LoadAdRequest.AdPosition.TOP)
		if admob_node.has_method("set_banner_size"):
			admob_node.set_banner_size(LoadAdRequest.RequestedAdSize.BANNER)
		if "banner_anchor_to_safe_area" in admob_node:
			admob_node.banner_anchor_to_safe_area = false

func _exit_tree():
	_clean_match_banner()

func get_readable_outline(c: Color) -> Color:
	var lum = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b
	return Color.BLACK if lum > 0.5 else Color.WHITE

func setup_scoreboard():
	var custom_font = preload("res://Teko-Bold.ttf")
	var ui_layer = CanvasLayer.new()
	main_ui_layer = ui_layer
	add_child(ui_layer)
	
	var score_margin = MarginContainer.new()
	score_margin.set_anchors_preset(Control.PRESET_TOP_WIDE)
	score_margin.add_theme_constant_override("margin_top", 140.0)
	score_margin.add_theme_constant_override("margin_left", 8.0)
	score_margin.add_theme_constant_override("margin_right", 8.0)
	ui_layer.add_child(score_margin)
	
	var center_cont = VBoxContainer.new()
	center_cont.alignment = BoxContainer.ALIGNMENT_CENTER
	center_cont.add_theme_constant_override("separation", -2)
	score_margin.add_child(center_cont)
	
	var top_panel = PanelContainer.new()
	top_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.08, 0.12, 0.85)
	style.corner_radius_top_left = 32; style.corner_radius_top_right = 32
	style.corner_radius_bottom_left = 32; style.corner_radius_bottom_right = 32
	style.border_width_left = 2; style.border_width_right = 2
	style.border_width_top = 2; style.border_width_bottom = 4
	style.border_color = Color(1.0, 1.0, 1.0, 0.15)
	style.content_margin_left = 40; style.content_margin_right = 40
	style.content_margin_top = 10; style.content_margin_bottom = 14
	top_panel.add_theme_stylebox_override("panel", style)
	center_cont.add_child(top_panel)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	top_panel.add_child(main_vbox)
	
	var score_hbox = HBoxContainer.new()
	score_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	score_hbox.add_theme_constant_override("separation", 20)
	main_vbox.add_child(score_hbox)
	
	t1_yellow_box = Control.new()
	score_hbox.add_child(t1_yellow_box)
	
	var c1 = ball1.team_colors[0]
	var lum1 = c1.get_luminance()
	var t1_col = c1.lightened(0.35) if lum1 < 0.3 else (c1.darkened(0.2) if lum1 > 0.85 else c1)
	var t1_outline = Color.BLACK if lum1 > 0.45 else Color.WHITE
	
	var t1 = Label.new()
	t1.text = ball1.team_short_name
	t1.add_theme_font_override("font", custom_font)
	t1.add_theme_font_size_override("font_size", 46)
	t1.add_theme_color_override("font_color", t1_col)
	t1.add_theme_color_override("font_outline_color", t1_outline)
	t1.add_theme_font_size_override("font_size", 42)
	t1.add_theme_constant_override("outline_size", 4)
	t1.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	t1.add_theme_constant_override("shadow_offset_y", 2)
	score_hbox.add_child(t1)
	
	t1_red_box = Control.new()
	score_hbox.add_child(t1_red_box)
	
	s1_lbl = Label.new()
	s1_lbl.add_theme_font_override("font", custom_font)
	s1_lbl.add_theme_font_size_override("font_size", 54)
	s1_lbl.add_theme_color_override("font_color", t1_col)
	s1_lbl.add_theme_color_override("font_outline_color", t1_outline)
	s1_lbl.add_theme_font_size_override("font_size", 54)
	s1_lbl.add_theme_constant_override("outline_size", 4)
	s1_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	s1_lbl.add_theme_constant_override("shadow_offset_y", 2)
	score_hbox.add_child(s1_lbl)
	
	var dash = Label.new()
	dash.text = "-"
	dash.add_theme_font_override("font", custom_font)
	dash.add_theme_font_size_override("font_size", 54)
	dash.add_theme_font_size_override("font_size", 48)
	dash.add_theme_color_override("font_color", Color(1, 1, 1, 0.7))
	dash.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	dash.add_theme_constant_override("shadow_offset_y", 2)
	score_hbox.add_child(dash)
	
	var c2 = ball2.team_colors[0]
	var lum2 = c2.get_luminance()
	var t2_col = c2.lightened(0.35) if lum2 < 0.3 else (c2.darkened(0.2) if lum2 > 0.85 else c2)
	var t2_outline = Color.BLACK if lum2 > 0.45 else Color.WHITE
	
	s2_lbl = Label.new()
	s2_lbl.add_theme_font_override("font", custom_font)
	s2_lbl.add_theme_font_size_override("font_size", 54)
	s2_lbl.add_theme_color_override("font_color", t2_col)
	s2_lbl.add_theme_color_override("font_outline_color", t2_outline)
	s2_lbl.add_theme_font_size_override("font_size", 54)
	s2_lbl.add_theme_constant_override("outline_size", 4)
	s2_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	s2_lbl.add_theme_constant_override("shadow_offset_y", 2)
	score_hbox.add_child(s2_lbl)
	
	t2_red_box = Control.new()
	score_hbox.add_child(t2_red_box)
	
	var t2 = Label.new()
	t2.text = ball2.team_short_name
	t2.add_theme_font_override("font", custom_font)
	t2.add_theme_font_size_override("font_size", 46)
	t2.add_theme_color_override("font_color", t2_col)
	t2.add_theme_color_override("font_outline_color", t2_outline)
	t2.add_theme_font_size_override("font_size", 42)
	t2.add_theme_constant_override("outline_size", 4)
	t2.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	t2.add_theme_constant_override("shadow_offset_y", 2)
	score_hbox.add_child(t2)
	
	t2_yellow_box = Control.new()
	score_hbox.add_child(t2_yellow_box)
	
	time_lbl = Label.new()
	time_lbl.add_theme_font_override("font", custom_font)
	time_lbl.add_theme_font_size_override("font_size", 30)
	time_lbl.add_theme_color_override("font_color", Color(1, 1, 1, 0.85))
	time_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	time_lbl.add_theme_constant_override("shadow_offset_y", 2)
	time_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(time_lbl)
	
	var banner_margin = MarginContainer.new()
	banner_margin.add_theme_constant_override("margin_top", -10)
	
	goal_banner_panel = PanelContainer.new()
	goal_banner_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var g_style = StyleBoxFlat.new()
	g_style.bg_color = active_theme.bg_bottom
	g_style.corner_radius_bottom_left = 14; g_style.corner_radius_bottom_right = 14
	g_style.border_width_left = 1; g_style.border_width_right = 1; g_style.border_width_bottom = 1
	g_style.border_color = Color(1, 1, 1, 0.2)
	g_style.content_margin_left = 24; g_style.content_margin_right = 24
	g_style.content_margin_top = 6; g_style.content_margin_bottom = 6
	goal_banner_panel.add_theme_stylebox_override("panel", g_style)
	
	goal_banner_lbl = Label.new()
	goal_banner_lbl.add_theme_font_override("font", custom_font)
	goal_banner_lbl.add_theme_font_size_override("font_size", 28)
	goal_banner_lbl.add_theme_color_override("font_color", Color8(255, 230, 100))
	goal_banner_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	goal_banner_lbl.add_theme_constant_override("shadow_offset_y", 2)
	goal_banner_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	goal_banner_panel.add_child(goal_banner_lbl)
	
	goal_banner_panel.modulate.a = 0.0
	banner_margin.add_child(goal_banner_panel)
	center_cont.add_child(banner_margin)
	
	event_lbl = Label.new()
	event_lbl.add_theme_font_override("font", custom_font)
	event_lbl.add_theme_font_size_override("font_size", 125)
	event_lbl.add_theme_color_override("font_color", Color.WHITE)
	event_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 230))
	event_lbl.add_theme_constant_override("shadow_offset_y", 6)
	event_lbl.add_theme_constant_override("shadow_offset_x", 0)
	event_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	event_lbl.add_theme_constant_override("outline_size", 8)
	event_lbl.custom_minimum_size = Vector2(600, 160)
	event_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	event_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	event_lbl.set_anchors_preset(Control.PRESET_CENTER)
	event_lbl.grow_horizontal = Control.GROW_DIRECTION_BOTH 
	event_lbl.grow_vertical = Control.GROW_DIRECTION_BOTH
	event_lbl.pivot_offset = Vector2(300, 80)
	event_lbl.modulate.a = 0.0
	ui_layer.add_child(event_lbl)
	
	intro_overlay = ColorRect.new()
	intro_overlay.color = Color8(0, 0, 0, 255)
	intro_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_layer.add_child(intro_overlay)
	
	var intro_vbox = VBoxContainer.new()
	intro_vbox.set_anchors_preset(Control.PRESET_CENTER)
	intro_vbox.grow_horizontal = Control.GROW_DIRECTION_BOTH 
	intro_vbox.grow_vertical = Control.GROW_DIRECTION_BOTH
	intro_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	intro_vbox.position.y -= 100.0 # Shift up to match arena
	intro_overlay.add_child(intro_vbox)
	
	var intro_t1 = Label.new()
	intro_t1.text = Global.home_team_name
	intro_t1.add_theme_font_override("font", custom_font)
	intro_t1.add_theme_font_size_override("font_size", 54)
	intro_t1.add_theme_color_override("font_color", ball1.team_colors[0])
	intro_t1.add_theme_color_override("font_outline_color", Color.WHITE)
	intro_t1.add_theme_font_size_override("font_size", 42)
	t1.add_theme_constant_override("outline_size", 4)
	intro_t1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_vbox.add_child(intro_t1)
	
	var intro_vs = Label.new()
	intro_vs.text = "VS"
	intro_vs.add_theme_font_override("font", custom_font)
	intro_vs.add_theme_font_size_override("font_size", 60)
	intro_vs.add_theme_color_override("font_color", Color.WHITE)
	intro_vs.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_vbox.add_child(intro_vs)
	
	var intro_t2 = Label.new()
	intro_t2.text = Global.away_team_name
	intro_t2.add_theme_font_override("font", custom_font)
	intro_t2.add_theme_font_size_override("font_size", 54)
	intro_t2.add_theme_color_override("font_color", ball2.team_colors[0])
	intro_t2.add_theme_color_override("font_outline_color", Color.WHITE)
	intro_t2.add_theme_font_size_override("font_size", 42)
	t2.add_theme_constant_override("outline_size", 4)
	intro_t2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_vbox.add_child(intro_t2)

	var top_ui_margin = MarginContainer.new()
	top_ui_margin.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_ui_margin.add_theme_constant_override("margin_top", 32)
	top_ui_margin.add_theme_constant_override("margin_left", 30)
	top_ui_margin.add_theme_constant_override("margin_right", 30)
	ui_layer.add_child(top_ui_margin)
	
	var top_ui_hbox = HBoxContainer.new()
	top_ui_hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	top_ui_margin.add_child(top_ui_hbox)
	
	# --- ÇIKIŞ BUTONU (Modernize & Standardize 72x72) ---
	abandon_btn = Button.new()
	abandon_btn.text = "<"
	abandon_btn.add_theme_font_override("font", custom_font)
	abandon_btn.add_theme_font_size_override("font_size", 42)
	abandon_btn.add_theme_color_override("font_color", Color.WHITE)
	var abnd_style = StyleBoxFlat.new()
	abnd_style.bg_color = active_theme.bg_bottom.darkened(0.2)
	abnd_style.corner_radius_top_left = 18; abnd_style.corner_radius_top_right = 18
	abnd_style.corner_radius_bottom_left = 18; abnd_style.corner_radius_bottom_right = 18
	abnd_style.border_width_left = 1.5; abnd_style.border_width_top = 1.5; abnd_style.border_width_right = 1.5
	abnd_style.border_width_bottom = 3.5; abnd_style.border_color = active_theme.accent.darkened(0.25)
	abnd_style.shadow_color = Color8(0, 0, 0, 120)
	abnd_style.shadow_size = 6
	abnd_style.shadow_offset = Vector2(0, 3)
	abnd_style.content_margin_left = 12; abnd_style.content_margin_right = 12
	abnd_style.content_margin_top = 8; abnd_style.content_margin_bottom = 8
	var abnd_hover = abnd_style.duplicate(); abnd_hover.bg_color = active_theme.bg_bottom.lightened(0.1)
	var abnd_pressed = abnd_style.duplicate(); abnd_pressed.border_width_bottom = 1.5; abnd_pressed.content_margin_top = 11
	abandon_btn.add_theme_stylebox_override("normal", abnd_style)
	abandon_btn.add_theme_stylebox_override("hover", abnd_hover)
	abandon_btn.add_theme_stylebox_override("pressed", abnd_pressed)
	abandon_btn.add_theme_stylebox_override("focus", abnd_style)
	abandon_btn.custom_minimum_size = Vector2(72, 72)
	abandon_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	abandon_btn.pressed.connect(func():
		Global.play_click()
		set_physics_process(false)
		set_process(false)
		Engine.time_scale = 1.0
		if is_instance_valid(ball1): ball1.velocity = Vector2.ZERO
		if is_instance_valid(ball2): ball2.velocity = Vector2.ZERO
		if state == "FULLTIME":
			Global.increment_matches_played()
		if is_instance_valid(stadium_player):
			stadium_player.stop()
		if is_instance_valid(Global.bg_music_player) and not Global.bg_music_player.playing:
			Global.bg_music_player.play()
		abandon_btn.disabled = true
		_clean_match_banner()
		if state == "FIRST_HALF" or state == "INTRO":
			get_tree().change_scene_to_file("res://main_menu.tscn")
		else:
			Global.show_interstitial_ad(func():
				Engine.time_scale = 1.0
				get_tree().change_scene_to_file("res://main_menu.tscn")
			)
	)
	top_ui_hbox.add_child(abandon_btn)
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_ui_hbox.add_child(spacer)
	
	# --- DURDURMA BUTONU (Modernize & Standardize 72x72) ---
	pause_btn = Button.new()
	pause_btn.text = ""
	pause_btn.icon = preload("res://pauseicon.svg")
	pause_btn.expand_icon = true
	pause_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_btn.add_theme_constant_override("icon_max_width", 38)
	var p_btn_style = StyleBoxFlat.new()
	p_btn_style.bg_color = active_theme.bg_bottom.darkened(0.2)
	p_btn_style.corner_radius_top_left = 18; p_btn_style.corner_radius_top_right = 18
	p_btn_style.corner_radius_bottom_left = 18; p_btn_style.corner_radius_bottom_right = 18
	p_btn_style.border_width_left = 1.5; p_btn_style.border_width_top = 1.5; p_btn_style.border_width_right = 1.5
	p_btn_style.border_width_bottom = 3.5; p_btn_style.border_color = active_theme.accent.darkened(0.25)
	p_btn_style.shadow_color = Color8(0, 0, 0, 120)
	p_btn_style.shadow_size = 6
	p_btn_style.shadow_offset = Vector2(0, 3)
	p_btn_style.content_margin_left = 12; p_btn_style.content_margin_right = 12
	p_btn_style.content_margin_top = 8; p_btn_style.content_margin_bottom = 8
	var p_btn_hover = p_btn_style.duplicate(); p_btn_hover.bg_color = active_theme.bg_bottom.lightened(0.1)
	var p_btn_pressed = p_btn_style.duplicate(); p_btn_pressed.border_width_bottom = 1.5; p_btn_pressed.content_margin_top = 11
	pause_btn.add_theme_stylebox_override("normal", p_btn_style)
	pause_btn.add_theme_stylebox_override("hover", p_btn_hover)
	pause_btn.add_theme_stylebox_override("pressed", p_btn_pressed)
	pause_btn.add_theme_stylebox_override("focus", p_btn_style)
	pause_btn.custom_minimum_size = Vector2(72, 72)
	pause_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	pause_btn.pressed.connect(func(): Global.play_click(); _toggle_pause())
	top_ui_hbox.add_child(pause_btn)

	# --- YENIDEN OYNA BUTONU (Enlarged 108x108 & Lowered) ---
	restart_btn = Button.new()
	restart_btn.text = ""
	restart_btn.icon = preload("res://replayicon.svg")
	restart_btn.expand_icon = true
	restart_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	restart_btn.add_theme_constant_override("icon_max_width", 54)
	restart_btn.add_theme_font_override("font", custom_font)
	restart_btn.add_theme_font_size_override("font_size", 44)
	restart_btn.add_theme_color_override("font_color", Color.WHITE)
	
	var rest_style = StyleBoxFlat.new()
	rest_style.bg_color = active_theme.accent
	rest_style.corner_radius_top_left = 28; rest_style.corner_radius_top_right = 28
	rest_style.corner_radius_bottom_left = 28; rest_style.corner_radius_bottom_right = 28
	rest_style.border_width_bottom = 6; rest_style.border_color = active_theme.accent.darkened(0.4)
	rest_style.shadow_color = Color8(0, 0, 0, 180)
	rest_style.shadow_size = 18
	rest_style.shadow_offset = Vector2(0, 5)
	rest_style.content_margin_top = 18; rest_style.content_margin_bottom = 18
	rest_style.content_margin_left = 22; rest_style.content_margin_right = 22
	var rest_hover = rest_style.duplicate(); rest_hover.bg_color = active_theme.accent.lightened(0.12)
	var rest_press = rest_style.duplicate(); rest_press.border_width_bottom = 0; rest_press.content_margin_top = 24
	restart_btn.add_theme_stylebox_override("normal", rest_style)
	restart_btn.add_theme_stylebox_override("hover", rest_hover)
	restart_btn.add_theme_stylebox_override("pressed", rest_press)
	restart_btn.add_theme_stylebox_override("focus", rest_style)
	
	restart_btn.custom_minimum_size = Vector2(108, 108)
	var screen_w = get_viewport_rect().size.x
	var screen_h = get_viewport_rect().size.y
	restart_btn.position = Vector2((screen_w - 108.0) / 2.0, (screen_h / 2.0) + ARENA_RADIUS + 24.0)
	
	restart_btn.visible = false
	restart_btn.pressed.connect(func(): Global.play_click(); _on_restart_pressed())
	ui_layer.add_child(restart_btn)

func _generate_added_time_1() -> int:
	var r = randf()
	if r < 0.20: return 0
	elif r < 0.40: return 1
	elif r < 0.80: return 2
	else: return 3

func _generate_added_time_2() -> int:
	var r = randf()
	if r < 0.10: return 0
	elif r < 0.20: return 1
	elif r < 0.30: return 2
	elif r < 0.40: return 3
	elif r < 0.60: return 4
	elif r < 0.80: return 5
	elif r < 0.90: return 6
	else: return 7


func _on_restart_pressed():
	# REPLAY CONFIRMATION POPUP WITH MODERN THEME HARMONIZATION
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.75)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	var confirm_panel = PanelContainer.new()
	var cp_style = StyleBoxFlat.new()
	cp_style.bg_color = active_theme.bg_bottom.darkened(0.15)
	cp_style.corner_radius_top_left = 22; cp_style.corner_radius_top_right = 22
	cp_style.corner_radius_bottom_left = 22; cp_style.corner_radius_bottom_right = 22
	cp_style.border_width_top = 3; cp_style.border_width_bottom = 5
	cp_style.border_width_left = 3; cp_style.border_width_right = 3
	cp_style.border_color = active_theme.accent
	cp_style.shadow_color = Color8(0, 0, 0, 200)
	cp_style.shadow_size = 35
	cp_style.content_margin_left = 30; cp_style.content_margin_right = 30
	cp_style.content_margin_top = 26; cp_style.content_margin_bottom = 26
	confirm_panel.add_theme_stylebox_override("panel", cp_style)
	confirm_panel.custom_minimum_size = Vector2(min(get_viewport_rect().size.x * 0.92, 620), 0)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.add_child(confirm_panel)
	overlay.add_child(center)
	
	if is_instance_valid(main_ui_layer):
		main_ui_layer.add_child(overlay)
	else:
		add_child(overlay)
	
	# Pop-in scale bounce animation
	confirm_panel.pivot_offset = Vector2(min(get_viewport_rect().size.x * 0.92, 620) / 2.0, 160.0)
	confirm_panel.scale = Vector2(0.85, 0.85)
	var tw = create_tween()
	tw.set_ease(Tween.EASE_OUT)
	tw.set_trans(Tween.TRANS_BACK)
	tw.tween_property(confirm_panel, "scale", Vector2.ONE, 0.26)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 24)
	confirm_panel.add_child(vbox)
	
	var custom_font = preload("res://Teko-Bold.ttf")
	
	# Replay Icon Header with accent halo
	var ic_rect = TextureRect.new()
	ic_rect.texture = preload("res://replayicon.svg")
	ic_rect.custom_minimum_size = Vector2(56, 56)
	ic_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ic_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	ic_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ic_rect.modulate = active_theme.accent
	vbox.add_child(ic_rect)
	
	var lbl = Label.new()
	var lang_dict = {
		"TR": "Aynı maçı tekrar oynatmak istediğinize emin misiniz?",
		"ENG": "Are you sure you want to replay the exact same match?",
		"ESP": "¿Estás seguro de que quieres volver a jugar el mismo partido?",
		"POR": "Tem certeza de que quer jogar a mesma partida?",
		"ITA": "Sei sicuro di voler rigiocare la stessa partita?"
	}
	var ask_str = lang_dict.get(Global.current_lang, lang_dict["TR"])
	
	lbl.text = ask_str
	lbl.add_theme_font_override("font", custom_font)
	lbl.add_theme_font_size_override("font_size", 34)
	lbl.add_theme_color_override("font_color", Color.WHITE)
	lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 180))
	lbl.add_theme_constant_override("shadow_offset_y", 2)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(lbl)
	
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 20)
	vbox.add_child(hbox)
	
	var no_btn = Button.new()
	var no_txt = "HAYIR"
	if Global.current_lang == "ENG": no_txt = "NO"
	elif Global.current_lang == "ESP": no_txt = "NO"
	elif Global.current_lang == "POR": no_txt = "NÃO"
	elif Global.current_lang == "ITA": no_txt = "NO"
	no_btn.text = no_txt
	no_btn.add_theme_font_override("font", custom_font)
	no_btn.add_theme_font_size_override("font_size", 30)
	no_btn.add_theme_color_override("font_color", Color8(220, 230, 245))
	var n_style = StyleBoxFlat.new()
	n_style.bg_color = active_theme.bg_top.lightened(0.12)
	n_style.corner_radius_top_left = 14; n_style.corner_radius_top_right = 14
	n_style.corner_radius_bottom_left = 14; n_style.corner_radius_bottom_right = 14
	n_style.border_width_bottom = 4; n_style.border_color = active_theme.bg_bottom.darkened(0.35)
	n_style.content_margin_top = 10; n_style.content_margin_bottom = 10
	n_style.content_margin_left = 24; n_style.content_margin_right = 24
	var n_hov = n_style.duplicate(); n_hov.bg_color = active_theme.bg_top.lightened(0.2)
	var n_press = n_style.duplicate(); n_press.border_width_bottom = 0; n_press.content_margin_top = 14
	no_btn.add_theme_stylebox_override("normal", n_style)
	no_btn.add_theme_stylebox_override("hover", n_hov)
	no_btn.add_theme_stylebox_override("pressed", n_press)
	no_btn.add_theme_stylebox_override("focus", n_style)
	no_btn.custom_minimum_size = Vector2(170, 58)
	no_btn.pressed.connect(func():
		Global.play_click()
		overlay.queue_free()
	)
	hbox.add_child(no_btn)
	
	var yes_btn = Button.new()
	var yes_txt = "EVET"
	if Global.current_lang == "ENG": yes_txt = "YES"
	elif Global.current_lang == "ESP": yes_txt = "SÍ"
	elif Global.current_lang == "POR": yes_txt = "SIM"
	elif Global.current_lang == "ITA": yes_txt = "SÌ"
	yes_btn.text = yes_txt
	yes_btn.add_theme_font_override("font", custom_font)
	yes_btn.add_theme_font_size_override("font_size", 30)
	yes_btn.add_theme_color_override("font_color", Color.WHITE)
	var y_style = StyleBoxFlat.new()
	y_style.bg_color = Color8(34, 197, 94)
	y_style.corner_radius_top_left = 14; y_style.corner_radius_top_right = 14
	y_style.corner_radius_bottom_left = 14; y_style.corner_radius_bottom_right = 14
	y_style.border_width_bottom = 4; y_style.border_color = Color8(20, 130, 60)
	y_style.content_margin_top = 10; y_style.content_margin_bottom = 10
	y_style.content_margin_left = 24; y_style.content_margin_right = 24
	var y_hov = y_style.duplicate(); y_hov.bg_color = Color8(45, 215, 110)
	var y_press = y_style.duplicate(); y_press.border_width_bottom = 0; y_press.content_margin_top = 14
	yes_btn.add_theme_stylebox_override("normal", y_style)
	yes_btn.add_theme_stylebox_override("hover", y_hov)
	yes_btn.add_theme_stylebox_override("pressed", y_press)
	yes_btn.add_theme_stylebox_override("focus", y_style)
	yes_btn.custom_minimum_size = Vector2(170, 58)
	yes_btn.pressed.connect(func():
		Global.play_click()
		overlay.queue_free()
		_reset_match_for_replay()
	)
	hbox.add_child(yes_btn)

func _reset_match_for_replay():
	# Reset states
	score1 = 0
	score2 = 0
	sim_minute = 0
	frame_counter = 0
	active_cards.clear()
	particles.clear()
	red_cards_1 = 0
	red_cards_2 = 0
	yellow_cards_1 = 0
	yellow_cards_2 = 0
	red_card_spawned_this_half = false
	yellow_cards_spawned_this_half = 0
	target_yellow_cards = randi_range(1, 3)
	team1_trailed = false
	team2_trailed = false
	display_added_time = false
	is_paused = false
	event_timer = 0.0
	screen_shake_timer = 0
	end_match_timer = 0
	goal_rotating = false
	goal_angle = PI / 2.0
	halftime_timer = 0
	goal_banner_timer = 0.0
	if is_instance_valid(goal_banner_panel):
		goal_banner_panel.modulate.a = 0.0
	if is_instance_valid(s1_lbl): s1_lbl.text = "0"
	if is_instance_valid(s2_lbl): s2_lbl.text = "0"
	if is_instance_valid(time_lbl): time_lbl.text = "0'"
	added_time_1 = _generate_added_time_1()
	added_time_2 = _generate_added_time_2()
	
	if is_instance_valid(stadium_player):
		stadium_player.stop()
	
	Engine.time_scale = 1.0
	pause_btn.icon = preload("res://pauseicon.svg")
	
	ball1.init_ball(Global.home_team_name, CENTER, ARENA_RADIUS)
	ball2.init_ball(Global.away_team_name, CENTER, ARENA_RADIUS, ball1.position)
	
	state = "FIRST_HALF"
	start_delay_timer = int(0.5 * FPS_TARGET)
	update_card_ui()
	restart_btn.visible = false

func _toggle_pause():
	is_paused = !is_paused
	if is_paused:
		Engine.time_scale = 0.0 # Bütün fizik/zaman akışını dondurur
		pause_btn.icon = preload("res://resumeicon.svg")
		if is_instance_valid(stadium_player):
			stadium_player.stream_paused = true
	else:
		Engine.time_scale = 1.0 # Eski hıza döndür
		pause_btn.icon = preload("res://pauseicon.svg")
		if is_instance_valid(stadium_player):
			stadium_player.stream_paused = false

func spawn_card(ctype: String):
	if goal_cooldown_timer > 0.0: return # Disable cards during goal cooldown
	var angle = randf() * TAU
	var dist = sqrt(randf()) * (ARENA_RADIUS - 60.0)
	var cpos = CENTER + Vector2(cos(angle), sin(angle)) * dist
	var cvel = Vector2(randf_range(-0.53, 0.53), randf_range(-0.53, 0.53))
	active_cards.append({
		"type": ctype,
		"pos": cpos,
		"vel": cvel,
		"life": 10 * FRAMES_PER_SIM_MINUTE,
		"blink_start": 5 * FRAMES_PER_SIM_MINUTE
	})

func create_particle(p_pos: Vector2, base_vel: Vector2, p_color: Color):
	if goal_cooldown_timer > 0.0: return # No particles during goal cooldown for performance
	var angle = randf_range(0, TAU)
	var speed = randf_range(1.33, 4.0)
	var rand_vel = Vector2(cos(angle), sin(angle)) * speed
	particles.append({
		"pos": p_pos, "vel": rand_vel + base_vel, "color": p_color,
		"life": 48.0, "fade_start": 30.0, "radius": randf_range(1.0, 3.0)
	})

func check_card_collision(c: Dictionary, ball) -> bool:
	var hw = 8.0; var hh = 12.0
	var closest_x = clamp(ball.position.x, c.pos.x - hw, c.pos.x + hw)
	var closest_y = clamp(ball.position.y, c.pos.y - hh, c.pos.y + hh)
	var dx = ball.position.x - closest_x
	var dy = ball.position.y - closest_y
	return (dx*dx + dy*dy) < (52.0 * 52.0)  

func update_card_ui():
	draw_stacked_cards(t1_yellow_box, yellow_cards_1, Color8(255, 220, 0))
	draw_stacked_cards(t1_red_box, red_cards_1, Color8(250, 10, 10))
	draw_stacked_cards(t2_red_box, red_cards_2, Color8(250, 10, 10))
	draw_stacked_cards(t2_yellow_box, yellow_cards_2, Color8(255, 220, 0))

func draw_stacked_cards(container: Control, count: int, color: Color):
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

	if count == 0:
		container.custom_minimum_size = Vector2(0, 0)
		return

	var card_w = 16
	var card_h = 24
	var overlap_offset = 8
	
	container.custom_minimum_size = Vector2(card_w + (count - 1) * overlap_offset, card_h)
	container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	for i in range(count):
		var p = Panel.new()
		var style = StyleBoxFlat.new()
		style.bg_color = color
		style.border_width_left = 1; style.border_width_top = 1
		style.border_width_right = 1; style.border_width_bottom = 1
		style.border_color = Color.WHITE
		style.corner_radius_top_left = 2; style.corner_radius_top_right = 2
		style.corner_radius_bottom_left = 2; style.corner_radius_bottom_right = 2
		style.shadow_color = Color8(0,0,0,100)
		style.shadow_size = 2
		p.add_theme_stylebox_override("panel", style)
		
		p.size = Vector2(card_w, card_h)
		p.position = Vector2(i * overlap_offset, 0) 
		container.add_child(p)

func _physics_process(delta):
	if is_paused: return # DURDURULDUYSA FIZIK IŞLEMLERINI ATLAA

	var run_physics = false
	if event_timer > 0:
		event_timer -= delta
		if event_timer < 0.4: event_lbl.modulate.a = event_timer / 0.4
		else: event_lbl.modulate.a = 1.0
	else:
		event_lbl.modulate.a = 0.0
		
	if goal_cooldown_timer > 0.0:
		goal_cooldown_timer -= delta
		
	if goal_banner_timer > 0.0:
		goal_banner_timer -= delta
		if goal_banner_timer > 4.5:
			goal_banner_panel.modulate.a = (5.0 - goal_banner_timer) / 0.5
		elif goal_banner_timer < 1.0:
			goal_banner_panel.modulate.a = goal_banner_timer
		else:
			goal_banner_panel.modulate.a = 1.0
	else:
		goal_banner_panel.modulate.a = 0.0
		
	if state == "INTRO":
		if intro_timer > 0:
			intro_timer -= 1
			intro_overlay.modulate.a = float(intro_timer) / (1.0 * FPS_TARGET)
		else:
			state = "FIRST_HALF"
			intro_overlay.visible = false
			start_delay_timer = int(0.5 * FPS_TARGET)
			
	elif state == "FIRST_HALF" or state == "SECOND_HALF":
		if start_delay_timer > 0:
			start_delay_timer -= 1
		else:
			if is_instance_valid(stadium_player) and not stadium_player.playing:
				stadium_player.play()
			run_physics = true
			frame_counter += 1
			var total_mins_played = frame_counter / FRAMES_PER_SIM_MINUTE
			
			var half_offset = 0 if state == "FIRST_HALF" else 45
			sim_minute = half_offset + total_mins_played
			
			if not red_card_spawned_this_half and randf() < (0.015 if state == "FIRST_HALF" else 0.035) / (45.0 * 60.0) * 13.33:
				spawn_card("red")
				red_card_spawned_this_half = true
				
			if yellow_cards_spawned_this_half < target_yellow_cards and randf() < 0.15 / (45.0 * 60.0) * 13.33:
				spawn_card("yellow")
				yellow_cards_spawned_this_half += 1
			
			if sim_minute >= half_offset + 45:
				display_added_time = true
				var added_t = added_time_1 if state == "FIRST_HALF" else added_time_2
				if sim_minute >= half_offset + 45 + added_t:
					if state == "FIRST_HALF":
						state = "HALFTIME"
						halftime_timer = 0
						active_cards.clear()
					else:
						state = "FULLTIME"
						end_match_timer = 0
			else: display_added_time = false
					
	elif state == "HALFTIME":
		halftime_timer += 1
		if halftime_timer > 0.75 * FPS_TARGET:
			state = "SECOND_HALF"
			frame_counter = 0
			display_added_time = false
			red_card_spawned_this_half = false
			yellow_cards_spawned_this_half = 0
			target_yellow_cards = randi_range(1, 3)
			ball1.init_ball(Global.home_team_name, CENTER, ARENA_RADIUS)
			ball2.init_ball(Global.away_team_name, CENTER, ARENA_RADIUS, ball1.position)
			
	elif state == "FULLTIME":
		end_match_timer += 1
		if end_match_timer == 1:
			# Record result once on the first frame of FULLTIME
			Global.match_history.append({
				"home": Global.home_team_name,
				"away": Global.away_team_name,
				"home_score": score1,
				"away_score": score2,
				"home_yellow": yellow_cards_1,
				"home_red": red_cards_1,
				"away_yellow": yellow_cards_2,
				"away_red": red_cards_2
			})
			Global.record_match_result(
				Global.home_team_name,
				Global.away_team_name,
				score1,
				score2,
				{
					"team1_trailed": team1_trailed,
					"team2_trailed": team2_trailed,
					"is_comeback": (score1 > score2 and team1_trailed) or (score2 > score1 and team2_trailed)
				}
			)
			
			# --- GOOGLE PLAY ACHIEVEMENTS TRIGGERS ---
			var total_matches = Global.match_history.size()
			if total_matches >= 10:
				Global.unlock_achievement("TEN_MATCHES")
			if score1 > score2 or score2 > score1:
				Global.unlock_achievement("FIRST_WIN")
			if (score1 > 0 and score2 == 0) or (score2 > 0 and score1 == 0):
				Global.unlock_achievement("CLEAN_SHEET")
			if score1 >= 5 or score2 >= 5:
				Global.unlock_achievement("FIVE_GOALS")
			if score1 >= 3 or score2 >= 3:
				Global.unlock_achievement("HAT_TRICK")
			if (score1 > score2 and team1_trailed) or (score2 > score1 and team2_trailed):
				Global.unlock_achievement("COMEBACK_KING")
			if Global.favorite_team != "":
				if (Global.home_team_name == Global.favorite_team and score1 > score2) or (Global.away_team_name == Global.favorite_team and score2 > score1):
					Global.unlock_achievement("FAVORITE_CHAMPION")
					
		if end_match_timer > 2.0 * FPS_TARGET and not restart_btn.visible:
			restart_btn.visible = true
			
	if run_physics:
		s1_lbl.text = str(score1)
		s2_lbl.text = str(score2)
		
		var time_str = ""
		var s_min = int(sim_minute)
		if state == "FIRST_HALF": time_str = ("45+" + str(int(sim_minute - 45.0) + 1) + "'") if (display_added_time and added_time_1 > 0) else (str(s_min) + "'")
		elif state == "HALFTIME": time_str = Global.LANG[Global.current_lang]["HT"]
		elif state == "SECOND_HALF": time_str = ("90+" + str(int(sim_minute - 90.0) + 1) + "'") if (display_added_time and added_time_2 > 0) else (str(s_min) + "'")
		elif state == "FULLTIME": time_str = Global.LANG[Global.current_lang]["FT"]
		time_lbl.text = time_str
		
		if goal_rotating: goal_angle = fmod(goal_angle + goal_rot_speed, TAU)
			
		var posts = calculate_goal_posts(CENTER.x, CENTER.y, ARENA_RADIUS, goal_angle, GOAL_WIDTH_RADIANS)
		
		ball1.move()
		ball2.move()
		var hit1_post = ball1.collide_post(posts.p1) or ball1.collide_post(posts.p2)
		var hit2_post = ball2.collide_post(posts.p1) or ball2.collide_post(posts.p2)
		var hit1_wall = ball1.collide_wall(CENTER, ARENA_RADIUS)
		var hit2_wall = ball2.collide_wall(CENTER, ARENA_RADIUS)
		var hit_balls = resolve_collisions(ball1, ball2)
		if hit1_post or hit2_post or hit1_wall or hit2_wall or hit_balls:
			Global.play_click()
		check_goal(ball1, 1); check_goal(ball2, 2)
		
		var ui_needs_update = false
		for i in range(active_cards.size() - 1, -1, -1):
			var c = active_cards[i]
			c.life -= 1
			if c.life <= 0:
				active_cards.remove_at(i)
				continue
			c.pos += c.vel
			if c.pos.distance_to(CENTER) > ARENA_RADIUS - 50: c.vel *= -1
			
			if check_card_collision(c, ball1):
				if c.type == "red": ball1.nerf_timer = int(2.0 * FPS_TARGET); red_cards_1 += 1
				else: ball1.yellow_nerf_timer = int(2.0 * FPS_TARGET); yellow_cards_1 += 1
				active_cards.remove_at(i)
				ui_needs_update = true
				continue
			if check_card_collision(c, ball2):
				if c.type == "red": ball2.nerf_timer = int(2.0 * FPS_TARGET); red_cards_2 += 1
				else: ball2.yellow_nerf_timer = int(2.0 * FPS_TARGET); yellow_cards_2 += 1
				active_cards.remove_at(i)
				ui_needs_update = true
				continue
				
		if ui_needs_update: update_card_ui()

		for i in range(particles.size() - 1, -1, -1):
			var p = particles[i]
			p.pos += p.vel
			p.life -= 1.0
			if p.life <= 0: particles.remove_at(i)
			
	queue_redraw()
	ball1.queue_redraw()
	ball2.queue_redraw()

	if Global.shake_enabled and screen_shake_timer > 0:
		var shake_intensity = int((float(screen_shake_timer) / 22.0) * 12.0)
		game_camera.offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		screen_shake_timer -= 1
	else:
		game_camera.offset = Vector2.ZERO

func resolve_collisions(b1, b2) -> bool:
	var d = b2.position - b1.position
	var dist = d.length()
	
	if dist < 52.0 + 52.0:
		if dist == 0: dist = 0.1
		var n = d.normalized() if dist > 0.001 else Vector2(1, 0)
		var overlap = (52.0 + 52.0) - dist
		var total_mass = b1.mass + b2.mass
		var m1_ratio = b2.mass / total_mass
		var m2_ratio = b1.mass / total_mass
		
		b1.position -= n * overlap * m1_ratio
		b2.position += n * overlap * m2_ratio
		
		var rx = b2.velocity.x - b1.velocity.x
		var ry = b2.velocity.y - b1.velocity.y
		var vel_along_normal = rx * n.x + ry * n.y
		
		if vel_along_normal > 0: return false
		
		var j = -(1.0 + ELASTICITY) * vel_along_normal
		j /= (1.0 / b1.mass + 1.0 / b2.mass)
		var impulse_x = j * n.x; var impulse_y = j * n.y
		b1.velocity.x -= impulse_x / b1.mass; b1.velocity.y -= impulse_y / b1.mass
		b2.velocity.x += impulse_x / b2.mass; b2.velocity.y += impulse_y / b2.mass
		
		var hit_pos = b1.position + n * 52.0
		for _i in range(5): create_particle(hit_pos, -n * 4.0, b1.team_colors[randi() % b1.team_colors.size()])
		for _i in range(5): create_particle(hit_pos, n * 4.0, b2.team_colors[randi() % b2.team_colors.size()])
		return true
	return false

func check_goal(b, team_id):
	var dist = b.position.distance_to(CENTER)
	if dist > ARENA_RADIUS - 52.0 - 5.0:
		var ball_ang = (b.position - CENTER).angle()
		var goal_n = fposmod(goal_angle, TAU)
		var ball_n = fposmod(ball_ang, TAU)
		var diff = abs(ball_n - goal_n)
		while diff > PI: diff = abs(diff - TAU)
		if diff < GOAL_WIDTH_RADIANS / 2.0:
			trigger_goal(b, team_id)

func trigger_goal(b, team_id):
	Global.play_goal_music()
	Global.trigger_vibration(500)
	
	var goal_str = Global.LANG[Global.current_lang]["GOAL"]
	var team_color = ball1.team_colors[0] if team_id == 1 else ball2.team_colors[0]
	
	if team_id == 1:
		score1 += 1
		if score1 < score2:
			team1_trailed = true
		elif score1 > score2 and score2 > 0:
			# Team 1 took the lead after conceding
			pass
		trigger_popup(goal_str, team_color, get_readable_outline(team_color))
	else:
		score2 += 1
		if score2 < score1:
			team2_trailed = true
		elif score2 > score1 and score1 > 0:
			# Team 2 took the lead after conceding
			pass
		trigger_popup(goal_str, team_color, get_readable_outline(team_color))
		
	if score1 < score2: team1_trailed = true
	if score2 < score1: team2_trailed = true
		
	var time_str = ""
	var s_min = int(sim_minute) + 1
	if state == "FIRST_HALF":
		if display_added_time:
			var extra = int(sim_minute - 45.0) + 1
			time_str = "45+" + str(extra)
		else:
			time_str = str(min(s_min, 45))
	elif state == "SECOND_HALF":
		if display_added_time:
			var extra = int(sim_minute - 90.0) + 1
			time_str = "90+" + str(extra)
		else:
			time_str = str(min(s_min, 90))
	else:
		time_str = str(s_min)
	
	var scoring_team_name = Global.home_team_name if team_id == 1 else Global.away_team_name
	var custom_names = []
	if Global.custom_player_names.has(scoring_team_name):
		var team_dict = Global.custom_player_names[scoring_team_name]
		if typeof(team_dict) == TYPE_DICTIONARY:
			for key in team_dict:
				var pname = String(team_dict[key]).strip_edges()
				if pname != "":
					custom_names.append(pname)
	
	if custom_names.size() > 0:
		var chosen_name = custom_names[randi() % custom_names.size()]
		goal_banner_lbl.text = chosen_name + " (" + time_str + "')"
	else:
		var available_nums = [7, 8, 9, 10, 11, 14, 17, 19, 21, 23]
		var scorer_num = available_nums[randi() % available_nums.size()]
		goal_banner_lbl.text = "#" + str(scorer_num) + " (" + time_str + "')"
	goal_banner_lbl.add_theme_color_override("font_color", Color.WHITE)
	goal_banner_lbl.remove_theme_color_override("font_outline_color")
	goal_banner_lbl.remove_theme_constant_override("outline_size")
	goal_banner_timer = 5.0

	if score1 + score2 >= 1: goal_rotating = true
	if Global.shake_enabled: screen_shake_timer = 22
	
	goal_cooldown_timer = 1.0
	
	ball1.reset_and_explode(CENTER)
	ball2.reset_and_explode(CENTER)

func calculate_goal_posts(cx: float, cy: float, radius: float, angle: float, width_rad: float) -> Dictionary:
	var gx = cx + cos(angle) * (radius - INWARD_OFFSET)
	var gy = cy + sin(angle) * (radius - INWARD_OFFSET)
	var half_width = (width_rad * radius) / 2.0
	var dx = cos(angle + PI / 2.0) * half_width
	var dy = sin(angle + PI / 2.0) * half_width
	return {"p1": Vector2(gx - dx, gy - dy), "p2": Vector2(gx + dx, gy + dy)}

func _draw():
	var posts = calculate_goal_posts(CENTER.x, CENTER.y, ARENA_RADIUS, goal_angle, GOAL_WIDTH_RADIANS)
	var p1: Vector2 = posts.p1; var p2: Vector2 = posts.p2
	var dx = cos(goal_angle) * GOAL_DEPTH; var dy = sin(goal_angle) * GOAL_DEPTH
	var b1 = p1 + Vector2(dx, dy); var b2 = p2 + Vector2(dx, dy)

	var rel_x1 = p1.x - CENTER.x; var rel_y1 = p1.y - CENTER.y
	var B1 = 2.0 * (rel_x1 * cos(goal_angle) + rel_y1 * sin(goal_angle))
	var C1 = rel_x1 * rel_x1 + rel_y1 * rel_y1 - ARENA_RADIUS * ARENA_RADIUS
	var D1 = B1 * B1 - 4.0 * C1
	var t1 = 20.0; if D1 >= 0: t1 = (-B1 + sqrt(D1)) / 2.0
	var nf1 = p1 + Vector2(t1 * cos(goal_angle), t1 * sin(goal_angle))

	var rel_x2 = p2.x - CENTER.x; var rel_y2 = p2.y - CENTER.y
	var B2 = 2.0 * (rel_x2 * cos(goal_angle) + rel_y2 * sin(goal_angle))
	var C2 = rel_x2 * rel_x2 + rel_y2 * rel_y2 - ARENA_RADIUS * ARENA_RADIUS
	var D2 = B2 * B2 - 4.0 * C2
	var t2 = 20.0; if D2 >= 0: t2 = (-B2 + sqrt(D2)) / 2.0
	var nf2 = p2 + Vector2(t2 * cos(goal_angle), t2 * sin(goal_angle))

	var ang1 = atan2(nf1.y - CENTER.y, nf1.x - CENTER.x); var ang2 = atan2(nf2.y - CENTER.y, nf2.x - CENTER.x)
	var diff = ang2 - ang1
	while diff > PI: diff -= 2.0 * PI
	while diff < -PI: diff += 2.0 * PI

	var steps_lr = 10; var steps_fb = 5
	for j in range(1, steps_fb + 1):
		var ratio_fb = float(j) / float(steps_fb)
		var points = PackedVector2Array()
		for i in range(steps_lr + 1):
			var ratio_lr = float(i) / float(steps_lr)
			var a = ang1 + diff * ratio_lr
			var arc_pos = CENTER + Vector2(ARENA_RADIUS * cos(a), ARENA_RADIUS * sin(a))
			var back_pos = b1 + (b2 - b1) * ratio_lr
			points.append(arc_pos + (back_pos - arc_pos) * ratio_fb)
		if points.size() > 1: draw_polyline(points, net_color, 1.0, true)

	for i in range(1, steps_lr):
		var ratio_lr = float(i) / float(steps_lr)
		var a = ang1 + diff * ratio_lr
		draw_line(CENTER + Vector2(ARENA_RADIUS * cos(a), ARENA_RADIUS * sin(a)), b1 + (b2 - b1) * ratio_lr, net_color, 1.0, true)

	draw_polyline(PackedVector2Array([p1, b1, b2, p2]), white, 7.0, true)
	draw_circle(p1, POST_RADIUS, white); draw_circle(p2, POST_RADIUS, white)
	
	for c in active_cards:
		var visible = true
		if c.life < c.blink_start:
			if int(c.life / 10) % 2 == 0: visible = false
		if visible:
			var rect = Rect2(c.pos.x - 8, c.pos.y - 12, 16, 24)
			var color = Color8(250, 10, 10) if c.type == "red" else Color8(255, 220, 0)
			draw_rect(rect, color)
			draw_rect(rect, Color.WHITE, false, 1.0)
			
	for p in particles:
		var alpha = 1.0
		if p.life < p.fade_start: alpha = p.life / p.fade_start
		var c = p.color; c.a = alpha
		draw_circle(p.pos, p.radius, c)
	
func trigger_popup(msg: String, color: Color = Color.WHITE, _outline_col: Color = Color.BLACK):
	event_lbl.text = msg
	var lum = color.get_luminance()
	var display_col = color.lightened(0.35) if lum < 0.3 else (color.darkened(0.15) if lum > 0.85 else color)
	var out_col = Color.BLACK if lum > 0.45 else Color.WHITE
	event_lbl.add_theme_color_override("font_color", display_col)
	event_lbl.add_theme_color_override("font_outline_color", out_col)
	event_lbl.add_theme_constant_override("outline_size", 8)
	event_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 230))
	event_lbl.add_theme_constant_override("shadow_offset_y", 6)
	event_lbl.add_theme_constant_override("shadow_offset_x", 0)
	event_lbl.pivot_offset = Vector2(300, 80)
	event_lbl.scale = Vector2(0.35, 0.35)
	event_lbl.modulate.a = 1.0
	var tw = create_tween()
	tw.set_trans(Tween.TRANS_BACK)
	tw.set_ease(Tween.EASE_OUT)
	tw.tween_property(event_lbl, "scale", Vector2(1.25, 1.25), 0.16)
	tw.set_trans(Tween.TRANS_SINE)
	tw.tween_property(event_lbl, "scale", Vector2(1.0, 1.0), 0.10)
	event_timer = 1.3
	# Performance: skip high-step drawing during cooldown
