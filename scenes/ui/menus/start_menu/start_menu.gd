class_name StartMenu
extends Control

@onready var start_button: Button = %StartButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton


func _on_start_button_pressed() -> void:
	EventBus.game_started.emit()

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): self.hide())


func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
