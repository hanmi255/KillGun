class_name LevelManager
extends Node

@export var levels_config_path: String = "res://resources/config_data/levels/"


var levels: Array = []
var current_level_index: int = -1
var current_level_data = null


func _ready() -> void:
	ServiceLocator.register_level_manager(self)

	_load_levels()

	EventBus.level_completed.connect(_on_level_completed)
	EventBus.game_started.connect(_on_game_started)

func _load_levels() -> void:
	var dir = DirAccess.open(levels_config_path)
	if not dir:
		push_error("无法打开关卡配置目录: " + levels_config_path)
		return

	# 查找所有关卡配置文件
	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			# 加载资源
			var level_data = load(levels_config_path + file_name)
			if level_data:
				levels.append(level_data)
		file_name = dir.get_next()

	levels.sort_custom(func(a, b): return a.level_id < b.level_id)


func _on_game_started() -> void:
	start_level(0)


func start_level(level_index: int) -> void:
	if level_index < 0 or level_index >= levels.size():
		push_error("无效的关卡索引: " + str(level_index))
		return

	# 设置当前关卡
	current_level_index = level_index
	current_level_data = levels[level_index]

	EventBus.level_started.emit(current_level_data)


func _on_level_completed(level_id: int) -> void:
	# 验证是否是当前关卡
	if current_level_data and current_level_data.level_id == level_id:
		var next_level_index = current_level_index + 1
		if next_level_index < levels.size():
			start_level(next_level_index)
		else:
			EventBus.game_over.emit(true)


func get_current_level_data():
	return current_level_data