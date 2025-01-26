extends BaseKinematic
class_name BubbleBase

@export var pop_on_collide: bool = false
@export_category("Movement")
@export var speed: float
@export var direc: Vector2
@export_category("Collision")
@export var shape: Shape2D
@export var target_layers: Array[PhysicsCast.TargetLayer] = [PhysicsCast.TargetLayer.World, PhysicsCast.TargetLayer.PlayerCol, PhysicsCast.TargetLayer.PlayerHealthHitbox]
@export_category("On Collide")
var layers: int = 0
var collider: CollisionShape2D
@export var on_player_input: bool = false

@export var push_mode: PushType
@export var push_strength: float
@export var push_direc: Vector2
var cooldown: bool = false
@export var cooldown_time: float = 0.5
@export_category("Damage")
@export var damage: float = 0
var tap_ring: Sprite2D
@export var tap_ring_target: Vector2 = Vector2(2,2)

func _ready() -> void:
	tap_ring = self.get_node_or_null("TapRing")
	if(tap_ring == null):
		on_player_input = false
	if(layers != 0):
		return
	for layer in target_layers:
		layers += layer
	
func _physics_process(delta: float)->void:
	if(!GameManager.level_started or GameManager.distance_to_player(self) > 2000):
		if(GameManager.distance_to_player(self) > 5000):
			queue_free()
		return
	movement()
	cast_collision()
	action()

func movement()->void:
	if(speed != 0):
		velocity = direc*speed
		move_and_slide()

func cast_collision()->void:
	var collided_with: bool = false
	if(!cooldown):
		var results: Array[Dictionary] = PhysicsCast.shape(self, shape, layers, 2, true, true)
		for result in results:
			if(result.is_empty()):
				continue
			if(result.collider is Player):
				on_collide_entity(result.collider)
				collided_with = true
				continue
			if(result.collider is HealthBase):
				if(push_mode == PushType.PULL):
					collided_with = true
					continue
				attack(result.collider)
				continue
			if(result.collider is Node2D):
				pop()
				
	if(!collided_with):
		tap_ring.scale = lerp(tap_ring.scale, Vector2.ZERO, 0.1)

func on_collide_entity(target: Player)->void:
	if(on_player_input):
		tap_ring.scale = lerp(tap_ring.scale, tap_ring_target, 0.5)
		if(GameManager.player_input_push):
			push(target)
			if(pop_on_collide):
				pop(true, 1)
		else:
			return
	else:
		push(target)
	start_cooldown()

func push(target: Player)->void:
	if(target is Player):
		target.jumps_amt = target.jumps
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
		PushType.BOUNCE:
			target.velocity = push_direc*push_strength
	pop()

func attack(target: HealthBase)->void:
	target.take_damage(damage)
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

func player_pop(player: Player)->void:
	push(player)
	pop(true)
	
func pop(force_pop: bool = false, delay: float = -1)->void:
	if((!pop_on_collide or on_player_input) and !force_pop):
		return
	if(delay > 0):
		await get_tree().create_timer(delay, false).timeout
	self.queue_free()

func action()->void:
	pass

func start_attack(spd: float, dir: Vector2, start_position: Vector2, dmg: float, inherit_layer: int, pop_collide: bool = true):
	speed = spd
	direc = dir
	position = start_position
	damage = dmg
	layers = inherit_layer
	pop_on_collide = pop_collide
