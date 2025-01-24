extends BaseKinematic
class_name BubbleBase

@export var pop_on_collide: bool = false
@export var speed: float
@export var direc: Vector2

@export var shape: Shape2D
@export var body_shape: Shape2D
@export var solid: bool = false
@export var target_layers: Array[PhysicsCast.TargetLayer]
var layers: int = 0
var collider: CollisionShape2D
@export var push_mode: PushType
@export var push_direc: Vector2
@export var push_strength: float
var cooldown: bool = false
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
	if(!result.is_empty() and !cooldown):
		if(result.collider is BaseKinematic):
			on_collide_entity(result.collider)
		if(result.collider is not BaseKinematic):
			on_collide_world()

func on_collide_entity(target: BaseKinematic)->void:
	push(target)
	start_cooldown()
	pop()

func on_collide_world()->void:
	print("World Collide")
	pop()

func push(target: BaseKinematic)->void:
	match push_mode: 
		PushType.REPEL:
			target.velocity = Vector2.ZERO
			target.impulse(-(self.global_position-target.global_position).normalized(), push_strength)
		PushType.PULL:
			pass
		PushType.AMPLIFY:
			target.impulse(target.velocity.normalized(), push_strength)
		PushType.SET_VELOCITY:
			target.velocity = push_direc*push_strength

func impulse(vector: Vector2, strength: float, use_current_dir: bool = false)->void:
	if(use_current_dir):
		vector = velocity.normalized()
	velocity += vector*strength

func start_cooldown()->void:
	cooldown = true
	await get_tree().create_timer(0.25, false).timeout
	cooldown = false

func pop()->void:
	if(!pop_on_collide):
		return
	self.queue_free()
