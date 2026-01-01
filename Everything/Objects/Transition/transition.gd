extends Area2D

class_name Transition

@export var target_id : String
@export var anim_tree : AnimationTree
@export var spawn_id : int = 0

func teleport():
	if get_tree().current_scene.current_level.doomed:
		get_tree().current_scene.current_level.freeze_doom()
	Fade.fade_out(0.5, Color.BLACK, get_tree().current_scene.current_level.pattern)
	await Fade.fade_out(0.5, Color.BLACK, get_tree().current_scene.current_level.pattern).finished
	SaveAndLoad.contents_to_save["spawn_point_idx"] = spawn_id
	SaveAndLoad.contents_to_save["room_id"] = target_id
	SaveAndLoad._quick_save()
	get_tree().current_scene.current_level.go_to_room(target_id)
