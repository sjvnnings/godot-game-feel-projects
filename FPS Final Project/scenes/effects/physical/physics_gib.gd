extends Spatial

const SPLATTER_SCENE := preload("res://scenes/effects/decals/splatter_decal.tscn")

export var gravity := -9.81

var linear_velocity : Vector3
var rotational_velocity : Vector3

func _physics_process(delta):
	linear_velocity.y += gravity * delta
	
	rotation += rotational_velocity * delta
	
	var new_pos = global_transform.origin + linear_velocity * delta
	var pos = global_transform.origin
	
	var results = get_world().direct_space_state.intersect_ray(pos, new_pos, [], 1)
	if results:
		var splatter = SPLATTER_SCENE.instance()
		get_tree().root.add_child(splatter)
		
		var size = rand_range(0.5, 1.2)
		
		var new_transform := TransformExtensions.transform_from_point_and_normal(results.position, results.normal, Vector3(size, size, splatter.scale.z))
		
		splatter.global_transform = new_transform
		splatter.rotate_object_local(Vector3.FORWARD, rand_range(0, 2 * PI))
		
		queue_free()
	else:
		global_transform.origin = new_pos
