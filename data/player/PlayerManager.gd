extends Node

const _pre_weapon = preload("res://scenes/weapon/Gun2.tscn")

var player_data: PlayerData

# 玩家属性
signal on_player_hp_changed(_current, _max)
signal on_player_death()

# 枪械信号
signal on_bullet_count_changed(_curr, _max)
signal on_weapon_reload()
signal on_weapon_changed(weapon: BaseWeapon)


func _ready() -> void:
	player_data = PlayerData.new()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		change_weapon(_pre_weapon.instantiate())


func change_weapon(weapon: BaseWeapon):
	var current_weapon = Game.player.weapon_node.get_child(0)
	if current_weapon:
		current_weapon.queue_free()
	weapon.player = Game.player
	Game.player.weapon_node.add_child(weapon)


func is_death() -> bool:
	if player_data:
		return player_data.current_hp <= 0
	return false
