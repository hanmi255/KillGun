class_name EnemyData
extends Resource

signal on_death()
signal on_hit(damage)

@export var max_hp = 50
@export var damage = 5

var current_hp:
	set(_value):
		if current_hp and current_hp - _value != 0:
			on_hit.emit(current_hp - _value)
		current_hp = _value
		if current_hp <= 0:
			on_death.emit()


func _init() -> void:
	current_hp = max_hp
