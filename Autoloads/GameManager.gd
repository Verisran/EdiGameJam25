extends Node

@onready var GameRoot: Node = get_tree().get_root().get_node("GameRoot")
@onready var LevelRoot: Node2D = GameRoot.get_child(0)
@onready var PlayerRoot: Node2D = GameRoot.get_child(1)
@onready var player: Player = PlayerRoot.get_child(0)

var current_level: Resource

func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	reset_player()
	change_level("res://Level/debug_level.tscn")

func change_level(level_path: String)->void:
	ResourceLoader.load_threaded_request(level_path)
	while(true):
		if(ResourceLoader.load_threaded_get_status(level_path) != ResourceLoader.THREAD_LOAD_LOADED):
			break
		if(ResourceLoader.load_threaded_get_status(level_path) != ResourceLoader.THREAD_LOAD_FAILED):
			return
		await get_tree().create_timer(0.16666).timeout
	current_level = ResourceLoader.load_threaded_get(level_path)
	add_level()
	
func add_level()->void:
	if(LevelRoot.get_child_count() > 0):
		LevelRoot.remove_child(LevelRoot.get_child(0))
	LevelRoot.add_child(current_level.instantiate())
	level_start()

func level_start()->void:
	player.start()

func reset_player()->void:
	player.reset()
