class_name Main
extends Node

const PLAYER_SCENE: PackedScene = preload("res://scenes/entities/player/player.tscn")

@onready var start_menu: StartMenu = $StartMenu
@onready var arena: Node2D = $Arena
@onready var map_land: TileMapLayer = $Arena/Land
@onready var hud: HUD = $HUD

func _ready() -> void:
	Game.map_land = map_land

	EventBus.game_started.connect(_on_game_start)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_echo():
			return
		if event.as_text() in ['a', 's', 'w', 'd']:
			if event.pressed:
				pass
			else:
				pass

	if event.is_action_pressed("move_down"):
		pass
	if event.is_action_released("move_down"):
		pass


func _on_game_start() -> void:
	var tween = create_tween()
	tween.tween_property(arena, "modulate:a", 1.0, 0.5)
	tween.tween_callback(func(): arena.show())
	hud.show_hud();

	var player_instance = PLAYER_SCENE.instantiate()
	add_child(player_instance)
	Game.player = player_instance
