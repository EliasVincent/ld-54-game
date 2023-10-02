extends StaticBody3D

@export var spawn_object: PackedScene = preload("res://actors/bullet.tscn")
var playerPos

@export var turretHP: float = 3.0

func _ready():
	pass

func _process(delta):
	playerPos = Vector3(get_tree().get_nodes_in_group("PLAYER")[0].global_position.x, 
	global_position.y, 
	get_tree().get_nodes_in_group("PLAYER")[0].global_position.z)
	var targetPos = playerPos
	
	transform = transform.interpolate_with(transform.looking_at(targetPos), delta)


func _on_timer_timeout():
	var bullet = spawn_object.instantiate()
	bullet.global_position = Vector3(global_position.x , global_position.y + 1.3, global_position.z)
	get_parent().add_child(bullet)
	#print("Bullet Spawned!")

func get_hit(damage):
	GlobalLogic.playHitSound()
	turretHP -= damage
	if turretHP <= 0.0:
		#TODO: animationplayer with sound and effects
		self.queue_free()
