extends Area2D

class_name EscapeDoor

@export var hub_scene : String
@export var anim_tree : AnimationTree

func _ready() -> void:
	if get_tree().current_scene.current_level.escape_on:
		anim_tree["parameters/playback"].travel("unlocked")
	else:
		anim_tree["parameters/playback"].travel("locked")

func _process(_delta: float) -> void:
	if get_tree().current_scene.current_level.escape_on:
		anim_tree["parameters/playback"].travel("unlocked")
		if Input.is_action_just_pressed("up"):
			for body in get_overlapping_bodies():
				if body is Player:
					if body.is_on_floor():
						print_debug("Opening escape door...")
						#anim_tree["parameters/playback"].travel("open")
						body.velocity = Vector2.ZERO
						body.freeze("transition", true, true)
						SaveAndLoad.contents_to_save["level_scene"] = hub_scene
						get_tree().current_scene.switch_level(hub_scene)
