extends Control

var custom_font = preload("res://Teko-Bold.ttf")
var logo_texture: Texture2D = null
var studio_texture: Texture2D = null
var pitch_lines_texture: Texture2D = null
var active_theme: Dictionary

var play_games_plugin = null
var sign_in_client: Node = null
var is_connecting_google: bool = false
var connecting_dots_timer: float = 0.0
var connecting_dots_count: int = 0

var splash_overlay: Control
var is_intro_active: bool = true
var intro_tween: Tween = null

var play_now_btn: Button
var gp_btn: Button
var title_lbl: Label
var subtitle_lbl: Label
var logo_rect: TextureRect
var logo_frame: PanelContainer
var logo_container: CenterContainer
var shine_overlay: Control
var shine_progress: float = -1.0
var privacy_btn: Button
var center_panel: PanelContainer
var lang_btn: Button
var privacy_modal: Control = null

var particles: Array = []
var particle_canvas: Control

const LANG_CYCLE: Array = ["TR", "ENG", "ESP", "POR", "ITA"]
const LANG_DISPLAY: Dictionary = {
	"TR": "TR",
	"ENG": "EN",
	"ESP": "ES",
	"POR": "PT",
	"ITA": "IT"
}

var LANG = {
	"TR": {
		"TITLE": "BOL GOL FUTBOL",
		"SUBTITLE": "EB STÜDYO  •  ebstudyo.com",
		"STUDIO_NAME": "EB STÜDYO",
		"PRESENTS": "SUNAR",
		"PLAY_NOW": "HEMEN OYNA",
		"GUEST": "MİSAFİR GİRİŞİ",
		"LOGIN_PLAY": "Google Play ile Bağlan",
		"PLAY_CONNECTED": "Google Play Bağlandı",
		"CONNECTING": "BAĞLANILIYOR",
		"PRIVACY": "Gizlilik Politikası",
		"PRIVACY_TITLE": "GİZLİLİK POLİTİKASI",
		"CLOSE": "KAPAT",
		"VISIT_WEB": "ebstudyo.com ↗",
		"SKIP_HINT": "Geçmek için dokunun"
	},
	"ENG": {
		"TITLE": "BOL GOL FUTBOL",
		"SUBTITLE": "EB STUDIO  •  ebstudyo.com",
		"STUDIO_NAME": "EB STUDIO",
		"PRESENTS": "PRESENTS",
		"PLAY_NOW": "PLAY NOW",
		"GUEST": "PLAY AS GUEST",
		"LOGIN_PLAY": "Sign in with Google Play",
		"PLAY_CONNECTED": "Google Play Connected",
		"CONNECTING": "CONNECTING",
		"PRIVACY": "Privacy Policy",
		"PRIVACY_TITLE": "PRIVACY POLICY",
		"CLOSE": "CLOSE",
		"VISIT_WEB": "ebstudyo.com ↗",
		"SKIP_HINT": "Tap to skip"
	},
	"ESP": {
		"TITLE": "BOL GOL FUTBOL",
		"SUBTITLE": "EB STUDIO  •  ebstudyo.com",
		"STUDIO_NAME": "EB STUDIO",
		"PRESENTS": "PRESENTA",
		"PLAY_NOW": "JUGAR AHORA",
		"GUEST": "JUGAR COMO INVITADO",
		"LOGIN_PLAY": "Iniciar con Google Play",
		"PLAY_CONNECTED": "Conectado con Google Play",
		"CONNECTING": "CONECTANDO",
		"PRIVACY": "Política de Privacidad",
		"PRIVACY_TITLE": "POLÍTICA DE PRIVACIDAD",
		"CLOSE": "CERRAR",
		"VISIT_WEB": "ebstudyo.com ↗",
		"SKIP_HINT": "Toca para saltar"
	},
	"POR": {
		"TITLE": "BOL GOL FUTBOL",
		"SUBTITLE": "EB STUDIO  •  ebstudyo.com",
		"STUDIO_NAME": "EB STUDIO",
		"PRESENTS": "APRESENTA",
		"PLAY_NOW": "JOGAR AGORA",
		"GUEST": "JOGAR COMO CONVIDADO",
		"LOGIN_PLAY": "Entrar com Google Play",
		"PLAY_CONNECTED": "Conectado ao Google Play",
		"CONNECTING": "CONECTANDO",
		"PRIVACY": "Política de Privacidade",
		"PRIVACY_TITLE": "POLÍTICA DE PRIVACIDADE",
		"CLOSE": "FECHAR",
		"VISIT_WEB": "ebstudyo.com ↗",
		"SKIP_HINT": "Toque para pular"
	},
	"ITA": {
		"TITLE": "BOL GOL FUTBOL",
		"SUBTITLE": "EB STUDIO  •  ebstudyo.com",
		"STUDIO_NAME": "EB STUDIO",
		"PRESENTS": "PRESENTA",
		"PLAY_NOW": "GIOCA ORA",
		"GUEST": "GIOCA COME OSPITE",
		"LOGIN_PLAY": "Accedi con Google Play",
		"PLAY_CONNECTED": "Connesso a Google Play",
		"CONNECTING": "CONNESSIONE...",
		"PRIVACY": "Informativa sulla Privacy",
		"PRIVACY_TITLE": "INFORMATIVA SULLA PRIVACY",
		"CLOSE": "CHIUDI",
		"VISIT_WEB": "ebstudyo.com ↗",
		"SKIP_HINT": "Tocca per saltare"
	}
}

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		# Graceful Android back button handling:
		# 1. Close modal if active
		if is_instance_valid(privacy_modal):
			_close_privacy_policy()
			return
		# 2. Skip intro splash if active
		if is_intro_active:
			_skip_splash()
			return
		# 3. Quit game
		get_tree().quit()

