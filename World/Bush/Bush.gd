extends Node2D

var player_in = false
export var seed_scene: PackedScene
export var seeds_per_bush = Vector2(1, 3)

func _ready():
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO).set_trans(Tween.TRANS_BOUNCE)

func _on_Area2D_body_entered(_body: Node) -> void:
	player_in = true

func _on_Area2D_body_exited(_body: Node) -> void:
	player_in = false

func _process(_delta: float) -> void:
	if player_in and GlobalScript.player.is_dashing():
		harvest()

func harvest():
	for _a in range(int(rand_range(seeds_per_bush.x, seeds_per_bush.y + 1))):
		var seeds = seed_scene.instance()
		seeds.make_seed()
		get_tree().get_root().add_child(seeds)
	
	var heart = seed_scene.instance()
	heart.make_heart()
	get_tree().get_root().add_child(heart)
		
	GlobalScript.player.reset_dash_cooldown()
	
	self.queue_free()
