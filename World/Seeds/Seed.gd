extends Sprite

export var distance_low = -100
export var distance_high = 100
export var not_grabbable_time = 1

var player_in = false
var grabbable = false

func _on_Area2D_body_entered(body: Node) -> void:
	player_in = true

func _on_Area2D_body_exited(body: Node) -> void:
	player_in = false

func _ready() -> void:
	position = GlobalScript.player.position
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(
		self,
		"position",
		GlobalScript.player.position + Vector2(get_random_float(distance_high, distance_low), get_random_float(distance_high, distance_low)),
		not_grabbable_time
	)
	tween.tween_callback(self, "make_grabbable")
	

func get_random_float(low, high) -> int:
	var random = RandomNumberGenerator.new()
	random.randomize()
	return random.randf_range(low, high)

func make_grabbable():
	grabbable = true

func grab_check():
	if !grabbable:
		return
	
	if player_in:
		GlobalScript.seeds += 1
		self.queue_free()

func _process(delta: float) -> void:
	grab_check()
