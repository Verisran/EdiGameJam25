extends ColorRect

func _on_resume_button_up() -> void:
	GameManager.pause_toggle()

func _on_restart_level_button_button_up() -> void:
	GameManager.pause_toggle()
	GameManager.restart_level()

func _on_main_menu_button_button_up() -> void:
	GameManager.pause_toggle()
	GameManager.change_level(1)
	GameManager.player.reset()

func _on_quit_game_button_button_up() -> void:
	GameManager.pause_toggle()
	get_tree().quit()
