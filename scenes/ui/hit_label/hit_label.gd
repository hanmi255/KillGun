extends Node2D

@onready var label = $Label

func _ready() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.2)
	tween.parallel().tween_property(label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1)
	tween.parallel().tween_property(label, "position:y", label.position.y - 15, 0.3)
	tween.tween_property(label, "position:y", label.position.y - 12, 0.3)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.3)
	
	tween.tween_callback(func():
		queue_free())


func set_text(text):
	label.text = text
