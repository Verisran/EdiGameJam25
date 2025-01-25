extends CanvasLayer

@onready var button_holder: ColorRect = $ButtonHolder
@export var main_menu_btn: CanvasLayer

func _ready() -> void:
	update_buttons()
	GameManager.completionLoaded.connect(update_buttons)

func update_buttons()->void:
	var buttons: Array[ChangeLevelButton]
	for child in button_holder.get_children():
		buttons.append(child)
		
	for i:int in range(button_holder.get_child_count()):
		if(buttons[i].level_index == 1 or buttons[i].level_index == 0):
			continue
		buttons[i].disabled = !GameManager.completion[buttons[i].level_index-1]

func _on_play_button_button_up() -> void:
	self.set_visible(true)
	main_menu_btn.set_visible(false)

func _on_back_button_up() -> void:
	self.set_visible(false)
	main_menu_btn.set_visible(true)

func _on_reset_progress_button_up() -> void:
	GameManager.load_completion(true)
