extends Control

@onready var memory_remaining = $MemoryRemaining
@onready var current_hp = $StatsContainer/CurrentHP
@onready var current_speed = $StatsContainer/CurrentSpeed
@onready var hp_upgrade_toggle = $UpgradeContainer/HPUpgradeToggle
@onready var firing_speed_upgrade_toggle = $UpgradeContainer/FiringSpeedUpgradeToggle
@onready var damage_upgrade_toggle = $UpgradeContainer/DamageUpgradeToggle
@onready var hud_upgrade_toggle = $UpgradeContainer/HUDUpgradeToggle
@onready var speed_upgrade_toggle = $UpgradeContainer/SpeedUpgradeToggle



@onready var error_sound = $Audio/ErrorSound
@onready var upgrade_success_sound = $Audio/UpgradeSuccessSound



func _ready():
	# RESET VALUES
  # If we want multiple levels, we prob don't want this anymore
	Globals.resetLoadoutValues()

func _process(delta):
	# TEXT
	memory_remaining.text = str("MEMORY: ", Globals.memory, " MB")
	current_hp.text = str(Globals.PLAYER_STATS.PLAYER_HP, " HP")
	current_speed.text = str(Globals.PLAYER_STATS.PLAYER_SPEED, " SPEED")


# Modulares upgraden mit checks und so weiter
func apply_upgrade(memoryToSubtract: int, PLAYER_STAT, amountToAdd, toggle: CheckButton):
	if memoryToSubtract > Globals.memory:
		print("NOT ENOUGH MEMORY")
		error_sound.play()
		toggle.button_pressed = false
		#return
	match PLAYER_STAT:
		"PLAYER_HP":
			Globals.PLAYER_STATS.PLAYER_HP += amountToAdd
		"PLAYER_SPEED":
			Globals.PLAYER_STATS.PLAYER_SPEED += amountToAdd
		"machineGunShootDelay":
			Globals.machineGunShootDelay -= amountToAdd
		"machineGunDamage":
			Globals.machineGunDamage += amountToAdd
		_:
			print("UPGRADE COULDNT BE MATCHED")
	
	Globals.memory -= memoryToSubtract
	upgrade_success_sound.play()

func apply_downgrade(memoryToAdd: int, PLAYER_STAT, amountToSubtract, toggle):
	print("downgrade")
	match PLAYER_STAT:
		"PLAYER_HP":
			Globals.PLAYER_STATS.PLAYER_HP -= amountToSubtract
		"PLAYER_SPEED":
			Globals.PLAYER_STATS.PLAYER_SPEED -= amountToSubtract
		"machineGunShootDelay":
			Globals.machineGunShootDelay += amountToSubtract
		"machineGunDamage":
			Globals.machineGunDamage -= amountToSubtract
		_:
			print("DOWNGRADE COULDNT BE MATCHED")

	Globals.memory += memoryToAdd
	error_sound.play()



func _on_hp_upgrade_toggle_toggled(button_pressed):
	if button_pressed:
		apply_upgrade(2, "PLAYER_HP", 20.0, hp_upgrade_toggle)
	else:
		apply_downgrade(2, "PLAYER_HP", 20.0, hp_upgrade_toggle)


func _on_firing_speed_upgrade_toggle_toggled(button_pressed):
	if button_pressed:
		apply_upgrade(2, "machineGunShootDelay", 0.1, firing_speed_upgrade_toggle)
	else:
		apply_downgrade(2, "machineGunShootDelay", 0.1, firing_speed_upgrade_toggle)


func _on_damage_upgrade_toggle_toggled(button_pressed):
	if button_pressed:
		apply_upgrade(2, "machineGunDamage", 0.5, damage_upgrade_toggle)
	else:
		apply_downgrade(2, "machineGunDamage", 0.5, damage_upgrade_toggle)


func _on_hud_upgrade_toggle_toggled(button_pressed):
	Globals.hudEnabled = button_pressed
	if button_pressed:
		Globals.memory -= 2
	if !button_pressed:
		Globals.memory += 2
	error_sound.play()


func _on_speed_upgrade_toggle_toggled(button_pressed):
	if button_pressed:
		apply_upgrade(2, "PLAYER_SPEED", 0.5, speed_upgrade_toggle)
	else:
		apply_downgrade(2, "PLAYER_SPEED", 0.5, speed_upgrade_toggle)


func _on_deploy_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
