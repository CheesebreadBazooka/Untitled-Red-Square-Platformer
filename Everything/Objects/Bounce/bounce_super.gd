extends Area2D

@export var bounce_speed : float = -1500.0


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity.y = bounce_speed
		body.velocity.x = 0.0
		body.spinning = true
		body.freeze("superbounce", 1, 1)
