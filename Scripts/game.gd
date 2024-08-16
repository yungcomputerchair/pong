extends Node2D

var rng = RandomNumberGenerator.new()

var ball
var ball_sprite
var tbound
var bbound
var lbound
var rbound

var idle
var direction
var speed

var left_score
var right_score

func get_spin_speed():
	const SPIN_SPEED_MAX = 720
	const SPIN_SPEED_IDLE = 30

	if idle:
		return SPIN_SPEED_IDLE
	return direction.y * SPIN_SPEED_MAX

func reset():
	idle = true
	speed = 0
	ball.position = Vector2.ZERO

func launch():
	const LAUNCH_SPEED = 500

	var target = Vector2(rng.randf_range(-1, 1), rng.randf_range(-0.5, 0.5))
	direction = Vector2.ZERO.direction_to(target)
	speed = LAUNCH_SPEED
	idle = false

func bounce_vert(_area):
	direction.y = -direction.y

func new_game():
	left_score = 0
	right_score = 0
	reset()

func get_winner():
	const POINTS_TO_WIN = 10
	print("Left: ", left_score, "; Right: ", right_score)
	if left_score >= POINTS_TO_WIN:
		return -1
	if right_score >= POINTS_TO_WIN:
		return 1
	return 0

func oob_left(_area):
	right_score += 1
	if get_winner() == 0:
		reset()

func oob_right(_area):
	left_score += 1
	if get_winner() == 0:
		reset()

# Called when the node enters the scene tree for the first time.
func _ready():
	ball = get_node("Ball")
	ball_sprite = ball.get_node("Sprite2D")
	tbound = get_node("TopBoundary")
	bbound = get_node("BotBoundary")
	lbound = get_node("LeftBoundary")
	rbound = get_node("RightBoundary")

	tbound.connect("area_entered", bounce_vert)
	bbound.connect("area_entered", bounce_vert)
	lbound.connect("area_entered", oob_left)
	rbound.connect("area_entered", oob_right)

	new_game()
	set_process_input(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ball_sprite.rotate(deg_to_rad(get_spin_speed()) * delta)
	if not idle:
		ball.move_local_x(speed * direction.x * delta)
		ball.move_local_y(speed * direction.y * delta)

func _input(_ev):
	if Input.is_key_pressed(KEY_SPACE) and idle:
		launch()
