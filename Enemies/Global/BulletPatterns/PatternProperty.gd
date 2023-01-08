extends HBoxContainer

signal value_changed(value)

func initialize(title : String, value, integer : bool):
	self.name = title
	$Label.text = title.capitalize()
	$HSlider.value = value
	$Value.text = str(value)
	
	if value is bool:
		$CheckBox.pressed = value
		$CheckBox.show()
		$HSlider.hide()
		$Value.hide()
	
	$HSlider.rounded = integer

func set_range(start, end):
	$HSlider.min_value = start
	$HSlider.max_value = end

func _on_value_changed(value):
	emit_signal("value_changed", value)
	$Value.text = str(value)
