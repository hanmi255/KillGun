extends Node
#怪物管理

var enemies = [] # 怪物数量数组
var current_level_data:LevelData
var timer = Timer.new() # 刷怪器

signal on_enemy_death() # 检测怪物死亡

func _ready() -> void:
	timer.one_shot = false
	timer.timeout.connect(time_out)
	add_child(timer)
	LevelManager.on_level_changed.connect(on_level_changed)

#开始刷怪
func on_level_changed(level_data:LevelData):
	current_level_data = level_data
	timer.start(level_data.tick)

func time_out():
	if current_level_data:
		current_level_data.create_enemy()

# 检测怪物数量
func check_enemies():
	if enemies.size() == 0:
		LevelManager.new_level()
