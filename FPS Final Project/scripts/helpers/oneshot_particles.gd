extends Particles

export var destruction_timer_override := 0.0

func _ready():
	emitting = true
	
	var time = destruction_timer_override if destruction_timer_override > 0.0 else lifetime
	get_tree().create_timer(time).connect("timeout", self, "queue_free")