func _ready():
	Engine.time_scale = 1.0
	Global.load_progression()
	Global.init_google_play_services()
	Global.init_admob()
	
	# 1. Load Main Game Logo (v2.1)
	if ResourceLoader.exists("res://game_logo.png"):
		var res = load("res://game_logo.png")
		if res is Texture2D:
			logo_texture = res
	if not logo_texture and ResourceLoader.exists("res://Bol Gol Futbol logo 2.1.jpg"):
		var res = load("res://Bol Gol Futbol logo 2.1.jpg")
		if res is Texture2D:
			logo_texture = res
	if not logo_texture and FileAccess.file_exists("res://game_logo.png"):
		var img = Image.load_from_file("res://game_logo.png")
		if img and not img.is_empty():
			logo_texture = ImageTexture.create_from_image(img)
	if not logo_texture and ResourceLoader.exists("res://icon.png"):
		var res = load("res://icon.png")
		if res is Texture2D:
			logo_texture = res

	# 2. Load Studio Logo & Button Pitch Texture
	if ResourceLoader.exists("res://eb studio 2.png"):
		var res = load("res://eb studio 2.png")
		if res is Texture2D:
			studio_texture = res
	if ResourceLoader.exists("res://match_btn_pitch_lines.png"):
		var p_res = load("res://match_btn_pitch_lines.png")
		if p_res is Texture2D:
			pitch_lines_texture = p_res
	
	if is_instance_valid(Global.bg_music_player) and not Global.bg_music_player.playing:
		Global.bg_music_player.play()
	
	active_theme = Global.THEMES.get(Global.current_theme, Global.THEMES["Turkuaz"])
	_build_ui()
	
	# Google Play Games setup
	if Global.play_games_sign_in_client:
		sign_in_client = Global.play_games_sign_in_client
		if not sign_in_client.user_authenticated.is_connected(_on_sign_in_result):
			sign_in_client.user_authenticated.connect(_on_sign_in_result)
	elif Engine.has_singleton("GodotPlayGameServices"):
		var gps_autoload = get_node_or_null("/root/GodotPlayGameServices")
		if is_instance_valid(gps_autoload) and gps_autoload.has_method("initialize"):
			gps_autoload.initialize()
		if ResourceLoader.exists("res://addons/GodotPlayGameServices/scripts/sign_in/sign_in_client.gd"):
			var client_script = load("res://addons/GodotPlayGameServices/scripts/sign_in/sign_in_client.gd")
			if client_script:
				sign_in_client = client_script.new()
				add_child(sign_in_client)
				sign_in_client.user_authenticated.connect(_on_sign_in_result)
	
	# If player was previously connected with Google, reflect state immediately
	if Global.login_method == "google":
		_set_gp_btn_connected(false)
	
	if sign_in_client and sign_in_client.has_method("is_authenticated"):
		sign_in_client.is_authenticated()
		
	_start_intro_sequence()

func _gui_input(event: InputEvent) -> void:
	if is_intro_active:
		if (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed):
			_skip_splash()
			return
	if event is InputEventKey and event.pressed:
		if is_intro_active:
			_skip_splash()
		elif event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			_on_play_now_pressed()

func _draw_regular_polygon_outline(canvas: CanvasItem, center: Vector2, radius: float, sides: int, rot_offset: float, col: Color, width: float = 1.5) -> void:
	var pts = PackedVector2Array()
	for i in range(sides + 1):
		var ang = rot_offset + (TAU * float(i) / float(sides))
		pts.append(center + Vector2(cos(ang), sin(ang)) * radius)
	canvas.draw_polyline(pts, col, width)

