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
		"STATS_TITLE": "İSTATİSTİKLER", "SHOP_TITLE": "MAĞAZA",
		"STATS_NO_DATA": "Henüz maç oynanmadı.\nBir maç oyna ve istatistiklerin burada görünecek!",
		"STATS_RECENT": "Son Maçlar", "STATS_TOTAL": "Toplam Maç",
		"STATS_HOME_W": "Galibiyet (Ev)", "STATS_AWAY_W": "Galibiyet (Deplasman)",
		"STATS_DRAW": "Beraberlik", "STATS_MOST_GOALS": "En Çok Gol", "STATS_BIGGEST_WIN": "En Büyük Fark",
		"SHOP_COSMETICS": "KOZMETİKLER", "SHOP_BALL_SKINS": "Top Görünümleri",
		"SHOP_BUY": "₺49.99 — SATIN AL", "SHOP_CANCEL": "VAZGEÇ",
		"SHOP_PRO_DESC": "Tüm özel temalar, özel toplar ve reklamsız deneyim",
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
		"STATS_TITLE": "STATISTICS", "SHOP_TITLE": "SHOP",
		"STATS_NO_DATA": "No matches played yet.\nPlay a match and your stats will appear here!",
		"STATS_RECENT": "Recent Matches", "STATS_TOTAL": "Total Matches",
		"STATS_HOME_W": "Home Wins", "STATS_AWAY_W": "Away Wins",
		"STATS_DRAW": "Draws", "STATS_MOST_GOALS": "Most Goals", "STATS_BIGGEST_WIN": "Biggest Win",
		"SHOP_COSMETICS": "COSMETICS", "SHOP_BALL_SKINS": "Ball Skins",
		"SHOP_BUY": "₺49.99 — BUY NOW", "SHOP_CANCEL": "CANCEL",
		"SHOP_PRO_DESC": "Unlock all themes, custom balls and ad-free experience",
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
		"STATS_TITLE": "ESTADÍSTICAS", "SHOP_TITLE": "TIENDA",
		"STATS_NO_DATA": "Aún no hay partidos.\n¡Juega un partido y tus estadísticas aparecerán aquí!",
		"STATS_RECENT": "Partidos Recientes", "STATS_TOTAL": "Total Partidos",
		"STATS_HOME_W": "Victorias (Local)", "STATS_AWAY_W": "Victorias (Visitante)",
		"STATS_DRAW": "Empates", "STATS_MOST_GOALS": "Más Goles", "STATS_BIGGEST_WIN": "Mayor Diferencia",
		"SHOP_COSMETICS": "COSMÉTICOS", "SHOP_BALL_SKINS": "Apariencias de Balón",
		"SHOP_BUY": "₺49.99 — COMPRAR", "SHOP_CANCEL": "CANCELAR",
		"SHOP_PRO_DESC": "Desbloquea todos los temas, balones y experiencia sin anuncios",
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
		"STATS_TITLE": "ESTATÍSTICAS", "SHOP_TITLE": "LOJA",
		"STATS_NO_DATA": "Nenhum jogo ainda.\nJogue uma partida e suas estatísticas aparecerão aqui!",
		"STATS_RECENT": "Jogos Recentes", "STATS_TOTAL": "Total de Jogos",
		"STATS_HOME_W": "Vitórias (Casa)", "STATS_AWAY_W": "Vitórias (Fora)",
		"STATS_DRAW": "Empates", "STATS_MOST_GOALS": "Mais Gols", "STATS_BIGGEST_WIN": "Maior Diferença",
		"SHOP_COSMETICS": "COSMÉTICOS", "SHOP_BALL_SKINS": "Aparências de Bola",
		"SHOP_BUY": "₺49.99 — COMPRAR", "SHOP_CANCEL": "CANCELAR",
		"SHOP_PRO_DESC": "Desbloqueie todos os temas, bolas personalizadas e experiência sem anúncios",
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
var ui_separators = []

var home_preview: Control
var away_preview: Control

var active_theme: Dictionary
var bg_grad: Gradient

var temp_settings = {}
var start_match_btn: Button
var top_stripe_panel: PanelContainer
var main_scroll: ScrollContainer

# --- TAB NAVIGATION ---
var current_tab: int = 1   # 0=Stats, 1=Home, 2=Shop
var tabs_hbox: HBoxContainer
var tab_container: Control
var nav_bar_panel: PanelContainer
var nav_bar_btns: Array = []
var swipe_start: Vector2 = Vector2.ZERO
var swipe_active: bool = false
var swipe_threshold: float = 40.0
var badge_textures: Dictionary = {}  # Preloaded at _ready() for badge overlay on preview balls

