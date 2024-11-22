extends EnemyState


@onready var random_timer: Timer = $RandomTimer
@onready var ray_floor: RayCast2D = $"../../RayFloor" #raycast detecting if floor exist
var move_direction : Vector2 	#initialize random patrol direction
var wander_time : float # initialize random time of patrol before changing direction

signal walk

func randomize_wander(): # randomize direction and time when patrolling
	move_direction = Vector2(randf_range(-1,1),0).normalized()
	wander_time = randf_range(2,enemy.RandomTimeforPatrol)

func update(_delta: float) -> void:
	enemy.update_view_cone()
	if enemy.player_is_visible():
		finished.emit(ALERTED)
	if enemy.isDead:
		finished.emit(DEATH)		
	queue_redraw()
		
func _physics_process(_delta: float) -> void:
	move_random(_delta)
	
func move_random(_delta: float) -> void:
		
 	# Apply the velocity to the enemy's position
	enemy.position += enemy.velocity * _delta

	# Check if the raycast detects no floor ahead
	if not ray_floor.is_colliding():
		# Reverse the direction to prevent falling
		move_direction = -move_direction
		enemy.velocity.x = -enemy.velocity.x
		enemy.flip_direction()
	
	
	print("velocity", enemy.velocity)
		
func enter(previous_state_path: String, data := {}) -> void:
	randomize_wander() # initiate randomness
	# Update the velocity based on the current move direction
	enemy.velocity = move_direction * enemy.walk_speed
	print("random direction :", move_direction)
	print("wander time :", wander_time)
	random_timer.start(wander_time)
	walk.emit()
	
	



func _on_random_timer_timeout() -> void:
	finished.emit(IDLE)
