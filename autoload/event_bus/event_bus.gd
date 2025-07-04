extends Node

# 玩家相关信号
signal player_health_changed(current: int, maximum: int)
signal player_death()
signal player_moved(position: Vector2)

# 敌人相关信号
signal enemy_spawned(enemy_instance: Node)
signal enemy_death(enemy_instance: Node)
signal enemy_damaged(enemy_instance: Node, damage_amount: int)

# 武器相关信号
signal weapon_fired(weapon_instance: Node, projectile: Node)
signal weapon_reload_started(weapon_instance: Node)
signal weapon_reload_completed(weapon_instance: Node)
signal weapon_ammo_changed(current: int, maximum: int)
signal weapon_equipped(weapon_instance: Node)

# 游戏流程相关信号
signal level_started(level_data: Resource)
signal level_completed(level_id: int)
signal game_started()
signal game_paused(is_paused: bool)
signal game_over(victory: bool)

# UI相关信号
signal damage_number_requested(position: Vector2, amount: int, is_critical: bool)