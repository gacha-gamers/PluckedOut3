class_name Menu
extends CanvasLayer

onready var title_tween = create_tween()
export var title_animation_time = 2
export var settings_animation_time = 0.3
export var settings_background_default_position = Vector2(0, -2000)
export var pause_menu_animation_time = 0.5

# Vars for when this menu appears in-game
export var is_pause_menu = false

func _ready():
	title_tween.set_loops()
	title_tween.set_trans(Tween.TRANS_CUBIC)

	title_tween.tween_property($Control/Title, "rect_size", Vector2(96, 150), title_animation_time)
	title_tween.tween_property($Control/Title, "rect_size", Vector2(96, 50), title_animation_time)
	
	$Control/SettingsBackground.rect_position = settings_background_default_position
	
	if not SaveManager.game_data["WatchLore"]:
		$Control/ButtonsVBOX/StartFB.visible = true

func _on_Exit_pressed():
	if is_pause_menu:
		FadeTransition.change_scene("res://Menu/Menu.tscn")
	else:
		get_tree().quit()


func _on_Start_pressed():
	if SaveManager.game_data["WatchLore"]:
		FadeTransition.change_scene("res://Lore/Lore.tscn")
	else:
		FadeTransition.change_scene("res://Level/Level.tscn")

var settings_visible = false
func _on_Settings_pressed():
	var settings_tween = create_tween()
	if is_pause_menu:
		settings_tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	settings_tween.set_trans(Tween.TRANS_CUBIC)
	
	if settings_visible:
		settings_tween.tween_property(
			$Control/SettingsBackground, 
			"rect_position", 
			settings_background_default_position, 
			settings_animation_time
		)
		settings_visible = false
	else:
		settings_tween.tween_property(
			$Control/SettingsBackground, 
			"rect_position", 
			Vector2(0, 0), 
			settings_animation_time
		)
		settings_visible = true

func select_window_mode(index):
	if index == 0:
		OS.window_borderless = false
		OS.window_maximized = false
		OS.window_resizable = true
		OS.window_fullscreen = false
	if index == 1:
		OS.window_borderless = true
		OS.window_maximized = true
		OS.window_fullscreen = false
	if index == 2:
		OS.window_borderless = false
		OS.window_fullscreen = true


func master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value / 100.0))
	$Control/SettingsBackground/VBoxContainer/VBoxContainer/Master/current.text = str(value)

func make_pause_menu():
	is_pause_menu = true
	$Control.rect_position = Vector2(-380, 0)
	$TextureRect.rect_position = Vector2(-2000, 0)
	$Control/ButtonsVBOX/Continue.visible = true
	$Control/ButtonsVBOX/Start.text = "Restart"
	$Control/ButtonsVBOX/Exit.text = "Exit to Main Menu"
	
	# Remove pause mode contraints
	title_tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	self.pause_mode = Node.PAUSE_MODE_PROCESS # The rest of the nodes inherit it
	
	var pmtween = create_tween()
	pmtween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
	get_tree().paused = true
	pmtween.set_trans(Tween.TRANS_CUBIC)
	pmtween.tween_property($Control, "rect_position", Vector2.ZERO, pause_menu_animation_time)	
	pmtween.parallel().tween_property($TextureRect, "rect_position", Vector2.ZERO, pause_menu_animation_time + 0.3)	


func _on_Continue_pressed() -> void:
	kill_pause_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_pause_menu:
		kill_pause_menu()

func kill_pause_menu():
	var pmtween = create_tween()
	pmtween.set_trans(Tween.TRANS_SINE)
	pmtween.tween_property($TextureRect, "rect_position", Vector2(-2000, 0), pause_menu_animation_time + 0.2)
	pmtween.parallel().tween_property($Control, "rect_position", Vector2(-380, 0), pause_menu_animation_time)
	pmtween.tween_callback(self, "tween_end_callback")

func tween_end_callback():
	get_tree().paused = false
	self.queue_free()


func _on_StartFB_pressed() -> void:
	SaveManager.game_data = SaveManager.game_data_default
	FadeTransition.change_scene("res://Lore/Lore.tscn")
