extends KinematicBody

signal damage_taken(amount)

export var gravity := -9.81

var velocity := Vector3.ZERO

func take_damage(amount : int):
	emit_signal("damage_taken", amount)

func _physics_process(delta):
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector3.UP)

func _on_health_depleted():
	queue_free()
