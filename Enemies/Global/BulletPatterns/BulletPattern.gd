extends Node2D

export var bullet : PackedScene
onready var target = GlobalScript.player
export var is_aimed : bool = true
export var is_even : bool = false

export var is_clock_on : bool = true
export(float, 0.01, 20) var clock_rate : float = 1
export var clock_noise : float = 0

export(float, 0.01, 20) var burst_rate : float = 1
export var burst_noise : float = 0
export var burst_power : int = 1

export(float, 0, 360) var spread_arc : float = 60
export var spread_noise : float = 0
export var spread_power : int = 1

export(float, 0, 360) var spin_angle : float = 0
export var spin_noise : float = 0

export var pressure : float = 1
export var pressure_noise : float = 0

var shoot_timer = 0
var shoot_timer_end = 0

var burst_counter = 0

var is_in_burst = false

func _ready():
	reset_timer(false)

func _process(delta):
	if is_aimed and is_instance_valid(target):
		look_at(target.global_position)
	
	# if is in a burst or is in clock and the clock is enabled
	if is_in_burst or is_clock_on: shoot_timer += delta
	
	if shoot_timer > shoot_timer_end:
		if is_in_burst: shoot()
		else: fire_burst()

func fire_burst():
	burst_counter = 0
	is_in_burst = true
	shoot()

func shoot():
	var is_radial = is_equal_approx(spread_arc, 360)
	var spread_arc = self.spread_arc if spread_power > 1 else 0
	
	var angle_step = spread_arc / (spread_power - int(not is_radial)) if spread_power != 1 else 0
	var angle_shift = spread_arc / 2
	# Even/odd patterns behavior for radial patterns
	# Even patterns are shot to exactly miss the player
	# Odd patterns are shot to exactly hit
	if is_radial and spread_power % 2 != int(is_even):
		angle_shift += angle_step / 2
	
	for i in range(spread_power):
		var rotation_offset = deg2rad(i * angle_step - angle_shift)
		shoot_bullet(add_noise(rotation_offset, spread_noise))
	
	rotate(add_noise(spin_angle, spin_noise)) 
	
	burst_counter += 1
	
	if is_in_burst:
		# reset with burst timer if burst is not over
		reset_timer(burst_counter < burst_power)
		
		if burst_counter >= burst_power:
			burst_counter = 0
			is_in_burst = false
	else:
		reset_timer(true, true)

func shoot_bullet(rotation_offset : float):
	var vector = Vector2.RIGHT.rotated(rotation + rotation_offset).normalized() * factor_noise(pressure, pressure_noise)
	var new_bullet : EnemyBullet = bullet.instance()
	
	new_bullet.position = global_position
	new_bullet.vector = vector
	new_bullet.rotation = rotation
	get_parent().get_parent().add_child(new_bullet)

func factor_noise(value : float, noise : float):
	return value * pow(1 + noise, rand_range(-1, 1))

func add_noise(value : float, noise : float):
	return value + rand_range(-noise, noise)

func reset_timer(is_burst : bool, force_reset_timer : bool = false):
	# you shouldnt force reset timer unless needed
	# decrementing the timer by the end value is usually preferrable,
	# as it makes timer more accurate at different framerates
	shoot_timer -= shoot_timer if force_reset_timer else shoot_timer_end
	
	shoot_timer_end = factor_noise(1/max(0.0001, burst_rate), burst_noise) if is_burst\
				else factor_noise(1/max(0.0001, clock_rate), clock_noise)
