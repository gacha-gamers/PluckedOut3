extends CanvasLayer

const PROPERTY_SCENE = preload("res://Enemies/Global/BulletPatterns/PatternProperty.tscn")

onready var list = $Panel/PanelContainer/VBoxContainer

func _ready():
	$Panel.show()
	var pattern_properties = []
	var has_begun = false
	
	for i in get_parent().get_property_list():
		if i.name == 'target': has_begun = true
		
		if has_begun and i.type in [1, 2, 3]:
			pattern_properties.append(i)
			
			var new_pattern = PROPERTY_SCENE.instance()
			
			if i.hint == 1:
				var parts = i.hint_string.split(',', false)
				new_pattern.set_range(float(parts[0]), float(parts[1]))

			new_pattern.initialize(i.name, get_parent().get(i.name), i.type == 2)
			
			new_pattern.connect("value_changed", self, "set_property", [i.name])
			list.add_child(new_pattern)

func set_property(value, property : String):
	get_parent().set(property, value)
