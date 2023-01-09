extends StaticBody2D

export var bridge_scene : PackedScene = preload("res://World/Bridge/Bridge.tscn")
var clickable = false

var is_hovered : bool = false
var in_range : bool = false
var is_done = false

func _process(delta):
	$WheatCounter/Label.text = "%s / 30" % GlobalScript.wheat_count
	$SlimeCounter/Label.text = "%s / 30" % GlobalScript.slimeball_count
	
	$WheatCounter/Label.modulate = Color.gray if GlobalScript.wheat_count < 30 else Color.white
	$SlimeCounter/Label.modulate = Color.gray if GlobalScript.slimeball_count < 30 else Color.white
	
	clickable = GlobalScript.wheat_count >= 30 and GlobalScript.slimeball_count >= 30
	$ClickLabel.visible = clickable

	$ClickLabel.text = "right click\nto build" if clickable else "need items\nto build bridge"
	
	if is_hovered:
		in_range = global_position.distance_to(GlobalScript.player.global_position) < 128
	
	if is_hovered and in_range and not is_done:
		$Sprite.modulate = Color.gray
		$ClickLabel.show() 
	else:
		$Sprite.modulate = Color.white
		$ClickLabel.visible = clickable

func _on_AreaSelect_mouse_entered():
	is_hovered = true

func _on_AreaSelect_mouse_exited():
	is_hovered = false

func _on_AreaSelect_input_event(viewport, event, shape_idx):
	if clickable and in_range and event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		click()

func click():
	if is_done:
		return
	
	is_done = true
	
	GlobalScript.wheat_count -= 30
	GlobalScript.slimeball_count -= 30
	
	$Bridge.queue_free()
	var bridge = bridge_scene.instance()
	bridge.position = $BridgePosition.global_position
	get_tree().root.add_child(bridge)
	
	$PlaceSound.play()
	return
#	var crop = crop_scene.instance()
#	add_child(crop)
#	has_crop = true
#
#	$Label.hide()
#	$Sprite.modulate = Color.white
#	$PlantSound.play()
#	crop.connect("harvested", self, "_on_harvested")
