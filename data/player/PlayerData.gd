class_name PlayerData
extends Resource

@export var max_hp = 10
@export var damage = 25

@export var gold = 0

var current_hp:
	set(_value):
		current_hp = _value
		PlayerManager.on_player_hp_changed.emit(_value, max_hp)
		if _value <= 0:
			PlayerManager.on_player_death.emit()


func _init() -> void:
	current_hp = max_hp
