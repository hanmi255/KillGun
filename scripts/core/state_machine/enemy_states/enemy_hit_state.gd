class_name EnemyHitState
extends State


var hit_timer: float = 0.0
var hit_duration: float = 0.3


func enter() -> void:
	owner_entity.animated_sprite.play("hit")
	hit_timer = 0.0
	
	owner_entity.velocity = Vector2.ZERO


func exit() -> void:
	pass


func process(delta: float) -> void:
	if owner_entity.is_dead:
		change_state("death")
		return
	
	# 受击状态持续一段时间
	hit_timer += delta
	if hit_timer >= hit_duration:
		# 受击结束后，如果有目标且在攻击范围内，则切换到攻击状态
		if owner_entity.current_target and owner_entity.is_target_in_attack_range():
			change_state("attack")
		# 否则，如果有目标但不在攻击范围内，切换到移动状态
		elif owner_entity.current_target:
			change_state("move")
		else:
			change_state("idle")