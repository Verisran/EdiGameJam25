extends Node

@onready var GameRoot: Node = get_tree().get_root().get_node("GameRoot")
@onready var LevelRoot: Node2D = GameRoot.get_child(0)
@onready var PlayerRoot: Node2D = GameRoot.get_child(1)
@onready var ui_root: CanvasLayer = GameRoot.get_child(2)

@onready var player: Player = PlayerRoot.get_child(0)
@onready var load_ui: ColorRect = preload("res://UIScenes/loading.tscn").instantiate()
@onready var pre_level_start: ColorRect = preload("res://UIScenes/pre_level_start.tscn").instantiate()
@onready var death_screen: ColorRect = preload("res://UIScenes/you_died.tscn").instantiate()

#var current_level: Resource
var level_file_path: String
var level_started: bool = false

func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	reset_player()
	change_level("res://Level/main_menu.tscn")

func change_level(level_path: String)->void:
	level_started = false
	GameRoot.add_child(load_ui)
	level_file_path = level_path
	ResourceLoader.load_threaded_request(level_path)
	var loading: bool = true
	while(loading):
		if(ResourceLoader.load_threaded_get_status(level_path) != ResourceLoader.THREAD_LOAD_LOADED):
			break
		if(ResourceLoader.load_threaded_get_status(level_path) == ResourceLoader.THREAD_LOAD_FAILED):
			change_level("res://Level/main_menu.tscn")
			return

	add_level(ResourceLoader.load_threaded_get(level_path))
	GameRoot.remove_child(load_ui)
	
func add_level(current_level: Resource)->void:
	if(LevelRoot.get_child_count() > 0):
		var old_level: Node = LevelRoot.get_child(0)
		LevelRoot.remove_child(old_level)
		old_level.queue_free()
	LevelRoot.add_child(current_level.instantiate())
	if(LevelRoot.get_child(0).get_node_or_null("OverrideCam") == null):
		player.camera.set_enabled(true)
		player.camera.make_current()
		ui_root.add_child(pre_level_start)
	else:
		player.camera.set_enabled(false)
	if(ui_root.get_node_or_null("DeathScreen") != null):
		ui_root.remove_child(death_screen)

func level_start()->void:
	player.start()
	level_started = true
	ui_root.remove_child(pre_level_start)

func restart_level()->void:
	change_level(level_file_path)

func reset_player()->void:
	player.reset()

func show_death_screen()->void:
	ui_root.add_child(death_screen)
	
func distance_to_player(from: Node2D)->float:
	return from.position.distance_to(player.position)

func spawn_enemy(to_add: Array[Node2D], to_loc: Array[Vector2])->void:
	if(to_add.size()==0):
		return
	var target: Node2D = LevelRoot.get_child(0)
	for i in range(to_add.size()):
		target.add_child(to_add[i])
		to_add[i].position = to_loc[i]
