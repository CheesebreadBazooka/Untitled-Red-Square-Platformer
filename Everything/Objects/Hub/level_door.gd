extends Area2D

@export var target_level : String
@export var texture : Texture
@export var anti_level : String
@export var anti_texture : Texture

func _ready() -> void:
	$Sprite2D.texture = texture

func _physics_process(_delta: float) -> void:
	if target_level in SaveAndLoad.contents_to_save["unlocked_levels"]:
		if Input.is_action_just_pressed("up"):
			for body in get_overlapping_bodies():
				if body is Player:
					if body.is_on_floor():
						print_debug("Opening level door...")
						#anim_tree["parameters/playback"].travel("open")
						body.velocity = Vector2.ZERO
						body.freeze("transition", true, true)
						go_to_level()

func go_to_level():
	if get_tree().current_scene.current_id == get_tree().current_scene.start_level:
		SaveAndLoad.contents_to_save["hub_room"] = get_tree().current_scene.current_level.current_room
	SaveAndLoad.contents_to_save["level_scene"] = target_level
	get_tree().current_scene.switch_level(target_level)
