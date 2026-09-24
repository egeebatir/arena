extends Node

var pitch_scene = preload("res://pitch.tscn")
var matches_to_simulate = 10
var matches_done = 0
var total_goals = 0

var current_pitch = null
var current_match_home = ""
var current_match_away = ""

func _ready():
	print("Starting 10-Match Goal Simulation...")
	Engine.time_scale = 100.0
	start_match()

func start_match():
	if matches_done >= matches_to_simulate:
		print("=== 10-MATCH SIMULATION COMPLETE ===")
		print("Total Goals across 10 matches: ", total_goals)
		var avg = float(total_goals) / matches_to_simulate
		print("Average Goals per match: ", avg)
		if avg < 3.0:
			print("EVALUATION: Gol ortalaması düşük (Öneri: Kale genişliğini veya top hızını artırabilirsiniz).")
		elif avg > 3.8:
			print("EVALUATION: Gol ortalaması yüksek (Öneri: Kale genişliğini daraltabilirsiniz).")
		else:
			print("EVALUATION: Gol ortalaması dengeli ve ideal aralıkta (3.0 - 3.8).")
		get_tree().quit()
		return
		
	current_pitch = pitch_scene.instantiate()
	# Randomize teams
	var keys = Global.TEAMS.keys()
	current_match_home = keys[randi() % keys.size()]
	current_match_away = keys[randi() % keys.size()]
	while current_match_away == current_match_home:
		current_match_away = keys[randi() % keys.size()]
	Global.home_team_name = current_match_home
	Global.away_team_name = current_match_away
	
	add_child(current_pitch)

func _process(_delta):
	if current_pitch and current_pitch.state == "FULLTIME":
		var s1 = current_pitch.score1
		var s2 = current_pitch.score2
		var g = s1 + s2
		total_goals += g
		matches_done += 1
		print("Maç ", matches_done, ": ", current_match_home, " ", s1, " - ", s2, " ", current_match_away, " (Toplam: ", g, " gol)")
		current_pitch.queue_free()
		current_pitch = null
		start_match()