func _ready():
	Engine.time_scale = 1.0 
	
	if is_instance_valid(Global.bg_music_player) and not Global.bg_music_player.playing:
		Global.bg_music_player.play()
	Global.load_stats()  # Load persisted match history from disk
	# Pre-load badge overlay textures so draw_ball_preview doesn't block per frame
	badge_textures = {
		"FB": load("res://fb1.png"),
		"TS": load("res://ts1.png"),
		"GS": load("res://gs1.png"),
		"BJK": load("res://bjk1.png")
	}
	
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
	
	await get_tree().process_frame
	# --- TAB CONTAINER SYSTEM ---
	# A clipping Control that holds 3 side-by-side pages
	tab_container = Control.new()
	tab_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	tab_container.clip_contents = true
	add_child(tab_container)

	# Horizontal strip of 3 pages, each screen-width wide
	tabs_hbox = HBoxContainer.new()
	tabs_hbox.add_theme_constant_override("separation", 0)
	tabs_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tab_container.add_child(tabs_hbox)
	# We'll size tabs_hbox after viewport is known (call_deferred)
	call_deferred("_init_tab_sizes")

	# --- PAGE 0: STATS TAB (Lazy Loaded) ---
	var stats_placeholder = Control.new()
	stats_placeholder.name = "Stats_Placeholder"
	stats_placeholder.custom_minimum_size.x = get_viewport_rect().size.x
	tabs_hbox.add_child(stats_placeholder)

	# --- PAGE 1: HOME TAB (existing main menu UI) ---
	var main_margin = MarginContainer.new()
	main_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_margin.add_theme_constant_override("margin_top", 80)
	main_margin.add_theme_constant_override("margin_bottom", 40)
	main_margin.add_theme_constant_override("margin_left", 20)
	main_margin.add_theme_constant_override("margin_right", 20)
	tabs_hbox.add_child(main_margin)

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
	lang_btn.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	lang_btn.add_theme_constant_override("shadow_offset_y", 4)
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
	
	var menu_sep = HSeparator.new()
	main_vbox.add_child(menu_sep)
	ui_separators.append(menu_sep)
	
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
	
	var home_col_margin = MarginContainer.new()
	home_col_margin.add_theme_constant_override("margin_left", 20)
	main_cols_hbox.add_child(home_col_margin)

	var home_col = VBoxContainer.new()
	home_col.custom_minimum_size = Vector2(320, 0)
	home_col.add_theme_constant_override("separation", 0)
	home_col_margin.add_child(home_col)
	
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
	home_col.add_child(home_lbl)

	var away_lbl = create_label_node("AWAY", Color.WHITE, 45)
	away_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	away_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	away_lbl.add_theme_constant_override("shadow_offset_y", 4)
	away_col.add_child(away_lbl)
	
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
	var lg_h_m = MarginContainer.new()
	lg_h_m.add_theme_constant_override("margin_left", 20)
	lg_h_m.add_child(league_dropdown_home)
	home_col.add_child(lg_h_m)
	league_dropdown_home.item_selected.connect(_on_filter_changed)
	
	league_dropdown_away = OptionButton.new()
	league_dropdown_away.custom_minimum_size = Vector2(320, 60)
	league_dropdown_away.add_theme_font_override("font", custom_font)
	league_dropdown_away.add_theme_font_size_override("font_size", 32)
	league_dropdown_away.add_theme_stylebox_override("normal", filter_style)
	league_dropdown_away.add_theme_stylebox_override("hover", filter_style)
	league_dropdown_away.add_theme_stylebox_override("pressed", filter_style)
	league_dropdown_away.add_theme_icon_override("arrow", arrow_empty)
	var lg_a_m = MarginContainer.new()
	lg_a_m.add_theme_constant_override("margin_left", 20)
	lg_a_m.add_child(league_dropdown_away)
	away_col.add_child(lg_a_m)
	league_dropdown_away.item_selected.connect(_on_filter_changed)
	
	# Gap between league dropdown and search bar
	var s_gap_h = Control.new(); s_gap_h.custom_minimum_size = Vector2(0, 10); home_col.add_child(s_gap_h)
	var s_gap_a = Control.new(); s_gap_a.custom_minimum_size = Vector2(0, 10); away_col.add_child(s_gap_a)
	
	search_bar_home = LineEdit.new()
	search_bar_home.custom_minimum_size = Vector2(320, 60)
	search_bar_home.add_theme_font_override("font", custom_font)
	search_bar_home.add_theme_font_size_override("font_size", 32)
	search_bar_home.add_theme_stylebox_override("normal", filter_style)
	search_bar_home.add_theme_stylebox_override("focus", filter_style)
	search_bar_home.text_changed.connect(_on_filter_changed)
	ui_labels.append({"node": search_bar_home, "key": "SEARCH", "type": "placeholder"})
	var sb_h_m = MarginContainer.new()
	sb_h_m.add_theme_constant_override("margin_left", 20)
	sb_h_m.add_child(search_bar_home)
	home_col.add_child(sb_h_m)
	
	search_bar_away = LineEdit.new()
	search_bar_away.custom_minimum_size = Vector2(320, 60)
	search_bar_away.add_theme_font_override("font", custom_font)
	search_bar_away.add_theme_font_size_override("font_size", 32)
	search_bar_away.add_theme_stylebox_override("normal", filter_style)
	search_bar_away.add_theme_stylebox_override("focus", filter_style)
	search_bar_away.text_changed.connect(_on_filter_changed)
	ui_labels.append({"node": search_bar_away, "key": "SEARCH", "type": "placeholder"})
	var sb_a_m = MarginContainer.new()
	sb_a_m.add_theme_constant_override("margin_left", 20)
	sb_a_m.add_child(search_bar_away)
	away_col.add_child(sb_a_m)
	
	setup_filters()
	
	# Scroll container for lists ONLY
	var scroll_both = ScrollContainer.new()
	scroll_both.name = "ScrollContainer"
	scroll_both.custom_minimum_size = Vector2(0, 200) # Minimum 200px tall
	scroll_both.size_flags_vertical = Control.SIZE_EXPAND_FILL
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
	lists_hbox.add_theme_constant_override("separation", 20) # Match header columns gap
	scroll_both.add_child(lists_hbox)
	
	home_list = VBoxContainer.new()
	home_list.mouse_filter = Control.MOUSE_FILTER_PASS
	home_list.custom_minimum_size = Vector2(320, 0)
	home_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	home_list.add_theme_constant_override("separation", 10)
	lists_hbox.add_child(home_list)
	
	away_list = VBoxContainer.new()
	away_list.mouse_filter = Control.MOUSE_FILTER_PASS
	away_list.custom_minimum_size = Vector2(320, 0)
	away_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	away_list.add_theme_constant_override("separation", 10)
	lists_hbox.add_child(away_list)
	
	TEAM_NAMES = Global.TEAMS.keys()
	populate_teams()
	
	# --- BAŞLA BUTONU (Hemen Altında) ---
	# Yaratılış sırasında ismi atlayalım, global değişkene referans atalım. (İsterseniz globalden direkt çekebilirsiniz)
	var start_btn = Button.new()
	start_btn.name = "StartMatchButton"
	start_btn.custom_minimum_size = Vector2(660, 90)
	start_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var start_lbl = Label.new()
	start_lbl.name = "ButtonLabel"
	start_lbl.text = LANG[Global.current_lang]["START_MATCH"]
	start_lbl.add_theme_font_override("font", custom_font)
	start_lbl.add_theme_font_size_override("font_size", 50)
	start_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	start_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	start_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	start_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,180))
	start_lbl.add_theme_constant_override("shadow_offset_x", 0)
	start_lbl.add_theme_constant_override("shadow_offset_y", 5)
	start_btn.add_child(start_lbl)
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
	update_theme_visuals()

	# --- PAGE 2: SHOP TAB (Lazy Loaded) ---
	var shop_placeholder = Control.new()
	shop_placeholder.name = "Shop_Placeholder"
	shop_placeholder.custom_minimum_size.x = get_viewport_rect().size.x
	tabs_hbox.add_child(shop_placeholder)

	# --- BOTTOM NAVIGATION BAR ---
	_build_bottom_nav()

	# Start on Home (tab index 1), instantly, no tween
	_switch_tab(1, true)
	
	_connect_all_buttons(self)

