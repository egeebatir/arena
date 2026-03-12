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

var abandon_btn: Button
var pause_btn: Button # YENİ DURDURMA BUTONU
var is_paused: bool = false # DURUM DEĞİŞKENİ

var restart_btn: Button

var t1_yellow_box: Control
var t1_red_box: Control
var t2_red_box: Control
var t2_yellow_box: Control

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
		draw_circle(Vector2.ZERO, 264.0, theme_dict.pitch_1)
		for y in range(-264.0, 264.0):
			if int(y + 264.0) % 60 < 30:
				var x = sqrt(264.0 * 264.0 - y * y)
				draw_line(Vector2(-x, y), Vector2(x, y), theme_dict.pitch_2, 1.0)
				
		draw_arc(Vector2.ZERO, 264.0, 0, TAU, 128, scream, 6.0, true)
		var line_len = 264.0 - 20
		draw_line(Vector2(-line_len, 0), Vector2(line_len, 0), swhite, 4.0)
		draw_arc(Vector2.ZERO, 65, 0, TAU, 64, swhite, 4.0, true)

var static_pitch_node: StaticPitch

@onready var ball1 = $Ball1
@onready var ball2 = $Ball2

func _ready():
	Engine.time_scale = 1.0 # Remove raw time_scale speedup/slowdown 
	
	# Determine logical frame count per sim minute (90 min match)
	if Global.match_duration == 0:
		FRAMES_PER_SIM_MINUTE = 720.0 / 45.0 # 24s total = 12s per half. 12s * 60 FPS = 720
	elif Global.match_duration == 1:
		FRAMES_PER_SIM_MINUTE = 1080.0 / 45.0 # 36s total = 18s per half. 18s * 60 FPS = 1080
	else:
		FRAMES_PER_SIM_MINUTE = 1440.0 / 45.0 # 48s total = 24s per half. 24s * 60 FPS = 1440
		
	active_theme = Global.THEMES[Global.current_theme]
	
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
	CENTER = Vector2(screen_size.x / 2.0, screen_size.y / 2.0 - 100.0) 
	
	static_pitch_node = StaticPitch.new()
	static_pitch_node.theme_dict = active_theme
	static_pitch_node.scream = cream
	static_pitch_node.swhite = white
	static_pitch_node.position = CENTER
	bg_layer.add_child(static_pitch_node)
	static_pitch_node.queue_redraw()
	
	added_time_1 = randi_range(2, 4)
	added_time_2 = randi_range(3, 8)
	target_yellow_cards = randi_range(1, 3)
	
	intro_timer = int(1.0 * FPS_TARGET)
	
	ball1.init_ball(Global.home_team_name, CENTER, ARENA_RADIUS)
	ball2.init_ball(Global.away_team_name, CENTER, ARENA_RADIUS, ball1.position)
	setup_scoreboard()

func get_readable_outline(c: Color) -> Color:
	var lum = 0.299 * c.r + 0.587 * c.g + 0.114 * c.b
	return Color.BLACK if lum > 0.5 else Color.WHITE

