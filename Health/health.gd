extends Area2D
class_name HealthBase
@export var health: float = 10
@export var shape: Shape2D
@onready var my_hitbox: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	my_hitbox.shape = shape
	
func take_damage(damage: float):
	health -= damage
