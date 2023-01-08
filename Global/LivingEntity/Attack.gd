class_name Attack
extends Area2D

export var damage : int = 1
export var is_hostile : bool = false
export var destroy_on_hit : bool = true

func on_hit():
	if destroy_on_hit:
		get_parent().queue_free()
