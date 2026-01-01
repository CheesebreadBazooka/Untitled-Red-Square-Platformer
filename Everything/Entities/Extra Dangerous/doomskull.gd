extends CharacterBody2D

class_name Doomskull

@export var wakeup_timer : Timer
@export var anim_tree : AnimationTree
@export var can_move : bool = false

var speed : float = 400
var wake_delay : float = 5.0

func _ready() -> void:
	print_debug("Succesfully spawned Doomskull")
	for player in get_parent().get_children():
		if player is Player:
			self.position = player.position
			wakeup_timer.start(wake_delay)
	if get_parent().doomskull_speed > 0:
		speed = get_parent().doomskull_speed

func _on_timer_timeout() -> void:
	anim_tree["parameters/playback"].travel("wakeup")
	print_debug("I'm gonna getcha!")

func _physics_process(_delta: float) -> void:
	if can_move:
		for player in get_parent().get_children():
			if player is Player:
				look_at(player.position)
				velocity = Vector2(speed, 0).rotated(rotation)
				rotation = 0
				move_and_slide()
				anim_tree["parameters/playback"].travel("normal")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().current_scene.restart_escape()
