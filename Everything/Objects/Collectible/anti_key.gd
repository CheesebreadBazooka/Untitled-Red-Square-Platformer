extends CharacterBody2D

class_name AntiKey

@export var speed : float = 4.0
var player : Player


func _ready() -> void:
	for child in get_parent().get_children():
		if child is Player:
			player = child
			if get_tree().current_scene.current_level.carry_anti:
				position = player.position


func _physics_process(delta: float) -> void:
	if get_tree().current_scene.current_level.carry_anti:
		self.position = self.position.lerp(player.position, delta * speed)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().current_scene.current_level.carry_anti = true
