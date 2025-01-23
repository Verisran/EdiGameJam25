extends CharacterBody2D

@onready var camera: Camera2D = $SmoothCam/Camera2D

@export var speed: float = 200:
	get:
		if(!is_on_floor()):
			return speed * air_mult
		else:
			return speed
@export var air_mult: float = 1.5
@export var speed_accel: float = 1
@export var speed_decel: float = 0.25
@export var jump_force: float = 500:
	get:
		return -jump_force

@export var grav_force: float = 10
var grav_multiplier: float = 1

var move_dir: float:
	get:
		return Input.get_axis("Left", "Right")

func _physics_process(_delta: float) -> void:
	velocity_control()
	time_in_air()
	move_and_slide()

func velocity_control()->void:
	velocity_x_lerped()
	if not is_on_floor():
		velocity.y += grav_force*grav_multiplier

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += jump_force

func velocity_x_lerped()->void:
	if(move_dir):
		velocity.x = lerpf(velocity.x, speed * move_dir, speed_accel)
	else:
		velocity.x = lerpf(velocity.x, 0, speed_decel)

func time_in_air()->void:
	if(!is_on_floor() and grav_multiplier < 10):
		grav_multiplier += 0.1
	else:
		grav_multiplier = 1

func impulse(vector: Vector2, strength: float)->void:
	velocity += vector*strength
