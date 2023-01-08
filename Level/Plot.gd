extends Area2D

export var crop_scene: PackedScene

var has_crop : bool = false

func _on_input_event(viewport, event : InputEvent, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		plant()

func plant():
	if not has_crop and GlobalScript.seeds_count:
		GlobalScript.seeds_count -= 1
		var crop = crop_scene.instance()
		add_child(crop)
		has_crop = true
		
		crop.connect("harvested", self, "_on_harvested")

func _on_harvested():
	has_crop = false
