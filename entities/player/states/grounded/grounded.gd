class_name Grounded extends PlayerState
# Grounded state



func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finished.emit(JUMPING)
	if player.attack_input_pressed(_event):
		player.attack()
	var grapple_vector:Vector2 = player.get_grapple_input_vector(_event)
	
	# Shoot grapples
	if grapple_vector.length() > player.MIN_GRAPPLE_DIST and grapple_vector.length() < player.MAX_HOOK_DISTANCE:
		finished.emit(GRAPPLING, {"direction":grapple_vector})

## Called by the state machine on the engine's main loop tick.
func physics_update(_delta: float) -> void:
	if !player.is_on_floor():
		finished.emit(FALLING)
