class_name EnemyData
extends Resource

signal on_death()
signal on_hit(damage)

# 敌人属性
@export_group("Base")
@export var name: String = "Enemy"
@export var max_hp: int = 50
@export var speed: float = 30.0

@export_group("Battle")
@export var attack_damage: int = 5
@export var attack_range: float = 20.0
@export var attack_cd: float = 1.0
@export var detection_range: float = 200.0

@export_group("Other")
@export var hit_sound: AudioStream

var current_hp:
	set(_value):
		if current_hp and current_hp - _value != 0:
			on_hit.emit(current_hp - _value)
		current_hp = _value
		if current_hp <= 0:
			on_death.emit()


func _init() -> void:
	current_hp = max_hp
