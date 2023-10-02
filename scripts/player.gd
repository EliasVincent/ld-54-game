extends CharacterBody3D

# playner nodes
@onready var nek = $nek
@onready var head = $nek/head
@onready var eyes = $nek/head/eyes
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var ray_cast_3d = $RayCast3D
@onready var camera_3d = $nek/head/eyes/Camera3D
@onready var animation_player = $nek/head/eyes/AnimationPlayer
@onready var weapon_manager = $nek/head/eyes/Camera3D/WeaponManager

# speed vars
var current_speed = 5.0

const walking_speed = 5.0
const sprinting_speed = 8.0
const crouching_speed = 3.0

# states
var walking = false
var sprinting = false
var crouching = false
var free_looking = false
var dodging = false

# dodge vars
var dodge_timer = 0.0
var dodge_timer_max = 0.8
var dodge_vector = Vector2.ZERO
var dodge_speed = 10.0
var dodge_side = 0

# head bobbing vars
const head_bobbing_sprinting_speed = 0.0
const head_bobbing_walking_speed = 8.0
const head_bobbing_crouching_speed = 8.0

const head_bobbing_sprinting_intensity = 0.0
const head_bobbing_walking_intensity = 0.2
const head_bobbing_crouching_intensity = 0.1

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0

# movement cars
var crouching_depth = -0.5

const jump_velocity = 5.0

var lerp_speed = 1.0
var air_lerp_speed = 0.2

var free_look_tilt_amount = 8.0

var last_velocity = Vector3.ZERO

# input vars
var direction = Vector3.ZERO
const mouse_sens = 0.1



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# mouse looking logic
	if event is InputEventMouseMotion:
		if free_looking:
			nek.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			nek.rotation.y = clamp(nek.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	# getting movement input
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	# handle movement state
	# crouching
	if Input.is_action_pressed("crouch"):
		current_speed = lerp(current_speed, crouching_speed, delta*lerp_speed)
		head.position.y = lerp(head.position.y, crouching_depth, delta*lerp_speed*2)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
		dodge_timer = 0
		dodging = false
		
		walking = false
		sprinting = false
		crouching = true
		
	elif !ray_cast_3d.is_colliding():
	# standing
		head.position.y = lerp(head.position.y, 0.0, delta*lerp_speed*2)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		if Input.is_action_just_pressed("sprint") && (Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("backward")) && input_dir != Vector2.ZERO && !dodging && !sprinting:
			dodging = true
			dodge_timer = dodge_timer_max
			dodge_vector = input_dir
			if Input.is_action_pressed("left"):
				dodge_side = -1.0
			elif Input.is_action_pressed("right"):
				dodge_side = 1.0
		
		# head tilt during movement
		if !dodging && Input.is_action_pressed("left"):
			eyes.rotation.z = lerp(eyes.rotation.z, -deg_to_rad(-7.0), delta*lerp_speed*2)
		elif !dodging && Input.is_action_pressed("right"):
			eyes.rotation.z = lerp(eyes.rotation.z, -deg_to_rad(7.0), delta*lerp_speed*2)
		
		if dodging:
			dodge_timer -= delta
			print(dodge_timer)
			if dodge_side < 0:
				eyes.rotation.z = lerp(eyes.rotation.z, -deg_to_rad(-7.0), delta*lerp_speed*2)
			elif dodge_side > 0:
				eyes.rotation.z = lerp(eyes.rotation.z, -deg_to_rad(7.0), delta*lerp_speed*2)
			if dodge_timer <= 0:
				dodging = false
				animation_player.play("dodge_end")
			
		elif Input.is_action_pressed("sprint") && Input.is_action_pressed("forward"):
		# sprinting
			current_speed = lerp(current_speed, sprinting_speed, delta*lerp_speed*10.0)
			
			walking = false
			sprinting = true
			crouching = false
		else:
		# walkingland_2
			current_speed = lerp(current_speed, walking_speed, delta*lerp_speed*4.0)
			
			walking = true
			sprinting = false
			crouching = false
			
	# handle free looking
	if Input.is_action_pressed("free_look"):
		free_looking = true
		
		eyes.rotation.z = deg_to_rad(-nek.rotation.y*free_look_tilt_amount)
	else:
		nek.rotation.y = lerp(nek.rotation.y, 0.0, delta*lerp_speed*2)
		eyes.rotation.z = lerp(eyes.rotation.z, 0.0, delta*lerp_speed*2)
		free_looking = false
	
	
	# handle headbob
	if sprinting:
		head_bobbing_current_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed * delta
	elif walking:
		head_bobbing_current_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed * delta
	elif crouching:
		head_bobbing_current_intensity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_crouching_speed * delta
	
	if is_on_floor() && !dodging && input_dir != Vector2.ZERO:
		
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2)+0.5
		
		eyes.position.y = lerp(eyes.position.y,head_bobbing_vector.y*(head_bobbing_current_intensity/2.0), delta * lerp_speed*5.0)
		eyes.position.x = lerp(eyes.position.x,head_bobbing_vector.x*head_bobbing_current_intensity, delta * lerp_speed*5.0)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * lerp_speed*5.0)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * lerp_speed*5.0)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		animation_player.play("jump")
		
	# handle landing
	if is_on_floor():
		if last_velocity.y < 0.0:
			animation_player.play("land")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	# movement speed if on floor or in air
	if is_on_floor() || sprinting:
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed*2.0)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*air_lerp_speed*2.0)
		
	if dodging:
		direction = (transform.basis * Vector3(dodge_vector.x,0,dodge_vector.y)).normalized()
		current_speed = (dodge_timer + 0.2) * dodge_speed + 0.2
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		
	last_velocity = velocity
	move_and_slide()
	
	# shoot auto
	if Input.is_action_pressed("shoot"):
		weapon_manager.shoot_auto(Globals.machineGunShootDelay, Globals.machineGunDamage)
	
func get_hit():
	# CURRENT HP - 1, alle machen gleich viel Schaden erstmal
	print("HURT")
	pass
