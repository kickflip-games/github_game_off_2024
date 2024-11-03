extends PlayerState
# Grounded state



func handle_input(_event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("MOUSSSEE")
	
	if _event.is_action_pressed("jump"):
		finished.emit(AIRBORNE, { "jump_pressed":true})
	if attack_input_pressed(_event):
		player.attack()
	var grapple_point:Vector2 = get_grapple_input_point(_event)
	if grapple_point.length() > player.MIN_GRAPPLE_DIST:
		finished.emit(GRAPPLING, {"point":grapple_point})

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	if !player.is_on_floor():
		finished.emit(AIRBORNE)

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	player.velocity.x = input_direction_x * player.MOVE_SPEED
	player.velocity.x *= player.FRICTION_GROUND
	player.velocity.y += player.GRAVITY
	
	player.velocity = player.velocity.limit_length(player.MAX_SPEED)
	player.move_and_slide()



## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