func _build_ui():
	var s = get_viewport_rect().size
	var bg_top: Color = active_theme.get("bg_top", Color8(150, 170, 200))
	var bg_bottom: Color = active_theme.get("bg_bottom", Color8(0, 18, 40))
	var accent_color: Color = active_theme.get("accent", Color8(255, 100, 0))
	
	# 1. Unified Theme Gradient Background (Matches main_menu.gd seamlessly)
	var bg_tex_rect = TextureRect.new()
	var bg_grad = Gradient.new()
	bg_grad.set_color(0, bg_top)
	bg_grad.set_color(1, bg_bottom)
	var grad_tex = GradientTexture2D.new()
	grad_tex.gradient = bg_grad
	grad_tex.fill_from = Vector2(0, 0)
	grad_tex.fill_to = Vector2(0, 1)
	grad_tex.width = 64
	grad_tex.height = 64
	bg_tex_rect.texture = grad_tex
	bg_tex_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg_tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg_tex_rect)
	
	# 2. Tactical Stadium & Football Vector Watermark Layer (Low-Opacity ~0.035 - 0.06)
	var bg = Control.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	bg.draw.connect(func():
		var sz = get_viewport_rect().size
		var c = sz * 0.5
		
		# Subtle dark depth vignette so the center card and typography maintain high WCAG contrast
		bg.draw_rect(Rect2(0, 0, sz.x, sz.y), Color(bg_bottom.r * 0.35, bg_bottom.g * 0.35, bg_bottom.b * 0.35, 0.32))
		
		# Subtle Diagonal Stadium Architecture Stripes
		var stripe_col = Color(1.0, 1.0, 1.0, 0.022)
		for i in range(-4, 12):
			var y_off = float(i) * 110.0
			var stripe_pts = PackedVector2Array([
				Vector2(0, y_off),
				Vector2(sz.x, y_off - 90.0),
				Vector2(sz.x, y_off - 45.0),
				Vector2(0, y_off + 45.0)
			])
			bg.draw_colored_polygon(stripe_pts, stripe_col)
		
		# Low-opacity Tactical Pitch Watermark Lines
		var line_col = Color(1.0, 1.0, 1.0, 0.055)
		var faint_col = Color(1.0, 1.0, 1.0, 0.038)
		var margin_x = sz.x * 0.06
		var margin_y = sz.y * 0.04
		var pitch_rect = Rect2(margin_x, margin_y, sz.x - margin_x * 2.0, sz.y - margin_y * 2.0)
		
		# Outer Pitch Touchlines & Goal Lines
		bg.draw_rect(pitch_rect, line_col, false, 2.0)
		
		# Halfway Line & Center Circle
		bg.draw_line(Vector2(pitch_rect.position.x, c.y), Vector2(pitch_rect.end.x, c.y), line_col, 2.0)
		var circle_r = min(sz.x, sz.y) * 0.24
		bg.draw_arc(c, circle_r, 0, TAU, 64, line_col, 2.0)
		bg.draw_arc(c, circle_r * 1.18, 0, TAU, 64, faint_col, 1.2)
		bg.draw_circle(c, 4.5, line_col)
		
		# Top & Bottom Penalty Boxes, 6-Yard Boxes & Penalty Arcs
		var pen_w = pitch_rect.size.x * 0.56
		var pen_h = pitch_rect.size.y * 0.14
		var goal_w = pitch_rect.size.x * 0.26
		var goal_h = pitch_rect.size.y * 0.055
		
		# Top Penalty Area
		bg.draw_rect(Rect2(c.x - pen_w * 0.5, pitch_rect.position.y, pen_w, pen_h), line_col, false, 1.8)
		bg.draw_rect(Rect2(c.x - goal_w * 0.5, pitch_rect.position.y, goal_w, goal_h), faint_col, false, 1.5)
		bg.draw_arc(Vector2(c.x, pitch_rect.position.y + pen_h), circle_r * 0.52, 0.15 * PI, 0.85 * PI, 32, line_col, 1.8)
		
		# Bottom Penalty Area
		bg.draw_rect(Rect2(c.x - pen_w * 0.5, pitch_rect.end.y - pen_h, pen_w, pen_h), line_col, false, 1.8)
		bg.draw_rect(Rect2(c.x - goal_w * 0.5, pitch_rect.end.y - goal_h, goal_w, goal_h), faint_col, false, 1.5)
		bg.draw_arc(Vector2(c.x, pitch_rect.end.y - pen_h), circle_r * 0.52, 1.15 * PI, 1.85 * PI, 32, line_col, 1.8)
		
		# 4 Corner Kick Arcs
		var cr = 22.0
		bg.draw_arc(pitch_rect.position, cr, 0.0, PI * 0.5, 16, line_col, 1.8)
		bg.draw_arc(Vector2(pitch_rect.end.x, pitch_rect.position.y), cr, PI * 0.5, PI, 16, line_col, 1.8)
		bg.draw_arc(pitch_rect.end, cr, PI, PI * 1.5, 16, line_col, 1.8)
		bg.draw_arc(Vector2(pitch_rect.position.x, pitch_rect.end.y), cr, PI * 1.5, TAU, 16, line_col, 1.8)
		
		# Geometric Football Hexagon Cluster Watermarks (Top-Left & Bottom-Right Flanks)
		var hex_r = 26.0
		var hex_centers = [
			Vector2(sz.x * 0.16, sz.y * 0.16),
			Vector2(sz.x * 0.84, sz.y * 0.83)
		]
		for hc in hex_centers:
			_draw_regular_polygon_outline(bg, hc, hex_r, 6, -PI / 6.0, faint_col, 1.5)
			for ring_i in range(6):
				var ang = (TAU * float(ring_i) / 6.0)
				var neighbor = hc + Vector2(cos(ang), sin(ang)) * (hex_r * 1.732)
				_draw_regular_polygon_outline(bg, neighbor, hex_r, 6, -PI / 6.0, Color(1.0, 1.0, 1.0, 0.025), 1.2)
		
		# Tactical Playbook X & O Markers
		var x_pos = Vector2(sz.x * 0.82, sz.y * 0.19)
		var x_sz = 8.0
		bg.draw_line(x_pos - Vector2(x_sz, x_sz), x_pos + Vector2(x_sz, x_sz), faint_col, 2.0)
		bg.draw_line(x_pos + Vector2(-x_sz, x_sz), x_pos + Vector2(x_sz, -x_sz), faint_col, 2.0)
		bg.draw_arc(Vector2(sz.x * 0.18, sz.y * 0.81), 9.0, 0, TAU, 24, faint_col, 2.0)
	)
	
	# Subtle Low-Opacity Stadium Atmosphere Dust (No harsh neon/orange blobs)
	particle_canvas = Control.new()
	particle_canvas.set_anchors_preset(Control.PRESET_FULL_RECT)
	particle_canvas.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(particle_canvas)
	
	particles.clear()
	for _i in range(18):
		particles.append({
			"pos": Vector2(randf() * s.x, randf() * s.y),
			"vel": Vector2(randf_range(-0.18, 0.18), randf_range(-0.38, -0.12)),
			"radius": randf_range(1.2, 2.4),
			"color": Color(1.0, 1.0, 1.0, randf_range(0.035, 0.075))
		})
	
	particle_canvas.draw.connect(func():
		for p in particles:
			particle_canvas.draw_circle(p.pos, p.radius, p.color)
	)
	
	# 3. Language Switcher Button (Top-Right, Standardized to match main_menu.gd)
	lang_btn = Button.new()
	lang_btn.text = " " + LANG_DISPLAY.get(Global.current_lang, "TR")
	if ResourceLoader.exists("res://languageicon.svg"):
		lang_btn.icon = load("res://languageicon.svg")
		lang_btn.expand_icon = true
		lang_btn.add_theme_constant_override("icon_max_width", 22)
		lang_btn.add_theme_constant_override("h_separation", 8)
	lang_btn.add_theme_font_override("font", custom_font)
	lang_btn.add_theme_font_size_override("font_size", 24)
	lang_btn.add_theme_color_override("font_color", Color.WHITE)
	lang_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	lang_btn.add_theme_constant_override("shadow_offset_y", 1)
	lang_btn.custom_minimum_size = Vector2(92, 48)
	
	var lang_style = StyleBoxFlat.new()
	lang_style.bg_color = bg_bottom.darkened(0.22)
	lang_style.bg_color.a = 0.94
	lang_style.corner_radius_top_left = 14; lang_style.corner_radius_top_right = 14
	lang_style.corner_radius_bottom_left = 14; lang_style.corner_radius_bottom_right = 14
	lang_style.border_width_left = 2; lang_style.border_width_right = 2
	lang_style.border_width_top = 2; lang_style.border_width_bottom = 4
	lang_style.border_color = accent_color
	lang_style.shadow_color = Color8(0, 0, 0, 110)
	lang_style.shadow_size = 6
	lang_style.shadow_offset = Vector2(0, 2)
	lang_style.content_margin_left = 14; lang_style.content_margin_right = 16
	lang_style.content_margin_top = 6; lang_style.content_margin_bottom = 6
	
	var lang_hover = lang_style.duplicate()
	lang_hover.bg_color = bg_bottom.darkened(0.10)
	lang_hover.border_color = accent_color.lightened(0.20)
	
	var lang_pressed = lang_style.duplicate()
	lang_pressed.border_width_bottom = 2
	lang_pressed.content_margin_top = 8
	
	lang_btn.add_theme_stylebox_override("normal", lang_style)
	lang_btn.add_theme_stylebox_override("hover", lang_hover)
	lang_btn.add_theme_stylebox_override("pressed", lang_pressed)
	lang_btn.add_theme_stylebox_override("focus", lang_style)
	lang_btn.pressed.connect(_cycle_language)
	
	# Place language button in top-right corner safely inside margins
	var top_bar = MarginContainer.new()
	top_bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_bar.add_theme_constant_override("margin_top", 22)
	top_bar.add_theme_constant_override("margin_right", 20)
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top_bar)
	
	var top_hbox = HBoxContainer.new()
	top_hbox.alignment = BoxContainer.ALIGNMENT_END
	top_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top_bar.add_child(top_hbox)
	top_hbox.add_child(lang_btn)
	
	# 4. Main Center Layout (Standardized Tactical Card matching main_menu.gd)
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(center)
	
	center_panel = PanelContainer.new()
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = bg_bottom.darkened(0.32)
	p_style.bg_color.a = 0.96
	p_style.corner_radius_top_left = 22; p_style.corner_radius_top_right = 22
	p_style.corner_radius_bottom_left = 22; p_style.corner_radius_bottom_right = 22
	p_style.border_width_left = 2; p_style.border_width_right = 2
	p_style.border_width_top = 2; p_style.border_width_bottom = 5
	var card_border_col = bg_top.lerp(accent_color, 0.35)
	card_border_col.a = 0.78
	p_style.border_color = card_border_col
	p_style.shadow_color = Color(0, 0, 0, 0.48)
	p_style.shadow_size = 24
	p_style.shadow_offset = Vector2(0, 8)
	p_style.content_margin_left = 32; p_style.content_margin_right = 32
	p_style.content_margin_top = 28; p_style.content_margin_bottom = 26
	center_panel.add_theme_stylebox_override("panel", p_style)
	center_panel.custom_minimum_size = Vector2(min(s.x * 0.90, 460), 0)
	center.add_child(center_panel)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 12)
	center_panel.add_child(vbox)
	
	# --- HERO LOGO CONTAINER (Rounded-Square Frame matching game_logo.png, no circular backplate!) ---
	logo_container = CenterContainer.new()
	var logo_dim = min(168.0, s.x * 0.38)
	logo_container.custom_minimum_size = Vector2(0, logo_dim + 8)
	vbox.add_child(logo_container)
	
	logo_frame = PanelContainer.new()
	logo_frame.custom_minimum_size = Vector2(logo_dim, logo_dim)
	logo_frame.pivot_offset = Vector2(logo_dim * 0.5, logo_dim * 0.5)
	logo_frame.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	var lf_style = StyleBoxFlat.new()
	lf_style.bg_color = bg_bottom.darkened(0.45)
	lf_style.corner_radius_top_left = 28; lf_style.corner_radius_top_right = 28
	lf_style.corner_radius_bottom_left = 28; lf_style.corner_radius_bottom_right = 28
	lf_style.border_width_left = 2; lf_style.border_width_right = 2
	lf_style.border_width_top = 2; lf_style.border_width_bottom = 4
	var lf_border = bg_top.lightened(0.18)
	lf_border.a = 0.55
	lf_style.border_color = lf_border
	lf_style.shadow_color = Color(0, 0, 0, 0.45)
	lf_style.shadow_size = 16
	lf_style.shadow_offset = Vector2(0, 5)
	logo_frame.add_theme_stylebox_override("panel", lf_style)
	logo_container.add_child(logo_frame)
	
	var logo_inner = Control.new()
	logo_inner.custom_minimum_size = Vector2(logo_dim, logo_dim)
	logo_inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	logo_frame.add_child(logo_inner)
	
	logo_rect = TextureRect.new()
	logo_rect.texture = logo_texture
	logo_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	logo_rect.custom_minimum_size = Vector2(logo_dim, logo_dim)
	logo_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	logo_rect.pivot_offset = Vector2(logo_dim * 0.5, logo_dim * 0.5)
	logo_inner.add_child(logo_rect)
	
	# Dynamic Light Sheen / Shine Overlay (Clipped cleanly inside rounded-square logo_frame)
	shine_overlay = Control.new()
	shine_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	shine_overlay.custom_minimum_size = Vector2(logo_dim, logo_dim)
	shine_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shine_overlay.draw.connect(func():
		if shine_progress > -0.3 and shine_progress < 1.4:
			var w = logo_dim
			var h = logo_dim
			var x_mid = shine_progress * (w + h * 0.8) - h * 0.4
			var slant = h * 0.35
			var bar_w = 24.0
			
			var pts = PackedVector2Array([
				Vector2(x_mid, 0),
				Vector2(x_mid + bar_w, 0),
				Vector2(x_mid - slant + bar_w, h),
				Vector2(x_mid - slant, h)
			])
			shine_overlay.draw_colored_polygon(pts, Color(1.0, 1.0, 1.0, 0.28))
			
			var pts2 = PackedVector2Array([
				Vector2(x_mid + bar_w + 8, 0),
				Vector2(x_mid + bar_w + 14, 0),
				Vector2(x_mid - slant + bar_w + 14, h),
				Vector2(x_mid - slant + bar_w + 8, h)
			])
			shine_overlay.draw_colored_polygon(pts2, Color(1.0, 1.0, 1.0, 0.14))
	)
	logo_inner.add_child(shine_overlay)
	
	# --- GAME TITLE ---
	title_lbl = Label.new()
	title_lbl.text = LANG.get(Global.current_lang, LANG["ENG"])["TITLE"]
	title_lbl.add_theme_font_override("font", custom_font)
	title_lbl.add_theme_font_size_override("font_size", 50)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)
	title_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 210))
	title_lbl.add_theme_constant_override("shadow_offset_y", 3)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title_lbl)
	
	# --- SUBTITLE BADGE: EB STÜDYO • ebstudyo.com ---
	var sub_badge = PanelContainer.new()
	sub_badge.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var sb_badge_style = StyleBoxFlat.new()
	sb_badge_style.bg_color = bg_bottom.darkened(0.48)
	sb_badge_style.bg_color.a = 0.90
	sb_badge_style.corner_radius_top_left = 10; sb_badge_style.corner_radius_top_right = 10
	sb_badge_style.corner_radius_bottom_left = 10; sb_badge_style.corner_radius_bottom_right = 10
	sb_badge_style.border_width_left = 1; sb_badge_style.border_width_right = 1
	sb_badge_style.border_width_top = 1; sb_badge_style.border_width_bottom = 2
	sb_badge_style.border_color = Color(1.0, 1.0, 1.0, 0.14)
	sb_badge_style.content_margin_left = 14; sb_badge_style.content_margin_right = 14
	sb_badge_style.content_margin_top = 2; sb_badge_style.content_margin_bottom = 2
	sub_badge.add_theme_stylebox_override("panel", sb_badge_style)
	vbox.add_child(sub_badge)
	
	subtitle_lbl = Label.new()
	subtitle_lbl.text = LANG.get(Global.current_lang, LANG["ENG"])["SUBTITLE"]
	subtitle_lbl.add_theme_font_override("font", custom_font)
	subtitle_lbl.add_theme_font_size_override("font_size", 19)
	subtitle_lbl.add_theme_color_override("font_color", Color.WHITE)
	subtitle_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_badge.add_child(subtitle_lbl)
	
	# Subtle Tactical Divider Bar
	var divider_ctrl = Control.new()
	divider_ctrl.custom_minimum_size = Vector2(0, 8)
	divider_ctrl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	divider_ctrl.draw.connect(func():
		var dw = divider_ctrl.size.x
		var dy = divider_ctrl.size.y * 0.5
		divider_ctrl.draw_line(Vector2(dw * 0.12, dy), Vector2(dw * 0.88, dy), Color(1, 1, 1, 0.08), 1.0)
		divider_ctrl.draw_line(Vector2(dw * 0.42, dy), Vector2(dw * 0.58, dy), Color(accent_color.r, accent_color.g, accent_color.b, 0.65), 2.5)
	)
	vbox.add_child(divider_ctrl)
	
	# --- 1. PRIMARY BUTTON: HEMEN OYNA (Standardized Tactile 3D Sport CTA, corner_radius = 16) ---
	var btn_width = min(s.x * 0.82, 380.0)
	play_now_btn = Button.new()
	play_now_btn.text = LANG.get(Global.current_lang, LANG["ENG"])["PLAY_NOW"]
	play_now_btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
	play_now_btn.add_theme_font_override("font", custom_font)
	play_now_btn.add_theme_font_size_override("font_size", 38)
	play_now_btn.add_theme_color_override("font_color", Color.WHITE)
	play_now_btn.add_theme_color_override("font_hover_color", Color.WHITE)
	play_now_btn.add_theme_color_override("font_pressed_color", Color.WHITE)
	play_now_btn.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 190))
	play_now_btn.add_theme_constant_override("shadow_offset_y", 2)
	play_now_btn.custom_minimum_size = Vector2(btn_width, 72)
	play_now_btn.clip_contents = true
	
	var p_btn_style = StyleBoxFlat.new()
	p_btn_style.bg_color = Color8(16, 152, 96)
	p_btn_style.corner_radius_top_left = 16; p_btn_style.corner_radius_top_right = 16
	p_btn_style.corner_radius_bottom_left = 16; p_btn_style.corner_radius_bottom_right = 16
	p_btn_style.border_width_left = 2; p_btn_style.border_width_right = 2
	p_btn_style.border_width_top = 2; p_btn_style.border_width_bottom = 5
	p_btn_style.border_color = Color8(8, 88, 54)
	p_btn_style.shadow_color = Color(0, 0, 0, 0.40)
	p_btn_style.shadow_size = 10
	p_btn_style.shadow_offset = Vector2(0, 4)
	
	var p_btn_hover = p_btn_style.duplicate()
	p_btn_hover.bg_color = Color8(22, 170, 108)
	p_btn_hover.border_color = Color8(10, 104, 64)
	
	var p_btn_pressed = p_btn_style.duplicate()
	p_btn_pressed.bg_color = Color8(12, 132, 82)
	p_btn_pressed.border_width_bottom = 2
	p_btn_pressed.content_margin_top = 4
	
	play_now_btn.add_theme_stylebox_override("normal", p_btn_style)
	play_now_btn.add_theme_stylebox_override("hover", p_btn_hover)
	play_now_btn.add_theme_stylebox_override("pressed", p_btn_pressed)
	play_now_btn.add_theme_stylebox_override("focus", p_btn_style)
	
	# Subtle Pitch Line Texture Overlay inside Primary CTA (matches StartMatchButton in main_menu.gd)
	if pitch_lines_texture:
		var field_tex = TextureRect.new()
		field_tex.texture = pitch_lines_texture
		field_tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		field_tex.stretch_mode = TextureRect.STRETCH_SCALE
		field_tex.set_anchors_preset(Control.PRESET_FULL_RECT)
		field_tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
		field_tex.modulate = Color(1, 1, 1, 0.22)
		play_now_btn.add_child(field_tex)
	
	# Crisp Vector Forward Play Chevron on Right Side of Primary CTA
	var play_chevron = Control.new()
	play_chevron.set_anchors_preset(Control.PRESET_FULL_RECT)
	play_chevron.mouse_filter = Control.MOUSE_FILTER_IGNORE
	play_chevron.draw.connect(func():
		var bsz = play_chevron.size
		# Subtle top inner highlight line
		play_chevron.draw_line(Vector2(16, 2), Vector2(bsz.x - 16, 2), Color(1, 1, 1, 0.22), 1.5)
		var cx = bsz.x - 28.0
		var cy = (bsz.y - 3.0) * 0.5
		var chevron_pts = PackedVector2Array([
			Vector2(cx - 5.0, cy - 8.0),
			Vector2(cx + 4.0, cy),
			Vector2(cx - 5.0, cy + 8.0)
		])
		play_chevron.draw_polyline(chevron_pts, Color(1, 1, 1, 0.92), 2.8)
	)
	play_now_btn.add_child(play_chevron)
	
	play_now_btn.pressed.connect(_on_play_now_pressed)
	vbox.add_child(play_now_btn)
	
	# --- 2. SECONDARY BUTTON: GOOGLE PLAY GAMES (Standardized Tactile Button, corner_radius = 14) ---
	gp_btn = Button.new()
	gp_btn.custom_minimum_size = Vector2(btn_width, 54)
	
	var gp_hbox = HBoxContainer.new()
	gp_hbox.name = "GPHBox"
	gp_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	gp_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	gp_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gp_hbox.add_theme_constant_override("separation", 10)
	gp_btn.add_child(gp_hbox)
	
	var gp_icon = TextureRect.new()
	gp_icon.name = "GPIcon"
	if ResourceLoader.exists("res://google_play_logo.svg"):
		gp_icon.texture = load("res://google_play_logo.svg")
	gp_icon.custom_minimum_size = Vector2(24, 24)
	gp_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	gp_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	gp_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gp_hbox.add_child(gp_icon)
	
	var gp_lbl = Label.new()
	gp_lbl.name = "GPLabel"
	gp_lbl.text = LANG.get(Global.current_lang, LANG["ENG"])["LOGIN_PLAY"]
	gp_lbl.add_theme_font_override("font", custom_font)
	gp_lbl.add_theme_font_size_override("font_size", 24)
	gp_lbl.add_theme_color_override("font_color", Color.WHITE)
	gp_lbl.add_theme_color_override("font_shadow_color", Color8(0, 0, 0, 150))
	gp_lbl.add_theme_constant_override("shadow_offset_y", 1)
	gp_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gp_hbox.add_child(gp_lbl)
	
	var gp_style = StyleBoxFlat.new()
	gp_style.bg_color = bg_bottom.darkened(0.16)
	gp_style.bg_color.a = 0.94
	gp_style.corner_radius_top_left = 14; gp_style.corner_radius_top_right = 14
	gp_style.corner_radius_bottom_left = 14; gp_style.corner_radius_bottom_right = 14
	gp_style.border_width_left = 2; gp_style.border_width_right = 2
	gp_style.border_width_top = 2; gp_style.border_width_bottom = 4
	var gp_border = bg_top.lightened(0.15)
	gp_border.a = 0.38
	gp_style.border_color = gp_border
	gp_style.shadow_color = Color(0, 0, 0, 0.32)
	gp_style.shadow_size = 8
	gp_style.shadow_offset = Vector2(0, 2)
	
	var gp_hover = gp_style.duplicate()
	gp_hover.bg_color = bg_bottom.lightened(0.04)
	gp_hover.border_color = Color(gp_border.r, gp_border.g, gp_border.b, 0.58)
	
	var gp_pressed = gp_style.duplicate()
	gp_pressed.border_width_bottom = 2
	gp_pressed.content_margin_top = 3
	
	gp_btn.add_theme_stylebox_override("normal", gp_style)
	gp_btn.add_theme_stylebox_override("hover", gp_hover)
	gp_btn.add_theme_stylebox_override("pressed", gp_pressed)
	gp_btn.add_theme_stylebox_override("focus", gp_style)
	gp_btn.pressed.connect(_on_google_play_pressed)
	vbox.add_child(gp_btn)
	
	# --- 3. PRIVACY POLICY FOOTER BUTTON (Standardized 48 dp Touch Target, corner_radius = 14) ---
	privacy_btn = Button.new()
	privacy_btn.text = LANG.get(Global.current_lang, LANG["ENG"])["PRIVACY"]
	privacy_btn.add_theme_font_override("font", custom_font)
	privacy_btn.add_theme_font_size_override("font_size", 20)
	privacy_btn.add_theme_color_override("font_color", Color.WHITE)
	privacy_btn.add_theme_color_override("font_hover_color", Color.WHITE)
	privacy_btn.custom_minimum_size = Vector2(min(s.x * 0.75, 280), 48)
	privacy_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var priv_style = StyleBoxFlat.new()
	priv_style.bg_color = bg_bottom.darkened(0.26)
	priv_style.bg_color.a = 0.82
	priv_style.corner_radius_top_left = 14; priv_style.corner_radius_top_right = 14
	priv_style.corner_radius_bottom_left = 14; priv_style.corner_radius_bottom_right = 14
	priv_style.border_width_left = 1; priv_style.border_width_right = 1
	priv_style.border_width_top = 1; priv_style.border_width_bottom = 3
	priv_style.border_color = Color(1, 1, 1, 0.18)
	priv_style.content_margin_left = 18; priv_style.content_margin_right = 18
	
	var priv_hover = priv_style.duplicate()
	priv_hover.bg_color = bg_bottom.darkened(0.14)
	priv_hover.border_color = Color(1, 1, 1, 0.35)
	
	var priv_pressed = priv_style.duplicate()
	priv_pressed.border_width_bottom = 1
	priv_pressed.content_margin_top = 2
	
	privacy_btn.add_theme_stylebox_override("normal", priv_style)
	privacy_btn.add_theme_stylebox_override("hover", priv_hover)
	privacy_btn.add_theme_stylebox_override("pressed", priv_pressed)
	privacy_btn.add_theme_stylebox_override("focus", priv_style)
	privacy_btn.pressed.connect(_show_privacy_policy)
	vbox.add_child(privacy_btn)

	# 5. Version / Build Badge (Subtle footer label)
	var ver_margin = MarginContainer.new()
	ver_margin.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	ver_margin.add_theme_constant_override("margin_left", 16)
	ver_margin.add_theme_constant_override("margin_bottom", 12)
	ver_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ver_margin)
	
	var ver_lbl = Label.new()
	ver_lbl.text = "v" + Global.CURRENT_GAME_VERSION
	ver_lbl.add_theme_font_override("font", custom_font)
	ver_lbl.add_theme_font_size_override("font_size", 16)
	ver_lbl.add_theme_color_override("font_color", Color.WHITE)
	ver_margin.add_child(ver_lbl)

	# 6. Create Splash Intro Overlay (AAA Studio Presentation)
	_build_splash_overlay()