func _connect_all_buttons(node: Node):
	if node is Button:
		node.pressed.connect(Global.play_click)
	for child in node.get_children():
		_connect_all_buttons(child)

func update_theme_visuals():
	active_theme = Global.THEMES[Global.current_theme]
	bg_grad.set_color(0, active_theme.bg_top)
	bg_grad.set_color(1, active_theme.bg_bottom)
	
	if is_instance_valid(burger_popup):
		var b_style = burger_popup.get_theme_stylebox("panel")
		if b_style is StyleBoxFlat:
			b_style.border_color = active_theme.accent.darkened(0.5)
			burger_popup.add_theme_stylebox_override("panel", b_style)

	if is_instance_valid(nav_bar_panel):
		var nb_style = nav_bar_panel.get_theme_stylebox("panel")
		if nb_style is StyleBoxFlat:
			nb_style.bg_color = active_theme.bg_top
			nb_style.bg_color.a = 0.97
			nb_style.border_color = active_theme.accent.darkened(0.4)
			nav_bar_panel.add_theme_stylebox_override("panel", nb_style)
	# Refresh indicator colors
	for btn_data in nav_bar_btns:
		var ind: Control = btn_data["indicator"]
		ind.queue_redraw()

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
			
			start_match_btn.add_theme_stylebox_override("normal", s_style)
			start_match_btn.add_theme_stylebox_override("hover", s_style)
			start_match_btn.add_theme_stylebox_override("pressed", s_style)
			start_match_btn.add_theme_stylebox_override("focus", s_style)
			
			var btn_lbl = start_match_btn.get_node_or_null("ButtonLabel")
			if btn_lbl:
				if Global.current_theme == "Buz":
					btn_lbl.add_theme_color_override("font_color", Color.BLACK)
					btn_lbl.remove_theme_color_override("font_shadow_color")
				else:
					btn_lbl.add_theme_color_override("font_color", Color.WHITE)
					btn_lbl.add_theme_color_override("font_shadow_color", Color8(0,0,0,180))
					btn_lbl.add_theme_constant_override("shadow_offset_x", 0)
					btn_lbl.add_theme_constant_override("shadow_offset_y", 5)

	# Buz (light blue) theme: force dark text on background elements, remove outline
	var buz_active = (Global.current_theme == "Buz")
	var buz_text_color = Color.BLACK
	
	# Update separators
	var sep_style = StyleBoxLine.new()
	sep_style.color = active_theme.bg_bottom
	sep_style.thickness = 3
	for sep in ui_separators:
		if is_instance_valid(sep):
			sep.add_theme_stylebox_override("separator", sep_style)

	# Update stats panel accents if they exist
	for node in get_tree().get_nodes_in_group("ThemeStatValueNodes"):
		node.add_theme_color_override("font_color", active_theme.accent)
		node.add_theme_color_override("font_shadow_color", active_theme.accent.darkened(0.5))

	for entry in ui_labels:
		if not is_instance_valid(entry["node"]): continue
		var t = entry.get("type", "label")
		var on_bg = entry.get("on_bg", false)
		# Update language text
		var lang = Global.current_lang
		if LANG[lang].has(entry["key"]):
			var txt = LANG[lang][entry["key"]]
			if t == "label" and entry["node"] is Label:
				entry["node"].text = txt
			elif t == "button" and entry["node"] is Button:
				entry["node"].text = txt
			elif t == "placeholder" and entry["node"] is LineEdit:
				entry["node"].placeholder_text = txt
		# Buz: recolor only labels that are ON the gradient background (on_bg:true)
		# and the lang button, and remove text outline
		if buz_active and (on_bg or t == "button"):
			if entry["node"] is Label:
				entry["node"].add_theme_color_override("font_color", buz_text_color)
				entry["node"].add_theme_constant_override("outline_size", 0)
				entry["node"].remove_theme_color_override("font_shadow_color")
			elif entry["node"] is Button:
				if entry["node"] != start_match_btn:
					entry["node"].add_theme_color_override("font_color", buz_text_color)
					entry["node"].remove_theme_color_override("font_shadow_color")
			elif t == "placeholder" and entry["node"] is LineEdit:
				entry["node"].add_theme_color_override("font_placeholder_color", buz_text_color)
		elif not buz_active and (on_bg or t == "button"):
			if entry["node"] is Label:
				entry["node"].add_theme_color_override("font_color", Color.WHITE)
				entry["node"].remove_theme_constant_override("outline_size")
				# Standard title shadow
				entry["node"].add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
				entry["node"].add_theme_constant_override("shadow_offset_y", 4)
			elif entry["node"] is Button:
				if entry["node"] != start_match_btn:
					entry["node"].add_theme_color_override("font_color", Color.WHITE)
					entry["node"].add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
					entry["node"].add_theme_constant_override("shadow_offset_y", 4)
			elif t == "placeholder" and entry["node"] is LineEdit:
				entry["node"].add_theme_color_override("font_placeholder_color", Color.WHITE)

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
	ui_separators.append(sep)

