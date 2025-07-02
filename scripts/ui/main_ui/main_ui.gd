extends Control

@onready var control = $Control
@onready var color_rect = $CanvasLayer/ColorRect

func _on_start_pressed() -> void:
	start_game()


func start_game():
	color_rect.show()
	var tween = create_tween()
	tween.parallel().tween_property(color_rect, 'modulate:a', 1.0, 0.2).from(0.0)
	tween.tween_callback(func():
		control.hide()
		Game.on_game_start.emit()
	)


func _on_exit_pressed() -> void:
	get_tree().quit()
