extends Node

# 游戏运行时引用
var current_scene: Node = null
var player: Node = null
var main_camera: Camera2D = null

# 游戏状态
var is_paused: bool = false
var is_game_over: bool = false

func _ready() -> void:
	# 连接场景树信号
	get_tree().node_added.connect(_on_node_added)

# 节点添加检测
func _on_node_added(node: Node) -> void:
	# 自动检测玩家
	if node.is_class("Player"):
		player = node

# 设置主相机
func set_main_camera(camera: Camera2D) -> void:
	main_camera = camera

# 游戏暂停/恢复
func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	if EventBus:
		EventBus.game_paused.emit(is_paused)

# 游戏结束
func game_over(victory: bool = false) -> void:
	if is_game_over:
		return
		
	is_game_over = true
	EventBus.game_over.emit(victory)

# 重启游戏
func restart_game() -> void:
	is_game_over = false
	is_paused = false
	get_tree().paused = false
	get_tree().reload_current_scene()

# 应用相机震动效果
func camera_shake(intensity: float = 5.0, duration: float = 0.5, frequency: float = 15.0) -> void:
	if main_camera and main_camera.has_method("shake"):
		main_camera.shake(intensity, duration, frequency)