func create_label_node(lang_key, color, f_size) -> Label: 
	var lbl = Label.new()
	lbl.text = LANG[Global.current_lang][lang_key]
	lbl.add_theme_color_override("font_color", color)
	lbl.add_theme_font_size_override("font_size", f_size) 
	lbl.add_theme_font_override("font", custom_font)
	ui_labels.append({"node": lbl, "key": lang_key, "type": "label", "on_bg": true})
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
	var short_name = team_data.get("short", "")
	# Use actual size when available; fall back to minimum so it draws on first frame
	var ctrl_size = ctrl.size if ctrl.size.x > 1.0 else ctrl.custom_minimum_size
	var center = ctrl_size / 2.0
	var radius = 54.0
	
	ctrl.draw_circle(center, radius, colors[0])
	
	var stripe_w = (radius * 2.0) / 6.0
	for x in range(int(-radius), int(radius)):
		var stripe_index = int((x + radius) / stripe_w)
		if stripe_index % 2 != 0:
			var y = sqrt(max(0, radius * radius - x * x))
			ctrl.draw_line(center + Vector2(x, -y), center + Vector2(x, y), colors[1], 1.0)
			
	# Colored arc just inside edge, then white arc at the very edge (ALL WHITE NOW)
	ctrl.draw_arc(center, radius - 1.5, 0, TAU, 64, Color.WHITE, 1.2, true)
	ctrl.draw_arc(center, radius, 0, TAU, 64, Color.WHITE, 0.8, true)

	# Draw team mascot badge if available
	if badge_textures.has(short_name):
		var badge_tex = badge_textures[short_name]
		if badge_tex:
			var bs = Vector2(72, 72)
			ctrl.draw_texture_rect(badge_tex, Rect2(center - bs / 2.0, bs), false)

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
	
	var shared_btn_style = StyleBoxFlat.new()
	shared_btn_style.bg_color = glass_panel
	shared_btn_style.corner_radius_top_left = 12; shared_btn_style.corner_radius_top_right = 12
	shared_btn_style.corner_radius_bottom_left = 12; shared_btn_style.corner_radius_bottom_right = 12

	var txt_filter_home = search_bar_home.text.to_lower() if search_bar_home else ""
	var txt_filter_away = search_bar_away.text.to_lower() if search_bar_away else ""
	var lg_filter_h = league_dropdown_home.get_item_text(league_dropdown_home.selected) if league_dropdown_home else "All Teams"
	var lg_filter_a = league_dropdown_away.get_item_text(league_dropdown_away.selected) if league_dropdown_away else "All Teams"
	
	for team in TEAM_NAMES:
		var team_league = Global.TEAMS[team].get("league", "Other")
		
		# Home column filtering
		if (lg_filter_h == "All Teams" or team_league == lg_filter_h) and (txt_filter_home == "" or txt_filter_home in team.to_lower()):
			var h_btn = Button.new()
			h_btn.mouse_filter = Control.MOUSE_FILTER_PASS
			h_btn.text = team
			h_btn.add_theme_font_override("font", custom_font)
			h_btn.add_theme_font_size_override("font_size", 28)
			h_btn.custom_minimum_size = Vector2(320, 80) 
			h_btn.add_theme_stylebox_override("normal", shared_btn_style)
			if team == Global.home_team_name: h_btn.add_theme_color_override("font_color", active_theme.accent)
			h_btn.pressed.connect(func(): Global.play_click(); Global.home_team_name = team; populate_teams())
			home_list.add_child(h_btn)
			
		# Away column filtering
		if (lg_filter_a == "All Teams" or team_league == lg_filter_a) and (txt_filter_away == "" or txt_filter_away in team.to_lower()):
			var a_btn = Button.new()
			a_btn.mouse_filter = Control.MOUSE_FILTER_PASS
			a_btn.text = team
			a_btn.add_theme_font_override("font", custom_font)
			a_btn.add_theme_font_size_override("font_size", 28)
			a_btn.custom_minimum_size = Vector2(320, 80)
			a_btn.add_theme_stylebox_override("normal", shared_btn_style)
			if team == Global.away_team_name: a_btn.add_theme_color_override("font_color", active_theme.accent)
			a_btn.pressed.connect(func(): Global.play_click(); Global.away_team_name = team; populate_teams())
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

# ======================================================
# TAB NAVIGATION HELPERS
# ======================================================

func _init_tab_sizes():
	# Set each page's minimum width to screen width so the hbox fills correctly
	var sw = get_viewport_rect().size.x
	for child in tabs_hbox.get_children():
		child.custom_minimum_size = Vector2(sw, 0)

func _switch_tab(idx: int, instant: bool = false):
	var sw = get_viewport_rect().size.x
	
	# Lazy Load check
	var target_node = tabs_hbox.get_child(idx)
	if target_node.name.ends_with("_Placeholder"):
		var real_page: Control = null
		if idx == 0:
			real_page = _build_stats_tab()
		elif idx == 2:
			real_page = _build_shop_tab()
		
		if real_page:
			real_page.custom_minimum_size = Vector2(sw, 0)
			tabs_hbox.add_child(real_page)
			tabs_hbox.move_child(real_page, idx)
			target_node.queue_free()
			_connect_all_buttons(real_page)
			update_theme_visuals()

	current_tab = idx
	var target_x = -idx * sw
	if instant:
		tabs_hbox.position.x = target_x
	else:
		var tw = create_tween()
		tw.set_ease(Tween.EASE_OUT)
		tw.set_trans(Tween.TRANS_CUBIC)
		tw.tween_property(tabs_hbox, "position:x", target_x, 0.28)
	# Update nav button visuals
	for i in range(nav_bar_btns.size()):
		var btn_data = nav_bar_btns[i]
		var is_active = (i == idx)
		var btn: Button = btn_data["btn"]
		var indicator: Control = btn_data["indicator"]
		if is_active:
			btn.modulate = Color.WHITE
			indicator.visible = true
		else:
			btn.modulate = Color(1, 1, 1, 0.45)
			indicator.visible = false

