extends Button
class_name QuitGameButton

func _ready() -> void:
	self.button_up.connect(get_tree().quit)
