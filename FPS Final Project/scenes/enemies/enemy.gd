extends RigidBody

const GIB_SPAWNER_SCENE := preload("res://scenes/effects/physical/gib_spawner.tscn")
const DEATH_VELOCITY_MULTIPLIER := 1000.0

signal damage_taken(amount)
signal died

export var gravity := -9.81
export var death_velocity_magnitude := 2.0

export var min_gibs : int = 1
export var max_gibs : int = 2

var is_dead := false
var last_impact_normal := Vector3.ZERO
var last_impact_point := Vector3.ZERO

onready var anim := $visuals/anim as AnimationPlayer

func take_damage(amount : int, pos : Vector3, normal : Vector3):
	if amount <= 0:
		return
	
	if is_dead:
		add_force(-last_impact_normal * amount * DEATH_VELOCITY_MULTIPLIER, global_transform.origin - last_impact_point)
	else:
		anim.stop()
		anim.play("hit")
	
	last_impact_normal = normal
	last_impact_point = pos
	
	emit_signal("damage_taken", amount)

func _on_health_depleted():
	#queue_free()
	is_dead = true
	
	$death_noise.play()
	
	var gib_spawner := GIB_SPAWNER_SCENE.instance() as Spatial
	gib_spawner.global_transform = TransformExtensions.transform_from_point_and_normal(last_impact_point, last_impact_normal)
	get_tree().root.add_child(gib_spawner)
	
	mode = RigidBody.MODE_RIGID
	add_force(-last_impact_normal * death_velocity_magnitude * DEATH_VELOCITY_MULTIPLIER, global_transform.origin - last_impact_point)
	
	emit_signal("died")
