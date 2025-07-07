class_name DamageLabel
extends Node2D

@export var label_color: Color = Color(1, 1, 1, 1)
@export var critical_color: Color = Color(1, 0.2, 0.2, 1)
@export var float_height: float = 50.0
@export var float_duration: float = 1.0
@export var scale_duration: float = 0.3

@onready var label: Label = $Label

func _set_damage(amount: int, is_critical: bool = false) -> void:
	label.text = str(amount)
	
	label.add_theme_color_override("font_color", critical_color if is_critical else label_color)
	
	var initial_scale = 1.0
	if is_critical:
		initial_scale = 1.5

	scale = Vector2(initial_scale, initial_scale)
	
	_animate(is_critical)


func _animate(is_critical: bool) -> void:
	var tween = create_tween()
	
	# 向上飘动
	tween.parallel().tween_property(self, "position:y",
		position.y - float_height, float_duration).set_ease(Tween.EASE_OUT)
	
	# 缩放动画
	var target_scale = 0.7
	if is_critical:
		# 先放大后缩小
		tween.parallel().tween_property(self, "scale",
			Vector2(2.0, 2.0), scale_duration).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self, "scale",
			Vector2(target_scale, target_scale),
			float_duration - scale_duration).set_ease(Tween.EASE_IN).set_delay(scale_duration)
	else:
		# 直接缩小
		tween.parallel().tween_property(self, "scale",
			Vector2(target_scale, target_scale),
			float_duration).set_ease(Tween.EASE_IN)
	
	# 淡出
	tween.parallel().tween_property(self, "modulate:a",
		0.0, float_duration * 0.7).set_delay(float_duration * 0.3)
	
	tween.tween_callback(queue_free)


static func create(parent: Node, _position: Vector2, damage: int, is_critical: bool = false) -> DamageLabel:
	var damage_label_scene = load("res://scenes/ui/hud/damage_label/damage_label.tscn")
	
	var instance = damage_label_scene.instantiate()
	parent.add_child(instance)
	
	instance.global_position = _position
	
	instance._set_damage(damage, is_critical)
	
	return instance