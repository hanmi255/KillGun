extends Node

const _pre_hit_label = preload("res://scenes/ui/hit_label/HitLabel.tscn")

var map: Node2D
var player: Player

signal on_game_start()


#origin 原始 target 目标
func damage(origin: Node2D, target: Node2D):
	if origin is Player:
		if target is BaseEnemy:
			target.enemy_data.current_hp -= PlayerManager.player_data.damage
	
	if origin is BaseEnemy:
		if target is Player:
			PlayerManager.player_data.current_hp -= origin.enemy_data.damage


#展示伤害飘字
func show_label(origin: Node2D, text: String):
	var instance = _pre_hit_label.instantiate()
	instance.global_position = origin.global_position
	map.add_child(instance)
	instance.set_text(text)


# 相机震动
func camera_offset(offset, time):
	var tween = create_tween()
	tween.tween_property(player.camera, 'offset', Vector2.ZERO, time).from(offset)
