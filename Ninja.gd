extends KinematicBody2D

var motion = Vector2(0,0)

var direction = 1

const MAX_SPEED = 100
const GRAVITY = 10
const JUMP_HEIGHT = -200
const ACCELERATION = 50
const FRICTION_FLOOR = 1
const FRICTION_AIR = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# movement
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if x_input != 0:
		if direction != x_input:
			direction = x_input
			scale.x = -scale.x
		motion.x += x_input * ACCELERATION
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

	# friction
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION_FLOOR)
	else:
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION_AIR)

	# falling 
	motion.y += GRAVITY
	
	# jumping
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT

	motion = move_and_slide(motion, Vector2.UP)
