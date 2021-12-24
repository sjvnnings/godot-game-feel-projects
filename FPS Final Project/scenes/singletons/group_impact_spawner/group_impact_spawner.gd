tool
extends Node

export var default_effect : PackedScene = preload("res://scenes/effects/impact/generic_impact_effect.tscn")
export(Array) var effect_associations setget _change_associations

func _change_associations(new_value):
	for i in new_value.size():
		if !(new_value[i] is GroupEffectAssociation):
			new_value[i] = GroupEffectAssociation.new()
	
	effect_associations = new_value

func get_associated_effect(entity : Node) -> PackedScene:
	for e in effect_associations:
		var effect := e as GroupEffectAssociation
		if effect != null and entity.is_in_group(effect.group_name):
			return effect.effect
	
	return default_effect

func spawn_impact_effect(entity : Node, pos : Vector3, normal : Vector3):
	var effect := get_associated_effect(entity)
	
	if effect == null:
		return
	
	var spawned := effect.instance()
	if !(spawned is Spatial):
		spawned.queue_free()
		return
	
	spawned.global_transform = TransformExtensions.transform_from_point_and_normal(pos, normal)
	get_tree().root.add_child(spawned)
