class_name LevelData
extends Resource

@export_group("Level Info")
@export var level_id: String = ""
@export var tick: float = 2.0

@export_group("Wave System")
@export var total_waves: int = 1
@export var enemies_per_wave: Array[int] = []

@export_group("Enemy Types")
@export var enemy_types: Array[String] = []
@export var enemy_scenes: Dictionary[String, PackedScene] = {}

var _current_wave: int = 0
var _spawned_in_wave: int = 0
var _total_spawned: int = 0


func get_next_enemy_type() -> String:
	if enemy_types.is_empty():
		return ""
	
	if enemy_types.size() == 1:
		return enemy_types[0]
	

	return enemy_types[randi() % enemy_types.size()]


func get_enemy_scene(enemy_type: String) -> PackedScene:
	if enemy_scenes.has(enemy_type):
		return enemy_scenes[enemy_type]
	return null


func enemy_spawned() -> void:
	_spawned_in_wave += 1
	_total_spawned += 1
	
	# 检查当前波次是否完成
	if _current_wave < enemies_per_wave.size() and _spawned_in_wave >= enemies_per_wave[_current_wave]:
		_current_wave += 1
		_spawned_in_wave = 0


func is_complete() -> bool:
	return _current_wave >= total_waves


func get_random_point() -> Vector2:
	var map_land = Game.map_land as TileMapLayer
	var rect = map_land.get_used_rect()
	var point = Vector2i(
		randi_range(rect.position.x, rect.position.x + rect.size.x),
		randi_range(rect.position.y, rect.position.y + rect.size.y)
	)
	return map_land.map_to_local(point)


func get_remaining_in_current_wave() -> int:
	if _current_wave >= enemies_per_wave.size():
		return 0
	return enemies_per_wave[_current_wave] - _spawned_in_wave


func get_total_remaining() -> int:
	var total = 0
	for i in range(_current_wave, enemies_per_wave.size()):
		if i == _current_wave:
			total += enemies_per_wave[i] - _spawned_in_wave
		else:
			total += enemies_per_wave[i]
	return total
