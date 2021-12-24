extends Spatial

const ROTATION_SENSITIVITY = 0.15

onready var cam := $Camera as Camera

export var invert_y := true
export var invert_x := false

export var min_x_rot := -70.0
export var max_x_rot := 70.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func cam_transform(vector : Vector3) -> Vector3:
	return cam.global_transform.basis.xform(vector)

static func get_invert_multiplier(invert : bool) -> int:
	return (int(!invert) * 2) - 1

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var mode = Input.MOUSE_MODE_VISIBLE if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
		Input.set_mouse_mode(mode)
	
	if event is InputEventMouseButton and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(event.relative.x * ROTATION_SENSITIVITY * get_invert_multiplier(invert_y)))
		
		var delta_x = event.relative.y * ROTATION_SENSITIVITY * get_invert_multiplier(invert_x)
		cam.rotation_degrees.x = clamp(cam.rotation_degrees.x + delta_x, min_x_rot, max_x_rot)
