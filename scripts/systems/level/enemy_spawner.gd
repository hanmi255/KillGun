class_name EnemySpawner
extends Node

# 敌人列表
var active_enemies: Array = []

# 敌人配置
@export var spawn_interval: float = 2.0
@export var max_enemies: int = 20
@export var spawn_radius: float = 500.0

var _spawn_timer: float = 0.0
var _current_level_data = null
var _current_wave_count: int = 0

# 敌人场景
@export var enemy_scenes: Dictionary = {}

# 初始化
func _ready() -> void:
	# 注册服务
	ServiceLocator.register_enemy_spawner(self)
	
	# 连接信号
	EventBus.enemy_death.connect(_on_enemy_death)
	EventBus.level_started.connect(_on_level_started)

func _process(delta: float) -> void:
	if _current_level_data and _current_wave_count < _current_level_data.total_waves:
		_spawn_timer += delta
		if _spawn_timer >= spawn_interval and active_enemies.size() < max_enemies:
			spawn_enemy()
			_spawn_timer = 0.0

# 生成敌人
func spawn_enemy() -> void:
	if not _current_level_data:
		return
	
	# 获取要生成的敌人类型
	var enemy_type = _current_level_data.get_next_enemy_type()
	if not enemy_type or not enemy_scenes.has(enemy_type):
		return
	
	# 创建敌人实例
	var enemy_scene = enemy_scenes[enemy_type]
	var enemy_instance = enemy_scene.instantiate()
	
	# 设置位置
	var spawn_position = _get_spawn_position()
	enemy_instance.global_position = spawn_position
	
	# 设置目标
	if enemy_instance.has_method("set_target") and get_tree().has_group("player"):
		var player = get_tree().get_nodes_in_group("player")[0]
		enemy_instance.set_target(player)
	
	# 添加到场景
	get_tree().current_scene.add_child(enemy_instance)
	
	# 记录敌人
	active_enemies.append(enemy_instance)
	
	# 更新波次计数
	_current_level_data.enemy_spawned()

# 获取生成位置
func _get_spawn_position() -> Vector2:
	# 获取玩家位置
	var player_position = Vector2.ZERO
	if get_tree().has_group("player"):
		player_position = get_tree().get_nodes_in_group("player")[0].global_position
	
	# 在玩家周围一定距离生成
	var angle = randf() * TAU # 随机角度
	var distance = spawn_radius # 在指定半径处生成
	var offset = Vector2(cos(angle), sin(angle)) * distance
	
	return player_position + offset

# 敌人死亡处理
func _on_enemy_death(enemy) -> void:
	active_enemies.erase(enemy)
	
	# 检查是否完成所有波次
	if _current_level_data and _current_level_data.is_complete() and active_enemies.size() == 0:
		EventBus.level_completed.emit(_current_level_data.level_id)

# 关卡开始处理
func _on_level_started(level_data) -> void:
	_current_level_data = level_data
	_current_wave_count = 0
	_spawn_timer = 0.0