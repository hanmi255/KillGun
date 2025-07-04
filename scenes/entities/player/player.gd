class_name Player
extends EntityBase

# 玩家状态
enum PlayerState {
	IDLE,
	MOVE,
	ATTACK,
	ROLL,
	DEATH
}

# 导出变量
@export var movement_speed: float = 70.0

# 引用
@onready var animated_sprite: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var body: Node2D = $Body
@onready var weapon_holder: Node2D = $Body/WeaponNode
@onready var camera: Camera2D = $Camera2D
@onready var state_machine: StateMachine = $StateMachine

# 动画状态
var _current_animation_prefix: String = 'down_'
var _current_weapon = null

func _ready() -> void:
	# 初始化玩家
	entity_name = "Player"
	max_health = 10
	current_health = max_health
	
	# 注册到Game
	Game.player = self
	
	# 发送初始化信号
	EventBus.player_health_changed.emit(current_health, max_health)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	# 处理移动
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	velocity = direction.normalized() * movement_speed
	
	# 更新动画
	_update_animation()
	
	# 应用移动
	move_and_slide()
	
	# 发送移动信号
	if direction != Vector2.ZERO:
		EventBus.player_moved.emit(global_position)

func take_damage(damage_amount: int) -> void:
	super.take_damage(damage_amount)
	
	# 更新UI
	EventBus.player_health_changed.emit(current_health, max_health)
	
	# 受伤动画/音效可以在状态机中处理

func die() -> void:
	# 隐藏武器
	weapon_holder.hide()
	
	# 触发死亡状态
	state_machine.change_state("death")
	
	# 发送死亡信号
	EventBus.player_death.emit()

func _update_animation() -> void:
	if velocity == Vector2.ZERO:
		animated_sprite.play(_current_animation_prefix + 'idle')
	else:
		_current_animation_prefix = _get_movement_direction()
		animated_sprite.play(_current_animation_prefix + 'move')
	
	# 武器跟随鼠标
	var mouse_position = get_global_mouse_position()
	weapon_holder.look_at(mouse_position)
	
	# 处理玩家翻转
	if mouse_position.x > global_position.x and body.scale.x != 1:
		body.scale.x = 1
	elif mouse_position.x < global_position.x and body.scale.x != -1:
		body.scale.x = -1

func _get_movement_direction() -> String:
	# 默认武器在前
	weapon_holder.z_index = 1
	
	if velocity == Vector2.ZERO:
		return 'lr_'
	
	# 根据移动角度确定动画方向
	var angle = velocity.angle()
	var degree = rad_to_deg(angle)
	
	if 45 <= degree and degree < 135:
		return 'down_'
	elif -135 <= degree and degree < -45:
		weapon_holder.z_index = 0 # 向上移动时武器在后面
		return 'up_'
	
	return 'lr_'

func equip_weapon(weapon_instance) -> void:
	# 如果已有武器，移除
	if _current_weapon:
		_current_weapon.queue_free()
	
	# 添加新武器
	_current_weapon = weapon_instance
	weapon_holder.add_child(weapon_instance)
	
	# 设置武器拥有者
	if _current_weapon.has_method("set_owner_entity"):
		_current_weapon.set_owner_entity(self)
	
	# 发送武器装备信号
	EventBus.weapon_equipped.emit(_current_weapon)
