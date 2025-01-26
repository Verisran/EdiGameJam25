extends Button
class_name StartLevelButton

func _ready() -> void:
	self.button_up.connect(GameManager.level_start)
