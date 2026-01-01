extends Area2D

@export var bounce_height : float = -400
@export var anim_tree : AnimationTree

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is Player:
			body.velocity.y = bounce_height
			body.can_double_jump = true
			body.spinning = false
			anim_tree["parameters/playback"].travel("bounce")
