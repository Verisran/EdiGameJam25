extends Area2D
class_name HealthBase
@export var health: float = 10:
	set(value):
		health = value
		if(health_bar == null):
			return
		health_bar.value = (health/target_health)*100
@onready var target_health: float = health
@export var shape: Shape2D
@onready var my_hitbox: CollisionShape2D = $CollisionShape2D
@export var health_bar: TextureProgressBar

func _ready() -> void:
	my_hitbox.shape = shape
	
func take_damage(damage: float)->void:
	print("Took: ", damage)
	health -= damage
	if(health <= 0):
		die()

func die()->void:
	get_parent().death_seq()

func reset_health()->void:
	health = target_health
