extends Control

var custom_font = preload("res://IMPACT.TTF")
var active_theme: Dictionary

var play_games_plugin

var gp_btn: Button
var guest_btn: Button
var title: Label

var LANG = {
	"TR": {
		"WELCOME": "HOŞ GELDİNİZ",
		"LOGIN_PLAY": " PLAY GAMES İLE GİRİŞ",
		"GUEST": "MİSAFİR OLARAK DEVAM",
		"LOADING": "BAĞLANILIYOR..."
	},
	"ENG": {
		"WELCOME": "WELCOME",
		"LOGIN_PLAY": " SIGN IN WITH PLAY",
		"GUEST": "CONTINUE AS GUEST",
		"LOADING": "CONNECTING..."
	},
	"ESP": {
		"WELCOME": "BIENVENIDO",
		"LOGIN_PLAY": " INICIAR CON PLAY",
		"GUEST": "CONTINUAR COMO INVITADO",
		"LOADING": "CONECTANDO..."
	},
	"POR": {
		"WELCOME": "BEM-VINDO",
		"LOGIN_PLAY": " ENTRAR COM PLAY",
		"GUEST": "CONTINUAR COMO CONVIDADO",
		"LOADING": "CONECTANDO..."
	}
}

func _ready():
	Engine.time_scale = 1.0
	
	if is_instance_valid(Global.bg_music_player) and not Global.bg_music_player.playing:
		Global.bg_music_player.play()
	
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_plugin = Engine.get_singleton("GodotPlayGamesServices")
		play_games_plugin.init(true) 
	
	active_theme = Global.THEMES[Global.current_theme]
	
	# Pitch Background
	var pitch_bg = Control.new()
	pitch_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(pitch_bg)
	pitch_bg.draw.connect(func():
		var s = get_viewport_rect().size
		pitch_bg.draw_rect(Rect2(0, 0, s.x, s.y), active_theme.pitch_1)
		for y in range(-int(s.y), int(s.y)):
			if int(y + s.y) % 60 < 30:
				pitch_bg.draw_rect(Rect2(0, y, s.x, 1), active_theme.pitch_2)
	)
	
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.4)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(overlay)
	
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	
	var panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = Color(0, 0, 0, 0.6)
	p_style.corner_radius_top_left = 30; p_style.corner_radius_top_right = 30
	p_style.corner_radius_bottom_left = 30; p_style.corner_radius_bottom_right = 30
	p_style.border_width_left = 2; p_style.border_width_right = 2
	p_style.border_width_top = 2; p_style.border_width_bottom = 2
	p_style.border_color = Color(1, 1, 1, 0.2)
	p_style.content_margin_left = 40; p_style.content_margin_right = 40
	p_style.content_margin_top = 50; p_style.content_margin_bottom = 50
	panel.add_theme_stylebox_override("panel", p_style)
	center.add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 30)
	panel.add_child(vbox)
	
	# TITLE
	title = Label.new()
	title.text = LANG[Global.current_lang]["WELCOME"]
	title.add_theme_font_override("font", custom_font)
	title.add_theme_font_size_override("font_size", 60)
	title.add_theme_color_override("font_color", Color.WHITE)
	title.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	title.add_theme_constant_override("shadow_offset_y", 4)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)
	
	# GOOGLE PLAY BUTTON
	gp_btn = Button.new()
	gp_btn.text = LANG[Global.current_lang]["LOGIN_PLAY"]
	gp_btn.add_theme_font_override("font", custom_font)
	gp_btn.add_theme_font_size_override("font_size", 30)
	gp_btn.add_theme_color_override("font_color", Color8(50, 50, 50))
	gp_btn.custom_minimum_size = Vector2(400, 90)
	
	# G Logo Draw Hook
	gp_btn.draw.connect(func():
		var g_color = Color8(15, 155, 15) # Google Play Green Base
		gp_btn.draw_circle(Vector2(50, 45), 18, g_color)
		gp_btn.draw_circle(Vector2(50, 45), 12, Color.WHITE)
		gp_btn.draw_rect(Rect2(50, 35, 18, 10), g_color)
		gp_btn.draw_rect(Rect2(30, 25, 40, 20), Color.WHITE)
		gp_btn.draw_rect(Rect2(50, 42, 20, 6), g_color)
	)
	
	var gp_style = StyleBoxFlat.new()
	gp_style.bg_color = Color.WHITE
	gp_style.corner_radius_top_left = 45; gp_style.corner_radius_top_right = 45
	gp_style.corner_radius_bottom_left = 45; gp_style.corner_radius_bottom_right = 45
	gp_style.border_width_bottom = 6; gp_style.border_color = Color8(200, 200, 200)
	
	var gp_hover = gp_style.duplicate()
	gp_hover.bg_color = Color8(240, 240, 240)
	
	var gp_pressed = gp_style.duplicate()
	gp_pressed.border_width_bottom = 0
	gp_pressed.content_margin_top = 6
	
	gp_btn.add_theme_stylebox_override("normal", gp_style)
	gp_btn.add_theme_stylebox_override("hover", gp_hover)
	gp_btn.add_theme_stylebox_override("pressed", gp_pressed)
	gp_btn.add_theme_stylebox_override("focus", gp_style)
	gp_btn.pressed.connect(_on_google_play_pressed)
	vbox.add_child(gp_btn)
	
	# GUEST BUTTON
	guest_btn = Button.new()
	guest_btn.text = LANG[Global.current_lang]["GUEST"]
	guest_btn.add_theme_font_override("font", custom_font)
	guest_btn.add_theme_font_size_override("font_size", 25)
	guest_btn.add_theme_color_override("font_color", Color8(200, 200, 200))
	guest_btn.custom_minimum_size = Vector2(400, 70)
	
	var guest_style = StyleBoxFlat.new()
	guest_style.bg_color = Color8(255, 255, 255, 20)
	guest_style.corner_radius_top_left = 35; guest_style.corner_radius_top_right = 35
	guest_style.corner_radius_bottom_left = 35; guest_style.corner_radius_bottom_right = 35
	guest_style.border_width_bottom = 4; guest_style.border_color = Color8(0, 0, 0, 50)
	
	var guest_pressed = guest_style.duplicate()
	guest_pressed.border_width_bottom = 0
	guest_pressed.content_margin_top = 4
	
	guest_btn.add_theme_stylebox_override("normal", guest_style)
	guest_btn.add_theme_stylebox_override("hover", guest_style)
	guest_btn.add_theme_stylebox_override("pressed", guest_pressed)
	guest_btn.add_theme_stylebox_override("focus", guest_style)
	guest_btn.pressed.connect(_on_guest_pressed)
	vbox.add_child(guest_btn)
	
	# Entrance Animation - Slide gracefully holding center screen
	panel.modulate.a = 0
	
	await get_tree().process_frame
	var target_y = panel.position.y
	var offset_y = 60
	panel.position.y = target_y + offset_y
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(panel, "modulate:a", 1.0, 0.8)
	tween.tween_property(panel, "position:y", target_y, 0.8)

func _on_google_play_pressed():
	gp_btn.disabled = true
	guest_btn.disabled = true
	gp_btn.text = LANG[Global.current_lang]["LOADING"]
	
	if play_games_plugin:
		play_games_plugin.signIn() 
		# Simulate await if callback not hooked natively for visual polish
		await get_tree().create_timer(1.2).timeout
		goto_main_menu()
	else:
		# PC Fallback Wait Logic
		await get_tree().create_timer(1.2).timeout
		goto_main_menu()

func _on_guest_pressed():
	guest_btn.disabled = true
	gp_btn.disabled = true
	goto_main_menu()

func goto_main_menu():
	get_tree().change_scene_to_file("res://main_menu.tscn")
