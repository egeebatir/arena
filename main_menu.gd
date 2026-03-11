extends Control

var custom_font = preload("res://IMPACT.TTF")

var LANG = {
	"TR": {
		"TEAM_SELECTION": "TAKIM SEÇİMİ", "SETTINGS": "AYARLAR",
		"HOME": "EV SAHİBİ", "AWAY": "DEPLASMAN", "SEARCH": "Takım Ara...",
		"START_MATCH": "MAÇI BAŞLAT", "LANG_BTN": "TR", "CLOSE": "KAPAT", "SAVE": "KAYDET",
		"LBL_MASTER": "GENEL SES", "LBL_MENU_MUSIC": "MENÜ MÜZİĞİ", "LBL_STADIUM": "STADYUM", "LBL_MUSIC": "GOL MÜZİĞİ",
		"LBL_COLLISION": "TOP ÇARPMA", "LBL_WHISTLE": "DÜDÜK",
		"LBL_THEME": "TEMA SEÇİMİ", "LBL_SHAKE": "EKRAN TİTREŞİMİ", "LBL_SPEED": "MAÇ SÜRESİ",
		"SEC_THEME": "TEMA AYARLARI", "SEC_GAME": "OYUN AYARLARI", "SEC_AUDIO": "SES AYARLARI",
		"REPLAY_ASK": "Aynı maçı tekrar oynatmak istediğinize emin misiniz?"
	},
	"ENG": {
		"TEAM_SELECTION": "TEAM SELECTION", "SETTINGS": "SETTINGS",
		"HOME": "HOME", "AWAY": "AWAY", "SEARCH": "Search Team...",
		"START_MATCH": "START MATCH", "LANG_BTN": "ENG", "CLOSE": "CLOSE", "SAVE": "SAVE",
		"LBL_MASTER": "MASTER VOL", "LBL_MENU_MUSIC": "MENU MUSIC", "LBL_STADIUM": "STADIUM", "LBL_MUSIC": "GOAL MUSIC",
		"LBL_COLLISION": "COLLISION", "LBL_WHISTLE": "WHISTLE",
		"LBL_THEME": "SELECT THEME", "LBL_SHAKE": "SCREEN SHAKE", "LBL_SPEED": "MATCH DURATION",
		"SEC_THEME": "THEME", "SEC_GAME": "GAME SETTINGS", "SEC_AUDIO": "AUDIO SETTINGS",
		"REPLAY_ASK": "Are you sure you want to replay the exact same match?"
	},
	"ESP": {
		"TEAM_SELECTION": "SELECCIÓN DE EQUIPO", "SETTINGS": "AJUSTES",
		"HOME": "LOCAL", "AWAY": "VISITANTE", "SEARCH": "Buscar...",
		"START_MATCH": "INICIAR PARTIDO", "LANG_BTN": "ESP", "CLOSE": "CERRAR", "SAVE": "GUARDAR",
		"LBL_MASTER": "VOL MAESTRO", "LBL_MENU_MUSIC": "MÚSICA DEL MENÚ", "LBL_STADIUM": "ESTADIO", "LBL_MUSIC": "MÚSICA",
		"LBL_COLLISION": "COLISIÓN", "LBL_WHISTLE": "SILBATO",
		"LBL_THEME": "TEMA", "LBL_SHAKE": "VIBRACIÓN", "LBL_SPEED": "DURACIÓN",
		"SEC_THEME": "TEMA", "SEC_GAME": "AJUSTES DE JUEGO", "SEC_AUDIO": "AUDIO",
		"REPLAY_ASK": "¿Estás seguro de que quieres volver a jugar el mismo partido?"
	},
	"POR": {
		"TEAM_SELECTION": "SELEÇÃO DE EQUIPA", "SETTINGS": "DEFINIÇÕES",
		"HOME": "CASA", "AWAY": "FORA", "SEARCH": "Pesquisar...",
		"START_MATCH": "INICIAR JOGO", "LANG_BTN": "POR", "CLOSE": "FECHAR", "SAVE": "GUARDAR",
		"LBL_MASTER": "VOL PRINCIPAL", "LBL_MENU_MUSIC": "MÚSICA DO MENU", "LBL_STADIUM": "ESTÁDIO", "LBL_MUSIC": "MÚSICA",
		"LBL_COLLISION": "COLISÃO", "LBL_WHISTLE": "APITO",
		"LBL_THEME": "TEMA", "LBL_SHAKE": "VIBRAÇÃO", "LBL_SPEED": "DURAÇÃO",
		"SEC_THEME": "TEMA", "SEC_GAME": "CONFIGURAÇÕES DE JOGO", "SEC_AUDIO": "ÁUDIO",
		"REPLAY_ASK": "Tem certeza de que quer jogar a mesma partida?"
	}
}

var white = Color.WHITE
var neon_green = Color8(57, 255, 20)
var glass_panel = Color8(25, 35, 55, 200)
var header_glass = Color8(20, 30, 45, 180)

var TEAM_NAMES = []
var search_bar_home: LineEdit
var search_bar_away: LineEdit
var league_dropdown_home: OptionButton
var league_dropdown_away: OptionButton
var home_list: VBoxContainer
var away_list: VBoxContainer
var settings_overlay: ColorRect
var ui_labels = []
var burger_popup: PopupMenu

var home_preview: Control
var away_preview: Control

var active_theme: Dictionary
var bg_grad: Gradient

var temp_settings = {}
var start_match_btn: Button
var top_stripe_panel: PanelContainer
var main_scroll: ScrollContainer

