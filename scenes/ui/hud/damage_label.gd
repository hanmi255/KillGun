class_name DamageLabel
extends Node2D

# 标签设置
@export var label_color: Color = Color(1, 1, 1, 1)
@export var critical_color: Color = Color(1, 0.2, 0.2, 1)
@export var float_height: float = 50.0
@export var float_duration: float = 1.0
@export var scale_duration: float = 0.3

# 节点引用
@onready var label: Label = $Label

# 初始化伤害标签
func set_damage(amount: int, is_critical: bool = false) -> void:
	# 设置文本
	label.text = str(amount)
	
	# 设置颜色
	label.add_theme_color_override("font_color", critical_color if is_critical else label_color)
	
	# 设置初始大小
	var initial_scale = 1.0
	if is_critical:
		initial_scale = 1.5
	scale = Vector2(initial_scale, initial_scale)
	
	# 动画
	_animate(is_critical)

# 创建动画
func _animate(is_critical: bool) -> void:
	# 创建补间动画
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
	
	# 完成后移除
	tween.tween_callback(queue_free)

# 静态创建方法
static func create(parent: Node, position: Vector2, damage: int, is_critical: bool = false) -> DamageLabel:
	# 加载场景
	var damage_label_scene = load("res://ui/hud/damage_label.tscn")
	
	# 实例化
	var instance = damage_label_scene.instantiate()
	parent.add_child(instance)
	
	# 设置位置
	instance.global_position = position
	
	# 设置伤害
	instance.set_damage(damage, is_critical)
	
	return instance