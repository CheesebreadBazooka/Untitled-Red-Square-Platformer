extends DestructibleHeathManager

@export var toughness_x : float = 1
@export var toughness_y : float = 2.5

func hit_criteria(cause):
	var success := false
	if cause is Player:
		for area in cause.get_children():
			if area is DamageArea2D:
				if area.name == "SpinArea":
					if abs(cause.last_vel.y) >= (-cause.jump_speed * toughness_y):
						print_debug("The Schpin Killed Me With " + str(abs(cause.last_vel.y)))
						return true
					elif cause.last_vel.y > 0:
						print_debug("The Schpin Couldn't Paull The Trigger, But It Was " + str(abs(cause.last_vel.y)) + " Close. It Could've If I Wasn't " + str(cause.jump_speed * toughness_y))
					#else:
						#print_debug("The Schpin Is Dumb")
				if area.name == "BookArea":
					if abs(cause.last_vel.x) >= (cause.run_speed * toughness_x):
						print_debug("The Book Killed Me")
						return true
					#else:
						#print_debug("The Book Couldn't Pull The Trigger, But It Was " + str(cause.last_vel.x) + " Close")
	if success:
		return true
	else:
		return false