func _ready():
	Engine.time_scale = 1.0 
	
	if is_instance_valid(Global.bg_music_player) and not Global.bg_music_player.playing:
		Global.bg_music_player.play()
	
	var bg = TextureRect.new()
	bg_grad = Gradient.new()
	var grad_tex = GradientTexture2D.new()
	grad_tex.gradient = bg_grad
	grad_tex.fill_from = Vector2(0, 0)
	grad_tex.fill_to = Vector2(0, 1)
	grad_tex.width = 64 
	grad_tex.height = 64
	bg.texture = grad_tex
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	
	active_theme = Global.THEMES[Global.current_theme]
	bg_grad.set_color(0, active_theme.bg_top)
	bg_grad.set_color(1, active_theme.bg_bottom)
	
	var main_margin = MarginContainer.new()
	main_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_margin.add_theme_constant_override("margin_top", -150)
	main_margin.add_theme_constant_override("margin_bottom", 40)
	main_margin.add_theme_constant_override("margin_left", 20)
	main_margin.add_theme_constant_override("margin_right", 20)
	add_child(main_margin)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_vbox.add_theme_constant_override("separation", 25)
	main_margin.add_child(main_vbox)
	
	# --- ÜST BAR (Aşağı Kaymış Oldu) ---
	var top_hbox = HBoxContainer.new()
	top_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	top_hbox.custom_minimum_size = Vector2(660, 0)
	main_vbox.add_child(top_hbox)
	
	var btn_style = StyleBoxFlat.new()
	btn_style.bg_color = Color(0, 0, 0, 0)
	
	var lang_box = HBoxContainer.new()
	lang_box.alignment = BoxContainer.ALIGNMENT_CENTER
	top_hbox.add_child(lang_box)
	
	var lang_btn = Button.new()
	var lang_icon = preload("res://languageicon.svg")
	lang_btn.icon = lang_icon
	lang_btn.text = " " + Global.current_lang
	lang_btn.add_theme_font_override("font", custom_font)
	lang_btn.add_theme_font_size_override("font_size", 35)
	lang_btn.add_theme_color_override("font_color", white)
	lang_btn.add_theme_color_override("font_shadow_color", Color8(0,0,0,100))
	lang_btn.add_theme_constant_override("shadow_offset_y", 2)
	lang_btn.expand_icon = true
	lang_btn.add_theme_constant_override("icon_max_width", 50)
	lang_btn.custom_minimum_size = Vector2(120, 70)
	lang_btn.add_theme_stylebox_override("normal", btn_style)
	lang_btn.add_theme_stylebox_override("hover", btn_style)
	lang_btn.add_theme_stylebox_override("pressed", btn_style)
	lang_btn.add_theme_stylebox_override("focus", btn_style)
	lang_box.add_child(lang_btn)
	
	ui_labels.append({"node": lang_btn, "key": "LANG_BTN", "type": "button"})
	
	var lang_popup = PopupMenu.new()
	lang_popup.add_theme_font_override("font", custom_font)
	lang_popup.add_theme_font_size_override("font_size", 40)
	var popup_style = StyleBoxFlat.new()
	popup_style.bg_color = Color8(20, 30, 45, 230)
	popup_style.corner_radius_top_left = 10; popup_style.corner_radius_top_right = 10
	popup_style.corner_radius_bottom_left = 10; popup_style.corner_radius_bottom_right = 10
	lang_popup.add_theme_stylebox_override("panel", popup_style)
	lang_popup.add_item("TR", 0)
	lang_popup.add_item("ENG", 1)
	lang_popup.add_item("ESP", 2)
	lang_popup.add_item("POR", 3)
	add_child(lang_popup)
	
	lang_btn.pressed.connect(func():
		lang_popup.position = Vector2(lang_btn.global_position.x, lang_btn.global_position.y + 70)
		lang_popup.popup()
	)
	
	lang_popup.id_pressed.connect(func(id):
		if id == 0: Global.current_lang = "TR"
		elif id == 1: Global.current_lang = "ENG"
		elif id == 2: Global.current_lang = "ESP"
		elif id == 3: Global.current_lang = "POR"
		lang_btn.text = " " + Global.current_lang
		
		for item in ui_labels:
			if is_instance_valid(item.node):
				if item.type == "label" or item.type == "button":
					item.node.text = LANG[Global.current_lang][item.key]
				elif item.type == "placeholder":
					item.node.placeholder_text = LANG[Global.current_lang][item.key]
				elif item.type == "popup_item":
					item.node.set_item_text(item.item_idx, LANG[Global.current_lang][item.key])
		setup_filters() 
	)
	
	var spacer1 = Control.new(); spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(spacer1)
	
	var title_lbl = create_label_node("TEAM_SELECTION", white, 55)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	title_lbl.add_theme_constant_override("shadow_offset_y", 4)
	top_hbox.add_child(title_lbl)
	
	var spacer2 = Control.new(); spacer2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hbox.add_child(spacer2)
	
	var burger_btn = Button.new()
	burger_btn.icon = preload("res://menuburgericon.svg")
	burger_btn.expand_icon = true
	burger_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	burger_btn.custom_minimum_size = Vector2(60, 60)
	burger_btn.add_theme_stylebox_override("normal", btn_style)
	burger_btn.add_theme_stylebox_override("hover", btn_style)
	burger_btn.add_theme_stylebox_override("pressed", btn_style)
	burger_btn.add_theme_stylebox_override("focus", btn_style)
	
	burger_popup = PopupMenu.new()
	burger_popup.add_theme_font_override("font", custom_font)
	burger_popup.add_theme_font_size_override("font_size", 35)
	var b_popup_style = StyleBoxFlat.new()
	b_popup_style.bg_color = header_glass
	b_popup_style.corner_radius_top_left = 10; b_popup_style.corner_radius_top_right = 10
	b_popup_style.corner_radius_bottom_left = 10; b_popup_style.corner_radius_bottom_right = 10
	b_popup_style.border_width_bottom = 3
	b_popup_style.border_color = active_theme.accent.darkened(0.5)
	b_popup_style.content_margin_left = 20
	b_popup_style.content_margin_right = 20
	b_popup_style.content_margin_top = 15
	b_popup_style.content_margin_bottom = 15
	burger_popup.add_theme_stylebox_override("panel", b_popup_style)
	burger_popup.add_theme_constant_override("icon_max_width", 40)
	burger_popup.add_theme_constant_override("item_start_padding", 10)
	burger_popup.add_theme_constant_override("item_end_padding", 10)
	burger_popup.add_icon_item(preload("res://settingsicon.svg"), LANG[Global.current_lang]["SETTINGS"], 0)
	ui_labels.append({"node": burger_popup, "key": "SETTINGS", "type": "popup_item", "item_idx": 0})
	add_child(burger_popup)
	
	burger_btn.pressed.connect(func():
		var p_size = burger_popup.get_contents_minimum_size()
		burger_popup.position = Vector2(burger_btn.global_position.x + burger_btn.size.x - p_size.x, burger_btn.global_position.y + burger_btn.size.y + 10)
		burger_popup.popup()
	)
	burger_popup.id_pressed.connect(func(id):
		if id == 0: _open_settings()
	)
	top_hbox.add_child(burger_btn)
	
	# --- YENİ HAVALI LİSTE PANELİ ---
	var list_panel = PanelContainer.new()
	var lp_style = StyleBoxFlat.new()
	lp_style.bg_color = Color(0,0,0,0)
	list_panel.add_theme_stylebox_override("panel", lp_style)
	list_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	main_vbox.add_child(list_panel)
	
	var header_offset_hbox = HBoxContainer.new()
	header_offset_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_offset_hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	list_panel.add_child(header_offset_hbox)
	
	var main_cols_hbox = HBoxContainer.new()
	main_cols_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_cols_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	main_cols_hbox.add_theme_constant_override("separation", 20) # Decreased gap by 10px
	header_offset_hbox.add_child(main_cols_hbox)
	
	var home_col = VBoxContainer.new()
	home_col.custom_minimum_size = Vector2(320, 0)
	home_col.add_theme_constant_override("separation", 0) 
	main_cols_hbox.add_child(home_col)
	
	var away_col = VBoxContainer.new()
	away_col.custom_minimum_size = Vector2(320, 0)
	away_col.add_theme_constant_override("separation", 0)
	main_cols_hbox.add_child(away_col)
	
	# Pushing headers to exactly align over the scrolled items:
	var scroll_compensator = Control.new()
	scroll_compensator.custom_minimum_size = Vector2(25, 0) # Just scrollbar width compensation
	header_offset_hbox.add_child(scroll_compensator)
	
	# --- BAŞLIKLAR & FİLTRELER (Artık Sütunlara Dahil) ---
	var home_lbl = create_label_node("HOME", Color.WHITE, 45)
	home_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	home_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	home_lbl.add_theme_constant_override("shadow_offset_y", 4)
	var h_lbl_margin = MarginContainer.new()
	h_lbl_margin.add_theme_constant_override("margin_left", 20)
	h_lbl_margin.add_child(home_lbl)
	home_col.add_child(h_lbl_margin)
	
	var away_lbl = create_label_node("AWAY", Color.WHITE, 45)
	away_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	away_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	away_lbl.add_theme_constant_override("shadow_offset_y", 4)
	var a_lbl_margin = MarginContainer.new()
	a_lbl_margin.add_theme_constant_override("margin_left", 20)
	a_lbl_margin.add_child(away_lbl)
	away_col.add_child(a_lbl_margin)
	
	# Spacer between HOME and preview
	var s_hp = Control.new(); s_hp.custom_minimum_size = Vector2(0, 30); home_col.add_child(s_hp)
	var s_ap = Control.new(); s_ap.custom_minimum_size = Vector2(0, 30); away_col.add_child(s_ap)
	
	var h_preview_cont = CenterContainer.new()
	h_preview_cont.custom_minimum_size = Vector2(320, 110)
	home_col.add_child(h_preview_cont)
	home_preview = Control.new()
	home_preview.custom_minimum_size = Vector2(108, 108)
	home_preview.draw.connect(func(): draw_ball_preview(home_preview, true))
	h_preview_cont.add_child(home_preview)
	
	var a_preview_cont = CenterContainer.new()
	a_preview_cont.custom_minimum_size = Vector2(320, 110)
	away_col.add_child(a_preview_cont)
	away_preview = Control.new()
	away_preview.custom_minimum_size = Vector2(108, 108)
	away_preview.draw.connect(func(): draw_ball_preview(away_preview, false))
	a_preview_cont.add_child(away_preview)
	
	# Gap between balls and filters
	var s_hf2 = Control.new(); s_hf2.custom_minimum_size = Vector2(0, 20); home_col.add_child(s_hf2)
	var s_af2 = Control.new(); s_af2.custom_minimum_size = Vector2(0, 20); away_col.add_child(s_af2)
	
	var filter_style = StyleBoxFlat.new()
	filter_style.bg_color = header_glass
	filter_style.corner_radius_top_left = 12; filter_style.corner_radius_top_right = 12
	filter_style.corner_radius_bottom_left = 12; filter_style.corner_radius_bottom_right = 12
	filter_style.border_width_bottom = 3
	filter_style.border_color = active_theme.accent.darkened(0.5)
	filter_style.content_margin_left = 20; filter_style.content_margin_right = 20
	
	var arrow_empty = ImageTexture.create_from_image(Image.create_empty(1, 1, false, Image.FORMAT_RGBA8))
	
	league_dropdown_home = OptionButton.new()
	league_dropdown_home.custom_minimum_size = Vector2(320, 60)
	league_dropdown_home.add_theme_font_override("font", custom_font)
	league_dropdown_home.add_theme_font_size_override("font_size", 32)
	league_dropdown_home.add_theme_stylebox_override("normal", filter_style)
	league_dropdown_home.add_theme_stylebox_override("hover", filter_style)
	league_dropdown_home.add_theme_stylebox_override("pressed", filter_style)
	league_dropdown_home.add_theme_icon_override("arrow", arrow_empty)
	var lg_h_margin = MarginContainer.new()
	lg_h_margin.add_theme_constant_override("margin_left", 30) # Push +30px right
	lg_h_margin.add_theme_constant_override("margin_bottom", 15)
	lg_h_margin.add_child(league_dropdown_home)
	home_col.add_child(lg_h_margin)
	league_dropdown_home.item_selected.connect(_on_filter_changed)
	
	league_dropdown_away = OptionButton.new()
	league_dropdown_away.custom_minimum_size = Vector2(320, 60)
	league_dropdown_away.add_theme_font_override("font", custom_font)
	league_dropdown_away.add_theme_font_size_override("font_size", 32)
	league_dropdown_away.add_theme_stylebox_override("normal", filter_style)
	league_dropdown_away.add_theme_stylebox_override("hover", filter_style)
	league_dropdown_away.add_theme_stylebox_override("pressed", filter_style)
	league_dropdown_away.add_theme_icon_override("arrow", arrow_empty)
	var lg_a_margin = MarginContainer.new()
	lg_a_margin.add_theme_constant_override("margin_left", 30) # Push +30px right
	lg_a_margin.add_theme_constant_override("margin_bottom", 15)
	lg_a_margin.add_child(league_dropdown_away)
	away_col.add_child(lg_a_margin)
	league_dropdown_away.item_selected.connect(_on_filter_changed)
	
	search_bar_home = LineEdit.new()
	search_bar_home.custom_minimum_size = Vector2(320, 60)
	search_bar_home.add_theme_font_override("font", custom_font)
	search_bar_home.add_theme_font_size_override("font_size", 32)
	search_bar_home.add_theme_stylebox_override("normal", filter_style)
	search_bar_home.add_theme_stylebox_override("focus", filter_style)
	search_bar_home.text_changed.connect(_on_filter_changed)
	ui_labels.append({"node": search_bar_home, "key": "SEARCH", "type": "placeholder"})
	var sb_h_margin = MarginContainer.new()
	sb_h_margin.add_theme_constant_override("margin_left", 30) # Push +30px right
	sb_h_margin.add_theme_constant_override("margin_bottom", 10)
	sb_h_margin.add_child(search_bar_home)
	home_col.add_child(sb_h_margin)
	
	search_bar_away = LineEdit.new()
	search_bar_away.custom_minimum_size = Vector2(320, 60)
	search_bar_away.add_theme_font_override("font", custom_font)
	search_bar_away.add_theme_font_size_override("font_size", 32)
	search_bar_away.add_theme_stylebox_override("normal", filter_style)
	search_bar_away.add_theme_stylebox_override("focus", filter_style)
	search_bar_away.text_changed.connect(_on_filter_changed)
	ui_labels.append({"node": search_bar_away, "key": "SEARCH", "type": "placeholder"})
	var sb_a_margin = MarginContainer.new()
	sb_a_margin.add_theme_constant_override("margin_left", 30) # Push +30px right
	sb_a_margin.add_theme_constant_override("margin_bottom", 10)
	sb_a_margin.add_child(search_bar_away)
	away_col.add_child(sb_a_margin)
	
	setup_filters()
	
	# Scroll container for lists ONLY
	var scroll_both = ScrollContainer.new()
	scroll_both.name = "ScrollContainer"
	scroll_both.custom_minimum_size = Vector2(685, 710) # 8 teams
	scroll_both.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll_both.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	var v_sc = scroll_both.get_v_scroll_bar()
	v_sc.custom_minimum_size.x = 25
	
	var sb_style = StyleBoxFlat.new(); sb_style.bg_color = Color.TRANSPARENT
	var gb_style = StyleBoxFlat.new(); gb_style.bg_color = active_theme.accent.darkened(0.2)
	gb_style.corner_radius_top_left = 8; gb_style.corner_radius_top_right = 8
	gb_style.corner_radius_bottom_left = 8; gb_style.corner_radius_bottom_right = 8
	v_sc.add_theme_stylebox_override("scroll", sb_style)
	v_sc.add_theme_stylebox_override("grabber", gb_style)
	v_sc.add_theme_stylebox_override("grabber_highlight", gb_style)
	v_sc.add_theme_stylebox_override("grabber_pressed", gb_style)
	
	main_vbox.add_child(scroll_both)
	main_scroll = scroll_both
	
	var lists_hbox = HBoxContainer.new()
	lists_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lists_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	lists_hbox.add_theme_constant_override("separation", 30) # Increased gap by 10px
	scroll_both.add_child(lists_hbox)
	
	home_list = VBoxContainer.new()
	home_list.mouse_filter = Control.MOUSE_FILTER_PASS
	home_list.custom_minimum_size = Vector2(320, 0)
	home_list.add_theme_constant_override("separation", 10)
	lists_hbox.add_child(home_list)
	
	away_list = VBoxContainer.new()
	away_list.mouse_filter = Control.MOUSE_FILTER_PASS
	away_list.custom_minimum_size = Vector2(320, 0)
	away_list.add_theme_constant_override("separation", 10)
	lists_hbox.add_child(away_list)
	
	TEAM_NAMES = Global.TEAMS.keys()
	populate_teams()
	
	# --- BAŞLA BUTONU (Hemen Altında) ---
	# Yaratılış sırasında ismi atlayalım, global değişkene referans atalım. (İsterseniz globalden direkt çekebilirsiniz)
	var start_btn = Button.new()
	start_btn.name = "StartMatchButton"
	start_btn.text = LANG[Global.current_lang]["START_MATCH"]
	start_btn.add_theme_font_override("font", custom_font)
	start_btn.add_theme_font_size_override("font_size", 50)
	start_btn.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	start_btn.add_theme_constant_override("shadow_offset_y", 4)
	start_btn.custom_minimum_size = Vector2(660, 90)
	start_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	start_btn.add_theme_color_override("font_color", Color8(250, 250, 250))
	
	var s_style = StyleBoxFlat.new()
	s_style.bg_color = active_theme.bg_top
	s_style.corner_radius_top_left = 20; s_style.corner_radius_top_right = 20
	s_style.corner_radius_bottom_left = 20; s_style.corner_radius_bottom_right = 20
	start_btn.add_theme_stylebox_override("normal", s_style)
	
	start_btn.pressed.connect(_on_start_match)
	main_vbox.add_child(start_btn)
	ui_labels.append({"node": start_btn, "key": "START_MATCH", "type": "button"})
	start_match_btn = start_btn
	
	temp_settings["master_vol"] = Global.master_vol
	temp_settings["vol_settings"] = Global.vol_settings.duplicate()
	temp_settings["shake_enabled"] = Global.shake_enabled
	temp_settings["match_duration"] = Global.match_duration
	temp_settings["current_theme"] = Global.current_theme
	
	setup_settings_overlay()

