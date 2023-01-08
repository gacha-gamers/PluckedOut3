class_name EnemyBullet
extends Node2D

export var vector: Vector2
export var bullet_speed = 3000.0
export var time_until_deletion: int

var timer = 0.0
var is_destroyed = false

func _physics_process(delta):
	translate(vector * bullet_speed * delta)
	timer += delta
	
	if timer > time_until_deletion:
		self.queue_free()


func _on_slime_hit_timer_timeout():
	$Attack.collision_mask |= 2

func _on_body_entered(_body):
	if is_destroyed: return
	is_destroyed = true
	
	$Attack.set_deferred("monitorable", false)
	var tween = Tween.new()
	add_child(tween)
	vector *= 0.3
	tween.interpolate_property(self, "scale", scale, Vector2.ZERO, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.interpolate_callback(self, 0.5, "queue_free")
	tween.start()
