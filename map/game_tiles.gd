extends TileMapLayer

# FIXME: close but not quite...the mapping of the cursor to the tiles arnt matching



func _process(delta):	
	var mouse_pos = get_global_mouse_position()
	var tile_pos = local_to_map(mouse_pos)
	var tile_data = get_cell_tile_data(tile_pos)
	
	# FIXME the correct tiles arnt being found.. PAIN
	
	# Check if there is tile data (i.e., if there's a tile at this position).
	if tile_data:
		Cursor.shape = Cursor.Shapes.CURSOR_TARGET
	else:
		
		Cursor.shape = Cursor.Shapes.CURSOR_POINTER
