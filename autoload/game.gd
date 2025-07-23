extends Node

var current_scene: Node = null
var player: Node = null
var map_land: TileMapLayer = null
var main_camera: Camera2D = null

var is_paused: bool = false
var is_game_over: bool = false


func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	EventBus.player_death.connect(_on_player_death)


func _on_node_added(node: Node) -> void:
	if node.is_class("Player"):
		player = node


func _on_player_death() -> void:
	game_over(true)


func set_main_camera(camera: Camera2D) -> void:
	main_camera = camera


func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused

	EventBus.game_paused.emit(is_paused)


func game_over(victory: bool = false) -> void:
	if is_game_over:
		return
		
	is_game_over = true
	EventBus.game_over.emit(victory)
	#TODO: 显示游戏结束界面
	# 现在先直接退出游戏
	get_tree().quit()


func restart_game() -> void:
	is_game_over = false
	is_paused = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func camera_shake(intensity: float = 5.0, duration: float = 0.5, frequency: float = 15.0) -> void:
	if main_camera and main_camera.has_method("shake"):
		main_camera.shake(intensity, duration, frequency)