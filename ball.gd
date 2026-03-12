extends Node2D

const POST_RADIUS = 4.0
const POST_ELASTICITY = 1.04
const BALL_RADIUS = 48.0
const SPEED = 7.8
const MIN_SPEED = 5.75
const GRAVITY = 0.055
const FRICTION = 0.999
const BOUNCE_DAMPING = 0.985

var ARENA_CENTER = Vector2.ZERO
var current_team_name = ""
var team_colors = [Color.WHITE, Color.BLACK]
var team_short_name = ""
var logo_texture: Texture2D
var badge_texture: Texture2D  # Mascot badge drawn on top of ball

# Map short team names to mascot overlay images
const BADGE_MAP = {
	"FB":  "res://fb1.png",
	"TS":  "res://ts1.png",
	"GS":  "res://gs1.png",
	"BJK": "res://bjk1.png"
}

var velocity = Vector2.ZERO
var mass = 1.0
var nerf_timer = 0
var yellow_nerf_timer = 0
var speed_multiplier = 1.0

var shadow_color = Color(0, 0, 0, 80.0 / 255.0)
var white = Color.WHITE
var shadow_offset = Vector2(8, 8)

var max_history = 10
var history = []

func init_ball(team_name: String, center_pos: Vector2, r_limit: float, avoid_pos: Vector2 = Vector2(-9999, -9999)):
	ARENA_CENTER = center_pos
	current_team_name = team_name # Save the team name so it doesn't default to GS
	team_colors = Global.TEAMS[team_name]["colors"]
	team_short_name = Global.TEAMS[team_name]["short"]
	
	
	if Global.TEAM_LOGOS.has(team_name) and Global.TEAM_LOGOS[team_name] != null:
		logo_texture = Global.TEAM_LOGOS[team_name]
	else:
		logo_texture = null
	self.set("current_logo_path", team_name)

	# Assign mascot badge if available for this team
	badge_texture = null
	if BADGE_MAP.has(team_short_name):
		badge_texture = load(BADGE_MAP[team_short_name])
	
	var valid_spawn = false
	var attempts = 0
	while not valid_spawn and attempts < 100:
		var spawn_angle = randf() * TAU
		var spawn_dist = randf_range(20.0, 80.0) 
		position = center_pos + Vector2(cos(spawn_angle), sin(spawn_angle)) * spawn_dist
		if avoid_pos != Vector2(-9999, -9999) and position.distance_to(avoid_pos) < BALL_RADIUS * 2.2:
			attempts += 1
		else:
			valid_spawn = true
	
	var target_angle = (center_pos - position).angle() + randf_range(-0.5, 0.5)
	velocity = Vector2(cos(target_angle), sin(target_angle)) * SPEED
	
	speed_multiplier = 1.0
	nerf_timer = 0
	yellow_nerf_timer = 0
	
	if not history.is_empty():
		history.clear()

func reset_and_explode(center_pos: Vector2):
	init_ball(current_team_name, center_pos, 220.0) # Uses saved team instead of Global.keys()[0]
	for _i in range(20):
		var p_color = team_colors[randi() % team_colors.size()]
		get_parent().create_particle(position, Vector2.ZERO, p_color)

func move():
	speed_multiplier = 1.0
	if nerf_timer > 0:
		speed_multiplier = 0.35
		nerf_timer -= 1
	elif yellow_nerf_timer > 0:
		speed_multiplier = 0.65
		yellow_nerf_timer -= 1
		
	var current_speed = velocity.length()
	if current_speed < MIN_SPEED:
		if current_speed == 0: velocity = Vector2(1, 0)
		velocity = velocity.normalized() * MIN_SPEED
		
	velocity *= FRICTION
	
	var dir_to_center = (ARENA_CENTER - position).normalized()
	velocity += dir_to_center * GRAVITY
	
	position += velocity * speed_multiplier
	
	history.push_front(position)
	if history.size() > max_history:
		history.pop_back()

