extends CanvasLayer

onready var animation = $AnimationPlayer

func change_scene(to_scene: String):
	get_tree().paused = true
	animation.play("start")
	yield(animation, "animation_finished")
	get_tree().change_scene(to_scene)
	animation.play_backwards("start")
	get_tree().paused = false
