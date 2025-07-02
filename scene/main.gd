extends Node2D

const _player = preload("res://scene/player/player.tscn")

@onready var canvas_layer = $CanvasLayer
@onready var map_land = $Land

func _ready() -> void:
	Game.map = self
	
	Game.on_game_start.connect(on_game_start)
	
func on_game_start():
	LevelManager.new_level()
	canvas_layer.show()
	var tween = create_tween()
	tween.parallel().tween_property(get_parent().color_rect,'modulate:a',0.0,0.2)
	tween.tween_callback(func ():
		get_parent().color_rect.hide()
	)
	var instance = _player.instantiate()
	add_child(instance)

func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		if event.is_echo():
			return
		if event.as_text() in ['a','s','w','d']:
			if event.pressed:
				#按下触发的内容
				pass
			else:
				#松开触发的内容
					pass
	
	if event.is_action_pressed("move_down"):
		pass #表示某个按键正在被按下
	if event.is_action_released("move_down"):
		pass #表示某个按键被松开
