extends Area2D

export var crop_scene: PackedScene

var has_crop : bool = false
var is_hovered : bool = false
var in_range : bool = false

func _process(delta):
	if is_hovered:
		in_range = global_position.distance_to(GlobalScript.player.global_position) < 128
	
	if is_hovered and in_range and not has_crop:
		$Sprite.modulate = Color.gray
		$Label.text = "Right Click" if GlobalScript.seeds_count else "No seeds"
		$Label.show()
	else:
		$Sprite.modulate = Color.white
		$Label.hide()

func _on_input_event(_viewport, event : InputEvent, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		plant()

func plant():
	if not has_crop and GlobalScript.seeds_count:
		GlobalScript.seeds_count -= 1
		var crop = crop_scene.instance()
		add_child(crop)
		has_crop = true
		
		$Label.hide()
		$Sprite.modulate = Color.white
		$PlantSound.play()
		crop.connect("harvested", self, "_on_harvested")

func _on_harvested():
	has_crop = false

func _on_mouse_entered():
	is_hovered = true

func _on_mouse_exited():
	is_hovered = false