func update_theme_visuals():
	active_theme = Global.THEMES[Global.current_theme]
	bg_grad.set_color(0, active_theme.bg_top)
	bg_grad.set_color(1, active_theme.bg_bottom)
	
	if is_instance_valid(burger_popup):
		var b_style = burger_popup.get_theme_stylebox("panel")
		if b_style is StyleBoxFlat:
			b_style.border_color = active_theme.accent.darkened(0.5)
			burger_popup.add_theme_stylebox_override("panel", b_style)

	
	var filter_style = StyleBoxFlat.new()
	filter_style.bg_color = header_glass
	filter_style.corner_radius_top_left = 12; filter_style.corner_radius_top_right = 12
	filter_style.corner_radius_bottom_left = 12; filter_style.corner_radius_bottom_right = 12
	filter_style.border_width_bottom = 3
	filter_style.border_color = active_theme.accent.darkened(0.5)
	filter_style.content_margin_left = 20; filter_style.content_margin_right = 20
	
	if league_dropdown_home: league_dropdown_home.add_theme_stylebox_override("normal", filter_style)
	if league_dropdown_away: league_dropdown_away.add_theme_stylebox_override("normal", filter_style)
	if search_bar_home: search_bar_home.add_theme_stylebox_override("normal", filter_style)
	if search_bar_away: search_bar_away.add_theme_stylebox_override("normal", filter_style)
	
	if is_instance_valid(start_match_btn):
		var s_style = start_match_btn.get_theme_stylebox("normal")
		if s_style is StyleBoxFlat:
			s_style.bg_color = active_theme.bg_top
			
			if Global.current_theme == "Buz":
				start_match_btn.add_theme_color_override("font_color", Color.BLACK)
				start_match_btn.add_theme_color_override("font_shadow_color", Color8(255, 255, 255, 150))
				s_style.border_width_bottom = 6; s_style.border_width_top = 3
				s_style.border_width_left = 3; s_style.border_width_right = 3
				s_style.border_color = Color8(0, 0, 0, 200)
			else:
				start_match_btn.add_theme_color_override("font_color", Color.WHITE)
				start_match_btn.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
				s_style.border_width_bottom = 0; s_style.border_width_top = 0
				s_style.border_width_left = 0; s_style.border_width_right = 0
				
			start_match_btn.add_theme_stylebox_override("normal", s_style)
			start_match_btn.add_theme_stylebox_override("hover", s_style)
			start_match_btn.add_theme_stylebox_override("pressed", s_style)
			start_match_btn.add_theme_stylebox_override("focus", s_style)

	if is_instance_valid(main_scroll):
		var v_sc = main_scroll.get_v_scroll_bar()
		var gb_style = v_sc.get_theme_stylebox("grabber")
		if gb_style is StyleBoxFlat:
			gb_style.bg_color = active_theme.accent.darkened(0.2)
			v_sc.add_theme_stylebox_override("grabber", gb_style)
			v_sc.add_theme_stylebox_override("grabber_highlight", gb_style)
			v_sc.add_theme_stylebox_override("grabber_pressed", gb_style)
	
	if home_list != null and away_list != null:
		populate_teams()

