extends Area3D

var isPlayerInside: bool = false
var isTimerValid: bool = false
var allTargetsDestroyed: bool = false


func _ready():
	pass # Replace with function body.



func _process(delta):
	if Globals.currentGameTimer > 0:
		isTimerValid = true
	if Globals.targetsToHit < 1:
		allTargetsDestroyed = true
	# TODO: soll man auch weiter können wenn nicht alle erfüllt sind?
	if isPlayerInside and isTimerValid and allTargetsDestroyed:
		Globals.handleLevelWin()


func _on_body_entered(body):
	if body.is_in_group("PLAYER"):
		isPlayerInside = true


func _on_body_exited(body):
	if body.is_in_group("PLAYER"):
		isPlayerInside = false
