extends EnemyState


## SEE 
# https://www.youtube.com/watch?v=tHrT4KoDZ_Y




var current_point_index: int = 0    # Index of the current target point
var target_point: Vector2             # Current target point to move towards
var move_direction : Vector2 	#initialize random patrol direction
var wander_time : float # initialize random time of patrol before changing direction


func randomize_wander(): # randomize direction and time when patrolling
	move_direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)


func update(_delta: float) -> void:
	if enemy.player_is_visible():
		finished.emit(ALERTED)
	if enemy.isDead:
		finished.emit(DEATH)
	if wander_time > 0 :
		wander_time -= _delta
	else:
		randomize_wander()

func physics_update(_delta: float) -> void:
	# if random patrol, then random beahavior patrol, else follow path
	move_along_path(_delta)
	
func move_along_path(_delta: float) -> void:
	# Update the offset based on speed and direction
	if enemy.direction > 0 and enemy.path_follow.progress_ratio == 0:
		finished.emit(IDLE)
	elif enemy.direction < 0 and enemy.path_follow.progress_ratio == 1:
		finished.emit(IDLE)
	else:
		var dx = move_direction.x * enemy.walk_speed * _delta
		enemy.path_follow.set_progress(enemy.path_follow.get_progress() + dx)	
	
	

func enter(previous_state_path: String, data := {}) -> void:
	print("entering patrolling from ", previous_state_path)
	

func exit() -> void:
	print("Exit patrolling")