func _open_settings():
	temp_settings["master_vol"] = Global.master_vol
	temp_settings["vol_settings"] = Global.vol_settings.duplicate()
	temp_settings["shake_enabled"] = Global.shake_enabled
	temp_settings["match_duration"] = Global.match_duration
	temp_settings["current_theme"] = Global.current_theme
	
	if is_instance_valid(settings_overlay):
		settings_overlay.queue_free()
	
	setup_settings_overlay()
	settings_overlay.visible = true

# --- AYARLAR EKRANI (660px Genişliğe Sabitlendi) ---
func setup_settings_overlay():
	settings_overlay = ColorRect.new()
	settings_overlay.color = Color8(0, 0, 0, 0) 
	settings_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_overlay.visible = false
	add_child(settings_overlay)
	
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.position.y += 30.0 # Shifted settings down by 30 pixels
	settings_overlay.add_child(center_container)
	
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(660, 0) # TAKIM LİSTESİYLE AYNI GENİŞLİK
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = Color8(15, 25, 35, 245)
	p_style.corner_radius_top_left = 25; p_style.corner_radius_top_right = 25
	p_style.corner_radius_bottom_left = 25; p_style.corner_radius_bottom_right = 25
	p_style.shadow_color = Color8(0, 0, 0, 200)
	p_style.shadow_size = 40
	p_style.border_width_top = 4; p_style.border_width_bottom = 4
	p_style.border_width_left = 4; p_style.border_width_right = 4
	p_style.border_color = active_theme.accent
	p_style.content_margin_left = 30; p_style.content_margin_right = 30
	p_style.content_margin_top = 30; p_style.content_margin_bottom = 40
	panel.add_theme_stylebox_override("panel", p_style)
	center_container.add_child(panel)
	
	var s_vbox = VBoxContainer.new()
	s_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	s_vbox.add_theme_constant_override("separation", 20)
	panel.add_child(s_vbox)
	
	# Make a distinct top bar for AYARLAR inside the window
	var window_title_bg = PanelContainer.new()
	var wtb_style = StyleBoxFlat.new()
	wtb_style.bg_color = Color8(5, 15, 25, 255)
	wtb_style.corner_radius_top_left = 20; wtb_style.corner_radius_top_right = 20
	wtb_style.corner_radius_bottom_left = 20; wtb_style.corner_radius_bottom_right = 20
	wtb_style.content_margin_top = 15; wtb_style.content_margin_bottom = 15
	window_title_bg.add_theme_stylebox_override("panel", wtb_style)
	s_vbox.add_child(window_title_bg)
	
	var s_title = create_label_node("SETTINGS", white, 55)
	s_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	window_title_bg.add_child(s_title)
	
	var scroll = ScrollContainer.new()
	var screen_h = get_viewport_rect().size.y
	scroll.custom_minimum_size = Vector2(600, min(800.0, screen_h * 0.65)) 
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER 
	s_vbox.add_child(scroll)
	
	var scroll_vbox = VBoxContainer.new()
	scroll_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_vbox.add_theme_constant_override("separation", 40)
	scroll.add_child(scroll_vbox)
	
	# SECTION 1: TEMA
	add_section_header(scroll_vbox, "SEC_THEME")
	var theme_grid = GridContainer.new()
	theme_grid.columns = 6
	theme_grid.add_theme_constant_override("h_separation", 20)
	theme_grid.add_theme_constant_override("v_separation", 25)
	scroll_vbox.add_child(theme_grid)
	
	for theme_name in Global.THEMES.keys():
		var t_color = Global.THEMES[theme_name].pitch_1
		var t_color2 = Global.THEMES[theme_name].pitch_2
		var t_btn = Button.new()
		var t_style = StyleBoxFlat.new()
		t_style.bg_color = t_color
		t_style.border_width_left = 8; t_style.border_width_right = 8
		t_style.border_width_top = 8; t_style.border_width_bottom = 8
		t_style.border_color = t_color2
		t_style.corner_radius_top_left = 10; t_style.corner_radius_top_right = 10
		t_style.corner_radius_bottom_left = 10; t_style.corner_radius_bottom_right = 10
		
		# Current theme highlight check with buffered property
		if temp_settings["current_theme"] == theme_name:
			t_style.border_color = Color.WHITE
		else:
			t_style.border_color = t_color2.lightened(0.3)
		
		t_btn.add_theme_stylebox_override("normal", t_style)
		t_btn.add_theme_stylebox_override("hover", t_style)
		t_btn.add_theme_stylebox_override("pressed", t_style)
		t_btn.custom_minimum_size = Vector2(80, 80)
		t_btn.pressed.connect(func():
			temp_settings["current_theme"] = theme_name
			# Rebuild the overlay quickly to show selected outline outline update
			settings_overlay.queue_free()
			setup_settings_overlay()
			settings_overlay.visible = true
		)
		theme_grid.add_child(t_btn)
	
	# SECTION 2: OYUN AYARLARI
	add_section_header(scroll_vbox, "SEC_GAME")
	var game_vbox = VBoxContainer.new()
	game_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	game_vbox.add_theme_constant_override("separation", 30)
	scroll_vbox.add_child(game_vbox)
	add_magnetic_slider_to_vbox(game_vbox, "SPEED", "LBL_SPEED", temp_settings["match_duration"])
	add_centered_toggle_to_vbox(game_vbox, "SHAKE", "LBL_SHAKE", temp_settings["shake_enabled"])
	
	# SECTION 3: SES
	add_section_header(scroll_vbox, "SEC_AUDIO")
	var audio_grid = GridContainer.new(); audio_grid.columns = 2
	audio_grid.add_theme_constant_override("h_separation", 20)
	audio_grid.add_theme_constant_override("v_separation", 25)
	scroll_vbox.add_child(audio_grid)
	add_slider_to_grid(audio_grid, "MASTER", "LBL_MASTER", temp_settings["master_vol"], 0.0, 1.0)
	var menu_m_vol = temp_settings["vol_settings"].get("menu_music", 0.4)
	add_slider_to_grid(audio_grid, "menu_music", "LBL_MENU_MUSIC", menu_m_vol, 0.0, 1.0)
	add_slider_to_grid(audio_grid, "stadium", "LBL_STADIUM", temp_settings["vol_settings"]["stadium"], 0.0, 1.0)
	add_slider_to_grid(audio_grid, "music", "LBL_MUSIC", temp_settings["vol_settings"]["music"], 0.0, 1.0)
	add_slider_to_grid(audio_grid, "collision", "LBL_COLLISION", temp_settings["vol_settings"]["collision"], 0.0, 1.0)
	add_slider_to_grid(audio_grid, "whistle", "LBL_WHISTLE", temp_settings["vol_settings"]["whistle"], 0.0, 1.0)
	
	var bot_hbox = HBoxContainer.new()
	bot_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	bot_hbox.add_theme_constant_override("separation", 20)
	bot_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	s_vbox.add_child(bot_hbox)
	
	var c_style = StyleBoxFlat.new()
	c_style.bg_color = Color8(20, 30, 40, 200)
	c_style.border_width_bottom = 4
	c_style.border_color = Color8(220, 50, 50, 255)
	c_style.corner_radius_top_left = 15; c_style.corner_radius_top_right = 15
	c_style.corner_radius_bottom_left = 15; c_style.corner_radius_bottom_right = 15
	
	var close_btn = Button.new()
	close_btn.text = LANG[Global.current_lang]["CLOSE"]
	close_btn.add_theme_font_override("font", custom_font)
	close_btn.add_theme_font_size_override("font_size", 30)
	close_btn.add_theme_stylebox_override("normal", c_style)
	close_btn.add_theme_stylebox_override("hover", c_style)
	close_btn.add_theme_stylebox_override("pressed", c_style)
	close_btn.add_theme_stylebox_override("focus", c_style)
	close_btn.custom_minimum_size = Vector2(250, 75)
	close_btn.pressed.connect(func(): settings_overlay.visible = false)
	bot_hbox.add_child(close_btn)
	ui_labels.append({"node": close_btn, "key": "CLOSE", "type": "button"})

	var ok_style = StyleBoxFlat.new()
	ok_style.bg_color = Color8(20, 30, 40, 200)
	ok_style.border_width_bottom = 4
	ok_style.border_color = active_theme.accent
	ok_style.corner_radius_top_left = 15; ok_style.corner_radius_top_right = 15
	ok_style.corner_radius_bottom_left = 15; ok_style.corner_radius_bottom_right = 15

	var save_btn = Button.new()
	save_btn.text = LANG[Global.current_lang]["SAVE"]
	save_btn.add_theme_font_override("font", custom_font)
	save_btn.add_theme_font_size_override("font_size", 30)
	save_btn.add_theme_stylebox_override("normal", ok_style)
	save_btn.add_theme_stylebox_override("hover", ok_style)
	save_btn.add_theme_stylebox_override("pressed", ok_style)
	save_btn.add_theme_stylebox_override("focus", ok_style)
	save_btn.custom_minimum_size = Vector2(250, 75)
	save_btn.pressed.connect(func():
		Global.master_vol = temp_settings["master_vol"]
		Global.vol_settings = temp_settings["vol_settings"].duplicate()
		Global.shake_enabled = temp_settings["shake_enabled"]
		Global.match_duration = temp_settings["match_duration"]
		Global.current_theme = temp_settings["current_theme"]
		
		# Immediately update node hierarchy
		update_theme_visuals()
		Global._update_bg_music_volume()
		settings_overlay.visible = false
	)
	bot_hbox.add_child(save_btn)
	ui_labels.append({"node": save_btn, "key": "SAVE", "type": "button"})

