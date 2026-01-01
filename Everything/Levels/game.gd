extends Node

@export var level_dict : Dictionary
@export var start_level : String
var current_level
var current_id

func _ready() -> void:
	var start_scene = level_dict[start_level].instantiate()
	current_level = start_scene
	current_id = start_level
	add_child(start_scene)

func switch_level(target_level : String):
	for child in self.get_children():
		if child is LevelMetadataManager:
			child.queue_free()
	current_id = target_level
	current_level = level_dict[target_level].instantiate()
	add_child(current_level)
