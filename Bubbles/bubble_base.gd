extends BaseKinematic
class_name BubbleBase

@export var pop_on_collide: bool = false
@export_category("Movement")
@export var speed: float
@export var direc: Vector2
@export_category("Collision")
@export var shape: Shape2D
@export var body_shape: Shape2D
@export var solid: bool = false
@export var target_layers: Array[PhysicsCast.TargetLayer]
@export_category("On Collide")
var layers: int = 0
var collider: CollisionShape2D
@export var push_mode: PushType
@export var push_strength: float
var cooldown: bool = false
@export var cooldown_time: float = 0.25
@export_category("Damage")
@export var damage: float = 0

func _ready() -> void:
	for layer in target_layers:
		layers += layer
	if(solid):
		collider = CollisionShape2D.new()
		collider.shape = body_shape
		add_child(collider)

func _physics_process(delta: float)->void:
	if(GameManager.distance_to_player(self) > 1000 or !GameManager.level_started):
		return
	if(speed != 0):
		velocity = direc*speed
		move_and_slide()
	if(!cooldown):
		var results: Array[Dictionary] = PhysicsCast.shape(self, shape, layers, 2, true, true)
		for result in results:
			if(result.is_empty()):
				return
			if(result.collider is BaseKinematic):
				on_collide_entity(result.collider)
				continue
			if(result.collider is HealthBase):
				if(push_mode == PushType.PULL):
					continue
				attack(result.collider)
				continue

func on_collide_entity(target: BaseKinematic)->void:
	push(target)
	start_cooldown()

func attack(target: HealthBase)->void:
	target.take_damage(damage)

func push(target: BaseKinematic)->void:
	match push_mode: 
		PushType.REPEL:
			target.velocity = Vector2.ZERO
			target.impulse(-(self.global_position-target.global_position).normalized(), push_strength)
		PushType.PULL:
			if(target is Player):
				pull_target(target)
				return
		PushType.AMPLIFY:
			target.impulse(target.velocity.normalized(), push_strength)
		PushType.SET_VELOCITY:
			target.velocity = -transform.y*push_strength
	pop()

func pull_target(target: Player):
	target.disabled = true
	target.velocity = Vector2.ZERO
	for i in range(5):
		target.velocity = (self.position-target.position).normalized()*push_strength*(clampf(i*0.01, 0.05, 0.1))
		target.health.take_damage(damage*(i*0.1))
		if((self.position-target.position).length() < 5):
			target.velocity = Vector2.ZERO
		await get_tree().create_timer(0.16666, false).timeout
	target.disabled = false
	pop()

func start_cooldown()->void:
	cooldown = true
	await get_tree().create_timer(cooldown_time, false).timeout
	cooldown = false

func pop()->void:
	if(!pop_on_collide):
		return
	self.queue_free()
