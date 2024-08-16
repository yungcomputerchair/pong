extends Area2D

var sprite;

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = find_child("Sprite2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.rotate(deg_to_rad(30) * delta)
