class_name EnemyDeathState
extends State


var death_timer: float = 0.0
var death_duration: float = 2.0
var destroy_timer: float = 3.0

func enter() -> void:
	owner_entity.animated_sprite.play("death")
	death_timer = 0.0
	
	owner_entity.velocity = Vector2.ZERO
	owner_entity.collision_shape.set_deferred("disabled", true)
	owner_entity.shadow.hide()
	
	EventBus.enemy_death.emit(owner_entity)

func exit() -> void:
	pass

func process(delta: float) -> void:
	death_timer += delta
	
	if death_timer > death_duration:
		var alpha = 1.0 - (death_timer - death_duration) / (destroy_timer - death_duration)
		alpha = clamp(alpha, 0.0, 1.0)
		owner_entity.modulate.a = alpha
	
	if death_timer > destroy_timer:
		owner_entity.queue_free()