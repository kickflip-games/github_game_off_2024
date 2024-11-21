extends EnemyState




## SEE 
# https://www.youtube.com/watch?v=tHrT4KoDZ_Y

var current_point_index: int = 0    # Index of the current target point
var target_point: Vector2             # Current target point to move towards

const X0 := 0.01
const X1 := 0.99 

signal walk

var dx:float

var progress: float:
	get: return enemy.path_follow.progress_ratio
	set(value):
		enemy.path_follow.progress_ratio = clamp(value, 0.001, 0.999)  # Clamp between 0 and 1




func update(_delta: float) -> void:
	enemy.update_view_cone()
	if enemy.player_is_visible():
		finished.emit(ALERTED)
	if enemy.isDead:
		finished.emit(DEATH)
	queue_redraw()

func physics_update(_delta: float) -> void:
	move_along_path(_delta)
	
func move_along_path(_delta: float) -> void:
	# Update the offset based on speed and direction
	progress +=  dx * _delta * 0.1	
	if enemy.facing_right and X1<=progress:
		print("finished moving right -- switching to idle ")
		finished.emit(IDLE)
	elif !enemy.facing_right and progress<=X0:
		print("finished moving left -- switching to idle ")
		finished.emit(IDLE)
		


func enter(previous_state_path: String, data := {}) -> void:
	print("entering patrolling from ", previous_state_path, " + moving in ", enemy.direction)
	dx = enemy.direction * enemy.walk_speed 	
	walk.emit()
	

func exit() -> void:
	print("Proggress is ", str(progress), " --> Exit patrolling")
	
#func _draw():
	#if GameManager.DEBUG_MODE
		#var text_position = Vector2(10, -20)
		#var text = "Progress : " + str(progress)
#
		## Draw a background box for the text (optional)
		#var rect_size = Vector2(0, 20)
		#draw_rect(Rect2(text_position, rect_size), Color(0, 0, 0, 0.5))
		## Draw the text using the default font
		#draw_string(
			#GameManager.debug_font,  # No font is specified, so the default font will be used
			#text_position + Vector2(5, 15),  # Offset to center text in box
			#text,
			#HORIZONTAL_ALIGNMENT_LEFT,
			#-1,
			#12,
			#Color.WHITE
		#)
		#
		#
