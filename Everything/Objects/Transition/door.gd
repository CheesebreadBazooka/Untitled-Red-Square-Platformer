extends Transition

func _physics_process(delta: float) -> void:
	if target_id != null:
		if Input.is_action_just_pressed("up"):
			for body in get_overlapping_bodies():
				if body is Player:
					if body.is_on_floor():
						print_debug("Opening a door...")
						anim_tree["parameters/playback"].travel("open")
						body.velocity = Vector2.ZERO
						body.freeze("transition", true, true)
						teleport()
