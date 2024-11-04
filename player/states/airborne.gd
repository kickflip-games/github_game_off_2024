extends PlayerState
# Airborne state



func handle_input(_event: InputEvent) -> void:
	if player.attack_input_pressed(_event):
		player.attack()
	var grapple_vector:Vector2 = player.get_grapple_input_vector(_event)
	if grapple_vector.length() > player.MIN_GRAPPLE_DIST:
		finished.emit(GRAPPLING, {"direction":grapple_vector})


## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	if player.is_on_floor():
		finished.emit(GROUNDED)

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = input_direction_x * player.MOVE_SPEED
	player.velocity.x *= player.FRICTION_AIR
	player.velocity.y += player.GRAVITY
	
	player.velocity = player.velocity.limit_length(player.MAX_SPEED)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	var jump_pressed:bool = data.get("jump_pressed", false)
	if jump_pressed:
		player.velocity.y = -player.JUMP_FORCE # godot coords are upside down (silly AF)
	# play animation
