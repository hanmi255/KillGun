class_name StateMachine
extends Node

# 导出变量
@export var initial_state: NodePath
@export var owner_entity: State

# 状态引用
var current_state: Node
var states: Dictionary = {}

# 当前状态名称
var current_state_name: String = ""

# 初始化
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

# 状态切换
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
	
	# 记录新状态名称
	current_state_name = new_state_name
	
	# 进入新状态
	current_state = states[new_state_name]
	current_state.enter()
	
	# 发出状态改变信号
	state_changed.emit(current_state_name)

# 状态变化信号
signal state_changed(new_state_name: String)