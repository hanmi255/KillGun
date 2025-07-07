extends Node

# 核心服务引用
var damage_manager: Node
var level_manager: Node
var enemy_spawner: Node
var audio_manager: Node
var save_manager: Node
var config_manager: Node
var weapon_manager: Node

# 服务获取函数
func get_damage_manager() -> Node:
	return damage_manager

func get_level_manager() -> Node:
	return level_manager
	
func get_enemy_spawner() -> Node:
	return enemy_spawner
	
func get_audio_manager() -> Node:
	return audio_manager

func get_save_manager() -> Node:
	return save_manager
	
func get_config_manager() -> Node:
	return config_manager

func get_weapon_manager() -> Node:
	return weapon_manager

# 服务注册函数
func register_damage_manager(manager: Node) -> void:
	damage_manager = manager
	
func register_level_manager(manager: Node) -> void:
	level_manager = manager
	
func register_enemy_spawner(manager: Node) -> void:
	enemy_spawner = manager
	
func register_audio_manager(manager: Node) -> void:
	audio_manager = manager
	
func register_save_manager(manager: Node) -> void:
	save_manager = manager
	
func register_config_manager(manager: Node) -> void:
	config_manager = manager

func register_weapon_manager(manager: Node) -> void:
	weapon_manager = manager