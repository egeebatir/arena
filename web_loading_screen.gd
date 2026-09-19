extends Control

func _ready():
    var custom_font = load("res://IMPACT.TTF")
    var active_theme = Global.THEMES[Global.current_theme]

    # --- Background ---
    var bg = ColorRect.new()
    bg.color = active_theme.bg_bottom
    bg.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    # --- Center panel ---
    var center = CenterContainer.new()
    center.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(center)

    var vbox = VBoxContainer.new()
    vbox.alignment = BoxContainer.ALIGNMENT_CENTER
    vbox.add_theme_constant_override("separation", 24)
    center.add_child(vbox)

    # Game title
    var title = Label.new()
    title.text = "BOL GOL FUTBOL"
    title.add_theme_font_override("font", custom_font)
    title.add_theme_font_size_override("font_size", 72)
    title.add_theme_color_override("font_color", Color.WHITE)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vbox.add_child(title)

    # Tap-to-start button (required to unlock audio on web)
    var start_btn = Button.new()
    start_btn.text = "OYNA"
    start_btn.add_theme_font_override("font", custom_font)
    start_btn.add_theme_font_size_override("font_size", 36)
    start_btn.custom_minimum_size = Vector2(320, 80)
    start_btn.pressed.connect(_on_start_pressed)
    vbox.add_child(start_btn)

    # Small brand label
    var brand = Label.new()
    brand.text = "ebstudyo.com"
    brand.add_theme_font_size_override("font_size", 18)
    brand.add_theme_color_override("font_color", Color(1, 1, 1, 0.4))
    brand.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vbox.add_child(brand)

func _on_start_pressed():
    if is_instance_valid(Global.bg_music_player) and not Global.bg_music_player.playing:
        Global.bg_music_player.play()
    get_tree().change_scene_to_file("res://main_menu.tscn")
