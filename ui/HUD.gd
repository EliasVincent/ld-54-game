extends Control

@onready var timer_label = $CenterContainer/TimerLabel
@onready var hp_label = $VBoxContainer/HPLabel
@onready var targets_label = $VBoxContainer/TargetsLabel


# HUD darf NICHT Game Logic kontrollieren, nur anzeigen
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_label.text = str(Globals.currentGameTimer)
	hp_label.text = str("HP: ", Globals.PLAYER_STATS.PLAYER_HP)
	targets_label.text = str("TARGETS: ", Globals.targetsToHit)
