extends KinematicBody2D

export var drop_scene : PackedScene = preload("res://World/Seeds/Seed.tscn")
export var speed = 50
export var shooting_speed = 1
export var player_position: Vector2 = Vector2(100, 100)

func _ready():
	$Animations.play()
	$ProgressBar.max_value = $LivingEntity.maximum_health

var _velocity: Vector2 = Vector2.ZERO
func follow_player():
	_velocity = (player_position - position)
	if _velocity.length() < 2:
		_velocity = Vector2.ZERO
		return
	
	_velocity = _velocity.normalized() * speed
	$Animations.flip_h = _velocity.x < 0

func _physics_process(_delta):
	get_player_position()
	follow_player()
	move_and_slide(_velocity)

func get_player_position():
	player_position = GlobalScript.player.position


func _on_LivingEntity_entity_hurt():
	$ProgressBar.visible = true
	$ProgressBar.value = $LivingEntity.health
	$HurtSound.play()

func _on_LivingEntity_entity_death():
	$ProgressBar.visible = false
	
func _on_LivingEntity_entity_free():
	var death_particles = $DeathParticles
	remove_child(death_particles)
	get_parent().add_child(death_particles)
	death_particles.global_position = global_position
	death_particles.emitting = true
	
	var death_sound = $DeathSound
	remove_child(death_sound)
	get_parent().add_child(death_sound)
	death_sound.play()
	
	var slimeball = drop_scene.instance()
	slimeball.make_slimeball()
	get_tree().get_root().add_child(slimeball)