func add_section_header(vbox: VBoxContainer, lang_key: String):
	var header = create_label_node(lang_key, white, 35)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(header)
	var sep = HSeparator.new()
	vbox.add_child(sep)

func create_label_node(lang_key, color, f_size) -> Label: 
	var lbl = Label.new()
	lbl.text = LANG[Global.current_lang][lang_key]
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_font_size_override("font_size", f_size) 
	lbl.add_theme_font_override("font", custom_font)
	ui_labels.append({"node": lbl, "key": lang_key, "type": "label"})
	return lbl

func add_slider_to_grid(grid: GridContainer, id: String, lang_key: String, default_val: float, min_val: float, max_val: float):
	var lbl = create_label_node(lang_key, white, 30)
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(lbl)
	
	var slider = HSlider.new()
	slider.custom_minimum_size = Vector2(240, 40) # TELEFONA UYGUN KÜÇÜLTÜLDÜ
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = 0.05
	slider.value = default_val
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slider.value_changed.connect(func(val):
		if id == "MASTER": 
			temp_settings["master_vol"] = val
			# Optional: preview the master volume bound live on menu music
			if is_instance_valid(Global.bg_music_player):
				var live_target = val * temp_settings["vol_settings"].get("menu_music", 0.4)
				if live_target <= 0.01:
					Global.bg_music_player.volume_db = -80.0
				else:
					Global.bg_music_player.volume_db = linear_to_db(live_target)
		else: 
			temp_settings["vol_settings"][id] = val
			if id == "menu_music":
				# Live preview for menu music slider
				if is_instance_valid(Global.bg_music_player):
					var live_target = temp_settings["master_vol"] * val
					if live_target <= 0.01:
						Global.bg_music_player.volume_db = -80.0
					else:
						Global.bg_music_player.volume_db = linear_to_db(live_target)
	)
	
	apply_modern_slider(slider)
	grid.add_child(slider)

