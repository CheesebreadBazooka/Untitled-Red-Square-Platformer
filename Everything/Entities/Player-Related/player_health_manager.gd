extends BaseHealthManager

func on_hit(cause):
	print_debug("Ouwie")

func on_zero_health(cause):
	print_debug("Ded")
	get_tree().current_scene.current_level.go_to_room(get_tree().current_scene.current_level.current_room)
