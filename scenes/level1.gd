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

