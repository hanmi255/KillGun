class_name BaseBullet
extends Node2D

const HIT_EFFECT = preload("res://scenes/hit_effect/hit_effect.tscn")

@export var speed = 800
@export var dir = Vector2.ZERO

var current_weapon: BaseWeapon
var _tick = 0


func _ready() -> void:
	look_at(get_global_mouse_position())


func _physics_process(delta: float) -> void:
	global_position += dir * delta * speed
	_tick += delta
	if Engine.get_physics_frames() % 20:
		if _tick >= 3:
			queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is BaseEnemy:
		Game.damage(Game.player, body)
		set_physics_process(false)
		var ins = HIT_EFFECT.instantiate()
		ins.global_position = global_position
		Game.map.add_child(ins)
		queue_free()
