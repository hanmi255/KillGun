extends Node

const _pre_hit_label = preload("res://ui/HitLabel.tscn")

var map:Node2D # 游戏场景节点
var player:Player # 玩家节点

signal on_game_start() #游戏开始信号

#造成伤害
#origin 原始 target 目标
func damage(origin:Node2D,target:Node2D):
	if origin is Player: # 玩家对怪物造成伤害
		if target is BaseEnemy:
			target.enemy_data.current_hp -= PlayerManager.player_data.damage
	
	if origin is BaseEnemy: # 怪物对玩家造成伤害
		if target is Player:
			PlayerManager.player_data.current_hp -= origin.enemy_data.damage

#展示飘字
func show_label(origin:Node2D,text:String):
	var instance = _pre_hit_label.instantiate()
	instance.global_position = origin.global_position
	map.add_child(instance)
	instance.set_text(text)

# 相机震动
func camera_offset(offset,time):
	var tween = create_tween()
	tween.tween_property(player.camera,'offset',Vector2.ZERO,time).from(offset)
