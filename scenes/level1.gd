extends Node3D

# nur Turret instanzen in Turrets Node!
@onready var turrets = $Turrets

var numOfTurretsInScene: int = 0

func _ready():
	var initialTurrets: int = 0
	for turret in turrets.get_children():
		initialTurrets += 1
	print("Initial number of turrets in scene: ", initialTurrets)
	
	Globals.level_init()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	numOfTurretsInScene = turrets.get_child_count()
	Globals.targetsToHit = numOfTurretsInScene



func _on_death_area_body_entered(body):
	if body.is_in_group("PLAYER"):
		get_tree().change_scene_to_file("res://ui/game_over.tscn")
