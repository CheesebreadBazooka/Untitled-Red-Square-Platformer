extends DamageArea2D

func on_deal(body):
	get_parent().spin_hit()
