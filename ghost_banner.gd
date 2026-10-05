extends Control
class_name GhostBanner

# -------------------------------------------------------------------------
# Card data – each entry is a string to be shown in the banner.
# Feel free to add/remove items; they will be selected randomly.
# -------------------------------------------------------------------------
const CARD_POOL := [
	"Visit ebstudyo.com for exclusive tips!",
	"Goals scored so far: %d",
	"Games played total: %d",
	"Did you know? Our national teams are now localized!",
	"Pro members enjoy ad‑free play + special crowns.",
	"Daily Quest: Score 3 goals to earn 50 coins!",
	"Check the live leaderboard at ebstudyo.com",
    "Unlock new ball skins in the shop!"
]

onready var label   = $Label
onready var pro_badge = $ProBadge

var rotate_timer : Timer
var ad_filled : bool = false    # set by the AdMob script when an ad loads

func _ready() -> void:
	visible = false
	rotate_timer = Timer.new()
	rotate_timer.wait_time = 8.0
	rotate_timer.one_shot = false
	rotate_timer.autostart = true
	add_child(rotate_timer)
	rotate_timer.connect("timeout", self, "_on_rotate")
	rotate_timer.start()
	_update_card()
	pro_badge.visible = false

func _on_rotate() -> void:
	_update_card()

func _update_card() -> void:
	var txt = CARD_POOL[randi() % CARD_POOL.size()]
	if txt.find("%d") != -1:
		if txt.begins_with("Goals"):
			txt = txt % Global.stats.total_goals
		elif txt.begins_with("Games"):
			txt = txt % Global.stats.total_matches
	label.text = txt

func set_ad_filled(filled: bool) -> void:
	ad_filled = filled
	visible = not filled

func show_pro_badge(show: bool) -> void:
	pro_badge.visible = show
