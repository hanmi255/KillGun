extends Node

const level_path = "res://data/levels/level/"

var level_data: Array[LevelData]

var current_level = 0

signal on_level_changed(level_data: LevelData)


func _ready() -> void:
	var files = DirAccess.get_files_at(level_path)
	for file_name in files:
		level_data.append(load(level_path + file_name))


func new_level():
	current_level += 1
	on_level_changed.emit(level_data[current_level - 1])


func stop():
	EnemyManager.timer.stop()
