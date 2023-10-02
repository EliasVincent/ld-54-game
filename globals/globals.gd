extends Node

var isFS: bool = false
var memory: int = 10 # in MB

var targetsToHit: int = 10

# TODO: tatsaechliche stats
# Wir koennen es so machen: entweder diese Stats sind die
# Ausgangsstats, also resetten sich sich jedes mal, 
# oder man nimmt sie mit. Also wenn man im letzten level
# 50 hp verloren hat, kann man sich gegen Memory heilen
var PLAYER_STATS = {
	PLAYER_HP = 100,
	PLAYER_SPEED = 100
}

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
		