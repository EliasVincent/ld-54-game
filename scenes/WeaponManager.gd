extends Node3D

@onready var fire_point = $"../FirePoint"
@onready var ray_cast_3d = $"../FirePoint/RayCast3D"

@onready var machine_gun_delay_timer = $MachineGunDelayTimer
@onready var machine_gun_fire_sound = $Sounds/MachineGunFireSound

var canShoot: bool = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

# gets called when we click shoot
func shoot_auto(machineGunShootDelay: float, damage: float):
	if canShoot:
		canShoot = false
		machine_gun_delay_timer.wait_time = machineGunShootDelay
		machine_gun_delay_timer.start()
		
		machine_gun_fire_sound.play()
	#if animation is not playing: play animation
		if ray_cast_3d.is_colliding():
			if ray_cast_3d.get_collider().is_in_group("ENEMY"):
				ray_cast_3d.get_collider().get_hit(damage)
				print("ENEMY HIT")


func _on_machine_gun_delay_timer_timeout():
	canShoot = true

