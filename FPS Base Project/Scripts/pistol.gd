extends Spatial

export var damage : int = 1

onready var raycast := $RayCast as RayCast
onready var muzzle_point := $pistol_model/muzzle_point as Spatial

func fire():
	raycast.force_raycast_update()
	var impact_point = raycast.get_collision_point()
	
	var collider = raycast.get_collider()
	
	if is_instance_valid(collider) and collider.has_method("take_damage"):
		collider.take_damage(damage)
