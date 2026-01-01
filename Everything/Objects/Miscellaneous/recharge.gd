extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.can_double_jump = true
		body.can_ground_pound = true
		body.spinning = false
