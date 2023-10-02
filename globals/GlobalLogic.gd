extends Node

@onready var game_timer = $GameTimer


# TODO: erst starten wenn auf level geklickt
func _ready():
	pass

func _process(delta):
	Globals.currentGameTimer = game_timer.time_left

func _on_game_timer_timeout():
	Globals.handleLevelTimerTimeout()

func start_level_timer():
	game_timer.wait_time = Globals.initialGameTimer
	game_timer.start()
