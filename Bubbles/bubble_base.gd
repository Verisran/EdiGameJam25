extends BaseKinematic
class_name BubbleBase

@export var speed: float
@export var direc: Vector2

@export var shape: Shape2D
@export var body_shape: Shape2D
@export var solid: bool = false
@export var target_layers: Array[PhysicsCast.TargetLayer]
var layers: int = 0
var collider: CollisionShape2D
@export var push_mode: PushType
@export var push_strength: float

#movement

func _ready() -> void:
	for layer in target_layers:
		layers += layer
	if(solid):
		collider = CollisionShape2D.new()
		collider.shape = body_shape
		add_child(collider)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float)->void:
	var result: Dictionary = PhysicsCast.shape(self, shape, layers)[0]
	if(!result.is_empty()):
		if(result.collider is BaseKinematic):
			on_collide_entity(result.collider)
		if(result.collider is not BaseKinematic):
			on_collide_world()

func on_collide_entity(target: BaseKinematic)->void:
	push(target)

func on_collide_world()->void:
	print("World Collide")

func push(target: BaseKinematic)->void:
	match push_mode: 
		PushType.REPEL:
			var direc: Vector2 = (target.global_position - self.global_position).normalized()
			target.impulse(direc, push_strength)
		PushType.PULL:
			pass
		PushType.AMPLIFY:
			pass
			#target.impulse()

func impulse(vector: Vector2, strength: float, use_current_dir: bool = false)->void:
	if(use_current_dir):
		vector = velocity.normalized()
	velocity += vector*strength
