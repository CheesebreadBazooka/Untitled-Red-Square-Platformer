extends BaseHealthManager

class_name DestructibleHeathManager

func on_zero_health(cause):
	self.get_parent().queue_free()
