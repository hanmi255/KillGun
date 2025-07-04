class_name WeaponBase
extends Node2D

# 武器数据资源
@export var weapon_data: WeaponData

# 当前弹药状态
var current_ammo: int = 0
var can_fire: bool = true
var is_reloading: bool = false
var fire_timer: float = 0.0

# 节点引用
@onready var sprite: Sprite2D = $Sprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var fire_particles: GPUParticles2D = $FireParticles

# 拥有者引用
var owner_entity = null

func _ready() -> void:
	# 验证武器数据
	if not weapon_data:
		push_error("武器没有配置数据！")
		weapon_data = WeaponData.new()
	
	# 应用武器贴图
	if weapon_data.weapon_texture and sprite:
		sprite.texture = weapon_data.weapon_texture
	
	# 初始化弹药
	current_ammo = weapon_data.max_ammo
	
	# 初始化粒子效果
	if fire_particles:
		fire_particles.lifetime = weapon_data.fire_rate - 0.01
	
	# 发送武器初始化信号
	EventBus.weapon_equipped.emit(self)
	EventBus.weapon_ammo_changed.emit(current_ammo, weapon_data.max_ammo)

func _process(delta: float) -> void:
	# 武器冷却
	if not can_fire:
		fire_timer += delta
		if fire_timer >= weapon_data.fire_rate:
			can_fire = true
			fire_timer = 0.0
	
	# 处理射击输入
	if Input.is_action_pressed("fire") and can_fire and current_ammo > 0 and not is_reloading:
		if weapon_data.can_auto_fire or Input.is_action_just_pressed("fire"):
			fire()
	
	# 处理换弹输入
	if Input.is_action_just_pressed("reload") and not is_reloading and current_ammo < weapon_data.max_ammo:
		reload()

func fire() -> void:
	# 设置冷却
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
	
	# 如果弹药用完，自动换弹
	if current_ammo <= 0:
		reload()
	
	# 播放射击动画和音效
	_play_fire_animation()

func reload() -> void:
	if is_reloading or current_ammo == weapon_data.max_ammo:
		return
	
	is_reloading = true
	
	# 播放换弹开始音效
	if weapon_data.reload_start_sound:
		EventBus.weapon_reload_started.emit(self)
		ServiceLocator.get_audio_manager().play_sfx(weapon_data.reload_start_sound)
	
	# 换弹计时
	var reload_time = weapon_data.reload_time
	var end_sound_time = reload_time - 0.4 # 结束音效提前播放
	
	# 换弹结束计时
	await get_tree().create_timer(end_sound_time).timeout
	
	# 播放换弹结束音效
	if weapon_data.reload_end_sound:
		ServiceLocator.get_audio_manager().play_sfx(weapon_data.reload_end_sound)
	
	await get_tree().create_timer(reload_time - end_sound_time).timeout
	
	# 恢复弹药
	current_ammo = weapon_data.max_ammo
	is_reloading = false
	EventBus.weapon_ammo_changed.emit(current_ammo, weapon_data.max_ammo)

func _play_fire_animation() -> void:
	# 重启粒子效果
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

func set_owner_entity(entity) -> void:
	owner_entity = entity
	
# 获取武器名称
func get_weapon_name() -> String:
	return weapon_data.weapon_name if weapon_data else "未知武器"

# 获取当前弹药状态
func get_ammo_status() -> Dictionary:
	return {
		"current": current_ammo,
		"max": weapon_data.max_ammo if weapon_data else 0
	}

# 获取武器描述
func get_weapon_description() -> String:
	return weapon_data.weapon_description if weapon_data else "无描述"