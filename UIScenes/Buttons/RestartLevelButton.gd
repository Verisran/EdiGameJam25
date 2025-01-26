extends Button
class_name RestartLevelButton

func _ready() -> void:
	self.button_up.connect(GameManager.restart_level)
