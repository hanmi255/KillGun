class_name EnemyBase
extends EntityBase

@export var enemy_data: EnemyData

@onready var body: Node2D = $Body
@onready var animated_sprite: AnimatedSprite2D = $Body/AnimatedSprite2D
@onready var shadow: Sprite2D = $Shadow
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var attack_area: Area2D = $AttackArea
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var state_machine: StateMachine = $StateMachine

var current_target = null


func _ready() -> void:
	state_machine.owner_entity = self


func take_damage(damage_amount: int) -> void:
	super.take_damage(damage_amount)

	state_machine.change_state("hit")

	if enemy_data.hit_sound:
		ServiceLocator.get_audio_manager().play_sfx(enemy_data.hit_sound)


func die() -> void:
	state_machine.change_state("death")


func attack(target) -> void:
	if target.has_method("take_damage"):
		target.take_damage(enemy_data.attack_damage)


func _update_facing(direction: Vector2) -> void:
	if direction.x < 0:
		body.scale.x = -1
	else:
		body.scale.x = 1


func set_target(target: Player) -> void:
	current_target = target

	# 设置目标后，如果是空闲状态，切换到移动状态
	if not state_machine:
		# 如果state_machine还未初始化，等待_ready完成后再执行
		call_deferred("_deferred_set_target")
		return

	if state_machine.current_state_name == "idle" and current_target != null:
		state_machine.change_state("move")


func _deferred_set_target() -> void:
	if state_machine and current_target != null:
		if state_machine.current_state_name == "idle":
			state_machine.change_state("move")


func is_target_in_attack_range() -> bool:
	if not current_target:
		return false

	var distance = global_position.distance_to(current_target.global_position)
	return distance <= enemy_data.attack_range


func _on_attack_area_entered(node: Node2D) -> void:
	if node.is_in_group("player") and state_machine.current_state_name != "death":
		state_machine.change_state("attack")


func _on_attack_area_exited(node: Node2D) -> void:
	if node.is_in_group("player"):
		state_machine.change_state("move")


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
