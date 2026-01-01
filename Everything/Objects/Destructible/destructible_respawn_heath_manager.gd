extends DestructibleHeathManager

@export var anim_tree : AnimationTree
@export var collision : CollisionShape2D
@export var reset_timer : Timer
@export var collidecheck_area : Area2D


func on_zero_health(_cause):
	anim_tree["parameters/playback"].travel("break")
	collision.disabled = true
	reset_timer.start(5.0)


func _on_timer_timeout() -> void:
	for body in collidecheck_area.get_overlapping_bodies():
		if body is Player:
			while body in collidecheck_area.get_overlapping_bodies():
				await collidecheck_area.body_exited
	health = 1
	anim_tree["parameters/playback"].travel("build")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "build":
		collision.disabled = false
