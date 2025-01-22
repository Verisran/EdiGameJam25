extends Camera2D

var curr_pos: Vector2
var prev_pos: Vector2

func _ready() -> void:
	top_level = true
	curr_pos = self.position
	prev_pos = curr_pos
