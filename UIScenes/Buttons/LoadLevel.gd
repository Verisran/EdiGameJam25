extends Button
class_name ChangeLevelButton

@export var level_path: String = "res://Level/debug_level.tscn"

func _ready() -> void:
	self.button_up.connect(GameManager.change_level.bind(level_path))
