class_name WeaponData
extends Resource

@export_group("Base")
@export var weapon_name: String = "默认武器"
@export var weapon_description: String = "一把普通的武器"

@export_group("Battle")
@export var damage: int = 10
@export var max_ammo: int = 30
@export var fire_rate: float = 0.2 # 射击间隔（秒）
@export var reload_time: float = 2.0 # 换弹时间
@export var bullet_speed: float = 800.0
@export var bullet_lifetime: float = 3.0

@export_group("Visual")
@export var weapon_texture: Texture
@export var bullet_scene: PackedScene
@export var muzzle_flash_scale: float = 1.0
@export var camera_shake_intensity: float = 2.0

@export_group("Audio")
@export var fire_sound: AudioStream
@export var reload_start_sound: AudioStream
@export var reload_end_sound: AudioStream

@export_group("Advanced")
@export var can_auto_fire: bool = true
@export var accuracy: float = 1.0 # 1.0表示完美精度，越低越不精确
@export var critical_chance: float = 0.1 # 10%暴击率
@export var critical_damage_multiplier: float = 1.5 # 暴击伤害倍率