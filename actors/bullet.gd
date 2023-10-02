extends CharacterBody3D
var playerPos

@onready var collision_shape_3d = $CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	playerPos = get_tree().get_nodes_in_group("PLAYER")[0].global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.move_toward(playerPos, delta * 10)
	


func _on_area_3d_body_entered(body):
	if body.is_in_group("PLAYER"):
		body.get_hit()
		self.queue_free() #byebye
	elif body.is_in_group("ENEMY"):
		pass
	elif body.is_in_group("BULLET"):
		pass
	else:
		self.queue_free()
