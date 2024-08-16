extends Node2D

var ball
var tbound
var bbound
var lbound
var rbound

var left_score
var right_score

func new_game():
	left_score = 0
	right_score = 0
	ball.reset()

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
		ball.reset()

func oob_right(_area):
	left_score += 1
	if get_winner() == 0:
		ball.reset()

func _ready():
	ball = get_node("Ball")
	tbound = get_node("TopBoundary")
	bbound = get_node("BotBoundary")
	lbound = get_node("LeftBoundary")
	rbound = get_node("RightBoundary")

	tbound.connect("area_entered", ball.bounce_vert)
	bbound.connect("area_entered", ball.bounce_vert)
	lbound.connect("area_entered", oob_left)
	rbound.connect("area_entered", oob_right)

	new_game()
	set_process_input(true)

func _process(_delta):
	pass

func _input(_ev):
	if Input.is_key_pressed(KEY_SPACE) and ball.idle:
		ball.launch()
