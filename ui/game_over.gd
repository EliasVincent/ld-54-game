extends Control

@onready var main_menu = $VBoxContainer/MainMenu
@onready var quit = $VBoxContainer/Quit

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	main_menu.grab_focus()



func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
