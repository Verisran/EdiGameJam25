extends ColorRect

@onready var next_level_button: Button = $NextLevelButton
@onready var change_level_button: Button = $MenuButton
@onready var time: Label = $Darken/Time
var first_ready: bool = true

func _ready() -> void:
	if(first_ready):
		next_level_button.button_up.connect(next_level)
		change_level_button.button_up.connect(go_to_menu)
		first_ready = false
	set_time()

func set_time()->void:
		time.set_text("Time: " + str(snapped(GameManager.level_time,0.001)) )

func next_level()->void:
	GameManager.change_level(GameManager.current_level+1)
	GameManager.ui_root.remove_child(self)

func go_to_menu()->void:
	GameManager.change_level(1)
	GameManager.ui_root.remove_child(self)

func _on_tree_exited() -> void:
	request_ready()
