extends Node

const HIT_LABEL = preload("res://scenes/ui/hit_label/hit_label.tscn")

signal on_game_start()

var map: Node2D
var player: Player


func damage(origin: Node2D, target: Node2D) -> int:
	var damage_amount := 0

	# 根据攻击者和目标类型确定伤害
	match [origin, target]:
		[ var o, var t] when o is Player and t is BaseEnemy:
			damage_amount = PlayerManager.player_data.damage
			t.enemy_data.current_hp -= damage_amount
		[ var o, var t] when o is BaseEnemy and t is Player:
			damage_amount = o.enemy_data.damage
			PlayerManager.player_data.current_hp -= damage_amount

	return damage_amount


#展示飘字
func show_label(origin: Node2D, text: String):
	var instance = HIT_LABEL.instantiate()
	instance.global_position = origin.global_position
	map.add_child(instance)
	instance.set_text(text)


# 相机震动
func camera_offset(offset, time):
	var tween = create_tween()
	tween.tween_property(player.camera, 'offset', Vector2.ZERO, time).from(offset)
