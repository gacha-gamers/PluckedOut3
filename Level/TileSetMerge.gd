tool
extends TileSet


func _is_tile_bound(drawn_id, _neighbor_id):
	return drawn_id in get_tiles_ids()
