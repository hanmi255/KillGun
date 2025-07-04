class_name EnemyBase
extends EntityBase

# 敌人状态
enum EnemyState {
	IDLE,
	MOVE,
	ATTACK,
	HIT,
	DEATH
}

# 导出变量
@export var movement_speed: float = 30.0
@export var attack_damage: int = 5
@export var attack_range: float = 20.0
@export var detection_range: float = 200.0
@export var hit_sound: AudioStream

# 引用
@onready var animated_sprite: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var body: Node2D = $Body
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shadow: Sprite2D = $Shadow
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_machine: StateMachine = $StateMachine

# 状态
var current_target = null
var path_update_timer: float = 0.0
var path_update_interval: float = 0.5

func _ready() -> void:
	# 初始化敌人
	entity_name = "Enemy"
	max_health = 50
	current_health = max_health
	
	# 注册到敌人管理器
	EventBus.enemy_spawned.emit(self)

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# 更新导航路径
	path_update_timer += delta
	if path_update_timer >= path_update_interval:
		_update_path()
		path_update_timer = 0.0
	
	# 处理移动
	if not nav_agent.is_navigation_finished() and current_target:
		var next_position = nav_agent.get_next_path_position()
		var direction = global_position.direction_to(next_position)
		
		velocity = direction * movement_speed
		
		# 更新朝向
		_update_facing(direction)
		
		move_and_slide()

func take_damage(damage_amount: int) -> void:
	super.take_damage(damage_amount)
	
	# 播放受击动画
	state_machine.change_state("hit")
	
	# 播放音效
	if hit_sound:
		ServiceLocator.get_audio_manager().play_sfx(hit_sound)
	
	# 显示伤害数字
	EventBus.damage_number_requested.emit(global_position, damage_amount, false)

func die() -> void:
	# 设置死亡状态
	state_machine.change_state("death")
	
	# 禁用碰撞
	collision_shape.set_deferred("disabled", true)
	
	# 隐藏阴影
	shadow.hide()
	
	# 发送死亡信号
	EventBus.enemy_death.emit(self)

func attack(target) -> void:
	if target.has_method("take_damage"):
		target.take_damage(attack_damage)

func _update_path() -> void:
	# 如果有目标，更新导航路径
	if current_target:
		nav_agent.target_position = current_target.global_position

func _update_facing(direction: Vector2) -> void:
	# 根据移动方向更新朝向
	if direction.x < 0:
		body.scale.x = -1
	else:
		body.scale.x = 1

# 设置目标
func set_target(target) -> void:
	current_target = target
	_update_path()

# 检查目标是否在攻击范围内
func is_target_in_attack_range() -> bool:
	if not current_target:
		return false
	
	var distance = global_position.distance_to(current_target.global_position)
	return distance <= attack_range