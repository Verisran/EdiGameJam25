extends BubbleBase
class_name BubbleSpawner

@export_category("Action")
@export var new_dmg: float
@export var new_speed: float
@export var rotate_deg: float
@export var spawn_interval: float
@export var spawn_amt: int
var pool: Array[BubbleBase]
@export var pool_amt: int
@export var bubble_tscn: Resource
var can_spawn: bool = true

func _ready() -> void:
	for layer in target_layers:
		layers += layer
	for i in range(pool_amt):
		var instance: BubbleBase = bubble_tscn.instantiate()
		pool.append(instance)
	
func action()->void:
	self.rotate(deg_to_rad(rotate_deg))
	
	if(!can_spawn or pool.size() == 0):
		return
	var to_spawn: Array[BubbleBase]
	for i in range(spawn_amt):
		var popped: BubbleBase = pool.pop_back()
		if(popped == null):
			break
		to_spawn.append(popped)

	var toggle_side: bool = false
	var new_dir: Vector2
	for bubble:BubbleBase in to_spawn:
		if(toggle_side):
			new_dir = self.transform.x
			toggle_side = !toggle_side
		else:
			new_dir = self.transform.y
			toggle_side = !toggle_side
		bubble.start_attack(new_speed, new_dir, self.position+new_dir*20, new_dmg, 7)
		GameManager.LevelRoot.add_child(bubble)
	can_spawn = false
	await get_tree().create_timer(spawn_interval, false).timeout
	can_spawn = true
