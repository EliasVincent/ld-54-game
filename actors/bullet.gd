extends CharacterBody3D
var playerPos

# Called when the node enters the scene tree for the first time.
func _ready():
	playerPos = get_tree().get_nodes_in_group("PLAYER")[0].global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.move_toward(playerPos, delta * 200)
