extends KinematicBody2D

var motion = Vector2(0,0)

var direction = 1

enum {
	MOVE,
	JUMP,
	ATTACK
}

var current_state = MOVE

const MAX_SPEED = 100
const GRAVITY = 10
const JUMP_HEIGHT = 200
const ACCELERATION = 50
const FRICTION_FLOOR = 1
const FRICTION_AIR = 0.05

onready var animation_player = $AnimationPlayer

var x_input

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	match current_state:
		MOVE:

			# movement
			x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			if x_input != 0:
				
				if direction != x_input:
					direction = x_input
					scale.x = -scale.x
				motion.x += x_input * ACCELERATION
				motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
				
				if is_on_floor():
					animation_player.play("Run")
			
			elif is_on_floor():
				animation_player.play("Idle")

			# friction
			apply_friction()
	
			# jumping
			if is_on_floor():
				if Input.is_action_just_pressed("ui_up"):
					current_state = JUMP

			# attack 
			if Input.is_action_just_pressed("attack"):
				current_state = ATTACK

		JUMP:

			if animation_player.current_animation != "Jump":
				animation_player.play("Jump")
			
			if motion.y > 0:
				animation_player.play("Fall")
				current_state = MOVE

			# friction
			apply_friction()

			# # jumping
			# if motion.y < 0:
			# 	animation_player.play("Jump")
			# else:
			# 	animation_player.play("Fall")

		ATTACK:

			# friction
			apply_friction()

			# attack
			if animation_player.current_animation != "Attack":
				animation_player.play("Attack")

	# falling 
	motion.y += GRAVITY

	motion = move_and_slide(motion, Vector2.UP)

func jump():
	if is_on_floor():
		motion.y = -JUMP_HEIGHT

func on_attack_animation_end():
	current_state = MOVE

func apply_friction():
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION_FLOOR)
	else:
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION_AIR)
