extends StaticBody2D

class_name TimeGem

@export var sprite : Sprite2D

func _ready() -> void:
	if get_tree().current_scene.current_level.escape_on:
		self.queue_free()
	else:
		sprite.material.set_shader_parameter("target_palette", get_tree().current_scene.current_level.timegem_palette)
