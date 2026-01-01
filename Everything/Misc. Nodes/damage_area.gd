extends Area2D

class_name DamageArea2D

@export var base_damage : int = 1
var damage : int = base_damage

@export var base_damage_on_enter : bool = false
var damage_on_enter : bool = base_damage_on_enter

@export var base_damage_while_inside : bool = false
var damage_while_inside : bool = base_damage_while_inside

func _on_body_entered(body: Node2D) -> void:
	if damage_on_enter and extra_criteria(body):
		for child in body.get_children():
			if child is BaseHealthManager:
				child.damage(damage, self.get_parent())
				on_deal(body)

func _process(delta: float) -> void:
	if damage_while_inside:
		for body in self.get_overlapping_bodies():
			for child in body.get_children():
				if child is BaseHealthManager and extra_criteria(body):
					child.damage(damage, self.get_parent())
					on_deal(body)

func extra_criteria(body):
	return body != self.get_parent()

func on_deal(body):
	pass
