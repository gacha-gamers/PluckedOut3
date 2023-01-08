extends Control

export var time_idle_till_warning = 5
export var lore_data = [
	"""What's that sound?
	Footsteps?""",
	"""Has the harvesting season arrived already?""",
	"""Impossible! It must have come sooner this year!""",
	"I must warn my friends!",
]
var index = 0
var screen_has_text = false 
var no_action_timer = 0

func _ready() -> void:
	$Label.text = lore_data[index]
	$AnimationPlayer.play_backwards('fadeout')


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	screen_has_text = not screen_has_text
	
	if not screen_has_text:
		index += 1
		if index == len(lore_data):
			FadeTransition.change_scene("res://Level/Level.tscn")
			return
		else:
			$Label.text = lore_data[index]
			
		$AnimationPlayer.play_backwards('fadeout')

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and screen_has_text:
		$AnimationPlayer.play('fadeout')
		$PressSpace.visible = false
		no_action_timer = 0

func _process(delta: float) -> void:
	if screen_has_text:
		no_action_timer += delta
	
	if no_action_timer >= time_idle_till_warning:
		$PressSpace.visible = true
