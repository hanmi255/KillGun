class_name PlayerData
extends Resource

@export var max_hp = 10
@export var damage = 25

@export var gold = 0

var current_hp:
	set(_value):
		current_hp = _value
		EventBus.player_health_changed.emit(_value, max_hp)
		if _value <= 0:
			EventBus.player_death.emit()


func _init() -> void:
	current_hp = max_hp
