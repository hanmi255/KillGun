class_name HUDManager
extends CanvasLayer

# 节点引用
@onready var health_bar: ProgressBar = $HealthBar
@onready var ammo_counter: Label = $AmmoCounter
@onready var wave_counter: Label = $WaveCounter
@onready var crosshair: TextureRect = $Crosshair

func _ready() -> void:
	# 连接信号
	EventBus.player_health_changed.connect(_on_player_health_changed)
	EventBus.weapon_ammo_changed.connect(_on_weapon_ammo_changed)
	EventBus.damage_number_requested.connect(_on_damage_number_requested)
	EventBus.level_started.connect(_on_level_started)

# 隐藏/显示HUD
func show_hud(visible: bool = true) -> void:
	self.visible = visible

# 更新玩家生命值
func _on_player_health_changed(current: int, maximum: int) -> void:
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current
		
		# 更新颜色
		var health_percent = float(current) / float(maximum)
		var color = Color(1, 0, 0, 1) # 红色（低血量）
		
		if health_percent > 0.6:
			color = Color(0, 1, 0, 1) # 绿色（高血量）
		elif health_percent > 0.3:
			color = Color(1, 1, 0, 1) # 黄色（中等血量）
			
		health_bar.modulate = color

# 更新武器弹药
func _on_weapon_ammo_changed(current: int, maximum: int) -> void:
	if ammo_counter:
		ammo_counter.text = "%d/%d" % [current, maximum]

# 创建伤害数字
func _on_damage_number_requested(position: Vector2, amount: int, is_critical: bool) -> void:
	DamageLabel.create(self, position, amount, is_critical)

# 更新关卡波次信息
func _on_level_started(level_data) -> void:
	if wave_counter:
		wave_counter.text = "关卡 %d - 波次 0/%d" % [level_data.level_id, level_data.total_waves]
		
# 更新波次计数
func update_wave_counter(current_wave: int, total_waves: int, level_id: int) -> void:
	if wave_counter:
		wave_counter.text = "关卡 %d - 波次 %d/%d" % [level_id, current_wave, total_waves]

# 设置准星
func set_crosshair(texture: Texture) -> void:
	if crosshair:
		crosshair.texture = texture