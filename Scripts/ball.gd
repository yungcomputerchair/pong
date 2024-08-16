extends Area2D

@onready var sprite = $Sprite2D

var rng = RandomNumberGenerator.new()

var idle
var direction
var speed

func get_spin_speed():
	const SPIN_SPEED_MAX = 720
	const SPIN_SPEED_IDLE = 30
	if idle:
		return SPIN_SPEED_IDLE
	return direction.y * SPIN_SPEED_MAX

func reset():
	idle = true
	speed = 0
	direction = Vector2.ZERO
	position = Vector2.ZERO

func launch():
	const LAUNCH_SPEED = 500
	var target = Vector2(rng.randf_range(-1, 1), rng.randf_range(-0.5, 0.5))
	direction = Vector2.ZERO.direction_to(target)
	speed = LAUNCH_SPEED
	idle = false

func bounce_vert(_area):
	if idle:
		pass
	direction.y = -direction.y

func _ready():
	reset()

func _process(delta):
	sprite.rotate(deg_to_rad(get_spin_speed()) * delta)
	if not idle:
		move_local_x(speed * direction.x * delta)
		move_local_y(speed * direction.y * delta)
