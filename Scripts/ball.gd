extends Area2D

@onready var sprite = $Sprite2D

var rng = RandomNumberGenerator.new()

var direction
var speed

func get_spin_speed():
	const SPIN_SPEED_MAX = 720
	return direction.y * SPIN_SPEED_MAX

func reset(reset_rotation):
	set_process(false)
	speed = 0
	direction = Vector2.ZERO
	position = Vector2.ZERO
	if reset_rotation:
		sprite.rotation = 0

func launch():
	const LAUNCH_SPEED = 500
	var target = Vector2(1 if rng.randf() > 0.5 else -1, rng.randf_range(-0.75, 0.75))
	direction = Vector2.ZERO.direction_to(target)
	speed = LAUNCH_SPEED
	set_process(true)

func wall_bounce(_area):
	direction.y = -direction.y

func _ready():
	reset(true)

func _process(delta):
	sprite.rotate(deg_to_rad(get_spin_speed()) * delta)
	move_local_x(speed * direction.x * delta)
	move_local_y(speed * direction.y * delta)
