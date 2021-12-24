extends Spatial

const GENERIC_IMPACT := preload("res://scenes/effects/impact/generic_impact_effect.tscn")

export var damage : int = 1
export var fire_delay := 0.5

var can_fire := true

onready var raycast := $RayCast as RayCast
onready var muzzle_point := $pistol_model/muzzle_point as Spatial

onready var fire_delay_timer := $fire_delay as Timer

onready var fire_sfx := $fire_sfx
onready var anim := $pistol_model/anim as AnimationPlayer

onready var trauma_area := $trauma_causer as Area

func fire():
	if !can_fire and fire_delay > 0:
		return
	
	raycast.force_raycast_update()
	var impact_point = raycast.get_collision_point()
	var impact_normal = raycast.get_collision_normal()
	
	var collider = raycast.get_collider()
	
	if is_instance_valid(collider):
		if collider.has_method("take_damage"):
			collider.take_damage(damage, impact_point, impact_normal)
		
		GroupImpactSpawner.spawn_impact_effect(collider, impact_point, impact_normal)
	
	fire_sfx.stop()
	fire_sfx.play()
	
	anim.stop()
	anim.play("fire")
	
	trauma_area.cause_trauma()
	
	can_fire = false
	fire_delay_timer.start(fire_delay)

func _on_fire_delay_timeout():
	can_fire = true