func _build_bottom_nav():
	var sw = get_viewport_rect().size.x
	nav_bar_panel = PanelContainer.new()
	var nb_style = StyleBoxFlat.new()
	nb_style.bg_color = active_theme.bg_top
	nb_style.bg_color.a = 0.97
	nb_style.corner_radius_top_left = 22; nb_style.corner_radius_top_right = 22
	nb_style.shadow_color = Color8(0, 0, 0, 120)
	nb_style.shadow_size = 18
	nb_style.shadow_offset = Vector2(0, -4)
	nb_style.border_width_top = 2
	nb_style.border_color = active_theme.accent.darkened(0.4)
	nb_style.content_margin_left = 0
	nb_style.content_margin_right = 0
	nb_style.content_margin_top = 8
	nb_style.content_margin_bottom = 8
	nav_bar_panel.add_theme_stylebox_override("panel", nb_style)
	nav_bar_panel.custom_minimum_size = Vector2(sw, 65)
	nav_bar_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	nav_bar_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	add_child(nav_bar_panel)

	var nav_hbox = HBoxContainer.new()
	nav_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	nav_hbox.add_theme_constant_override("separation", 0)
	nav_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	nav_bar_panel.add_child(nav_hbox)

	var icons = [
		preload("res://statsicon.svg"),
		preload("res://homeicon.svg"),
		preload("res://shoppingcarticon.svg")
	]

	var sep_style = StyleBoxFlat.new()
	sep_style.bg_color = active_theme.accent.darkened(0.55)

	for i in range(3):
		# Thin separator before 2nd and 3rd buttons
		if i > 0:
			var sep = VSeparator.new()
			sep.add_theme_stylebox_override("separator", sep_style)
			sep.custom_minimum_size = Vector2(2, 50)
			sep.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			nav_hbox.add_child(sep)

		# Container per button for indicator line
		var btn_vbox = VBoxContainer.new()
		btn_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		btn_vbox.add_theme_constant_override("separation", 2)
		btn_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
		nav_hbox.add_child(btn_vbox)

		# The button itself
		var n_btn = Button.new()
		n_btn.icon = icons[i]
		n_btn.expand_icon = true
		n_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		n_btn.custom_minimum_size = Vector2(0, 56)
		n_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		# 3D look: gradient shadow stylebox
		var n_style_normal = StyleBoxFlat.new()
		n_style_normal.bg_color = Color(0, 0, 0, 0)
		n_style_normal.shadow_color = Color8(0, 0, 0, 60)
		n_style_normal.shadow_size = 4
		n_style_normal.shadow_offset = Vector2(0, 2)
		n_btn.add_theme_stylebox_override("normal", n_style_normal)
		n_btn.add_theme_stylebox_override("hover", n_style_normal)
		n_btn.add_theme_stylebox_override("focus", n_style_normal)

		var n_style_pressed = StyleBoxFlat.new()
		n_style_pressed.bg_color = active_theme.accent.darkened(0.6)
		n_style_pressed.bg_color.a = 0.25
		n_style_pressed.corner_radius_top_left = 10; n_style_pressed.corner_radius_top_right = 10
		n_style_pressed.corner_radius_bottom_left = 10; n_style_pressed.corner_radius_bottom_right = 10
		n_btn.add_theme_stylebox_override("pressed", n_style_pressed)

		n_btn.add_theme_constant_override("icon_max_width", 40)
		btn_vbox.add_child(n_btn)

		# Accent indicator line under active button
		var indicator = Control.new()
		indicator.custom_minimum_size = Vector2(40, 3)
		indicator.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		var ind_draw_target = indicator
		var accent_col = active_theme.accent
		ind_draw_target.draw.connect(func():
			ind_draw_target.draw_rect(Rect2(Vector2.ZERO, ind_draw_target.size), accent_col, true, -1.0)
		)
		indicator.visible = false
		btn_vbox.add_child(indicator)

		# Connect
		var tab_idx = i
		n_btn.pressed.connect(func(): _switch_tab(tab_idx))

		nav_bar_btns.append({"btn": n_btn, "indicator": indicator})

