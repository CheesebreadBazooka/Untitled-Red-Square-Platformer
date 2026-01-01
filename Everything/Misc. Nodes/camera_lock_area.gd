extends Area2D

class_name CameraLockArea

@export var size : Vector2 = Vector2(64, 64)
@export var lock_at : Vector2 = Vector2(-537, -798)
@export var collision : CollisionShape2D

func _ready() -> void:
	collision.shape.extents = size
	if lock_at == Vector2(-537, -798):
		lock_at = position

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.lock_camera(true, position)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.lock_camera(false)
