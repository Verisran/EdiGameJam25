extends Button
class_name NextLevelButton

func _ready() -> void:
	self.button_up.connect(GameManager.change_level.bind(GameManager.current_level+1))
