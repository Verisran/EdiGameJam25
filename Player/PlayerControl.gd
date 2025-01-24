extends BaseKinematic
class_name Player

@onready var camera: Camera2D = $SmoothCam/Camera2D
@onready var point: MeshInstance2D = $CollisionShape2D/point

@export var speed: float = 200:
	get:
		if(!is_on_floor()):
			return speed * air_mult
		else:
			return speed
@export var air_mult: float = 1.25
@export var speed_accel: float = 0.8
@export var speed_decel: float = 0.25:
	get:
		if(!move_dir):
			return speed_decel * 0.1
		return speed_decel
@export var wall_vector: Vector2 = Vector2.ZERO

@export var jumps: int = 3
var jumps_amt: int = jumps
@export var jump_force: float = 500:
	get:
		return -jump_force

@export var grav_force: float = 10
var grav_multiplier: float = 1
var move_dir: float:
	get:
		return Input.get_axis("Left", "Right")

func _ready() -> void:
	point.top_level = true

func _physics_process(_delta: float) -> void:
	var direc: float = move_dir
	get_wall_side()
	velocity_control(direc)
	time_in_air()
	move_and_slide()

func velocity_control(direc: float)->void:
	velocity_x_lerped(direc)
	if not is_on_floor():
		velocity.y += grav_force*grav_multiplier
	else:

		jumps_amt = jumps

	if (Input.is_action_just_pressed("Jump") and (is_on_floor() or wall_vector != Vector2.ZERO) and jumps_amt > 0):
		jumps_amt -= 1
		velocity.y = 0
		impulse(Vector2.DOWN, jump_force)
		if(wall_vector):
			velocity.x = 0
			impulse(wall_vector, jump_force*0.5)

func velocity_x_lerped(direc: float)->void:
	if(direc):
		velocity.x = lerpf(velocity.x, speed * direc, speed_accel)
	else:
		velocity.x = lerpf(velocity.x, 0, speed_decel)

func get_wall_side()->void:
	if(is_on_floor()):
		point.global_position = self.global_position
		wall_vector = Vector2.ZERO
		return
	var wall_left: Dictionary = PhysicsCast.ray(self, global_position, Vector2.LEFT, 12, PhysicsCast.TargetLayer.World + PhysicsCast.TargetLayer.EnemyCol)
	if(!wall_left.is_empty()):
		velocity.x = 0
		point.global_position = wall_left.position
		wall_vector = -wall_left.normal
		return
	
	var wall_right: Dictionary = PhysicsCast.ray(self, global_position, Vector2.RIGHT, 12, PhysicsCast.TargetLayer.World + PhysicsCast.TargetLayer.EnemyCol)
	if(!wall_right.is_empty()):
		velocity.x = 0
		point.global_position = wall_right.position
		wall_vector = -wall_right.normal
		return
	
	else:
		point.global_position = self.global_position
		wall_vector = Vector2.ZERO

func time_in_air()->void:
	if(!is_on_floor() and grav_multiplier <= 2.5):
		grav_multiplier += 0.025
	else:
		grav_multiplier = 1

func impulse(vector: Vector2, strength: float, use_current_dir: bool = false)->void:
	if(use_current_dir):
		vector = velocity.normalized()
	velocity += vector*strength
	if(!is_on_floor()):
		grav_multiplier = 1

func amplify(strength: float)->void:
	velocity = velocity.normalized()*strength
