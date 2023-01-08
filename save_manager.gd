extends Node

export var SAVE_FILE_PATH="user://savefile.gachagamers"
var game_data = {}
var game_data_default = {
	"FirstPlay": true,
	"Level": 0,
}

func save():
	var file = File.new()
	file.open(SAVE_FILE_PATH, File.WRITE)
	file.store_var(game_data)
	file.close()

func load_save():
	var file = File.new()
	file.open(SAVE_FILE_PATH, File.READ)
	game_data = file.get_var()
	file.close()

func _ready() -> void:
	load_save()
	if game_data == null:
		game_data = game_data_default

# On quit
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save()
