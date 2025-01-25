extends Button
class_name ChangeLevelButton

@export var level_index: int

func _ready() -> void:
	self.button_up.connect(GameManager.change_level.bind(level_index))
