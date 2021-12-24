extends LifetimeSpatial

const GIB_SCENE := preload("res://scenes/effects/physical/physics_gib.tscn")

export var min_gib_count := 1
export var max_gib_count := 2

export var gib_rotation_max := 22.5
export var gib_reverse_chance := 0.4

export var gib_velocity_min := 5.0
export var gib_velocity_max := 20.0

func _ready():
	spawn_random_number_gibs(min_gib_count, max_gib_count)

func spawn_random_number_gibs(min_gibs : int, max_gibs : int):
	for i in int(rand_range(min_gibs, max_gibs + 1)):
		spawn_random_gib()

func spawn_random_gib():
	var gib = GIB_SCENE.instance()
	get_tree().root.add_child(gib)
	
	gib.global_transform.origin = global_transform.origin
	
	var vel = global_transform.basis.z if randf() >= gib_reverse_chance else -global_transform.basis.z
	
	vel = vel.rotated(global_transform.basis.y, deg2rad(rand_range(-1.0, 1.0) * gib_rotation_max))
	vel = vel.rotated(vel.cross(global_transform.basis.y), deg2rad(rand_range(-1.0, 1.0) * gib_rotation_max))
	
	gib.linear_velocity = vel * rand_range(gib_velocity_min, gib_velocity_max)
	gib.rotational_velocity = Vector3(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)) * 3.0
