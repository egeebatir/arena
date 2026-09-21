extends Node

var pitch_scene = preload("res://pitch.tscn")
var matches_to_simulate = 20
var matches_done = 0
var total_goals = 0

var current_pitch = null

func _ready():
	print("Starting Goal Simulation...")
	Engine.time_scale = 100.0
	start_match()

func start_match():
	if matches_done >= matches_to_simulate:
		print("=== SIMULATION COMPLETE ===")
		print("Total Goals: ", total_goals)
		var avg = float(total_goals) / matches_to_simulate
		print("Average Goals: ", avg)
		if avg < 3.1:
			print("RECOMMENDATION: INCREASE GOAL WIDTH")
		elif avg > 3.6:
			print("RECOMMENDATION: DECREASE GOAL WIDTH")
		else:
			print("RECOMMENDATION: PERFECT")
		get_tree().quit()
		return
		
	current_pitch = pitch_scene.instantiate()
	# Randomize teams
	var keys = Global.TEAMS.keys()
	Global.home_team_name = keys[randi() % keys.size()]
	Global.away_team_name = keys[randi() % keys.size()]
	
	add_child(current_pitch)

func _process(_delta):
	if current_pitch and current_pitch.state == "FULLTIME":
		var g = current_pitch.score1 + current_pitch.score2
		total_goals += g
		matches_done += 1
		print("Match ", matches_done, " finished with ", g, " goals.")
		current_pitch.queue_free()
		current_pitch = null
		start_match()
