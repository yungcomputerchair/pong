extends Node2D

@onready var ball = $Ball
@onready var lpaddle = $LeftPaddle
@onready var rpaddle = $RightPaddle
@onready var tbound = $TopBoundary
@onready var bbound = $BotBoundary
@onready var lbound = $LeftBoundary
@onready var rbound = $RightBoundary
@onready var ui = %UI
@onready var point_sfx = $PointSound

var left_score
var right_score

var paddle_min
var paddle_max

func update_ui(winner):
	ui.update_scores(left_score, right_score)
	if winner != 0:
		ui.set_winner(winner)

func new_game():
	left_score = 0
	right_score = 0
	ui.set_start_text()
	update_ui(0)
	ball.reset(true)

func get_winner():
	const POINTS_TO_WIN = 3
	print("Left: ", left_score, "; Right: ", right_score)
	if left_score >= POINTS_TO_WIN:
		return -1
	if right_score >= POINTS_TO_WIN:
		return 1
	return 0

func check_winner():
	point_sfx.play()
	var winner = get_winner()
	if winner == 0:
		ball.reset(false)
	update_ui(winner)

func oob_left(_area):
	right_score += 1
	check_winner()

func oob_right(_area):
	left_score += 1
	check_winner()

func resize():
	const GOAL_OFFSET = 75
	const PADDLE_OFFSET = 25
	var sz = get_viewport_rect().size
	lpaddle.position.x = -sz.x / 2 + PADDLE_OFFSET
	rpaddle.position.x = sz.x / 2 - PADDLE_OFFSET 
	paddle_min = -sz.y / 2 + PADDLE_OFFSET * 2.5
	paddle_max = sz.y / 2 - PADDLE_OFFSET * 2.5
	tbound.get_node("CollisionShape2D").shape.distance = -sz.y / 2
	bbound.get_node("CollisionShape2D").shape.distance = -sz.y / 2
	lbound.get_node("CollisionShape2D").shape.distance = -sz.x / 2 - GOAL_OFFSET
	rbound.get_node("CollisionShape2D").shape.distance = -sz.x / 2 - GOAL_OFFSET
	
func move_paddle(paddle, dir):
	const PADDLE_MOVE_SPEED = 500
	var dy = dir * PADDLE_MOVE_SPEED
	paddle.position.y = clamp(paddle.position.y + dy, paddle_min, paddle_max)

func _ready():
	RenderingServer.set_default_clear_color(Color.WHITE)
	lpaddle.connect("area_entered", ball.paddle_bounce.bind(lpaddle))
	rpaddle.connect("area_entered", ball.paddle_bounce.bind(rpaddle))
	tbound.connect("area_entered", ball.wall_bounce)
	bbound.connect("area_entered", ball.wall_bounce)
	lbound.connect("area_entered", oob_left)
	rbound.connect("area_entered", oob_right)
	get_viewport().connect("size_changed", resize)
	resize()
	new_game()
	set_process_input(true)

func _input(_ev):
	if Input.is_key_pressed(KEY_SPACE) and not ball.is_processing():
		ui.clear_start_text()
		ball.launch()
	if Input.is_key_pressed(KEY_R):
		new_game()

func _process(delta):
	if Input.is_key_pressed(KEY_W):
		move_paddle(lpaddle, -1 * delta)
	if Input.is_key_pressed(KEY_S):
		move_paddle(lpaddle, 1 * delta)
	if Input.is_key_pressed(KEY_UP):
		move_paddle(rpaddle, -1 * delta)
	if Input.is_key_pressed(KEY_DOWN):
		move_paddle(rpaddle, 1 * delta)
