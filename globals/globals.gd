extends Node

var isFS: bool = false
var playerHp: int = 100
var playerSpeed: int = 100

var targetsToHit: int = 10

func _input(event):
	if Input.is_action_just_pressed("fullscreen"):
		if isFS:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			#ProjectSettings.set_setting("display/window/size/mode", "windowed")
			isFS = false
			OS
		else:
			#ProjectSettings.set_setting("display/window/size/mode", "fullscreen")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			isFS = true
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
		
