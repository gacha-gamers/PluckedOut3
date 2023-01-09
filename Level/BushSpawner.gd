extends Node2D

export var dirt_tilemap_path : NodePath
export var fence_tilemap_path : NodePath

export var bush_scene : PackedScene
export var spawn_interval = 1.0
export var map_size = Vector2(1536, 1536)

onready var dirt_tilemap : TileMap = get_node_or_null(dirt_tilemap_path)
onready var fence_tilemap : TileMap = get_node_or_null(fence_tilemap_path)

var spawn_timer = 0

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer -= spawn_interval
		spawn_bush()

func spawn_bush():
	var spawn_pos = Vector2.ZERO
	while true:
		spawn_pos = (Vector2(randf(), randf()) * 2 - Vector2.ONE) * map_size
		if (not dirt_tilemap or dirt_tilemap.get_cellv(dirt_tilemap.world_to_map(spawn_pos / dirt_tilemap.scale)) == TileMap.INVALID_CELL)\
			and (not fence_tilemap or fence_tilemap.get_cellv(fence_tilemap.world_to_map(spawn_pos / fence_tilemap.scale)) == TileMap.INVALID_CELL):
			break
	
	var new_bush = bush_scene.instance()
	new_bush.position = spawn_pos
	add_child(new_bush)
