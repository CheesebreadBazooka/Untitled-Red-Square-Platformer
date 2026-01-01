extends CanvasLayer

class_name EscapeTimer

@export var timer_node : Timer
@export var label : Label
@export var time : float = 240.0
@export var scene_skull : PackedScene

func _ready() -> void:
	timer_node.wait_time = time

func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	var time_minutes = int(timer_node.time_left) / 60
	var time_seconds = int(timer_node.time_left) % 60
	label.text = str(time_minutes) + ":" + str(time_seconds)

func _start():
	timer_node.start(time)

func _on_timer_timeout() -> void:
	print_debug("Spawning Doomskull")
	var doomskull = scene_skull.instantiate()
	for room in get_parent().get_children():
		if room is Room:
			room.add_child(doomskull)
			SaveAndLoad.contents_to_save["doomed"] = true
			get_parent().doomed = true
	#get_parent().add_child(doomskull)
