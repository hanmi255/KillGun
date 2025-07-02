extends Resource
class_name PlayerData

# 玩家属性
@export var max_hp = 10 # 最大生命值
@export var damage = 25 # 伤害值

#玩家存档
@export var gold = 0 # 玩家持有金币

var current_hp: # 玩家当前血量
	set(_value):
		current_hp = _value
		PlayerManager.on_player_hp_changed.emit(_value,max_hp)
		if _value <= 0:
			PlayerManager.on_player_death.emit()
			
			

func _init() -> void:
	current_hp = max_hp
