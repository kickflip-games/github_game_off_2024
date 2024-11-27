class_name Grounded extends PlayerState
# Grounded state



func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finished.emit(JUMPING)
	
	var grapple_vector:Vector2 = player.get_grapple_input_vector(_event)
	# Shoot grapples first
	if grapple_vector.length() > player.MIN_GRAPPLE_DIST and grapple_vector.length() < player.MAX_HOOK_DISTANCE:
		finished.emit(GRAPPLING, {"direction":grapple_vector})
	
	# Check for attack
	elif player.attack_input_pressed(_event):
		finished.emit(ATTACKING)


func _process(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")

## Called by the state machine on the engine's main loop tick.
func physics_update(_delta: float) -> void:
	if !player.is_on_floor():
		finished.emit(FALLING)
