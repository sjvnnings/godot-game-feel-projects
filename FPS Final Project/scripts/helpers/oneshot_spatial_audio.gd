extends AudioStreamPlayer3D

func _ready():
	connect("finished", self, "queue_free")
