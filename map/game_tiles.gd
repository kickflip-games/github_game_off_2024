extends TileMapLayer


var hover_tile_data:TileData = null

# This is set withing the TileSet resource
const IS_GRAPPLE_POINT_FLAG = "grapple_point" 

var __hovering_on_grapple_point:bool:
	get: 
		if hover_tile_data and hover_tile_data.get_custom_data(IS_GRAPPLE_POINT_FLAG):
			return true
		return false


func get_hover_tile_data()->TileData:
	var mouse_pos:Vector2 = get_global_mouse_position()
	var tile_pos:Vector2 = local_to_map(mouse_pos)
	return get_cell_tile_data(tile_pos)

func _process(delta):	
	hover_tile_data = get_hover_tile_data()
	if __hovering_on_grapple_point:
		Cursor.shape = Cursor.Shapes.CURSOR_TARGET
	else:
		Cursor.shape = Cursor.Shapes.CURSOR_POINTER
