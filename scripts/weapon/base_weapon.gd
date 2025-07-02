class_name BaseWeapon
extends Node2D

const BULLET = preload("res://scenes/bullet/base_bullet.tscn")

@export var weapon_name = '默认枪械'
@export var bullet_max = 30
@export var damage = 5
@export var weapon_rof = 0.2
@export var weapon_reload_start : AudioStream
@export var weapon_reload_end : AudioStream
@export var weapon_fire : AudioStream

var current_bullet_count = 0
var current_rof_tick = 0

@onready var sprite = $Sprite2D
@onready var bullet_point = $BulletPoint
@onready var fire_particles = $GPUParticles2D

var player: Player


func _ready() -> void:
	fire_particles.lifetime = weapon_rof - 0.01

	current_bullet_count = bullet_max
	PlayerManager.on_weapon_changed.emit(self)
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count, bullet_max)


func _process(delta: float) -> void:
	current_rof_tick += delta
	if Input.is_action_pressed("fire") and current_rof_tick >= weapon_rof && current_bullet_count > 0:
		shoot()
		current_rof_tick = 0


func shoot():
	var instance = BULLET.instantiate()
	instance.global_position = bullet_point.global_position
	instance.dir = global_position.direction_to(get_global_mouse_position())
	instance.current_weapon = self
	get_tree().root.add_child(instance)

	current_bullet_count -= 1
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count, bullet_max)

	if current_bullet_count <= 0:
		reload()

	weapon_anim()


func weapon_anim():
	fire_particles.restart()

	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "scale:x", 0.7, weapon_rof / 2)
	tween.tween_property(sprite, "scale:x", 1, weapon_rof / 2)

	SFXPlayer.play(weapon_fire)

	Game.camera_offset(Vector2(-1.5, 2), weapon_rof)


func reload():
	SFXPlayer.play(weapon_reload_start)
	PlayerManager.on_weapon_reload.emit()

	await get_tree().create_timer(2 - 0.42).timeout
	SFXPlayer.play(weapon_reload_end)

	await get_tree().create_timer(0.42).timeout # 模拟换弹需要2秒
	current_bullet_count = bullet_max
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count, bullet_max)
