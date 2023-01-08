extends Node2D

export var pause_menu: PackedScene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		var _pause_menu = pause_menu.instance()
		self.add_child(_pause_menu)
		_pause_menu.make_pause_menu()
