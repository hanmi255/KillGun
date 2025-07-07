class_name StateMachine
extends Node

@export_node_path("State") var initial_state: NodePath
@export var owner_entity: Node

signal state_changed(new_state_name: String)

var current_state: State
var states: Dictionary = {}

var current_state_name: String = ""


func _ready() -> void:
	# 注册所有子节点状态
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
			child.owner_entity = owner_entity

	# 设置初始状态
	if initial_state:
		var initial = get_node(initial_state)
		if initial is State:
			change_state(initial.name.to_lower())
		else:
			push_error("初始状态必须是State类型")


# 状态机委托流程到当前状态
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)


func _input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)


func change_state(new_state_name: String) -> void:
	new_state_name = new_state_name.to_lower()

	# 验证新状态
	if new_state_name == current_state_name:
		return

	if not states.has(new_state_name):
		push_error("State machine 尝试切换到不存在的状态: " + new_state_name)
		return

	# 退出当前状态
	if current_state:
		current_state.exit()

	current_state_name = new_state_name

	current_state = states[new_state_name]
	current_state.enter()

	state_changed.emit(current_state_name)
