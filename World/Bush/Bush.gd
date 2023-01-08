extends Node2D

var player_in = false
export var seed_scene: PackedScene
export var seeds_per_bush = 1

func _on_Area2D_body_entered(body: Node) -> void:
	player_in = true

func _on_Area2D_body_exited(body: Node) -> void:
	player_in = false

func _process(delta: float) -> void:
	if player_in and GlobalScript.player.is_dashing():
		for _a in range(seeds_per_bush):
			var seeds = seed_scene.instance()
			get_tree().get_root().add_child(seeds)
		
		self.queue_free()
