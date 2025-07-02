extends Resource
class_name EnemyData

# 怪物属性
@export var max_hp = 50 # 最大生命值
@export var damage = 5 # 伤害值

var current_hp: # 当前血量
	set(_value):
		if current_hp and current_hp - _value != 0:
			on_hit.emit(current_hp - _value)
		current_hp = _value
		if current_hp <= 0:
			on_death.emit()

signal on_death() # 死亡通知
signal on_hit(damage) # 受击通知

func _init() -> void:
	current_hp = max_hp