func setup_scoreboard():
	var custom_font = preload("res://IMPACT.TTF")
	var ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	
	var score_margin = MarginContainer.new()
	score_margin.set_anchors_preset(Control.PRESET_TOP_WIDE)
	var calculated_margin = CENTER.y - ARENA_RADIUS - 480.0
	score_margin.add_theme_constant_override("margin_top", 65.0)
	ui_layer.add_child(score_margin)
	
	var center_cont = CenterContainer.new()
	score_margin.add_child(center_cont)
	
	var top_panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = active_theme.bg_bottom
	style.corner_radius_top_left = 15; style.corner_radius_top_right = 15
	style.corner_radius_bottom_left = 15; style.corner_radius_bottom_right = 15
	style.border_width_bottom = 2; style.border_width_top = 2
	style.border_width_left = 2; style.border_width_right = 2
	style.border_color = cream
	style.content_margin_left = 35; style.content_margin_right = 35
	style.content_margin_top = 15; style.content_margin_bottom = 15
	top_panel.add_theme_stylebox_override("panel", style)
	center_cont.add_child(top_panel)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	top_panel.add_child(main_vbox)
	
	var score_hbox = HBoxContainer.new()
	score_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	score_hbox.add_theme_constant_override("separation", 25)
	main_vbox.add_child(score_hbox)
	
	t1_yellow_box = Control.new()
	score_hbox.add_child(t1_yellow_box)
	
	var t1 = Label.new()
	t1.text = ball1.team_short_name
	t1.add_theme_font_override("font", custom_font)
	t1.add_theme_font_size_override("font_size", 50)
	t1.add_theme_color_override("font_color", ball1.team_colors[0])
	t1.add_theme_color_override("font_outline_color", get_readable_outline(ball1.team_colors[0]))
	t1.add_theme_constant_override("outline_size", 5)
	score_hbox.add_child(t1)
	
	t1_red_box = Control.new()
	score_hbox.add_child(t1_red_box)
	
	s1_lbl = Label.new()
	s1_lbl.add_theme_font_override("font", custom_font)
	s1_lbl.add_theme_font_size_override("font_size", 60)
	s1_lbl.add_theme_color_override("font_color", ball1.team_colors[0])
	s1_lbl.add_theme_color_override("font_outline_color", get_readable_outline(ball1.team_colors[0]))
	s1_lbl.add_theme_constant_override("outline_size", 5)
	score_hbox.add_child(s1_lbl)
	
	var dash = Label.new()
	dash.text = "-"
	dash.add_theme_font_override("font", custom_font)
	dash.add_theme_font_size_override("font_size", 60)
	dash.add_theme_color_override("font_color", Color.WHITE)
	score_hbox.add_child(dash)
	
	s2_lbl = Label.new()
	s2_lbl.add_theme_font_override("font", custom_font)
	s2_lbl.add_theme_font_size_override("font_size", 60)
	s2_lbl.add_theme_color_override("font_color", ball2.team_colors[0])
	s2_lbl.add_theme_color_override("font_outline_color", get_readable_outline(ball2.team_colors[0]))
	s2_lbl.add_theme_constant_override("outline_size", 5)
	score_hbox.add_child(s2_lbl)
	
	t2_red_box = Control.new()
	score_hbox.add_child(t2_red_box)
	
	var t2 = Label.new()
	t2.text = ball2.team_short_name
	t2.add_theme_font_override("font", custom_font)
	t2.add_theme_font_size_override("font_size", 50)
	t2.add_theme_color_override("font_color", ball2.team_colors[0])
	t2.add_theme_color_override("font_outline_color", get_readable_outline(ball2.team_colors[0]))
	t2.add_theme_constant_override("outline_size", 5)
	score_hbox.add_child(t2)
	
	t2_yellow_box = Control.new()
	score_hbox.add_child(t2_yellow_box)
	
	time_lbl = Label.new()
	time_lbl.add_theme_font_override("font", custom_font)
	time_lbl.add_theme_font_size_override("font_size", 36)
	time_lbl.add_theme_color_override("font_color", Color.WHITE)
	time_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(time_lbl)
	
	event_lbl = Label.new()
	event_lbl.add_theme_font_override("font", custom_font)
	event_lbl.add_theme_font_size_override("font_size", 100)
	event_lbl.add_theme_color_override("font_color", Color.WHITE)
	event_lbl.add_theme_color_override("font_outline_color", Color.BLACK)
	event_lbl.add_theme_constant_override("outline_size", 15)
	event_lbl.set_anchors_preset(Control.PRESET_CENTER)
	event_lbl.grow_horizontal = Control.GROW_DIRECTION_BOTH 
	event_lbl.grow_vertical = Control.GROW_DIRECTION_BOTH
	event_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
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
	intro_t1.add_theme_constant_override("outline_size", 4)
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
	intro_t2.add_theme_constant_override("outline_size", 4)
	intro_t2.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_vbox.add_child(intro_t2)

	var top_ui_margin = MarginContainer.new()
	top_ui_margin.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_ui_margin.add_theme_constant_override("margin_top", 50)
	top_ui_margin.add_theme_constant_override("margin_left", 30)
	top_ui_margin.add_theme_constant_override("margin_right", 30)
	ui_layer.add_child(top_ui_margin)
	
	var top_ui_hbox = HBoxContainer.new()
	top_ui_hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	top_ui_margin.add_child(top_ui_hbox)
	
	# --- ÇIKIŞ BUTONU (Aşağı İndirildi) ---
	abandon_btn = Button.new()
	abandon_btn.text = "<"
	abandon_btn.add_theme_font_override("font", custom_font)
	abandon_btn.add_theme_font_size_override("font_size", 70)
	abandon_btn.add_theme_color_override("font_color", cream)
	var abnd_style = StyleBoxFlat.new()
	abnd_style.bg_color = Color(0,0,0,0)
	abandon_btn.add_theme_stylebox_override("normal", abnd_style)
	abandon_btn.add_theme_stylebox_override("hover", abnd_style)
	abandon_btn.add_theme_stylebox_override("pressed", abnd_style)
	abandon_btn.add_theme_stylebox_override("focus", abnd_style)
	abandon_btn.custom_minimum_size = Vector2(80, 80)
	abandon_btn.pressed.connect(func(): Global.play_click(); get_tree().change_scene_to_file("res://main_menu.tscn"))
	top_ui_hbox.add_child(abandon_btn)
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_ui_hbox.add_child(spacer)
	
	# --- DURDURMA BUTONU (Aynı Hizada Sağ Üstte) ---
	pause_btn = Button.new()
	pause_btn.text = ""
	pause_btn.icon = preload("res://pauseicon.svg")
	pause_btn.expand_icon = true
	pause_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pause_btn.add_theme_font_override("font", custom_font)
	pause_btn.add_theme_font_size_override("font_size", 30)
	pause_btn.add_theme_color_override("font_color", cream)
	pause_btn.add_theme_stylebox_override("normal", abnd_style)
	pause_btn.add_theme_stylebox_override("hover", abnd_style)
	pause_btn.add_theme_stylebox_override("pressed", abnd_style)
	pause_btn.add_theme_stylebox_override("focus", abnd_style)
	pause_btn.custom_minimum_size = Vector2(50, 50)
	pause_btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	pause_btn.pressed.connect(func(): Global.play_click(); _toggle_pause())
	top_ui_hbox.add_child(pause_btn)

	restart_btn = Button.new()
	restart_btn.text = ""
	restart_btn.icon = preload("res://replayicon.svg")
	restart_btn.expand_icon = true
	restart_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	restart_btn.add_theme_font_override("font", custom_font)
	restart_btn.add_theme_font_size_override("font_size", 40)
	restart_btn.add_theme_color_override("font_color", cream)
	var rest_style = StyleBoxFlat.new()
	rest_style.bg_color = Color(0,0,0,0)
	restart_btn.add_theme_stylebox_override("normal", rest_style)
	restart_btn.add_theme_stylebox_override("hover", rest_style)
	restart_btn.add_theme_stylebox_override("pressed", rest_style)
	restart_btn.add_theme_stylebox_override("focus", rest_style)
	
	restart_btn.custom_minimum_size = Vector2(100, 100)
	var screen_w = get_viewport_rect().size.x
	var screen_h = get_viewport_rect().size.y
	restart_btn.position = Vector2((screen_w / 2.0) - 50.0, CENTER.y + ARENA_RADIUS + 50.0) 
	
	restart_btn.visible = false
	restart_btn.pressed.connect(func(): Global.play_click(); _on_restart_pressed())
	ui_layer.add_child(restart_btn)

