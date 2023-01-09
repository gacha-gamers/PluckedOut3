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

func _physics_process(delta):
	get_player_position()
	follow_player()
	move_and_slide(_velocity)

func get_player_position():
	player_position = GlobalScript.player.position
