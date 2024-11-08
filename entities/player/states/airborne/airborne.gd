class_name Airborne extends PlayerState
# Airborne state



func handle_input(_event: InputEvent) -> void:
	if player.attack_input_pressed(_event):
		player.attack()
	var grapple_vector:Vector2 = player.get_grapple_input_vector(_event)
	if grapple_vector.length() > player.MIN_GRAPPLE_DIST:
		finished.emit(GRAPPLED, {"direction":grapple_vector})


## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = input_direction_x * player.MOVE_SPEED
	player.velocity.x *= player.FRICTION_AIR
	player.velocity.y += player.GRAVITY
	
	player.velocity = player.velocity.limit_length(player.MAX_SPEED)
	player.move_and_slide()
	
