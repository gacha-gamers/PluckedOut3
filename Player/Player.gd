extends KinematicBody2D

export var SPEED: int = 10000
export var walk_animation_name = "walk"
export var walk_forward_animation_name = "walk_forward"
export var walk_up_animation_name = "walk_up"
export var idle_animation_name = "idle"
export var dash_time = 0.2
export var dash_speed_multiplier = 10
onready var animations: AnimatedSprite = $Animations

var dash = Vector2.ZERO # Vec2.zero for not dashing, any other vector for the direction. Must be normalized
var dash_timer = 0

func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		animations.flip_h = false
	
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
		animations.flip_h = true
	
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
	
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if is_dashing():
		velocity = dash
		dash_timer += delta
		
		if dash_timer >= dash_time:
			reset_dash()
	
	# play_walk_animation(velocity)
	
	velocity = velocity.normalized() * SPEED * delta
	
	if is_dashing():
		velocity *= dash_speed_multiplier
	
	move_and_slide(velocity)

func play_walk_animation(input):
	if input.y == 0: animations.play(walk_animation_name)
	elif input.y > 0: animations.play(walk_forward_animation_name)
	else: animations.play(walk_up_animation_name)

func reset_dash():
	dash = Vector2.ZERO
	dash_timer = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and can_dash():
		dash = (get_global_mouse_position() - position).normalized()

func can_dash() -> bool:
	if dash != Vector2.ZERO:
		return false
	return true

func is_dashing() -> bool:
	if dash != Vector2.ZERO:
		return true
	return false
