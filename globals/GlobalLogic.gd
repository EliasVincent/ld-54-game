extends Node

@onready var game_timer = $GameTimer

@onready var hit_sound = $Sounds/HitSound
@onready var dash_sound = $Sounds/DashSound
@onready var jump_sound = $Sounds/JumpSound
@onready var hurt_sound = $Sounds/HurtSound

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

func playHitSound():
	hit_sound.play()

func playDashSound():
	dash_sound.play()

func playJumpSound():
	jump_sound.play()

func playHurtSound():
	hurt_sound.play()
