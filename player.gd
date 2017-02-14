extends KinematicBody2D

var sprite_node

var input_direction = 0
var direction = 1

var speed = Vector2()
var velocity = Vector2()

const MAX_SPEED = 700
const ACCELERATION = 2600
const DECELERATION = 5000

const JUMP_FORCE = 1000
const GRAVITY = 2800
const MAX_FALL_SPEED = 1400

var jump_count = 0
const MAX_JUMP_COUNT = 2


func _ready():
	set_process(true)
	set_process_input(true)
	sprite_node = get_node("Sprite")


func _input(event):
	if jump_count < MAX_JUMP_COUNT and event.is_action_pressed("jump"):
		speed.y = -JUMP_FORCE
		jump_count += 1


func _process(delta):
	if input_direction:
		direction = input_direction
	
	if Input.is_action_pressed("move_left"):
		input_direction = -1
		sprite_node.set_flip_h(true)
	elif Input.is_action_pressed("move_right"):
		input_direction = 1
		sprite_node.set_flip_h(false)
	else:
		input_direction = 0
	
	if input_direction == - direction:
		speed.x /= 3
	if input_direction:
		speed.x += ACCELERATION * delta
	else:
		speed.x -= DECELERATION * delta
	speed.x = clamp(speed.x, 0, MAX_SPEED)
	
	speed.y += GRAVITY * delta
	if speed.y > MAX_FALL_SPEED:
		speed.y = MAX_FALL_SPEED
	
	velocity = Vector2(speed.x * delta * direction, speed.y * delta)
	var movement_remainder = move(velocity)
	
	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		speed = normal.slide(speed)
		move(final_movement)
		
		if normal == Vector2(0, -1):
			jump_count = 0
