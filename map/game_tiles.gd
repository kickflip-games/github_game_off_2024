extends TileMapLayer

var hover_tile_data:TileData = null

var hookable_point_scene = preload("res://entities/Hookable/hookable_point.tscn")
#@export var hookable_point_scene: PackedScene # DOING THIS is better but need to import the scene to each lvl

# This is set withing the TileSet resource
const IS_GRAPPLE_POINT_FLAG = "grapple_point" 

func _ready():
	place_hookable_points()
	if position!=Vector2.ZERO:
		push_error("tilemap not centerd, errors will aise.")
		
	
func place_hookable_points():
	var used_tiles = get_used_cells()  # Get all tiles used in this TileMapLayer
	for tile_coords in used_tiles:
		var tile_data: TileData = get_cell_tile_data(tile_coords)
		if tile_data and tile_data.get_custom_data(IS_GRAPPLE_POINT_FLAG):
			var world_position = map_to_local(tile_coords)
			
			var hookable_point = hookable_point_scene.instantiate()
			hookable_point.global_position = world_position
			
			add_child(hookable_point) 
				

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
