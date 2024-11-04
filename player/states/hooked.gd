extends PlayerState
# Hooked




func handle_input(_event: InputEvent) -> void:
	if player.mouse_released(_event):
		release_chain_and_transition_state()



func physics_update(_delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_direction.length() > 0:
		finished.emit(GRAPPLING,{"direction": input_direction})
	
	#TODO: Continue hooked physics
	
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	#var chain_velocity:Vector2 = data.get('chain_velocity')
	pass
