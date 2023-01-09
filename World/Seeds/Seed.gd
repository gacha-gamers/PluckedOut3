extends Node2D

enum Item { SEEDS, WHEAT, HEART, SLIMEBALL }

export var distance_low = -100
export var distance_high = 100
export var not_grabbable_time = 0.75
export(Item) var item_type

var player_in = false
var grabbable = false

func _on_Area2D_body_entered(_body: Node) -> void:
	player_in = true

func _on_Area2D_body_exited(_body: Node) -> void:
	player_in = false

func _ready() -> void:
	position = GlobalScript.player.position
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(
		self,
		"position:x",
		get_random_float(distance_high, distance_low),
		not_grabbable_time
	).set_trans(Tween.TRANS_LINEAR).as_relative()
	
	var other_tween = create_tween()
	other_tween.tween_property(
		self,
		"position:y",
		-50.0,
		not_grabbable_time / 2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT).as_relative()
	other_tween.tween_property(
		self,
		"position:y",
		50.0,
		not_grabbable_time
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT).as_relative()
	
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
		match item_type:
			Item.SEEDS:
				GlobalScript.seeds_count += 1
			Item.WHEAT:
				GlobalScript.wheat_count += 1
			Item.HEART:
				GlobalScript.player.get_node("LivingEntity").heal(1)
			Item.SLIMEBALL:
				GlobalScript.slimeball_count += 1
		
		var pickup_sound = $PickupSound
		remove_child(pickup_sound)
		get_parent().add_child(pickup_sound)
		pickup_sound.play()
		
		self.queue_free()

func _process(_delta: float) -> void:
	grab_check()

func make_seed():
	item_type = Item.SEEDS
	$Seed.visible = true

func make_wheat():
	item_type = Item.WHEAT
	$Wheat.visible = true

func make_heart():
	item_type = Item.HEART
	$Heart.visible = true

func make_slimeball():
	item_type = Item.SLIMEBALL
	$Slimeball.visible = true
