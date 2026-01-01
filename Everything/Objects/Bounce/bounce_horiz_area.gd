extends Area2D

@export var bounce_distance : float = 400
@export var bounce_height : float = -200
@export var anim_tree : AnimationTree


func side(value):
	if (value is int) or (value is float):
		return value / abs(value) if value != 0 else 0
	elif (value is Vector2):
		return Vector2(value.x / abs(value.x) if value.x != 0 else 0, value.y / abs(value.y) if value.y != 0 else 0)
	else:
		print_debug("Couldn't get side of " + str(value))


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.face_dir = -body.face_dir
		print_debug(str(body.velocity.x))
		body.velocity.x = -body.velocity.x + (bounce_distance * body.face_dir)
		print_debug(str(body.velocity.x))
		body.horzbounce_take = 50 * -body.face_dir
		body.velocity.y = bounce_height
		body.can_double_jump = true
		body.spinning = false
		anim_tree["parameters/playback"].travel("bounce")
