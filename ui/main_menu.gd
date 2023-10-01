extends Control

@onready var start = $VBoxContainer/Start
@onready var quit = $VBoxContainer/Quit


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start.grab_focus()


func _on_start_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
