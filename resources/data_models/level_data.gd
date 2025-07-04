class_name LevelData
extends Resource

@export var enemy: PackedScene
@export var count: int
@export var tick: float
@export var once_count: int

var current_count = 0


func create_enemy():
	for i in once_count:
		if current_count >= count:
			ServiceLocator.get_level_manager().stop_spawning()
			return
		var instance = enemy.instantiate()
		instance.position = get_random_point()

		Game.map.add_child(instance)
		current_count += 1


func get_random_point():
	var map_land = Game.map.map_land as TileMapLayer

	var rect = map_land.get_used_rect()

	var point = Vector2i(randi_range(rect.position.x, rect.position.x + rect.size.x), randi_range(rect.position.y, rect.position.y + rect.size.y))

	var point_2 = map_land.map_to_local(point)
	return point_2
