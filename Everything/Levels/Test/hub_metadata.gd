extends LevelMetadataManager

func _ready() -> void:
	var start_scene : PackedScene = id_dict[SaveAndLoad.contents_to_save["hub_room"]]
	add_child(start_scene.instantiate())
	current_room = SaveAndLoad.contents_to_save["hub_room"]
