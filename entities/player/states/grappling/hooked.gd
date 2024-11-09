extends Grappling
# Hooked




func physics_update(delta: float) -> void:
	var d:float = distance_to_tip
	
	chain_velocity =  chain_direction * -player.CHAIN_PULL
	chain_velocity.y *= 0.55 if chain_velocity.y > 0.0 else 1.65
	

	player.velocity *= 0.3 # Damping factor
			

	update_player_velocity()
	
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	pass
