extends DamageArea2D

func on_deal(body):
	print_debug("Spiky spike")

func extra_criteria(body):
	return body is Player
