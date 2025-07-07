class_name EnemyMoveState
extends State


var path_update_timer: float = 0.0
var path_update_interval: float = 0.5


func enter() -> void:
	owner_entity.animated_sprite.play("move")
	path_update_timer = 0.0
	
	if owner_entity.current_target:
		_update_path()


func exit() -> void:
	owner_entity.velocity = Vector2.ZERO


func physics_process(delta: float) -> void:
	if owner_entity.is_dead:
		return

	if not owner_entity.current_target:
		change_state("idle")
		return

	if owner_entity.is_target_in_attack_range():
		change_state("attack")
		return
	
	# 更新导航路径
	path_update_timer += delta
	if path_update_timer >= path_update_interval:
		_update_path()
		path_update_timer = 0.0
	
	# 处理移动
	if not owner_entity.nav_agent.is_navigation_finished():
		var next_position = owner_entity.nav_agent.get_next_path_position()
		var direction = owner_entity.global_position.direction_to(next_position)
		
		owner_entity.velocity = direction * owner_entity.movement_speed
		owner_entity._update_facing(direction)
		
		owner_entity.move_and_slide()


func _update_path() -> void:
	if owner_entity.current_target:
		owner_entity.nav_agent.target_position = owner_entity.current_target.global_position