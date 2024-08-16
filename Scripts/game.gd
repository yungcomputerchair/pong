extends Node2D

@onready var ball = $Ball
@onready var tbound = $TopBoundary
@onready var bbound = $BotBoundary
@onready var lbound = $LeftBoundary
@onready var rbound = $RightBoundary

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

func resize():
	const GOAL_OFFSET = 75
	var sz = get_viewport_rect().size
	tbound.get_node("CollisionShape2D").shape.distance = -sz.y / 2
	bbound.get_node("CollisionShape2D").shape.distance = -sz.y / 2
	lbound.get_node("CollisionShape2D").shape.distance = -sz.x / 2 - GOAL_OFFSET
	rbound.get_node("CollisionShape2D").shape.distance = -sz.x / 2 - GOAL_OFFSET

func _ready():
	tbound.connect("area_entered", ball.bounce_vert)
	bbound.connect("area_entered", ball.bounce_vert)
	lbound.connect("area_entered", oob_left)
	rbound.connect("area_entered", oob_right)
	get_viewport().connect("size_changed", resize)

	new_game()
	set_process_input(true)

func _input(_ev):
	if Input.is_key_pressed(KEY_SPACE) and ball.idle:
		ball.launch()
