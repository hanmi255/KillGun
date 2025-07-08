class_name HUD
extends CanvasLayer

@onready var hp_bar: ProgressBar = $HPControl/HPBar
@onready var weapon_icon: TextureRect = $WeaponControl/WeaponIcon
@onready var weapon_name: Label = $WeaponControl/WeaponName
@onready var ammo_counter: Label = $WeaponControl/AmmoCounter
@onready var wave_counter: Label = $WaveCounter
@onready var crosshair: TextureRect = $Crosshair


func _ready() -> void:
	EventBus.player_health_changed.connect(_on_player_health_changed)
	EventBus.weapon_equipped.connect(_on_weapon_equipped)
	EventBus.weapon_ammo_changed.connect(_on_weapon_ammo_changed)
	EventBus.damage_number_requested.connect(_on_damage_number_requested)
	EventBus.level_started.connect(_on_level_started)


func _process(_delta: float) -> void:
	if crosshair:
		crosshair.position = get_viewport().get_mouse_position()

func show_hud(value: bool = true) -> void:
	self.visible = value


func _on_player_health_changed(current: int, maximum: int) -> void:
	if hp_bar:
		hp_bar.max_value = maximum
		hp_bar.value = current
		
		# 更新颜色
		var health_percent = float(current) / float(maximum)
		var color = Color(1, 0, 0, 1) # 红色（低血量）
		
		if health_percent > 0.6:
			color = Color(0, 1, 0, 1) # 绿色（高血量）
		elif health_percent > 0.3:
			color = Color(1, 1, 0, 1) # 黄色（中等血量）

		hp_bar.modulate = color


func _on_weapon_equipped(weapon_instance: WeaponBase) -> void:
	if weapon_icon and weapon_instance.weapon_data:
		weapon_icon.texture = weapon_instance.weapon_data.weapon_texture
		weapon_name.text = weapon_instance.weapon_data.weapon_name


func _on_weapon_ammo_changed(current: int, maximum: int) -> void:
	if ammo_counter:
		ammo_counter.text = "%d/%d" % [current, maximum]


func _on_damage_number_requested(position: Vector2, amount: int, is_critical: bool) -> void:
	DamageLabel.create(self, position, amount, is_critical)


func _on_level_started(level_data) -> void:
	if wave_counter:
		wave_counter.text = "关卡 %s - 波次 0/%d" % [level_data.level_id, level_data.total_waves]


func update_wave_counter(current_wave: int, total_waves: int, level_id: int) -> void:
	if wave_counter:
		wave_counter.text = "关卡 %s - 波次 %d/%d" % [level_id, current_wave, total_waves]


func set_crosshair(texture: Texture) -> void:
	if crosshair:
		crosshair.texture = texture

	crosshair.position = get_viewport().get_mouse_position()
