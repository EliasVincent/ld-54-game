extends Control

@onready var memory_remaining = $MemoryRemaining
@onready var hp_upgrade = $UpgradeContainer/HPUpgrade
@onready var speed_upgrade = $UpgradeContainer/SpeedUpgrade
@onready var current_hp = $StatsContainer/CurrentHP
@onready var current_speed = $StatsContainer/CurrentSpeed

func _ready():
	pass

func _process(delta):
	# TEXT
	memory_remaining.text = str(Globals.memory, " MB")
	current_hp.text = str(Globals.PLAYER_STATS.PLAYER_HP, " HP")
	current_speed.text = str(Globals.PLAYER_STATS.PLAYER_SPEED, " SPEED")


func _on_hp_upgrade_pressed():
	apply_upgrade(2, "PLAYER_HP", 20)


func _on_speed_upgrade_pressed():
	apply_upgrade(4, "PLAYER_SPEED", 50)

# Modulares upgraden mit checks und so weiter
func apply_upgrade(memoryToSubtract: int, PLAYER_STAT, amountToAdd):
	if memoryToSubtract > Globals.memory:
		print("NOT ENOUGH MEMORY") # TODO: error sound
		return
	match PLAYER_STAT:
		"PLAYER_HP":
			Globals.PLAYER_STATS.PLAYER_HP += amountToAdd
		"PLAYER_SPEED":
			Globals.PLAYER_STATS.PLAYER_SPEED += amountToAdd
	
	Globals.memory -= memoryToSubtract

