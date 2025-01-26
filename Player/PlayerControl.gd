extends BaseKinematic
class_name Player

@export var camera: Camera2D
@export var health: HealthBase
@onready var point: MeshInstance2D = $CollisionShape2D/point

@export var speed: float = 400
var speed_target: float = speed

@export var air_mult: float = 1.25
@export var speed_accel: float = 1:
	get:
		if(is_on_floor()):
			return speed_accel 
		else:
			return speed_accel * 0.1
@export var speed_decel: float = 0.001:
	get:
		if(is_on_floor()):
			return speed_decel*100
		else:
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

var disabled: bool = true

func _ready() -> void:
	point.top_level = true

func _physics_process(_delta: float) -> void:
	if(!GameManager.level_started or health.dead):
		return
	if(!disabled):
		var direc: float = move_dir
		get_wall_side()
		velocity_control(direc)
		time_in_air()
	move_and_slide()

func speed_control()->void:
	var curr_vel: float = Vector2(get_real_velocity().x, 0).length()
	if(speed_target < curr_vel):
		speed_target = curr_vel - 0.001
	else:
		speed_target = speed

func velocity_control(direc: float)->void:
	speed_control()
	velocity_x_lerped(direc)
	if not is_on_floor():
		velocity.y += grav_force*grav_multiplier
	else:
		jumps_amt = jumps

	if (Input.is_action_just_pressed("Jump") and (is_on_floor() or wall_vector != Vector2.ZERO) and jumps_amt > 0):
		if(!is_on_floor()):
			jumps_amt -= 1
		velocity.y = 0
		impulse(Vector2.DOWN, jump_force)
		if(wall_vector):
			velocity.x = 0
			impulse(wall_vector+Vector2(0,0.25), jump_force)

func velocity_x_lerped(direc: float)->void:
	if(direc):
		velocity.x = lerpf(velocity.x, speed_target * direc, speed_accel)
	else:
		velocity.x = lerpf(velocity.x, 0, speed_decel)

func get_wall_side()->void:
	if(is_on_floor()):
		point.global_position = self.global_position
		wall_vector = Vector2.ZERO
		return
	var wall_left: Dictionary = PhysicsCast.ray(self, global_position, Vector2.LEFT, 12, PhysicsCast.TargetLayer.World + PhysicsCast.TargetLayer.EnemyCol)
	if(!wall_left.is_empty()):
		wall_slide_down()
		velocity.x = 0
		point.global_position = wall_left.position
		wall_vector = -wall_left.normal
		return
	
	var wall_right: Dictionary = PhysicsCast.ray(self, global_position, Vector2.RIGHT, 12, PhysicsCast.TargetLayer.World + PhysicsCast.TargetLayer.EnemyCol)
	if(!wall_right.is_empty()):
		wall_slide_down()
		velocity.x = 0
		point.global_position = wall_right.position
		wall_vector = -wall_right.normal
		return
	
	else:
		point.global_position = self.global_position
		wall_vector = Vector2.ZERO

func wall_slide_down()->void:
	if(jumps_amt == 0):
		return
	var clamps: Vector2 = Vector2(-1024, 128)
	if(Input.is_action_pressed("Down")):
		clamps.y = 128*2.5
	elif(Input.is_action_pressed("Up")):
		clamps.y = 16
	velocity.y = clampf(velocity.y, clamps.x, clamps.y)

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

func death_seq()->void:
	reset()
	GameManager.show_death_screen()

func reset()->void:
	disabled = true
	velocity = Vector2.ZERO
	position = Vector2.ZERO
	self.visible = false
	
func start()->void:
	reset()
	health.reset_health()
	disabled = false
	self.visible = true