func _build_splash_overlay():
	var bg_bottom: Color = active_theme.get("bg_bottom", Color8(0, 18, 40))
	var accent_color: Color = active_theme.get("accent", Color8(255, 100, 0))
	
	splash_overlay = Control.new()
	splash_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(splash_overlay)
	
	# Connect gui_input directly on the splash overlay so tapping anywhere immediately skips!
	splash_overlay.gui_input.connect(func(event: InputEvent):
		if (event is InputEventMouseButton and event.pressed) or (event is InputEventScreenTouch and event.pressed):
			_skip_splash()
	)
	
	# Dark cinematic backdrop harmonized with active theme
	var splash_bg = ColorRect.new()
	splash_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash_bg.color = bg_bottom.darkened(0.55)
	splash_bg.color.a = 1.0
	splash_bg.mouse_filter = Control.MOUSE_FILTER_PASS
	splash_overlay.add_child(splash_bg)
	
	# Center container for splash items
	var splash_center = CenterContainer.new()
	splash_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	splash_center.mouse_filter = Control.MOUSE_FILTER_PASS
	splash_overlay.add_child(splash_center)
	
	var splash_vbox = VBoxContainer.new()
	splash_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	splash_vbox.add_theme_constant_override("separation", 16)
	splash_vbox.mouse_filter = Control.MOUSE_FILTER_PASS
	splash_center.add_child(splash_vbox)
	
	# Studio Logo / Icon
	if studio_texture:
		var studio_icon_rect = TextureRect.new()
		studio_icon_rect.texture = studio_texture
		studio_icon_rect.custom_minimum_size = Vector2(120, 120)
		studio_icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		studio_icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		studio_icon_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		studio_icon_rect.mouse_filter = Control.MOUSE_FILTER_PASS
		splash_vbox.add_child(studio_icon_rect)
	
	# Studio Title
	var studio_title = Label.new()
	studio_title.text = LANG.get(Global.current_lang, LANG["ENG"])["STUDIO_NAME"]
	studio_title.add_theme_font_override("font", custom_font)
	studio_title.add_theme_font_size_override("font_size", 44)
	studio_title.add_theme_color_override("font_color", Color.WHITE)
	studio_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	studio_title.mouse_filter = Control.MOUSE_FILTER_PASS
	splash_vbox.add_child(studio_title)
	
	# "PRESENTS" / "SUNAR"
	var studio_sub = Label.new()
	studio_sub.text = LANG.get(Global.current_lang, LANG["ENG"])["PRESENTS"]
	studio_sub.add_theme_font_override("font", custom_font)
	studio_sub.add_theme_font_size_override("font_size", 22)
	studio_sub.add_theme_color_override("font_color", Color.WHITE)
	studio_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	studio_sub.mouse_filter = Control.MOUSE_FILTER_PASS
	splash_vbox.add_child(studio_sub)

	# Subtle "Tap to skip" prompt at bottom
	var skip_hint = Label.new()
	skip_hint.text = LANG.get(Global.current_lang, LANG["ENG"]).get("SKIP_HINT", "Geçmek için dokunun")
	skip_hint.add_theme_font_override("font", custom_font)
	skip_hint.add_theme_font_size_override("font_size", 18)
	skip_hint.add_theme_color_override("font_color", Color.WHITE)
	skip_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	skip_hint.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	skip_hint.offset_top = -48
	skip_hint.mouse_filter = Control.MOUSE_FILTER_PASS
	splash_overlay.add_child(skip_hint)

