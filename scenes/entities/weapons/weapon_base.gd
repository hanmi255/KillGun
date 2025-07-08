class_name WeaponBase
extends Node2D

@export var weapon_data: WeaponData: set = _set_weapon_data

var current_ammo: int = 0
var can_fire: bool = true
var is_reloading: bool = false
var fire_timer: float = 0.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var fire_particles: GPUParticles2D = $FireParticles

var owner_entity = null


func _ready() -> void:
	if not weapon_data:
		push_error("武器没有配置数据！")
		weapon_data = WeaponData.new()
	
	if weapon_data.weapon_texture and sprite:
		sprite.texture = weapon_data.weapon_texture
	
	current_ammo = weapon_data.max_ammo
	
	if fire_particles:
		fire_particles.lifetime = weapon_data.fire_rate - 0.01

	EventBus.weapon_changed.connect(_on_weapon_changed)
	EventBus.weapon_ammo_changed.emit(current_ammo, weapon_data.max_ammo)


func _on_weapon_changed(old_weapon_data: WeaponData, new_weapon_data: WeaponData) -> void:
	if weapon_data == old_weapon_data:
		_set_weapon_data(new_weapon_data)
		current_ammo = weapon_data.max_ammo
		can_fire = true
		is_reloading = false
		fire_timer = 0.0

		if weapon_data.weapon_texture and sprite:
			sprite.texture = weapon_data.weapon_texture

		if fire_particles:
			fire_particles.lifetime = weapon_data.fire_rate - 0.01

		EventBus.weapon_ammo_changed.emit(current_ammo, weapon_data.max_ammo)


func _process(delta: float) -> void:
	if not can_fire:
		fire_timer += delta
		if fire_timer >= weapon_data.fire_rate:
			can_fire = true
			fire_timer = 0.0
	
	if Input.is_action_pressed("fire") and can_fire and current_ammo > 0 and not is_reloading:
		if weapon_data.can_auto_fire or Input.is_action_just_pressed("fire"):
			fire()
	
	if Input.is_action_just_pressed("reload") and not is_reloading and current_ammo < weapon_data.max_ammo:
		reload()


func fire() -> void:
	can_fire = false
	
	# 创建子弹
	if weapon_data.bullet_scene:
		var bullet_instance = weapon_data.bullet_scene.instantiate()
		bullet_instance.global_position = bullet_spawn_point.global_position
		
		# 应用精度偏移
		var direction = global_position.direction_to(get_global_mouse_position())
		if weapon_data.accuracy < 1.0:
			var max_deviation = (1.0 - weapon_data.accuracy) * 0.2 # 最大20%角度偏移
			var random_angle = randf_range(-max_deviation, max_deviation)
			direction = direction.rotated(random_angle)
			
		bullet_instance.direction = direction
		bullet_instance.source_weapon = self
		bullet_instance.damage = weapon_data.damage
		
		# 设置子弹速度和生命周期
		if bullet_instance.has_method("set_bullet_properties"):
			bullet_instance.set_bullet_properties(
				weapon_data.bullet_speed,
				weapon_data.bullet_lifetime
			)
		
		# 处理暴击
		if randf() <= weapon_data.critical_chance:
			bullet_instance.is_critical = true
			bullet_instance.damage = int(bullet_instance.damage * weapon_data.critical_damage_multiplier)
		
		# 添加到场景
		get_tree().root.add_child(bullet_instance)
	
	# 减少弹药
	current_ammo -= 1
	EventBus.weapon_ammo_changed.emit(current_ammo, weapon_data.max_ammo)
	
	if current_ammo <= 0:
		reload()
	
	_play_fire_animation()


func reload() -> void:
	if is_reloading or current_ammo == weapon_data.max_ammo:
		return
	
	is_reloading = true
	
	if weapon_data.reload_start_sound:
		EventBus.weapon_reload_started.emit(self)
		ServiceLocator.get_audio_manager().play_sfx(weapon_data.reload_start_sound)
	
	# 换弹计时
	var reload_time = weapon_data.reload_time
	var end_sound_time = reload_time - 0.4 # 结束音效提前播放
	
	# 换弹结束计时
	await get_tree().create_timer(end_sound_time).timeout
	
	if weapon_data.reload_end_sound:
		ServiceLocator.get_audio_manager().play_sfx(weapon_data.reload_end_sound)
	
	await get_tree().create_timer(reload_time - end_sound_time).timeout
	
	# 恢复弹药
	current_ammo = weapon_data.max_ammo
	is_reloading = false
	EventBus.weapon_ammo_changed.emit(current_ammo, weapon_data.max_ammo)


func _play_fire_animation() -> void:
	if fire_particles:
		fire_particles.restart()
		fire_particles.scale = Vector2.ONE * weapon_data.muzzle_flash_scale
	
	# 缩放动画
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "scale:x", 0.7, weapon_data.fire_rate / 2)
	tween.tween_property(sprite, "scale:x", 1, weapon_data.fire_rate / 2)
	
	# 播放射击音效
	if weapon_data.fire_sound:
		ServiceLocator.get_audio_manager().play_sfx(weapon_data.fire_sound)
	
	# 相机震动
	if owner_entity and owner_entity is Player and owner_entity.camera:
		var shake_intensity = weapon_data.camera_shake_intensity
		var camera_tween = create_tween()
		camera_tween.tween_property(
			owner_entity.camera,
			"offset",
			Vector2.ZERO,
			weapon_data.fire_rate
		).from(Vector2(-shake_intensity / 2, shake_intensity))


func _set_weapon_data(value: WeaponData) -> void:
	weapon_data = value

func set_owner_entity(entity) -> void:
	owner_entity = entity


func get_weapon_name() -> String:
	return weapon_data.weapon_name if weapon_data else "未知武器"


func get_ammo_status() -> Dictionary:
	return {
		"current": current_ammo,
		"max": weapon_data.max_ammo if weapon_data else 0
	}


func get_weapon_description() -> String:
	return weapon_data.weapon_description if weapon_data else "无描述"