# ======================================================
# STATS TAB
# ======================================================
func _build_stats_tab() -> Control:
	var sw = get_viewport_rect().size.x
	var page = Control.new()
	page.custom_minimum_size = Vector2(sw, 0)
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 80)
	margin.add_theme_constant_override("margin_bottom", 160)
	margin.add_theme_constant_override("margin_left", 30)
	margin.add_theme_constant_override("margin_right", 30)
	page.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	vbox.add_theme_constant_override("separation", 28)
	margin.add_child(vbox)

	# --- Title (same style as TAKIM SEÇİMİ) ---
	var title = create_label_node("STATS_TITLE", white, 55)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	title.add_theme_constant_override("shadow_offset_y", 4)
	vbox.add_child(title)

	var sep = HSeparator.new()
	vbox.add_child(sep)
	ui_separators.append(sep)

	var history = Global.match_history

	if history.is_empty():
		var no_data_lbl = Label.new()
		no_data_lbl.text = LANG[Global.current_lang]["STATS_NO_DATA"]
		no_data_lbl.add_theme_font_override("font", custom_font)
		no_data_lbl.add_theme_font_size_override("font_size", 34)
		no_data_lbl.add_theme_color_override("font_color", Color8(200, 200, 200, 200))
		no_data_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		no_data_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
		ui_labels.append({"node": no_data_lbl, "key": "STATS_NO_DATA", "type": "label"})
		vbox.add_child(no_data_lbl)
	else:
		# Compute stats
		var total = history.size()
		var most_goals_match = history[0]
		var most_diff_match = history[0]
		var home_wins = 0; var away_wins = 0; var draws = 0
		for m in history:
			var goals = m.home_score + m.away_score
			var diff = abs(m.home_score - m.away_score)
			if goals > most_goals_match.home_score + most_goals_match.away_score:
				most_goals_match = m
			if diff > abs(most_diff_match.home_score - most_diff_match.away_score):
				most_diff_match = m
			if m.home_score > m.away_score: home_wins += 1
			elif m.away_score > m.home_score: away_wins += 1
			else: draws += 1

		var stat_panel_style = StyleBoxFlat.new()
		stat_panel_style.bg_color = Color8(15, 25, 40, 210)
		stat_panel_style.corner_radius_top_left = 16; stat_panel_style.corner_radius_top_right = 16
		stat_panel_style.corner_radius_bottom_left = 16; stat_panel_style.corner_radius_bottom_right = 16
		stat_panel_style.border_width_left = 3
		stat_panel_style.border_color = active_theme.accent

		# Row helper – redesigned with filled accent bar
		var _add_stat = func(label_text: String, value_text: String):
			var row_panel = PanelContainer.new()
			var rp_style = StyleBoxFlat.new()
			rp_style.bg_color = Color8(10, 18, 32, 230)
			rp_style.corner_radius_top_left = 12; rp_style.corner_radius_top_right = 12
			rp_style.corner_radius_bottom_left = 12; rp_style.corner_radius_bottom_right = 12
			rp_style.border_width_bottom = 3
			rp_style.border_color = active_theme.accent
			rp_style.content_margin_left = 18; rp_style.content_margin_right = 18
			rp_style.content_margin_top = 12; rp_style.content_margin_bottom = 12
			row_panel.add_theme_stylebox_override("panel", rp_style)
			var row = HBoxContainer.new()
			row.add_theme_constant_override("separation", 20)
			row_panel.add_child(row)
			var lbl = Label.new()
			lbl.text = LANG[Global.current_lang][label_text]
			lbl.add_theme_font_override("font", custom_font)
			lbl.add_theme_font_size_override("font_size", 30)
			lbl.add_theme_color_override("font_color", Color.WHITE)
			lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			ui_labels.append({"node": lbl, "key": label_text, "type": "label"})
			row.add_child(lbl)
			var val_lbl = Label.new()
			val_lbl.text = value_text
			val_lbl.add_theme_font_override("font", custom_font)
			val_lbl.add_theme_font_size_override("font_size", 33)
			val_lbl.add_theme_color_override("font_color", active_theme.accent)
			val_lbl.add_theme_color_override("font_shadow_color", active_theme.accent.darkened(0.5))
			val_lbl.add_to_group("ThemeStatValueNodes")
			val_lbl.add_theme_constant_override("shadow_offset_x", 1)
			val_lbl.add_theme_constant_override("shadow_offset_y", 2)
			val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			row.add_child(val_lbl)
			vbox.add_child(row_panel)

		_add_stat.call("STATS_TOTAL", str(total))
		_add_stat.call("STATS_HOME_W", str(home_wins))
		_add_stat.call("STATS_AWAY_W", str(away_wins))
		_add_stat.call("STATS_DRAW", str(draws))

		var mg = most_goals_match
		var mg_total = mg.home_score + mg.away_score
		_add_stat.call("STATS_MOST_GOALS", "%s %d-%d %s (%d)" % [mg.home, mg.home_score, mg.away_score, mg.away, mg_total])

		var md = most_diff_match
		_add_stat.call("STATS_BIGGEST_WIN", "%s %d - %d %s" % [md.home, md.home_score, md.away_score, md.away])

		# Recent matches (Last 5, no scroll)
		var recent_title = Label.new()
		recent_title.text = LANG[Global.current_lang]["STATS_RECENT"]
		recent_title.add_theme_font_override("font", custom_font)
		recent_title.add_theme_font_size_override("font_size", 36)
		recent_title.add_theme_color_override("font_color", Color.WHITE)
		recent_title.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
		recent_title.add_theme_constant_override("shadow_offset_y", 4)
		ui_labels.append({"node": recent_title, "key": "STATS_RECENT", "type": "label"})
		vbox.add_child(recent_title)

		var recent_vbox = VBoxContainer.new()
		recent_vbox.add_theme_constant_override("separation", 10)
		recent_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.add_child(recent_vbox)

		# Show last 5, newest first
		var shown = min(history.size(), 5)
		for i in range(history.size() - 1, history.size() - 1 - shown, -1):
			var m = history[i]
			var r_panel = PanelContainer.new()
			r_panel.add_theme_stylebox_override("panel", stat_panel_style)
			var r_lbl = Label.new()
			r_lbl.text = "%s  %d - %d  %s" % [m.home, m.home_score, m.away_score, m.away]
			r_lbl.add_theme_font_override("font", custom_font)
			r_lbl.add_theme_font_size_override("font_size", 28)
			r_lbl.add_theme_color_override("font_color", Color.WHITE)
			r_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			r_panel.add_child(r_lbl)
			recent_vbox.add_child(r_panel)

	return page

