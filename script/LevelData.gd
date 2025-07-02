extends Resource
class_name LevelData
# 关卡数据

@export var enemy :PackedScene # 关卡怪物
@export var count :int # 怪物数量
@export var tick :float # 刷怪间隔
@export var once_count:int #单次数量

var current_count = 0

func create_enemy():
	for i in once_count:
		if current_count >= count:
			LevelManager.stop()
			return
		var instance = enemy.instantiate()
		instance.position = get_random_point()
		
		Game.map.add_child(instance)
		current_count += 1

# 获取刷怪区域中的随机点
func get_random_point():
	var map_land = Game.map.map_land as TileMapLayer
	
	var rect = map_land.get_used_rect()

	#var area2d = Game.map.enemy_area as Area2D
	#var coll = area2d.get_node('CollisionShape2D') as CollisionShape2D
	#var rect = coll.shape.get_rect()
	
	var point = Vector2i(randi_range(rect.position.x,rect.position.x + rect.size.x),randi_range(rect.position.y,rect.position.y + rect.size.y))
	
	var point_2 = map_land.map_to_local(point)
	return point_2
	
