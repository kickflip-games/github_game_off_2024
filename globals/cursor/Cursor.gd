extends Node2D
enum Shapes {
	CURSOR_POINTER,
	CURSOR_SWORD,
	CURSOR_TARGET,
	CUSOR_DISABLED
}

## Instead of the Input function, use this as it only shows the sprite and never the cursor


@onready var sprites = {
	Shapes.CURSOR_POINTER: $CanvasLayer/pointer,
	Shapes.CURSOR_SWORD:$CanvasLayer/sword,
	Shapes.CURSOR_TARGET: $CanvasLayer/target,
	Shapes.CUSOR_DISABLED: $CanvasLayer/disabled
}



func _ready():
	for sprite in sprites.values():
		sprite.hide()
	

var shape: int = Input.CURSOR_ARROW: 
	set(value):
		if shape <= - 1:
			shape = Input.CURSOR_ARROW
		shape = value
		var sprite:Sprite2D = sprites[shape]
		
		var hotspot = Vector2.ZERO
		match shape:
			Shapes.CURSOR_TARGET:
				hotspot = sprite.texture.get_size() * 0.5
			Shapes.CURSOR_POINTER:
				hotspot = sprite.offset
		
		Input.set_custom_mouse_cursor(
			sprite.texture,
			Input.get_current_cursor_shape(),
			hotspot,
		)

		

var on_grapple_point:bool:
	get: return shape==Shapes.CURSOR_TARGET


	

func _physics_process(delta):
	queue_redraw()



func _draw():
	draw_circle(get_global_mouse_position(), 3, Color.RED)
	
