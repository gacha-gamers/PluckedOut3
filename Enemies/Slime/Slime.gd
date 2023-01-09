extends KinematicBody2D

export var speed = 50
export var shooting_speed = 1
export var player_position: Vector2 = Vector2(100, 100)

func _ready():
	$Animations.play()

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


onready var total_health = $LivingEntity.health
func _on_LivingEntity_entity_hurt():
	$ProgressBar.visible = true
	$ProgressBar.value = (float($LivingEntity.health) / float(total_health)) * 100
	$hurt.play()


func _on_LivingEntity_entity_death():
	$ProgressBar.visible = false
