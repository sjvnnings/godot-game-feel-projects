extends Area

export var trauma_reduction_rate := 1.0

export var max_x := 10.0
export var max_y := 10.0
export var max_z := 5.0

export var noise : OpenSimplexNoise
export var noise_speed := 50.0

var trauma := 0.0

var time := 0.0

onready var camera := $Camera as Camera
onready var initial_rotation := camera.rotation_degrees as Vector3

func _process(delta):
	time += delta
	trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
	
	camera.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	camera.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	camera.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)

func add_trauma(trauma_amount : float):
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed : int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)
