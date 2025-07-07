class_name WeaponManager
extends Node

var current_weapon_index: int = 0
var weapons: Array[WeaponData] = []


func _ready() -> void:
	ServiceLocator.register_weapon_manager(self)

	_load_weapons_from_directory("res://resources/config_data/weapons/")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("last_weapon"):
		_switch_weapon(-1)
	elif Input.is_action_just_pressed("next_weapon"):
		_switch_weapon(1)


func _switch_weapon(direction: int) -> void:
	var last_weapon_data = weapons[current_weapon_index]
	
	# 计算新武器索引
	current_weapon_index = (current_weapon_index + direction) % weapons.size()
	if current_weapon_index < 0:
		current_weapon_index = weapons.size() - 1

	var next_weapon_data = weapons[current_weapon_index]
	
	EventBus.weapon_changed.emit(last_weapon_data, next_weapon_data)


func _load_weapons_from_directory(directory_path: String) -> void:
	weapons.clear()
	
	# 获取目录访问对象
	var dir = DirAccess.open(directory_path)
	if dir:
		# 遍历目录中的所有文件
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var full_path = directory_path + file_name
				_load_weapon_data(full_path)
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		push_error("无法访问武器数据目录: " + directory_path)
	
	# 如果成功加载了武器，设置当前武器为第一个
	if not weapons.is_empty():
		current_weapon_index = 0


func _load_weapon_data(path: String) -> void:
	var weapon_data = load(path) as WeaponData
	if weapon_data:
		weapons.append(weapon_data)
	else:
		push_error("无法加载武器数据: " + path)
