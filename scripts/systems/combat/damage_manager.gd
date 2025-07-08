class_name DamageManager
extends Node

enum DamageType {
	PHYSICAL,
	MAGICAL,
	TRUE
}

class DamageInfo:
	var amount: int = 0
	var type: int = DamageType.PHYSICAL
	var is_critical: bool = false
	var source = null
	var target = null


	func _init(p_amount: int, p_source = null, p_target = null, p_type: int = DamageType.PHYSICAL) -> void:
		amount = p_amount
		source = p_source
		target = p_target
		type = p_type


	func set_critical(value: bool = true) -> DamageInfo:
		is_critical = value
		if value:
			amount = int(amount * 1.5) # 暴击伤害1.5倍
		return self


func _ready() -> void:
	ServiceLocator.register_damage_manager(self)


func _calculate_damage(source, target, base_damage: int, damage_type: int = DamageType.PHYSICAL) -> DamageInfo:
	var damage_info = DamageInfo.new(base_damage, source, target, damage_type)
	
	# 暴击计算 (20%几率造成1.5倍伤害)
	if randf() <= 0.2:
		damage_info.set_critical()
	
	return damage_info


func _apply_damage(damage_info: DamageInfo) -> void:
	if damage_info.target and damage_info.target.has_method("take_damage"):
		damage_info.target.take_damage(damage_info.amount)
		
		# 请求显示伤害数字
		EventBus.damage_number_requested.emit(
			damage_info.target.global_position,
			damage_info.amount,
			damage_info.is_critical
		)


func quick_damage(source, target, amount: int) -> void:
	var damage_info = _calculate_damage(source, target, amount)
	_apply_damage(damage_info)