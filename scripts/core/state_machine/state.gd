class_name State
extends Node

# 状态引用
var state_machine = null
var owner_entity = null

# 状态生命周期函数
func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process(delta: float) -> void:
	pass
	
func physics_process(delta: float) -> void:
	pass
	
func input(event: InputEvent) -> void:
	pass

# 状态转换
func change_state(new_state_name: String) -> void:
	if state_machine:
		state_machine.change_state(new_state_name)