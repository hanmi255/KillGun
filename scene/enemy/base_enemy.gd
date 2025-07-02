extends CharacterBody2D
class_name BaseEnemy

enum State {
	IDLE,
	MOVE,
	ATK,
	DETAH,
	HIT
}

@export var speed = 30 # 移动速度

@onready var anim = $Body/AnimatedSprite2D
@onready var body = $Body
@onready var coll = $CollisionShape2D
@onready var shadow = $Shadow
@onready var hit_audio = $AudioStreamPlayer2D
@onready var nav = $NavigationAgent2D

var _tick = 0

var current_state = State.IDLE # 当前状态
var current_player = null # 当前目标玩家

var movement_delta
var enemy_data: EnemyData # 怪物属性

func _ready() -> void:
	_tick = randi_range(120,240)
	#nav.max_speed = speed
	EnemyManager.enemies.append(self)
	enemy_data = EnemyData.new() # 直接创建，后续会动态创建
	
	enemy_data.on_hit.connect(on_hit)
	enemy_data.on_death.connect(on_death)

func on_hit(_damage):
	current_state = State.HIT
	
	hit_audio.play()
	Game.show_label(self,'-%s' %_damage)
	
	anim.play("hit")
	await anim.animation_finished
	current_state = State.IDLE

func on_death():
	if current_state == State.DETAH:
		return
	current_state = State.DETAH
	coll.call_deferred("set_disabled",true)
	anim.play('death')
	shadow.hide()
	await anim.animation_finished
	queue_free()

func set_movement_target(movement_target: Vector2):
	nav.set_target_position(movement_target)

func _process(delta: float) -> void:
	if Engine.get_process_frames() % _tick == 0 and Game.player:
		set_movement_target(Game.player.global_position)

func _physics_process(delta: float) -> void: 
	if current_state == State.DETAH || current_state == State.ATK || current_state == State.HIT:
		return
	
	if NavigationServer2D.map_get_iteration_id(nav.get_navigation_map()) == 0:
		return
	if nav.is_navigation_finished():
		return

	#movement_delta = speed
	var next_path_position: Vector2 = nav.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * speed
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	
	changeAnim()

func changeAnim():
	if velocity == Vector2.ZERO:
		anim.play("idle")
		current_state = State.IDLE
	else:
		anim.play("move")
		current_state = State.MOVE
		body.scale.x = -1 if !is_facing_taget() and velocity.x < 0 else 1
		

func _on_atk_area_body_entered(body: Node2D) -> void:
	if body is Player and current_state != State.DETAH:
		current_player = body
		current_state = State.ATK
		anim.play("atk")

func _on_atk_area_body_exited(body: Node2D) -> void:
	if body is Player && body == current_player:
		current_player = null

func _on_animated_sprite_2d_frame_changed() -> void:
	if current_state == State.ATK && anim.animation == 'atk':
		if current_player && anim.frame == 2:
			Game.damage(self,current_player)

func _on_animated_sprite_2d_animation_finished() -> void:
	if current_state == State.ATK && anim.animation == 'atk':
		if current_player && PlayerManager.isDeath() == false:
			anim.play("atk")
		else:
			current_state = State.IDLE

func _exit_tree() -> void:
	EnemyManager.enemies.erase(self)
	EnemyManager.on_enemy_death.emit()
	EnemyManager.check_enemies()

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if current_state == State.DETAH || current_state == State.ATK || current_state == State.HIT:
		return
	
	if PlayerManager.isDeath():
		velocity = Vector2.ZERO
	else:
		
		velocity = safe_velocity * speed * 50
		move_and_slide()

#是否朝向主角
func is_facing_taget():
	var dir_to_target = (Game.player.global_position - global_position).normalized()
	var facing_dir = transform.x.normalized()
	
	var dot = facing_dir.dot(dir_to_target)
	
	return dot >= (1 - 0.7)
