class_name LivingEntity
extends Area2D

signal entity_hurt
signal entity_healed
signal entity_death
signal entity_free

export var health : int = 10
export var invincibility_duration : float = 1
export var is_hostile : bool = true
export var death_size_multiplier = 3
export var game_ends_when_killed = true

onready var tween = $GetBigger
onready var maximum_health = health

var invincibility_timer = 0

func _ready():
	connect("area_entered", self, "_on_area_entered")

func _process(delta):
	if invincibility_timer > 0:
		invincibility_timer -= delta

func _on_area_entered(area):
	if invincibility_timer > 0 or not area is Attack: return
	
	var attack = area as Attack
	if attack.is_hostile != is_hostile:
		hurt(area.damage)
		attack.on_hit()

func hurt(damage : int):
	if is_dying: return
	
	health = clamp(health - damage, 0, maximum_health)
	invincibility_timer = invincibility_duration
	emit_signal("entity_hurt")
	
	if health <= 0:
		die()

func heal(heal : int):
	health = clamp(health + heal, 0, maximum_health)
	emit_signal("entity_healed")

var is_dying = false
func die():
	if is_dying: return
	else: is_dying = true
	if game_ends_when_killed: get_tree().paused = true
	
	var parent = get_parent()
	# parent.animations.playing = false
	
	var animation_duration
	if game_ends_when_killed: animation_duration = 2
	else: animation_duration = 1
	tween.interpolate_property(
			parent,
			"scale",
			parent.scale,
			parent.scale * death_size_multiplier,
			animation_duration,
			Tween.TRANS_BOUNCE,
			Tween.EASE_IN_OUT
	)
	tween.start()
	emit_signal("entity_death")

func _on_GetBigger_tween_all_completed():
	if game_ends_when_killed: FadeTransition.change_scene("res://Menu/Menu.tscn")
	emit_signal("entity_free")
	get_parent().queue_free()

