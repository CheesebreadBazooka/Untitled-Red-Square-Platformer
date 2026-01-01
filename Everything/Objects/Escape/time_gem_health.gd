extends BaseHealthManager

func on_hit(cause):
	print_debug("Ouchie")

func on_zero_health(_cause):
	get_tree().current_scene.current_level.escape_room = get_tree().current_scene.current_level.current_room
	get_tree().current_scene.current_level.start_escape()
	print_debug("Broke the Time Gem!")
	self.get_parent().queue_free()