# ======================================================
# SHOP TAB
# ======================================================
func _build_shop_tab() -> Control:
	var sw = get_viewport_rect().size.x
	var page = Control.new()
	page.custom_minimum_size = Vector2(sw, 0)
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var margin = MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_top", 80)
	margin.add_theme_constant_override("margin_bottom", 80)
	margin.add_theme_constant_override("margin_left", 0)
	margin.add_theme_constant_override("margin_right", 0)
	page.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 30)
	margin.add_child(vbox)

	# No spacer needed — margin_top handles offset

	# --- SHOP TITLE (same style as TAKIM SEÇİMİ) ---
	var title = create_label_node("SHOP_TITLE", white, 55)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	title.add_theme_constant_override("shadow_offset_y", 4)
	vbox.add_child(title)

	# --- PREMIUM BANNER ---
	var prem_panel = PanelContainer.new()
	var prem_style = StyleBoxFlat.new()
	prem_style.bg_color = Color8(20, 14, 40, 245)
	prem_style.corner_radius_top_left = 22; prem_style.corner_radius_top_right = 22
	prem_style.corner_radius_bottom_left = 22; prem_style.corner_radius_bottom_right = 22
	prem_style.border_width_top = 3; prem_style.border_width_bottom = 3
	prem_style.border_width_left = 3; prem_style.border_width_right = 3
	prem_style.border_color = Color8(255, 200, 0, 230)
	prem_style.shadow_color = Color8(255, 200, 0, 60)
	prem_style.shadow_size = 20
	prem_style.content_margin_left = 30; prem_style.content_margin_right = 30
	prem_style.content_margin_top = 30; prem_style.content_margin_bottom = 30
	prem_panel.add_theme_stylebox_override("panel", prem_style)
	var prem_margin = MarginContainer.new()
	prem_margin.add_theme_constant_override("margin_left", 20)
	prem_margin.add_theme_constant_override("margin_right", 20)
	prem_margin.add_child(prem_panel)
	vbox.add_child(prem_margin)

	var prem_vbox = VBoxContainer.new()
	prem_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	prem_vbox.add_theme_constant_override("separation", 18)
	prem_panel.add_child(prem_vbox)

	var prem_icon_lbl = Label.new()
	prem_icon_lbl.text = "⭐  PRO"
	prem_icon_lbl.add_theme_font_override("font", custom_font)
	prem_icon_lbl.add_theme_font_size_override("font_size", 52)
	prem_icon_lbl.add_theme_color_override("font_color", Color8(255, 210, 0))
	prem_icon_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prem_vbox.add_child(prem_icon_lbl)

	var prem_desc = Label.new()
	prem_desc.text = LANG[Global.current_lang]["SHOP_PRO_DESC"]
	prem_desc.add_theme_font_override("font", custom_font)
	prem_desc.add_theme_font_size_override("font_size", 28)
	prem_desc.add_theme_color_override("font_color", Color.WHITE)
	prem_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prem_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	ui_labels.append({"node": prem_desc, "key": "SHOP_PRO_DESC", "type": "label"})
	prem_vbox.add_child(prem_desc)

	var buy_btn = Button.new()
	buy_btn.text = LANG[Global.current_lang]["SHOP_BUY"]
	ui_labels.append({"node": buy_btn, "key": "SHOP_BUY", "type": "button"})
	buy_btn.add_theme_font_override("font", custom_font)
	buy_btn.add_theme_font_size_override("font_size", 34)
	buy_btn.add_theme_color_override("font_color", Color8(10, 10, 10))
	buy_btn.custom_minimum_size = Vector2(360, 75)
	buy_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var buy_style = StyleBoxFlat.new()
	buy_style.bg_color = Color8(255, 210, 0)
	buy_style.corner_radius_top_left = 16; buy_style.corner_radius_top_right = 16
	buy_style.corner_radius_bottom_left = 16; buy_style.corner_radius_bottom_right = 16
	buy_style.shadow_color = Color8(255, 200, 0, 120)
	buy_style.shadow_size = 10
	buy_style.shadow_offset = Vector2(0, 3)
	var buy_hover_style = buy_style.duplicate()
	buy_hover_style.bg_color = Color8(255, 230, 60)
	buy_btn.add_theme_stylebox_override("normal", buy_style)
	buy_btn.add_theme_stylebox_override("hover", buy_hover_style)
	buy_btn.add_theme_stylebox_override("pressed", buy_style)
	buy_btn.add_theme_stylebox_override("focus", buy_style)
	buy_btn.pressed.connect(_on_buy_premium_pressed)
	prem_vbox.add_child(buy_btn)

	# --- COSMETICS SECTION ---
	var cosm_title = create_label_node("SHOP_COSMETICS", white, 38)
	cosm_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cosm_title.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	cosm_title.add_theme_constant_override("shadow_offset_y", 4)
	vbox.add_child(cosm_title)

	var cosm_sep = HSeparator.new(); vbox.add_child(cosm_sep)
	ui_separators.append(cosm_sep)

	# Ball skins grid
	var balls_label = create_label_node("SHOP_BALL_SKINS", white, 42)
	balls_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	balls_label.add_theme_color_override("font_shadow_color", Color8(0,0,0,150))
	balls_label.add_theme_constant_override("shadow_offset_y", 4)
	vbox.add_child(balls_label)

	var balls_grid = GridContainer.new()
	balls_grid.columns = 3
	balls_grid.add_theme_constant_override("h_separation", 15)
	balls_grid.add_theme_constant_override("v_separation", 15)
	var balls_grid_margin = MarginContainer.new()
	balls_grid_margin.add_theme_constant_override("margin_left", 20)
	balls_grid_margin.add_theme_constant_override("margin_right", 20)
	balls_grid_margin.add_child(balls_grid)
	vbox.add_child(balls_grid_margin)

	var ball_skin_names = ["Klasik", "Altın", "Neon", "Krom", "Lav", "Buz"]
	var ball_skin_colors = [
		Color8(255,255,255), Color8(255,210,0), Color8(57,255,20),
		Color8(180,200,220), Color8(255,80,0), Color8(120,200,255)
	]
	for bi in range(ball_skin_names.size()):
		var card = PanelContainer.new()
		var card_style = StyleBoxFlat.new()
		card_style.bg_color = Color8(15, 25, 40, 220)
		card_style.corner_radius_top_left = 14; card_style.corner_radius_top_right = 14
		card_style.corner_radius_bottom_left = 14; card_style.corner_radius_bottom_right = 14
		card_style.border_width_bottom = 3
		card_style.border_color = ball_skin_colors[bi].darkened(0.3)
		card_style.content_margin_top = 22; card_style.content_margin_bottom = 22
		card.add_theme_stylebox_override("panel", card_style)
		card.custom_minimum_size = Vector2(0, 145)

		var card_vbox = VBoxContainer.new()
		card_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		card.add_child(card_vbox)

		# Ball circle preview
		var ball_preview = Control.new()
		ball_preview.custom_minimum_size = Vector2(70, 70)
		ball_preview.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		var bcolor = ball_skin_colors[bi]
		ball_preview.draw.connect(func():
			var c = ball_preview.size / 2.0
			var r = 28.0
			ball_preview.draw_circle(c, r, bcolor)
			ball_preview.draw_arc(c, r, 0, TAU, 48, bcolor.darkened(0.4), 4, true)
			ball_preview.draw_arc(c, r - 2.0, 0, TAU, 48, Color.WHITE, 1.5, true)
		)
		card_vbox.add_child(ball_preview)

		var name_lbl = Label.new()
		name_lbl.text = ball_skin_names[bi]
		name_lbl.add_theme_font_override("font", custom_font)
		name_lbl.add_theme_font_size_override("font_size", 30)
		name_lbl.add_theme_color_override("font_color", Color.WHITE)
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card_vbox.add_child(name_lbl)

		var lock_lbl = Label.new()
		lock_lbl.text = "🔒"
		lock_lbl.add_theme_font_override("font", custom_font)
		lock_lbl.add_theme_font_size_override("font_size", 28)
		lock_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card_vbox.add_child(lock_lbl)

		balls_grid.add_child(card)

	# Bottom spacer for nav bar
	var sp_bot = Control.new(); sp_bot.custom_minimum_size = Vector2(0, 160); vbox.add_child(sp_bot)

	return page

