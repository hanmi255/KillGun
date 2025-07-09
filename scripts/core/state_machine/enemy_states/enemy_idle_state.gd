class_name EnemyIdleState
extends State

var idle_timer: float = 0.0
var idle_duration: float = 2.0


func enter() -> void:
	owner_entity.animated_sprite.play("idle")
	idle_timer = 0.0


func exit() -> void:
	pass


func process(delta: float) -> void:
	if owner_entity.current_target != null:
		if owner_entity.is_target_in_attack_range():
			change_state("attack")
		else:
			change_state("move")
		return
	
	# 如果没有目标，保持空闲状态一段时间后可能转为巡逻
	idle_timer += delta
	if idle_timer >= idle_duration:
		idle_timer = 0.0
