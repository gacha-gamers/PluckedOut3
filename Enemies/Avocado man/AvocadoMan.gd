extends KinematicBody2D

export var bullet_speed = 10
export var attack_speed_secs = 2
export var attack0_number_bullets = 100
export var enemy_speed = 200.0

onready var animations = $Animations
onready var tween = $Tween

var attack_timer = attack_speed_secs
var random_attack = null

func _process(delta):
	if attack_timer >= attack_speed_secs:
		random_attack = get_random_int(0,0)
		attack_timer = 0.0
		move_to(Vector2(rand_range(256, 1024), rand_range(256, 1024)), 1)
	
	if random_attack == 0 and attack_timer == 0.0:
		$Pattern1.fire_burst()
#		for bullet in range(0, attack0_number_bullets):
#			spawn_bullet(position, bullet * (2*PI / attack0_number_bullets))
	
	attack_timer += delta

export var enemy_bullet_scene: PackedScene

func spawn_bullet(position : Vector2, direction : float):
	var vector = Vector2.RIGHT.rotated(direction).normalized()
	
	var bullet: EnemyBullet = enemy_bullet_scene.instance()
	bullet.position = position
	bullet.vector = vector
	bullet.rotation = rotation
	get_parent().add_child(bullet)

func get_random_int(low, high) -> int:
	var random = RandomNumberGenerator.new()
	random.randomize()
	return random.randi_range(low, high)

func move_to(move_to, time):
	tween.interpolate_property(
		self, 
		"position",
		position,
		move_to,
		time,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT
	)
	tween.start()
