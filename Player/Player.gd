class_name Player
extends KinematicBody2D

export var SPEED: int = 10000
export var dash_forward_animation_name = "dash_forward"
export var walk_animation_name = "walk"
export var walk_forward_animation_name = "walk_forward"
export var walk_up_animation_name = "walk_up"
export var idle_animation_name = "idle"
onready var animations: AnimatedSprite = $Animations
export var dash_distance = 300
export var dash_duration = 0.6
export var dash_cooldown = 1
export var crop_scene: PackedScene

var is_dashing = false
var is_on_dash_cooldown = false
var crops_collected = 0
var seeds_collected = 1

func _ready() -> void:
	GlobalScript.player = self

func _physics_process(delta):
	
	if is_dashing():
		return
	
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
	
	play_walk_animation(velocity)
	
	velocity = velocity.normalized() * SPEED * delta
	
	move_and_slide(velocity)

func play_walk_animation(input):
	if input.y == 0: animations.play(walk_animation_name)
	elif input.y > 0: animations.play(walk_forward_animation_name)
	else: animations.play(walk_up_animation_name)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and can_dash():
		dash()
	if event.is_action_pressed("plant") and seeds_collected > 0:
		seeds_collected -= 1
		plant()

func can_dash() -> bool:
	if is_dashing() or is_on_dash_cooldown:
		return false
	return true

func is_dashing() -> bool:
	return is_dashing

func dash():
	is_dashing = true
	animations.play('dash_forward')
	
	var direction = (get_global_mouse_position() - position).normalized()
	var final = position + direction * dash_distance
	if direction.x > 0: animations.flip_h = false
	if direction.x < 0: animations.flip_h = true
	
	var dash_tween = create_tween()
	dash_tween.set_trans(Tween.TRANS_CIRC)
	dash_tween.set_ease(Tween.EASE_IN_OUT)
	dash_tween.tween_property(
		self,
		"position",
		final,
		dash_duration
	)
	dash_tween.tween_callback(self, "dash_cooldown_start")


func dash_cooldown_start():
	is_on_dash_cooldown = true
	is_dashing = false
	
	$ProgressBar.value = 0
	$ProgressBar.visible = true
	
	var dash_tween = create_tween()
	dash_tween.set_trans(Tween.TRANS_CIRC)
	dash_tween.set_ease(Tween.EASE_OUT)
	dash_tween.tween_property(
		$ProgressBar,
		"value",
		100.0,
		dash_cooldown
	)
	dash_tween.tween_callback(self, "dash_cooldown_end")

func dash_cooldown_end():
	is_on_dash_cooldown = false
	$ProgressBar.visible = false

func plant():
	var crop = crop_scene.instance()
	get_tree().get_root().add_child(crop)
