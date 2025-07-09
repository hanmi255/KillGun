class_name BulletBase
extends Node2D

@export var speed: float = 800.0
@export var lifetime: float = 3.0
@export var damage: int = 10
@export var hit_effect_scene: PackedScene

var direction: Vector2 = Vector2.RIGHT
var source_weapon = null
var elapsed_time: float = 0.0
var is_critical: bool = false


func _ready() -> void:
	rotation = direction.angle()

	if source_weapon:
		EventBus.weapon_fired.emit(source_weapon, self)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
	elapsed_time += delta
	if elapsed_time >= lifetime:
		_on_lifetime_ended()


func set_bullet_properties(bullet_speed: float, bullet_lifetime: float) -> void:
	speed = bullet_speed
	lifetime = bullet_lifetime


func _on_lifetime_ended() -> void:
	queue_free()


func _on_hit(node: Node2D) -> void:
	ServiceLocator.get_damage_manager().quick_damage(self, node, damage)

	# 播放击中效果
	if hit_effect_scene:
		var effect = hit_effect_scene.instantiate()
		effect.global_position = global_position
		get_tree().current_scene.add_child(effect)

	queue_free()


func _on_area_2d_body_entered(node: Node2D) -> void:
	if node.is_in_group("enemies"):
		_on_hit(node)