func _start_intro_sequence():
	center_panel.modulate.a = 0.0
	center_panel.scale = Vector2(0.92, 0.92)
	
	await get_tree().process_frame
	if not is_intro_active:
		return
	center_panel.pivot_offset = center_panel.size / 2.0
	
	intro_tween = create_tween()
	
	# Phase 1: Studio Splash Display (Fade In & Soft Scale)
	splash_overlay.modulate.a = 0.0
	splash_overlay.scale = Vector2(0.95, 0.95)
	splash_overlay.pivot_offset = get_viewport_rect().size / 2.0
	
	intro_tween.tween_property(splash_overlay, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	intro_tween.parallel().tween_property(splash_overlay, "scale", Vector2.ONE, 0.5)
	intro_tween.tween_interval(1.1)
	
	# Phase 2: Fade Out Studio Splash
	intro_tween.tween_property(splash_overlay, "modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Phase 3: Reveal Main Game Logo and Welcome Card
	intro_tween.tween_callback(func():
		if is_instance_valid(splash_overlay):
			splash_overlay.visible = false
		is_intro_active = false
		_reveal_main_menu()
	)

func _skip_splash():
	if not is_intro_active:
		return
	is_intro_active = false
	if intro_tween and intro_tween.is_valid():
		intro_tween.kill()
	if is_instance_valid(splash_overlay):
		splash_overlay.visible = false
	_reveal_main_menu(true)

func _reveal_main_menu(instant: bool = false):
	center_panel.pivot_offset = center_panel.size / 2.0
	
	if instant:
		center_panel.modulate.a = 1.0
		center_panel.scale = Vector2.ONE
	else:
		var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(center_panel, "modulate:a", 1.0, 0.6)
		tween.tween_property(center_panel, "scale", Vector2.ONE, 0.6)
	
	_trigger_logo_shine()
	_start_logo_idle_effects()
	_start_button_pulse()

func _trigger_logo_shine():
	shine_progress = -0.3
	var shine_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	shine_tween.tween_property(self, "shine_progress", 1.4, 0.75)
	shine_tween.tween_callback(func():
		shine_progress = -1.0
		if is_instance_valid(shine_overlay):
			shine_overlay.queue_redraw()
	)

func _start_logo_idle_effects():
	var target_node: Control = logo_frame if is_instance_valid(logo_frame) else logo_rect
	if not is_instance_valid(target_node):
		return
	
	target_node.pivot_offset = target_node.size * 0.5
	# Gentle living breath animation on the rounded-square logo frame
	var logo_tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	logo_tween.tween_property(target_node, "scale", Vector2(1.025, 1.025), 1.8)
	logo_tween.tween_property(target_node, "scale", Vector2(0.99, 0.99), 1.8)
	
	# Periodic glossy shine sweep every 4.5 seconds
	var periodic_shine = create_tween().set_loops()
	periodic_shine.tween_interval(4.5)
	periodic_shine.tween_callback(_trigger_logo_shine)

func _start_button_pulse():
	if not is_instance_valid(play_now_btn):
		return
	play_now_btn.pivot_offset = play_now_btn.size / 2.0
	var btn_tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	btn_tween.tween_property(play_now_btn, "scale", Vector2(1.015, 1.015), 1.4)
	btn_tween.tween_property(play_now_btn, "scale", Vector2(1.0, 1.0), 1.4)

func _process(delta: float) -> void:
	var s = get_viewport_rect().size
	for p in particles:
		p.pos += p.vel
		if p.pos.y < 0:
			p.pos.y = s.y
			p.pos.x = randf() * s.x
		if p.pos.x < 0: p.pos.x = s.x
		elif p.pos.x > s.x: p.pos.x = 0
	if is_instance_valid(particle_canvas):
		particle_canvas.queue_redraw()
	
	if shine_progress > -0.5 and is_instance_valid(shine_overlay):
		shine_overlay.queue_redraw()
	
	# Animated 3 dots cycling while connecting
	if is_connecting_google and is_instance_valid(gp_btn):
		connecting_dots_timer += delta
		if connecting_dots_timer >= 0.35:
			connecting_dots_timer = 0.0
			connecting_dots_count = (connecting_dots_count + 1) % 4
			var base_txt = LANG.get(Global.current_lang, LANG["ENG"])["CONNECTING"]
			var dots = ""
			for _i in range(connecting_dots_count):
				dots += "."
			_update_gp_btn_text(base_txt + dots)

func _on_play_now_pressed():
	Global.play_click()
	play_now_btn.disabled = true
	if Global.login_method != "google":
		Global.login_method = "guest"
	Global.save_progression()
	goto_main_menu()

func _on_google_play_pressed():
	Global.play_click()
	if is_connecting_google: return
	is_connecting_google = true
	connecting_dots_count = 0
	connecting_dots_timer = 0.0
	gp_btn.disabled = true
	var base_txt = LANG.get(Global.current_lang, LANG["ENG"])["CONNECTING"]
	_update_gp_btn_text(base_txt)
	
	# Fallback timeout: if user cancels prompt or service fails, reset after 10s
	get_tree().create_timer(10.0).timeout.connect(func():
		if is_connecting_google:
			print("[Welcome] Google Play sign-in timed out or dismissed.")
			_on_sign_in_failed()
	)
	
	if sign_in_client and sign_in_client.has_method("sign_in"):
		sign_in_client.sign_in()
	elif Engine.has_singleton("GodotPlayGameServices"):
		var gps = Engine.get_singleton("GodotPlayGameServices")
		if gps.has_method("signIn"):
			gps.signIn()
		else:
			await get_tree().create_timer(1.2).timeout
			_on_sign_in_result(true, true)
	else:
		# PC / Debug fallback: simulate connecting animation for a brief moment then proceed
		await get_tree().create_timer(1.2).timeout
		_on_sign_in_result(true, true)

func _update_gp_btn_text(new_text: String, new_icon_path: String = ""):
	if not is_instance_valid(gp_btn): return
	var gp_lbl = gp_btn.get_node_or_null("GPHBox/GPLabel") as Label
	if is_instance_valid(gp_lbl):
		gp_lbl.text = new_text
	else:
		gp_btn.text = new_text
	if new_icon_path != "":
		var gp_icon = gp_btn.get_node_or_null("GPHBox/GPIcon") as TextureRect
		if is_instance_valid(gp_icon) and ResourceLoader.exists(new_icon_path):
			gp_icon.texture = load(new_icon_path)

func _set_gp_btn_connected(animate: bool = false):
	if not is_instance_valid(gp_btn): return
	_update_gp_btn_text(LANG.get(Global.current_lang, LANG["ENG"]).get("PLAY_CONNECTED", "Google Play Bağlandı"), "res://checkmark_icon.svg")
	gp_btn.disabled = true
	var gp_lbl = gp_btn.get_node_or_null("GPHBox/GPLabel") as Label
	if is_instance_valid(gp_lbl):
		gp_lbl.add_theme_color_override("font_color", Color8(110, 255, 150))
	var gp_conn_style = StyleBoxFlat.new()
	gp_conn_style.bg_color = Color8(14, 65, 42, 238)
	gp_conn_style.corner_radius_top_left = 14; gp_conn_style.corner_radius_top_right = 14
	gp_conn_style.corner_radius_bottom_left = 14; gp_conn_style.corner_radius_bottom_right = 14
	gp_conn_style.border_width_left = 2; gp_conn_style.border_width_right = 2
	gp_conn_style.border_width_top = 2; gp_conn_style.border_width_bottom = 4
	gp_conn_style.border_color = Color8(24, 165, 98)
	gp_btn.add_theme_stylebox_override("normal", gp_conn_style)
	gp_btn.add_theme_stylebox_override("hover", gp_conn_style)
	gp_btn.add_theme_stylebox_override("pressed", gp_conn_style)
	gp_btn.add_theme_stylebox_override("disabled", gp_conn_style)
	gp_btn.add_theme_color_override("font_disabled_color", Color8(110, 255, 150))
	if animate:
		gp_btn.pivot_offset = gp_btn.size / 2.0
		var pop_tw = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		pop_tw.tween_property(gp_btn, "scale", Vector2(1.06, 1.06), 0.16)
		pop_tw.tween_property(gp_btn, "scale", Vector2.ONE, 0.14)

func _on_sign_in_result(is_authenticated: bool, is_manual_click: bool = false):
	var was_manual = is_connecting_google or is_manual_click
	is_connecting_google = false
	if is_authenticated:
		Global.login_method = "google"
		Global.save_progression()
		_set_gp_btn_connected(true)
		if was_manual:
			await get_tree().create_timer(0.85).timeout
			goto_main_menu()
	else:
		_on_sign_in_failed()

func _on_sign_in_failed(_arg = null):
	is_connecting_google = false
	if is_instance_valid(gp_btn):
		var gp_lbl = gp_btn.get_node_or_null("GPHBox/GPLabel") as Label
		if is_instance_valid(gp_lbl):
			gp_lbl.add_theme_color_override("font_color", Color.WHITE)
		_update_gp_btn_text(LANG.get(Global.current_lang, LANG["ENG"])["LOGIN_PLAY"], "res://google_play_logo.svg")
		gp_btn.disabled = false

func goto_main_menu():
	Global.change_scene_with_loading("res://main_menu.tscn")

func _cycle_language():
	Global.play_click()
	var cur_idx = LANG_CYCLE.find(Global.current_lang)
	if cur_idx == -1: cur_idx = 0
	var next_idx = (cur_idx + 1) % LANG_CYCLE.size()
	Global.current_lang = LANG_CYCLE[next_idx]
	Global.save_progression()
	_update_language_texts()

func _update_language_texts():
	var lang_data = LANG.get(Global.current_lang, LANG["ENG"])
	if is_instance_valid(title_lbl):
		title_lbl.text = lang_data["TITLE"]
	if is_instance_valid(subtitle_lbl):
		subtitle_lbl.text = lang_data["SUBTITLE"]
	if is_instance_valid(play_now_btn):
		play_now_btn.text = lang_data["PLAY_NOW"]
	if is_instance_valid(gp_btn):
		if Global.login_method == "google":
			_set_gp_btn_connected(false)
		else:
			_update_gp_btn_text(lang_data["LOGIN_PLAY"], "res://google_play_logo.svg")
	if is_instance_valid(privacy_btn):
		privacy_btn.text = lang_data["PRIVACY"]
	if is_instance_valid(lang_btn):
		lang_btn.text = " " + LANG_DISPLAY.get(Global.current_lang, "TR")

func refresh_ui_texts():
	_update_language_texts()

func _on_play_pressed():
	_on_play_now_pressed()

func _on_gpgs_pressed():
	_on_google_play_pressed()

func _on_privacy_pressed():
	_show_privacy_policy()

func _on_lang_pressed():
	_cycle_language()

func _update_gpgs_btn_state():
	if Global.login_method == "google":
		_set_gp_btn_connected(false)
	else:
		var lang_data = LANG.get(Global.current_lang, LANG["ENG"])
		_update_gp_btn_text(lang_data["LOGIN_PLAY"], "res://google_play_logo.svg")

func _show_privacy_policy():
	Global.play_click()
	OS.shell_open("https://ebstudyo.com/privacy.html")

func _close_privacy_policy():
	pass
