class_name EnemySpawner
extends Node

const EnemyBaseScene = preload("res://scenes/entities/enemies/enemy_base.tscn")

@export var spawn_interval: float = 2.0
@export var max_enemies: int = 20
@export var spawn_radius: float = 500.0

var _spawn_timer: float = 0.0
var _current_level_data: LevelData = null
var _current_wave_count: int = 1
var _enemies_data: Dictionary = {}
var active_enemies: Array = []


func _ready() -> void:
	ServiceLocator.register_enemy_spawner(self)

	EventBus.enemy_death.connect(_on_enemy_death)
	EventBus.level_started.connect(_on_level_started)


func _process(delta: float) -> void:
	if _current_level_data and _current_wave_count < _current_level_data.total_waves:
		_spawn_timer += delta
		if _spawn_timer >= spawn_interval and active_enemies.size() < max_enemies:
			spawn_enemy()
			_spawn_timer = 0.0


func spawn_enemy() -> void:
	if not _current_level_data:
		return

	var enemy_type = _current_level_data.get_next_enemy_type()

	var enemy_data = _enemies_data[enemy_type]
	var enemy_instance = EnemyBaseScene.instantiate()
	enemy_instance.enemy_data = enemy_data

	var spawn_position = _get_spawn_position()
	enemy_instance.global_position = spawn_position

	if enemy_instance.has_method("set_target") and Game.player:
		enemy_instance.set_target(Game.player)

	Game.map_land.add_child(enemy_instance)
	enemy_instance.add_to_group("enemies")

	active_enemies.append(enemy_instance)

	_current_level_data.enemy_spawned()
	
	# 检查当前波次是否完成
	if _current_level_data.is_wave_complete():
		_current_wave_count += 1
		EventBus.wave_completed.emit(_current_level_data.level_id, _current_wave_count, _current_level_data.total_waves)


func _get_spawn_position() -> Vector2:
	var player_position = Vector2.ZERO
	if Game.player:
		player_position = Game.player.global_position

	var angle = randf() * TAU
	var distance = spawn_radius
	var offset = Vector2(cos(angle), sin(angle)) * distance

	return player_position + offset


func _on_enemy_death(enemy) -> void:
	active_enemies.erase(enemy)

	# 检查是否完成所有波次
	if _current_level_data and _current_level_data.is_complete() and active_enemies.size() == 0:
		EventBus.level_completed.emit(_current_level_data.level_id)


func _on_level_started(level_data: LevelData) -> void:
	_current_level_data = level_data
	_current_wave_count = 1
	_spawn_timer = 0.0
	_enemies_data = _current_level_data.enemies_data
	
	# 初始化波次计数器显示
	EventBus.wave_completed.emit(_current_level_data.level_id, _current_wave_count, _current_level_data.total_waves)
