extends Node

const LEVEL_PATH = "res://data/levels/level/"

signal on_level_changed(level_data: LevelData)

var level_data: Array[LevelData]

var current_level = 0


func _ready() -> void:
	var files = DirAccess.get_files_at(LEVEL_PATH)
	for file_name in files:
		level_data.append(load(LEVEL_PATH + file_name))


func new_level():
	current_level += 1
	on_level_changed.emit(level_data[current_level - 1])


func stop():
	EnemyManager.timer.stop()
