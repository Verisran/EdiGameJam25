extends Node2D

var do_update: bool = false
var curr_trf: Transform2D
var prev_trf: Transform2D
@export var target: Node2D

func _ready() -> void:
	top_level = true
	curr_trf = self.transform
	prev_trf = curr_trf
	global_transform = target.global_transform

func _physics_process(delta: float) -> void:
	do_update = true
	
func _process(delta: float) -> void:
	interpolate_position(do_update, delta)

func interpolate_position(update: bool, delta: float)->void:
	if(update):
		prev_trf = curr_trf
		curr_trf = target.global_transform
		do_update = false
	var f: float = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
	global_transform = prev_trf.interpolate_with(curr_trf, f)
