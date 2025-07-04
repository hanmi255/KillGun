class_name DamageInfo
extends Resource

# 伤害类型枚举
enum DamageType {
	PHYSICAL,
	MAGICAL,
	TRUE
}

# 伤害属性
var amount: int = 0
var type: int = DamageType.PHYSICAL
var is_critical: bool = false
var source = null
var target = null

# 初始化
func _init(p_amount: int = 0, p_source = null, p_target = null, p_type: int = DamageType.PHYSICAL) -> void:
	amount = p_amount
	source = p_source
	target = p_target
	type = p_type
	
# 设置为暴击
func set_critical(value: bool = true) -> DamageInfo:
	is_critical = value
	if value:
		amount = int(amount * 1.5) # 暴击伤害1.5倍
	return self