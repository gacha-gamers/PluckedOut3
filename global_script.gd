extends Node

var player: Player
var seeds_count = 0
var wheat_count = 0
var slimeball_count = 0

var timer = 0.0

func _process(delta):
	timer += delta
