extends CanvasLayer

func _ready():
	GlobalScript.set_process(false)

func _on_Exit_pressed():
	get_tree().quit()

func _on_Menu_pressed():
	FadeTransition.change_scene("res://Menu/Menu.tscn")

func _button_mouse_entered() -> void:
	$Control/MenuSound.play()
