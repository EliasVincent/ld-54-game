extends StaticBody3D

@export var spawn_object: PackedScene
var playerPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerPos = Vector3(get_tree().get_nodes_in_group("PLAYER")[0].global_position.x, 
	global_position.y, 
	get_tree().get_nodes_in_group("PLAYER")[0].global_position.z)
	var targetPos = playerPos
	
	transform = transform.interpolate_with(transform.looking_at(targetPos), delta)


func _on_timer_timeout():
	var bullet = spawn_object.instantiate()
	bullet.global_position = Vector3(global_position.x , global_position.y + 1, global_position.z)
	get_parent().add_child(bullet)
	print("Bullet Spawned!")

func get_hit():
	# TODO: HP and so son and so on and aaa
	pass
