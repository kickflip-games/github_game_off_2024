extends Grounded
# walkinng



## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	super(_delta)
	
	var input_direction_x := Input.get_axis("move_left", "move_right")

	
	player.velocity.x = input_direction_x * player.MOVE_SPEED
	player.velocity.x *= player.FRICTION_GROUND
	player.velocity.y += player.GRAVITY
	
	player.velocity = player.velocity.limit_length(player.MAX_SPEED)
	player.move_and_slide()
	
	if player.velocity.x == 0:
		finished.emit(IDLE) 
		
