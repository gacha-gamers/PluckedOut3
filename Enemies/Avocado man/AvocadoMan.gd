extends KinematicBody2D

export var bullet_speed = 10
export var attack_speed_secs = 2
export var attack0_number_bullets = 100
export var enemy_speed = 200.0

onready var animations = $Animations

var attack_timer = attack_speed_secs
var random_attack = null

func _process(delta):
	if attack_timer >= attack_speed_secs:
		random_move()
		attack_timer = 0.0
	
	#if random_attack == 0 and attack_timer == 0.0:
	#	$Pattern1.fire_burst()

	attack_timer += delta

func random_move():
	var target_pos = Vector2(rand_range(256, 1024), rand_range(256, 1024))
	animations.flip_h = target_pos.x < position.x
	move_to(target_pos, 1)
	animations.play("jump")

func get_random_int(low, high) -> int:
	var random = RandomNumberGenerator.new()
	random.randomize()
	return random.randi_range(low, high)

func move_to(move_to, time):
	var tween = create_tween()
	tween.tween_property(
		self, 
		"position",
		move_to,
		time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(animations, "play", ["idle"])
