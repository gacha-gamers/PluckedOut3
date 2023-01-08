extends Node2D

var player_in = false

func _on_Area2D_body_entered(body: Node) -> void:
	player_in = true

func _on_Area2D_body_exited(body: Node) -> void:
	player_in = false

func _process(delta: float) -> void:
	if player_in and GlobalScript.player.is_dashing():
		$Area2D.monitoring = false
		$Area2D.monitorable = false
