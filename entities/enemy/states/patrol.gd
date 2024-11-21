extends EnemyState




## SEE 
# https://www.youtube.com/watch?v=tHrT4KoDZ_Y

var current_point_index: int = 0    # Index of the current target point
var target_point: Vector2             # Current target point to move towards
@onready var ray_floor: RayCast2D = $"../../RayFloor" #raycast detecting if floor exist
var move_direction : Vector2 	#initialize random patrol direction
var wander_time : float # initialize random time of patrol before changing direction

const X0 := 0.01
const X1 := 0.99 

signal walk

var dx:float
var dxx:float 

func randomize_wander(): # randomize direction and time when patrolling
	move_direction = Vector2(randf_range(-1,1),0).normalized()
	wander_time = randf_range(1,5)

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
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()
	queue_redraw()

func physics_update(_delta: float) -> void:
	if enemy.Behavior == enemy.Choices.Along_Path:
		move_along_path(_delta)
	if enemy.Behavior == enemy.Choices.Random:
		move_random(_delta)

func move_along_path(_delta: float) -> void:
	if enemy.Behavior == enemy.Choices.Random:
		return  # Skip updating progress if the behavior is Random
	# Update the offset based on speed and direction
	progress +=  dx * _delta * 0.1	
	if enemy.facing_right and X1<=progress:
		print("finished moving right -- switching to idle ")
		finished.emit(IDLE)
	elif !enemy.facing_right and progress<=X0:
		print("finished moving left -- switching to idle ")
		finished.emit(IDLE)
		
func move_random(_delta: float) -> void:
	
	 # Update the velocity based on the current move direction
	enemy.velocity = move_direction * enemy.walk_speed
	
 	# Apply the velocity to the enemy's position
	enemy.position += enemy.velocity * _delta

	# Check if the raycast detects no floor ahead
	if not ray_floor.is_colliding():
		# Reverse the direction to prevent falling
		move_direction = -move_direction
		enemy.velocity.x = -enemy.velocity.x
		enemy.flip_direction()
	
	
	if enemy.velocity.x == 0:
		print("finished random patrol -- switching to idle")
		finished.emit(IDLE)

func enter(previous_state_path: String, data := {}) -> void:
	print("entering patrolling from ", previous_state_path, " + moving in ", enemy.direction)
	randomize_wander() # initiate randomness
	dx = enemy.direction * enemy.walk_speed 	
	print("random direction :", move_direction)
	print("wander time :", wander_time)
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
