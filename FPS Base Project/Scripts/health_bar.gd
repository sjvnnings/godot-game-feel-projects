extends Sprite3D

const HP : int = 3

signal health_depleted

export var free_on_depletion := true

onready var health := HP

func lower_health(amount : int):
	health -= amount
	
	if health <= 0:
		emit_signal("health_depleted")
		
		if free_on_depletion:
			queue_free()
	else:
		frame = clamp(HP - health, 0, 2)
