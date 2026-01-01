extends Node

const save_folder = "user://"

var current_save : int = 1

var contents_to_save : Dictionary = {
	"spawn_point_id" : 0,
	"room_id" : "room1",
	"level_scene" : preload("res://Levels/Test/test_hub.tscn"),
	"hub_room" : "start_room",
	"hub_anti" : false,
	"unlocked_levels" : ["level_test"],
	"escape_on" : false,
	"escape_time" : 240.0,
	"doomed" : false
}

#func _ready() -> void:
	#_quick_load()

func _quick_save():
	_save_to(current_save)

func _save_to(index:int):
	var path = save_folder + "save_" + str(index) + ".json"
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, "well done you found my super-secret hacker code (:")
	file.store_var(contents_to_save.duplicate())
	file.close()

func _quick_load():
	_load_from(current_save)

func _load_from(index:int):
	var path = save_folder + "save_" + str(index) + ".json"
	if FileAccess.file_exists(path):
		current_save = index
		
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, "well done you found my super-secret hacker code (:")
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		for info in save_data:
			contents_to_save[info] = save_data[info]
