class_name PlayerData
extends Resource

@export_group("Base")
@export var max_hp: int = 10
@export var speed: float = 40.0

@export_group("Battle")
@export var weapon: PackedScene: set = _set_weapon
@export var gold: int = 60: set = _set_gold

var current_hp:
	set(_value):
		current_hp = _value
		EventBus.player_health_changed.emit(_value, max_hp)
		if _value <= 0:
			EventBus.player_death.emit()


func _init() -> void:
	current_hp = max_hp


func _set_weapon(value: PackedScene) -> void:
	weapon = value
	emit_changed()


func _set_gold(value: int) -> void:
	gold = value
	emit_changed()