func _on_buy_premium_pressed():
	# Show a purchase confirmation dialog
	var dlg = PanelContainer.new()
	var dlg_style = StyleBoxFlat.new()
	dlg_style.bg_color = Color8(15, 20, 35, 250)
	dlg_style.corner_radius_top_left = 20; dlg_style.corner_radius_top_right = 20
	dlg_style.corner_radius_bottom_left = 20; dlg_style.corner_radius_bottom_right = 20
	dlg_style.border_width_top = 3; dlg_style.border_width_bottom = 3
	dlg_style.border_width_left = 3; dlg_style.border_width_right = 3
	dlg_style.border_color = Color8(255, 210, 0)
	dlg_style.shadow_color = Color8(0, 0, 0, 180)
	dlg_style.shadow_size = 30
	dlg_style.content_margin_left = 40; dlg_style.content_margin_right = 40
	dlg_style.content_margin_top = 35; dlg_style.content_margin_bottom = 35
	dlg.add_theme_stylebox_override("panel", dlg_style)
	dlg.custom_minimum_size = Vector2(600, 0)

	# Center it
	var dlg_center = CenterContainer.new()
	dlg_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg_center.add_child(dlg)
	add_child(dlg_center)

	var dlg_vbox = VBoxContainer.new()
	dlg_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_vbox.add_theme_constant_override("separation", 25)
	dlg.add_child(dlg_vbox)

	var dlg_title = Label.new()
	dlg_title.text = "⭐  PRO'ya Yükselt"
	dlg_title.add_theme_font_override("font", custom_font)
	dlg_title.add_theme_font_size_override("font_size", 44)
	dlg_title.add_theme_color_override("font_color", Color8(255, 210, 0))
	dlg_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_vbox.add_child(dlg_title)

	var dlg_desc = Label.new()
	dlg_desc.text = "₺49.99 karşılığında tüm premium özelliklere kalıcı erişim elde et. Bu uygulama içi satın alma Google Play üzerinden gerçekleşir."
	dlg_desc.add_theme_font_override("font", custom_font)
	dlg_desc.add_theme_font_size_override("font_size", 28)
	dlg_desc.add_theme_color_override("font_color", Color.WHITE)
	dlg_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg_desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	dlg_vbox.add_child(dlg_desc)

	var dlg_hbox = HBoxContainer.new()
	dlg_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg_hbox.add_theme_constant_override("separation", 20)
	dlg_vbox.add_child(dlg_hbox)

	var cancel_btn = Button.new()
	cancel_btn.text = "VAZGEÇ"
	cancel_btn.add_theme_font_override("font", custom_font)
	cancel_btn.add_theme_font_size_override("font_size", 28)
	var cancel_style = StyleBoxFlat.new()
	cancel_style.bg_color = Color8(60, 60, 80, 220)
	cancel_style.corner_radius_top_left = 12; cancel_style.corner_radius_top_right = 12
	cancel_style.corner_radius_bottom_left = 12; cancel_style.corner_radius_bottom_right = 12
	cancel_btn.add_theme_stylebox_override("normal", cancel_style)
	cancel_btn.add_theme_stylebox_override("hover", cancel_style)
	cancel_btn.add_theme_stylebox_override("pressed", cancel_style)
	cancel_btn.add_theme_stylebox_override("focus", cancel_style)
	cancel_btn.custom_minimum_size = Vector2(200, 65)
	cancel_btn.pressed.connect(func(): dlg_center.queue_free())
	dlg_hbox.add_child(cancel_btn)

	var confirm_btn = Button.new()
	confirm_btn.text = "SATIN AL"
	confirm_btn.add_theme_font_override("font", custom_font)
	confirm_btn.add_theme_font_size_override("font_size", 28)
	confirm_btn.add_theme_color_override("font_color", Color8(10, 10, 10))
	var confirm_style = StyleBoxFlat.new()
	confirm_style.bg_color = Color8(255, 210, 0)
	confirm_style.corner_radius_top_left = 12; confirm_style.corner_radius_top_right = 12
	confirm_style.corner_radius_bottom_left = 12; confirm_style.corner_radius_bottom_right = 12
	confirm_btn.add_theme_stylebox_override("normal", confirm_style)
	confirm_btn.add_theme_stylebox_override("hover", confirm_style)
	confirm_btn.add_theme_stylebox_override("pressed", confirm_style)
	confirm_btn.add_theme_stylebox_override("focus", confirm_style)
	confirm_btn.custom_minimum_size = Vector2(200, 65)
	confirm_btn.pressed.connect(func():
		# Placeholder: trigger actual in-app billing here
		dlg_center.queue_free()
	)
	dlg_hbox.add_child(confirm_btn)

# ======================================================
# SWIPE INPUT
# ======================================================
func _input(event: InputEvent):
	if settings_overlay != null and settings_overlay.visible:
		return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_RIGHT and current_tab < 2:
			_switch_tab(current_tab + 1)
		elif event.keycode == KEY_LEFT and current_tab > 0:
			_switch_tab(current_tab - 1)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				swipe_start = event.position
				swipe_active = true
			else:
				swipe_active = false
	elif event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.position
			swipe_active = true
		else:
			swipe_active = false
	elif swipe_active and (event is InputEventMouseMotion or event is InputEventScreenDrag):
		var pos = event.position
		var delta_x = pos.x - swipe_start.x
		var delta_y = abs(pos.y - swipe_start.y)
		if abs(delta_x) > swipe_threshold and abs(delta_x) > delta_y * 1.5:
			swipe_active = false
			if delta_x < 0 and current_tab < 2:
				_switch_tab(current_tab + 1)
			elif delta_x > 0 and current_tab > 0:
				_switch_tab(current_tab - 1)
