extends Node

class_name BaseHealthManager

@export var base_health : int = 1
var health : int = base_health

func damage(value, cause):
	if hit_criteria(cause):
		health -= value
		on_hit(cause)
		if health <= 0:
			on_zero_health(cause)
	else:
		failed_criteria(cause)

@warning_ignore("unused_parameter")
func on_hit(cause):
	pass

@warning_ignore("unused_parameter")
func on_zero_health(cause):
	pass

@warning_ignore("unused_parameter")
func hit_criteria(cause):
	return true

@warning_ignore("unused_parameter")
func failed_criteria(cause):
	pass