func collide_wall(center_pos: Vector2, r_limit: float) -> bool:
	var dist = position.distance_to(center_pos)
	if dist > r_limit - BALL_RADIUS:
		var n = (center_pos - position).normalized()
		var overlap = (dist + BALL_RADIUS) - r_limit
		position += n * overlap
		
		var dot = velocity.dot(n)
		velocity -= 2.0 * dot * n
		velocity *= BOUNCE_DAMPING
		
		var hit_pos = position - n * BALL_RADIUS
		var p_color = team_colors[randi() % team_colors.size()]
		var is_crit = randf() < 0.1
		var particle_count = 12 if is_crit else 8
		var base_vel = n * (6.67 if is_crit else 3.33)
		
		for _i in range(particle_count):
			get_parent().create_particle(hit_pos, base_vel, p_color)
		return true
	return false

func collide_post(post_pos: Vector2) -> bool:
	var dist = position.distance_to(post_pos)
	if dist < BALL_RADIUS + POST_RADIUS:
		var n = (position - post_pos).normalized()
		var overlap = (BALL_RADIUS + POST_RADIUS) - dist
		var dot = velocity.dot(n)
		
		velocity -= 2.0 * dot * n
		velocity *= POST_ELASTICITY
		position += n * overlap
		
		var hit_pos = position - n * BALL_RADIUS
		var p_color = team_colors[randi() % team_colors.size()]
		
		for _i in range(8):
			get_parent().create_particle(hit_pos, n * 4.0, p_color)
		return true
	return false

func _draw():
	for i in range(history.size()):
		var ratio = float(max_history - i) / max_history
		var trail_radius = int(BALL_RADIUS * ratio * 0.8)
		if trail_radius > 0:
			var alpha = ratio * 0.5
			var trail_color = team_colors[0]
			trail_color.a = alpha
			draw_circle(history[i] - position, trail_radius, trail_color)

	draw_circle(shadow_offset, BALL_RADIUS - 2.0, shadow_color)
	draw_circle(Vector2.ZERO, BALL_RADIUS, team_colors[0])

	var stripe_w = (BALL_RADIUS * 2.0) / 6.0
	for x in range(int(-BALL_RADIUS), int(BALL_RADIUS)):
		var stripe_index = int((x + BALL_RADIUS) / stripe_w)
		if stripe_index % 2 != 0:
			var y = sqrt(max(0, BALL_RADIUS * BALL_RADIUS - x * x))
			draw_line(Vector2(x, -y), Vector2(x, y), team_colors[1], 1.0)
			
	# Colored arc inside, white arc at the very edge (ALL WHITE NOW)
	draw_arc(Vector2.ZERO, BALL_RADIUS - 1.5, 0, TAU, 64, white, 1.2, true)
	draw_arc(Vector2.ZERO, BALL_RADIUS, 0, TAU, 64, white, 0.8, true)
	
	if logo_texture:
		var logo_size = Vector2(50, 50) 
		var logo_rect = Rect2(-logo_size / 2.0, logo_size)
		draw_texture_rect(logo_texture, logo_rect, false)

	# Draw team mascot badge centered on ball
	if badge_texture:
		var badge_size = Vector2(80, 80)
		var badge_rect = Rect2(-badge_size / 2.0, badge_size)
		draw_texture_rect(badge_texture, badge_rect, false)

	if nerf_timer > 0 or yellow_nerf_timer > 0:
		var crd_w = 12
		var crd_h = 18
		var offset_amount = BALL_RADIUS + 4.0
		var card_top_right = Vector2(offset_amount / 1.414, -offset_amount / 1.414)
		var c_rect = Rect2(card_top_right.x, card_top_right.y - crd_h, crd_w, crd_h)
		
		# If red card is active, it takes precedence in display
		var is_red = nerf_timer > 0
		var visible_alpha = 1.0
		
		var active_timer = nerf_timer if is_red else yellow_nerf_timer
		# Start blinking if time is less than 5 seconds (5 * 60 FPS = 300 frames)
		if active_timer < 300:
			if int(active_timer / 7.5) % 2 == 0: visible_alpha = 0.0
			
		if visible_alpha > 0.0:
			var card_color = Color8(250, 10, 10) if is_red else Color8(255, 220, 0)
			draw_rect(c_rect, card_color)
			draw_rect(c_rect, Color.WHITE, false, 1.0)
