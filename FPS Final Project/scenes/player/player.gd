extends KinematicBody

const STOP_THRESHOLD := 0.5

export var max_input_speed := 5.0
export var time_to_max_speed := 1.0
export var time_to_stop := 0.5

onready var acceleration = max_input_speed / time_to_max_speed
onready var deacceleration = max_input_speed / time_to_stop

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

export var gun_path : NodePath

onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

onready var camera := $player_camera
onready var gun := get_node(gun_path) as Spatial

var velocity := Vector3.ZERO

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	
	var horizontal := 0.0
	var vertical := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	if Input.is_action_pressed("forward"):
		vertical -= 1.0
	if Input.is_action_pressed("backward"):
		vertical += 1.0
	
	var input = Vector3(horizontal, 0.0, vertical).normalized()
	input = camera.cam_transform(input)
	input.y = 0
	input = input.normalized()
	
	if Input.is_action_just_pressed("jump"):
		jump()
	
	var hvel = velocity
	hvel.y = 0
	
	if input == Vector3.ZERO:
		var h_dir = hvel.normalized()
		hvel -= h_dir * deacceleration * delta
		
		if hvel.normalized().dot(h_dir) < 0:
			hvel = Vector3.ZERO
	else:
		var accel = acceleration if input.dot(hvel.normalized()) >= 0 else deacceleration
		hvel += input * accel * delta
	
	hvel = hvel.normalized() * min(hvel.length(), max_input_speed)
	
	velocity.x = hvel.x
	velocity.z = hvel.z
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("fire") and is_instance_valid(gun):
		gun.fire()

func jump():
	if is_on_floor():
		velocity.y = jump_velocity

func get_gravity() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity
