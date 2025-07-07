class_name EntityBase
extends CharacterBody2D

var entity_name: String = "Entity"
var current_health: int = 100
var max_health: int = 100
var is_dead: bool = false

func take_damage(damage_amount: int) -> void:
	current_health = max(0, current_health - damage_amount)
	
	if current_health <= 0 and not is_dead:
		is_dead = true
		die()

func die() -> void:
	pass

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)