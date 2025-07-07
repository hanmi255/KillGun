class_name EnemyAttackState
extends State

var attack_timer: float = 0.0
var attack_cd: float = 1.0
var can_attack: bool = true
var attack_triggered: bool = false


func enter() -> void:
	owner_entity.animated_sprite.play("attack")
	can_attack = true
	attack_triggered = false
	attack_timer = 0.0
	
	if owner_entity.current_target:
		var direction = owner_entity.global_position.direction_to(owner_entity.current_target.global_position)
		owner_entity._update_facing(direction)


func exit() -> void:
	can_attack = true
	attack_triggered = false


func process(delta: float) -> void:
	if owner_entity.is_dead:
		return
	
	if not owner_entity.current_target or owner_entity.current_target.is_dead:
		change_state("idle")
		return
	
	if not owner_entity.is_target_in_attack_range():
		change_state("move")
		return
	
	if not attack_triggered and can_attack:
		owner_entity.attack(owner_entity.current_target)
		attack_triggered = true
		can_attack = false
	
	if not can_attack:
		attack_timer += delta
		if attack_timer >= attack_cd:
			attack_timer = 0.0
			can_attack = true
			attack_triggered = false
			
			owner_entity.animated_sprite.play("attack")