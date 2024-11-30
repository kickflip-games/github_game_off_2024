extends Grounded
# walkinng

signal walking

func enter(previous_state_path: String, data := {}) -> void:
	walking.emit()


## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	super(_delta)
	
	var input_direction_x := Input.get_axis("move_left", "move_right")

	
	#player.velocity.x = input_direction_x * player.MOVE_SPEED
	#player.velocity.x *= player.FRICTION_GROUND
	#player.velocity.y += player.GRAVITY
	
	# trying to fix the jittering
	player.velocity.x = lerp(player.velocity.x, input_direction_x * player.MOVE_SPEED,0.4)
	
	#player.velocity = player.velocity.limit_length(player.MAX_SPEED)
	player.move_and_slide()
	
	if abs(player.velocity.x) < 0.1 and player.is_on_floor():
		finished.emit(IDLE)
	#if player.velocity.x == 0:
		#finished.emit(IDLE) 
		
