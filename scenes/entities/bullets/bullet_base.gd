class_name BulletBase
extends Node2D

# 子弹属性
@export var speed: float = 800.0
@export var lifetime: float = 3.0
@export var damage: int = 10
@export var hit_effect_scene: PackedScene

# 状态属性
var direction: Vector2 = Vector2.RIGHT
var source_weapon = null
var elapsed_time: float = 0.0
var is_critical: bool = false

func _ready() -> void:
	# 旋转子弹朝向移动方向
	rotation = direction.angle()
	
	# 发送发射信号
	if source_weapon:
		EventBus.weapon_fired.emit(source_weapon, self)

func _physics_process(delta: float) -> void:
	# 移动子弹
	global_position += direction * speed * delta
	
	# 生命周期计时
	elapsed_time += delta
	if elapsed_time >= lifetime:
		_on_lifetime_ended()

# 设置子弹属性
func set_bullet_properties(p_speed: float, p_lifetime: float) -> void:
	speed = p_speed
	lifetime = p_lifetime

# 生命周期结束
func _on_lifetime_ended() -> void:
	queue_free()

# 击中处理
func _on_hit(body: Node) -> void:
	# 处理伤害
	if body.has_method("take_damage"):
		body.take_damage(damage)
		
		# 触发伤害数字
		EventBus.damage_number_requested.emit(body.global_position, damage, is_critical)
	
	# 播放击中效果
	if hit_effect_scene:
		var effect = hit_effect_scene.instantiate()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)
	
	# 销毁子弹
	queue_free()

# 区域进入检测 - 在继承类中连接信号
func _on_area_entered(area: Area2D) -> void:
	pass

# 物体进入检测
func _on_body_entered(body: Node) -> void:
	if body != get_parent() and body.has_method("take_damage"):
		_on_hit(body)