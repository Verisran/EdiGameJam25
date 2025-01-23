extends Node2D
class_name BubbleBase

@export var shape: Shape2D
@export var layers: PhysicsCast.TargetLayer
@export var push_mode: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float)->void:
	var result: Dictionary = PhysicsCast.shape(self, shape, layers)[0]
	if(!result.is_empty()):
		print(result.collider)

func on_collide()->void:
	pass
