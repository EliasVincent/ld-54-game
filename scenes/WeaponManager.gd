extends Node3D

@onready var fire_point = $"../FirePoint"
@onready var ray_cast_3d = $"../FirePoint/RayCast3D"

var canShoot: bool = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

# gets called when we click shoot
func shoot_auto():
	#if animation is not playing: play animation
	if ray_cast_3d.is_colliding():
		if ray_cast_3d.get_collider().is_in_group("ENEMY"):
			ray_cast_3d.get_collider().get_hit()
			print("ENEMY HIT")
