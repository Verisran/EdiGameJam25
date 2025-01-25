extends Area2D

func _ready() -> void:
	self.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D)->void:
	GameManager.set_level_complete()
	queue_free()
