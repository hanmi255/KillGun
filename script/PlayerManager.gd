extends Node
# 玩家管理单例

const _pre_weapon = preload("res://scene/weapon/Gun2.tscn")

var player_data :PlayerData

# 玩家属性
signal on_player_hp_changed(_current,_max) # 玩家血量改变信号
signal on_player_death() # 玩家死亡信号

# 枪械信号
signal on_bullet_count_changed(_curr,_max) # 子弹数量改变
signal on_weapon_reload() # 枪械换弹触发

signal on_weapon_changed(weapon:BaseWeapon) # 枪械更换信号

func _ready() -> void:
	player_data = PlayerData.new() # 直接创建一个，后续做存档会修改

# 更换枪械
func changeWeapon(weapon:BaseWeapon):
	var current_weapon = Game.player.weapon_node.get_child(0)
	if current_weapon:
		current_weapon.queue_free()
	weapon.player = Game.player
	Game.player.weapon_node.add_child(weapon)

# 判断玩家是否死亡
func isDeath() -> bool:
	if player_data:
		return player_data.current_hp <= 0
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		changeWeapon(_pre_weapon.instantiate())
