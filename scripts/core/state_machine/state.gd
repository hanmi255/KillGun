class_name State
extends Node

var state_machine = null
var owner_entity = null


# 状态生命周期函数
func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> void:
	pass


func physics_process(_delta: float) -> void:
	pass


func input(_event: InputEvent) -> void:
	pass


func change_state(new_state_name: String) -> void:
	if state_machine:
		state_machine.change_state(new_state_name)