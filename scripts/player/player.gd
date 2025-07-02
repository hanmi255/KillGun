class_name Player
extends CharacterBody2D

@onready var anim = $Body/AnimatedSprite2D
@onready var body = $Body
@onready var weapon_node = $Body/WeaponNode
@onready var camera = $Camera2D

var speed = 70
var _current_anim = 'down_'


func _ready() -> void:
	Game.player = self
	PlayerManager.on_player_death.connect(on_player_death)


func on_player_death():
	weapon_node.hide()
	anim.play("death")


func _physics_process(_delta: float) -> void:
	if PlayerManager.is_death():
		return

	var dir = Vector2.ZERO

	dir.x = Input.get_axis("move_left", "move_right")
	dir.y = Input.get_axis("move_up", "move_down")

	velocity = dir.normalized() * speed

	change_anim()

	move_and_slide()


func change_anim():
	if velocity == Vector2.ZERO:
		anim.play(_current_anim + 'idle')
	else:
		_current_anim = get_movement_dir()
		anim.play(_current_anim + 'move')
	
	var _position = get_global_mouse_position()

	weapon_node.look_at(_position)

	if _position.x > position.x and body.scale.x != 1:
		body.scale.x = 1
	elif _position.x < position.x && body.scale.x != -1:
		body.scale.x = -1


func get_movement_dir() -> String:
	weapon_node.z_index = 1
	if velocity == Vector2.ZERO:
		return 'lr_'

	var angle = velocity.angle() # 获取速度向量的角度
	var degree = rad_to_deg(angle)

	if 45 <= degree and degree < 135:
		return 'down_'
	elif -135 <= degree and degree < -45:
		weapon_node.z_index = 0
		return 'up_'
	return 'lr_'
