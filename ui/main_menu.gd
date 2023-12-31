extends Control

@onready var start = $VBoxContainer/Start
@onready var quit = $VBoxContainer/Quit


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start.grab_focus()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://ui/loadout_ui.tscn")

func _on_quit_pressed():
	get_tree().quit()
