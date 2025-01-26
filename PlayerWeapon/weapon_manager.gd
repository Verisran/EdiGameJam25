extends Node2D

@export var action_delay1: float
@export var action_delay2: float
@export var player: Player
@onready var sword_visual: Sprite2D = $SwordVisual
@export var hitbox: Shape2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _input(event: InputEvent) -> void:
	if(!GameManager.level_started):
		return
	if(event is InputEventMouseButton):
		if(Input.is_action_just_pressed("Action1")):
			action1()
		if(Input.is_action_just_pressed("Action2")):
			action2()

func _physics_process(delta: float) -> void:
	sword_visual.look_at(get_global_mouse_position())
	collision.transform = sword_visual.transform

func action1()->void:
	sword_visual.look_at(get_global_mouse_position())
	var towards: Vector2 = self.position+PhysicsCast.vec_toward_mouse(player.camera)
	var result: Dictionary = PhysicsCast.shape(self, hitbox, PhysicsCast.TargetLayer.EnemyCol, 1, true, true, sword_visual.transform)[0]
	if(!result.is_empty()):
		var bubble: BubbleBase = result.collider
		bubble.player_pop(player)
		print(bubble)

func action2()->void:
	pass