func add_magnetic_slider_to_vbox(parent: Control, id: String, lang_key: String, default_val: float):
	var cont = VBoxContainer.new()
	cont.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(cont)
	
	var lbl = create_label_node(lang_key, white, 30)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cont.add_child(lbl)
	
	var vst = VBoxContainer.new()
	vst.alignment = BoxContainer.ALIGNMENT_CENTER
	cont.add_child(vst)
	
	var slider = HSlider.new()
	slider.custom_minimum_size = Vector2(280, 40)
	apply_modern_slider(slider)
	slider.min_value = 0
	slider.max_value = 2
	slider.step = 1
	var def_step = 1
	if default_val < 0.9: def_step = 0
	elif default_val > 1.1: def_step = 2
	slider.value = def_step
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slider.value_changed.connect(func(val):
		if val == 0: temp_settings["match_duration"] = 0
		elif val == 1: temp_settings["match_duration"] = 1
		elif val == 2: temp_settings["match_duration"] = 2
	)
	vst.add_child(slider)
	
	var lbl_box = HBoxContainer.new()
	var l_kisa = Label.new(); l_kisa.text = "Kısa"; l_kisa.add_theme_font_override("font", custom_font); l_kisa.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var l_norm = Label.new(); l_norm.text = "Normal"; l_norm.add_theme_font_override("font", custom_font); l_norm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; l_norm.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var l_uzun = Label.new(); l_uzun.text = "Uzun"; l_uzun.add_theme_font_override("font", custom_font); l_uzun.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; l_uzun.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl_box.add_child(l_kisa); lbl_box.add_child(l_norm); lbl_box.add_child(l_uzun)
	vst.add_child(lbl_box)

