extends CharacterBody3D

# playner nodes
@onready var head = $nek/head
@onready var nek = $nek
@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape
@onready var ray_cast_3d = $RayCast3D
@onready var camera_3d = $nek/head/Camera3D

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
var sliding = false

# slide vars
var slide_timer = 0.0
var slide_timer_max = 1.0

# movement cars
var crouching_depth = -0.5

const jump_velocity = 4.5

var lerp_speed = 1.0

var free_look_tilt_amount = 8.0

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
	# handle movement state
	# crouching
	if Input.is_action_pressed("crouch"):
		current_speed = crouching_speed
		head.position.y = lerp(head.position.y, crouching_depth, delta*lerp_speed*2)
		standing_collision_shape.disabled = true
		crouching_collision_shape.disabled = false
		
		# https://youtu.be/WF7d21zOD0M?t=891
		
		var walking = false
		var sprinting = false
		var crouching = true
		
	elif !ray_cast_3d.is_colliding():
	# standing
		head.position.y = lerp(head.position.y, 0.0, delta*lerp_speed*2)
		standing_collision_shape.disabled = false
		crouching_collision_shape.disabled = true
		if Input.is_action_pressed("dodge"):
		# sprinting
			current_speed = sprinting_speed
			
			var walking = false
			var sprinting = true
			var crouching = false
		else:
		# walking
			current_speed = walking_speed
			
			var walking = true
			var sprinting = false
			var crouching = false
			
	# handle free looking
	if Input.is_action_pressed("free_look"):
		camera_3d.rotation.z = deg_to_rad(-nek.rotation.y*free_look_tilt_amount)
		free_looking = true
	else:
		nek.rotation.y = lerp(nek.rotation.y, 0.0, delta*lerp_speed*2)
		camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta*lerp_speed*2)
		free_looking = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
