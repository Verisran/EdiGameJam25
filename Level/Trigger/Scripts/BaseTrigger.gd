extends Area2D
class_name BaseTrigger

func connect_signal()->void:
	self.body_entered.connect(on_body_entered)
	
func set_collision_layers()->void:
	collision_mask = PhysicsCast.TargetLayer.PlayerCol
	collision_layer = 0

func on_body_entered(body: Node2D)->void:
	pass
