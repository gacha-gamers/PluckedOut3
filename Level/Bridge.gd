extends TileMap

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "position", position, 0.5).from(position + Vector2.UP * 100).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)


func _on_body_entered(body):
	if body is Player:
		play_ending()

func play_ending():
	GlobalScript.player.play_end_animation()
	FadeTransition.change_scene("res://Level/Ending.tscn")
