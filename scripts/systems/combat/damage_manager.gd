class_name DamageManager
extends Node

# 伤害类型
enum DamageType {
	PHYSICAL,
	MAGICAL,
	TRUE
}

# 伤害信息类
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

# 处理伤害计算
func calculate_damage(source, target, base_damage: int, damage_type: int = DamageType.PHYSICAL) -> DamageInfo:
	var damage_info = DamageInfo.new(base_damage, source, target, damage_type)
	
	# 暴击计算 (20%几率造成1.5倍伤害)
	if randf() <= 0.2:
		damage_info.is_critical = true
		damage_info.amount = int(damage_info.amount * 1.5)
	
	return damage_info

# 应用伤害
func apply_damage(damage_info: DamageInfo) -> void:
	if damage_info.target and damage_info.target.has_method("take_damage"):
		damage_info.target.take_damage(damage_info.amount)
		
		# 请求显示伤害数字
		EventBus.damage_number_requested.emit(
			damage_info.target.global_position,
			damage_info.amount,
			damage_info.is_critical
		)

# 辅助函数 - 快速应用伤害
func quick_damage(source, target, amount: int) -> void:
	var damage_info = calculate_damage(source, target, amount)
	apply_damage(damage_info)