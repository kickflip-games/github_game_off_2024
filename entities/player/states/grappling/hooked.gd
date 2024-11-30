extends Grappling
# Hooked


func handle_input(_event: InputEvent) -> void:
	input_direction = Input.get_vector("move_left", "move_right", "jump", "move_down")

	if Input.is_action_just_pressed("jump") or player.mouse_released(_event):
		var is_jumping = Input.is_action_just_pressed("jump")
		release_chain_and_transition_state(is_jumping)

func physics_update(delta: float) -> void:
	pass
#
#
	#player.velocity *= 0.1 # Damping factor
			#
#
	#update_player_velocity()
	
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	pass