func apply_modern_slider(slider: HSlider):
	var slider_sb = StyleBoxFlat.new()
	slider_sb.bg_color = active_theme.bg_bottom.darkened(0.2)
	slider_sb.corner_radius_top_left = 10; slider_sb.corner_radius_top_right = 10
	slider_sb.corner_radius_bottom_left = 10; slider_sb.corner_radius_bottom_right = 10
	slider_sb.expand_margin_top = 10; slider_sb.expand_margin_bottom = 10

	var grabber_sb = StyleBoxFlat.new()
	grabber_sb.bg_color = active_theme.accent
	grabber_sb.corner_radius_top_left = 10; grabber_sb.corner_radius_top_right = 10
	grabber_sb.corner_radius_bottom_left = 10; grabber_sb.corner_radius_bottom_right = 10
	grabber_sb.expand_margin_top = 10; grabber_sb.expand_margin_bottom = 10

	slider.add_theme_stylebox_override("slider", slider_sb)
	slider.add_theme_stylebox_override("grabber_area", grabber_sb)
	slider.add_theme_stylebox_override("grabber_area_hl", grabber_sb)
	
	var img = Image.create(30, 30, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	for x in range(30):
		for y in range(30):
			if Vector2(x - 15, y - 15).length() <= 14:
				img.set_pixel(x, y, Color.WHITE)
	var tex = ImageTexture.create_from_image(img)
	slider.add_theme_icon_override("grabber", tex)
	slider.add_theme_icon_override("grabber_highlight", tex)

func add_dropdown_to_grid(grid: GridContainer, id: String, lang_key: String, options: Array, default_val: String):
	var lbl = create_label_node(lang_key, white, 30)
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_child(lbl)
	
	var drop = OptionButton.new()
	drop.add_theme_font_override("font", custom_font)
	drop.add_theme_font_size_override("font_size", 28)
	drop.custom_minimum_size = Vector2(240, 50) # TELEFONA UYGUN KÜÇÜLTÜLDÜ
	var default_idx = 0
	for i in range(options.size()):
		drop.add_item(options[i])
		if options[i] == default_val: default_idx = i
	drop.selected = default_idx
	drop.item_selected.connect(func(idx):
		if id == "THEME":
			Global.current_theme = drop.get_item_text(idx)
			update_theme_visuals()
			settings_overlay.queue_free()
			setup_settings_overlay()
	)
	grid.add_child(drop)

func draw_ball_preview(ctrl: Control, is_home: bool):
	var team_name = Global.home_team_name if is_home else Global.away_team_name
	var team_data = Global.TEAMS.get(team_name)
	if not team_data: return
	
	var colors = team_data["colors"]
	var center = ctrl.size / 2.0
	var radius = 54.0
	
	ctrl.draw_circle(center, radius, colors[0])
	
	var stripe_w = (radius * 2.0) / 6.0
	for x in range(int(-radius), int(radius)):
		var stripe_index = int((x + radius) / stripe_w)
		if stripe_index % 2 != 0:
			var y = sqrt(max(0, radius * radius - x * x))
			ctrl.draw_line(center + Vector2(x, -y), center + Vector2(x, y), colors[1], 1.0)
			
	ctrl.draw_arc(center, radius, 0, TAU, 64, colors[1], 2.0, true)
	ctrl.draw_arc(center, radius - 2.0, 0, TAU, 64, Color.WHITE, 1.0, true)

func add_centered_toggle_to_vbox(parent: Control, id: String, lang_key: String, default_val: bool):
	var cont = VBoxContainer.new()
	cont.alignment = BoxContainer.ALIGNMENT_CENTER
	cont.add_theme_constant_override("separation", 10)
	parent.add_child(cont)
	
	var lbl = create_label_node(lang_key, white, 30)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cont.add_child(lbl)
	
	var c_cont = CenterContainer.new()
	c_cont.custom_minimum_size = Vector2(420, 210)
	cont.add_child(c_cont)
	
	var check = CheckButton.new()
	check.button_pressed = default_val
	check.custom_minimum_size = Vector2(140, 70)
	
	var scale_factor = 3.0
	check.scale = Vector2(scale_factor, scale_factor)
	check.pivot_offset = Vector2(140/2, 70/2)
	
	check.toggled.connect(func(toggled_on):
		if id == "SHAKE": temp_settings["shake_enabled"] = toggled_on
	)
	c_cont.add_child(check)

func populate_teams():
	if not home_list or not away_list: return
	
	for child in home_list.get_children(): 
		home_list.remove_child(child); child.queue_free()
	for child in away_list.get_children(): 
		away_list.remove_child(child); child.queue_free()
	
	var txt_filter_home = search_bar_home.text.to_lower() if search_bar_home else ""
	var txt_filter_away = search_bar_away.text.to_lower() if search_bar_away else ""
	var lg_filter_h = league_dropdown_home.get_item_text(league_dropdown_home.selected) if league_dropdown_home else "All Teams"
	var lg_filter_a = league_dropdown_away.get_item_text(league_dropdown_away.selected) if league_dropdown_away else "All Teams"
	
	for team in TEAM_NAMES:
		var team_league = Global.TEAMS[team].get("league", "Other")
		
		# Home column filtering
		if (lg_filter_h == "All Teams" or team_league == lg_filter_h) and (txt_filter_home == "" or txt_filter_home in team.to_lower()):
			var style = StyleBoxFlat.new()
			style.bg_color = glass_panel
			style.corner_radius_top_left = 12; style.corner_radius_top_right = 12
			style.corner_radius_bottom_left = 12; style.corner_radius_bottom_right = 12
			var h_btn = Button.new()
			h_btn.mouse_filter = Control.MOUSE_FILTER_PASS
			h_btn.text = team
			h_btn.add_theme_font_override("font", custom_font)
			h_btn.add_theme_font_size_override("font_size", 28)
			h_btn.custom_minimum_size = Vector2(320, 80) 
			h_btn.add_theme_stylebox_override("normal", style)
			if team == Global.home_team_name: h_btn.add_theme_color_override("font_color", active_theme.accent)
			h_btn.pressed.connect(func(): Global.home_team_name = team; populate_teams())
			home_list.add_child(h_btn)
			
		# Away column filtering
		if (lg_filter_a == "All Teams" or team_league == lg_filter_a) and (txt_filter_away == "" or txt_filter_away in team.to_lower()):
			var style = StyleBoxFlat.new()
			style.bg_color = glass_panel
			style.corner_radius_top_left = 12; style.corner_radius_top_right = 12
			style.corner_radius_bottom_left = 12; style.corner_radius_bottom_right = 12
			var a_btn = Button.new()
			a_btn.mouse_filter = Control.MOUSE_FILTER_PASS
			a_btn.text = team
			a_btn.add_theme_font_override("font", custom_font)
			a_btn.add_theme_font_size_override("font_size", 28)
			a_btn.custom_minimum_size = Vector2(320, 80)
			a_btn.add_theme_stylebox_override("normal", style)
			if team == Global.away_team_name: a_btn.add_theme_color_override("font_color", active_theme.accent)
			a_btn.pressed.connect(func(): Global.away_team_name = team; populate_teams())
			away_list.add_child(a_btn)
			
	if home_preview: home_preview.queue_redraw()
	if away_preview: away_preview.queue_redraw()

func setup_filters():
	var opts = ["Liga Ara...", "Süper Lig", "Premier League", "La Liga", "Bundesliga", "Serie A", "Ligue 1", "MLS", "Saudi Pro League", "Other", "All Teams"]
	
	if league_dropdown_home:
		league_dropdown_home.clear()
		league_dropdown_home.add_theme_font_override("font", custom_font)
		league_dropdown_home.add_theme_font_size_override("font_size", 25)
		for opt in opts: league_dropdown_home.add_item(opt)
		league_dropdown_home.select(1) # Süper Lig
			
	if league_dropdown_away:
		league_dropdown_away.clear()
		league_dropdown_away.add_theme_font_override("font", custom_font)
		league_dropdown_away.add_theme_font_size_override("font_size", 25)
		for opt in opts: league_dropdown_away.add_item(opt)
		league_dropdown_away.select(1) # Süper Lig
		
	if search_bar_home:
		search_bar_home.placeholder_text = LANG[Global.current_lang]["SEARCH"]
		search_bar_home.add_theme_font_override("font", custom_font)
		search_bar_home.add_theme_font_size_override("font_size", 25)
		
	if search_bar_away:
		search_bar_away.placeholder_text = LANG[Global.current_lang]["SEARCH"]
		search_bar_away.add_theme_font_override("font", custom_font)
		search_bar_away.add_theme_font_size_override("font_size", 25)

func _on_filter_changed(_arg = null):
	populate_teams()

func _on_lang_dropdown_selected(idx: int):
	if idx == 0: Global.current_lang = "TR"
	elif idx == 1: Global.current_lang = "ENG"
	elif idx == 2: Global.current_lang = "ESP"
	elif idx == 3: Global.current_lang = "POR"
	
	for item in ui_labels:
		if is_instance_valid(item.node):
			if item.type == "label" or item.type == "button":
				item.node.text = LANG[Global.current_lang][item.key]
			elif item.type == "placeholder":
				item.node.placeholder_text = LANG[Global.current_lang][item.key]

func _on_start_match():
	if is_instance_valid(Global.bg_music_player):
		Global.bg_music_player.stop()
	get_tree().change_scene_to_file("res://pitch.tscn")
