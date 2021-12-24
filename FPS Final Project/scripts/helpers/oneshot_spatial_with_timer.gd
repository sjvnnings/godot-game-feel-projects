extends Spatial
class_name LifetimeSpatial

#If lifetime is 0, the spatial node will stay spawned forever.
export var lifetime := 1.0

func _ready():
	if lifetime == 0.0:
		return
	
	get_tree().create_timer(lifetime).connect("timeout", self, "queue_free")
