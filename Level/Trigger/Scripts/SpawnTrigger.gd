extends BaseTrigger
class_name SpawnTrigger

@export var enemy: Resource
@export var prep_amt: int = 1
@export var spawn_amt: int = 1
var enemy_pool: Array[Node2D]
@export var spawn_loc: Array[Vector2]

func _ready() -> void:
	set_collision_layers()
	connect_signal()
	for i in range(prep_amt):
		enemy_pool.append(enemy.instantiate())

func on_body_entered(body: Node2D)->void:
	GameManager.spawn_enemy(pop_enemies(), pop_location())

func pop_location()->Array[Vector2]:
	var popped: Array[Vector2]
	for i in range(spawn_amt):
		var location: Vector2 
		if(spawn_loc.size() != 0):
			location = spawn_loc.pop_back()
		else:
			popped.append(self.position)
			continue
		popped.append(self.position+location)
	return popped

func pop_enemies()->Array[Node2D]:
	if(enemy_pool.size() == 0):
		return []
	var popped: Array[Node2D]
	for i in range(spawn_amt):
		popped.append(enemy_pool.pop_back())
	return popped