func _on_restart_pressed():
	# REPLAY CONFIRMATION POPUP
	var confirm_panel = PanelContainer.new()
	var cp_style = StyleBoxFlat.new()
	cp_style.bg_color = Color8(15, 25, 35, 245)
	cp_style.corner_radius_top_left = 20; cp_style.corner_radius_top_right = 20
	cp_style.corner_radius_bottom_left = 20; cp_style.corner_radius_bottom_right = 20
	confirm_panel.add_theme_stylebox_override("panel", cp_style)
	confirm_panel.custom_minimum_size = Vector2(700, 350)
	var screen_size = get_viewport_rect().size
	confirm_panel.position = Vector2((screen_size.x - 700) / 2, (screen_size.y - 350) / 2)
	get_node("/root").add_child(confirm_panel) # Or add to ui_layer safely
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 50)
	confirm_panel.add_child(vbox)
	
	var custom_font = preload("res://IMPACT.TTF")
	
	var lbl = Label.new()
	# Retrieve string safely even if missing, default to TR.
	var lang_dict = {"TR": "Aynı maçı tekrar oynatmak istediğinize emin misiniz?",
					 "ENG": "Are you sure you want to replay the exact same match?",
					 "ESP": "¿Estás seguro de que quieres volver a jugar el mismo partido?",
					 "POR": "Tem certeza de que quer jogar a mesma partida?"}
	var ask_str = lang_dict.get(Global.current_lang, lang_dict["TR"])
	
	lbl.text = ask_str
	lbl.add_theme_font_override("font", custom_font)
	lbl.add_theme_font_size_override("font_size", 40)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(lbl)
	
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 50)
	vbox.add_child(hbox)
	
	var yes_btn = Button.new()
	var yes_txt = "EVET"
	if Global.current_lang == "ENG": yes_txt = "YES"
	elif Global.current_lang == "ESP": yes_txt = "SÍ"
	elif Global.current_lang == "POR": yes_txt = "SIM"
	yes_btn.text = yes_txt
	yes_btn.add_theme_font_override("font", custom_font)
	yes_btn.add_theme_font_size_override("font_size", 30)
	var y_style = StyleBoxFlat.new()
	y_style.bg_color = Color8(34, 139, 34)
	y_style.corner_radius_top_left = 10; y_style.corner_radius_top_right = 10
	y_style.corner_radius_bottom_left = 10; y_style.corner_radius_bottom_right = 10
	yes_btn.add_theme_stylebox_override("normal", y_style)
	yes_btn.custom_minimum_size = Vector2(150, 60)
	yes_btn.pressed.connect(func():
		Global.play_click()
		confirm_panel.queue_free()
		_reset_match_for_replay()
	)
	hbox.add_child(yes_btn)
	
	var no_btn = Button.new()
	var no_txt = "HAYIR"
	if Global.current_lang == "ENG": no_txt = "NO"
	elif Global.current_lang == "ESP": no_txt = "NO"
	elif Global.current_lang == "POR": no_txt = "NÃO"
	no_btn.text = no_txt
	no_btn.add_theme_font_override("font", custom_font)
	no_btn.add_theme_font_size_override("font_size", 30)
	var n_style = StyleBoxFlat.new()
	n_style.bg_color = Color8(178, 34, 34)
	n_style.corner_radius_top_left = 10; n_style.corner_radius_top_right = 10
	n_style.corner_radius_bottom_left = 10; n_style.corner_radius_bottom_right = 10
	no_btn.add_theme_stylebox_override("normal", n_style)
	no_btn.custom_minimum_size = Vector2(150, 60)
	no_btn.pressed.connect(func(): Global.play_click(); confirm_panel.queue_free())
	hbox.add_child(no_btn)

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
	display_added_time = false
	is_paused = false
	event_timer = 0.0
	screen_shake_timer = 0
	end_match_timer = 0
	goal_rotating = false
	goal_angle = PI / 2.0
	halftime_timer = 0
	
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
	else:
		Engine.time_scale = 1.0 # Eski hıza döndür
		pause_btn.icon = preload("res://pauseicon.svg")

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
	if is_paused: return # DURDURULDUYSA FİZİK İŞLEMLERİNİ ATLAA

	var run_physics = false
	if event_timer > 0:
		event_timer -= delta
		if event_timer < 1.0: event_lbl.modulate.a = event_timer
		else: event_lbl.modulate.a = 1.0
	else:
		event_lbl.modulate.a = 0.0
		
	if goal_cooldown_timer > 0.0:
		goal_cooldown_timer -= delta
		
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
				"away_score": score2
			})
			Global.save_stats()  # Persist to disk immediately
		if end_match_timer > 2.0 * FPS_TARGET and not restart_btn.visible:
			restart_btn.visible = true
			
	if run_physics:
		s1_lbl.text = str(score1)
		s2_lbl.text = str(score2)
		
		var time_str = ""
		var s_min = int(sim_minute)
		if state == "FIRST_HALF": time_str = "45+" + str(s_min - 45) + "'" if display_added_time else str(s_min) + "'"
		elif state == "HALFTIME": time_str = Global.LANG[Global.current_lang]["HT"]
		elif state == "SECOND_HALF": time_str = "90+" + str(s_min - 90) + "'" if display_added_time else str(s_min) + "'"
		elif state == "FULLTIME": time_str = Global.LANG[Global.current_lang]["FT"]
		time_lbl.text = time_str
		
		if goal_rotating: goal_angle = fmod(goal_angle + goal_rot_speed, TAU)
			
		var posts = calculate_goal_posts(CENTER.x, CENTER.y, ARENA_RADIUS, goal_angle, GOAL_WIDTH_RADIANS)
		
		ball1.move()
		ball2.move()
		ball1.collide_post(posts.p1); ball1.collide_post(posts.p2)
		ball2.collide_post(posts.p1); ball2.collide_post(posts.p2)
		ball1.collide_wall(CENTER, ARENA_RADIUS)
		ball2.collide_wall(CENTER, ARENA_RADIUS)
		resolve_collisions(ball1, ball2)
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
		position = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		screen_shake_timer -= 1
	else:
		position = Vector2.ZERO 

func resolve_collisions(b1, b2) -> bool:
	var d = b2.position - b1.position
	var dist = d.length()
	
	if dist < 52.0 + 52.0:
		if dist == 0: dist = 0.1
		var n = d.normalized()
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
	var goal_str = Global.LANG[Global.current_lang]["GOAL"]
	if team_id == 1:
		score1 += 1
		trigger_popup(goal_str, ball1.team_colors[0], get_readable_outline(ball1.team_colors[0]))
	else:
		score2 += 1
		trigger_popup(goal_str, ball2.team_colors[0], get_readable_outline(ball2.team_colors[0]))
		
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
	if goal_cooldown_timer > 0.0:
		steps_lr = 4; steps_fb = 2 # Simplify for performance
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
	
func trigger_popup(msg: String, color: Color = Color.WHITE, outline_col: Color = Color.BLACK):
	event_lbl.text = msg
	event_lbl.add_theme_color_override("font_color", color)
	event_lbl.add_theme_color_override("font_outline_color", outline_col)
	event_timer = 3.0
	# Performance: skip high-step drawing during cooldown
