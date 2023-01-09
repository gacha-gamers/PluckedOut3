extends AnimatedSprite

signal harvested

export var seeds_dropped = 1
export var seed_scene: PackedScene

var player_in = false

func _ready() -> void:
	self.scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(
		self,
		"scale",
		Vector2(3, 3),
		1
	)
	
func _on_Area2D_body_entered(_body: Node) -> void:
	player_in = true

func _on_Area2D_body_exited(_body: Node) -> void:
	player_in = false

export var time_till_growth = 1
export var stages = 3

var timer = 0
var stage = 0
var harvestable = false
var harvested = false

func _process(delta: float) -> void:
	timer(delta)
	harvest()

func timer(delta):
	if harvestable:
		return

	timer += delta
	
	if timer < time_till_growth:
		return

	timer = 0
	stage += 1

	if stage == stages - 1:
		harvestable = true
		$ready.visible = true
		$ready.play('default')
	self.frame = stage

func harvest():
	if !harvestable or harvested:
		return
	
	if GlobalScript.player.is_dashing() and player_in:
		harvested = true
		for _a in range(seeds_dropped):
			var seeds = seed_scene.instance()
			seeds.make_wheat()
			get_tree().get_root().add_child(seeds)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(
			self,
			"scale",
			Vector2(0, 0),
			.1
		)
		
		GlobalScript.player.reset_dash_cooldown()
		
		emit_signal("harvested")
		tween.tween_callback(self, "despawn")

func despawn():
	self.queue_free()
