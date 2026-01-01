extends Node2D

class_name LevelMetadataManager

@export var starting_room : String
@export var id_dict : Dictionary
@export var pattern : String
@export var escape_duration : Array[int] = [4, 0]
@export var scene_esc_time : PackedScene
@export var scene_doom : PackedScene
@export var scene_anti_key : PackedScene
@export var timegem_palette : Texture
@export var anti_id : String

var escape_on : bool = false
var escape_time : float = 0
var doomed : bool = false
var escape_lost : bool = false
var escape_room : String
var current_room : String
var carry_anti : bool = false

func _ready() -> void:
	var start_scene : PackedScene = id_dict[starting_room]
	add_child(start_scene.instantiate())
	current_room = starting_room

func go_to_room(target_id : String):
	var target_room : PackedScene = id_dict[target_id]
	for child in get_children():
		if child is Room:
			child.queue_free()
	Fade.fade_in(0.5, Color.BLACK, pattern)
	add_child(target_room.instantiate())
	current_room = target_id
	if doomed:
		for child in get_children():
			if child is Room:
				child.add_child(scene_doom.instantiate())
	if carry_anti:
		for child in get_children():
			if child is Room:
				child.add_child(scene_anti_key.instantiate())
	await Fade.fade_in(0.5, Color.BLACK, pattern).finished

func start_escape():
	escape_time = (escape_duration[0] * 60) + escape_duration[1]
	escape_on = true
	SaveAndLoad.contents_to_save["escape_on"] = true
	#var timer = EscapeTimer
	@warning_ignore("unassigned_variable")
	var escape_timer = scene_esc_time.instantiate()
	escape_timer.time = escape_time
	add_child(escape_timer)
	for child in get_children():
		if child is EscapeTimer:
			child._start()
	print_debug("Run!")

func restart_escape():
	print_debug("Dead...")
	doomed = false
	escape_lost = true
	for child in get_children():
		if child is EscapeTimer:
			child.queue_free()
	go_to_room(escape_room)
	start_escape()

func freeze_doom():
	if doomed:
		for child in get_children():
			if child is Room:
				for grandchild in child.get_children():
					if grandchild is Doomskull:
						grandchild.can_move = false
						grandchild.anim_tree["parameters/playback"].travel("stopped")
