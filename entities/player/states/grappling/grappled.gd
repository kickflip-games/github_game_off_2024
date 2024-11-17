extends Grappling



func physics_update(delta: float) -> void:
	var d:float = distance_to_tip
	
	chain_velocity =  chain_direction * -player.CHAIN_PULL
	chain_velocity.y *= 0.55 if chain_velocity.y > 0.0 else 1.65
	
	# release if too far from hook
	if d > player.MAX_HOOK_DISTANCE:
		release_chain_and_transition_state()
		return 
		
	# speed is damped if grapple from very far, and accelerates when closer
	elif d > player.MAX_HOOK_DISTANCE /2 and d < player.MAX_HOOK_DISTANCE:
		var damping_factor = (player.MAX_HOOK_DISTANCE - d) / (player.MAX_HOOK_DISTANCE /2)
		chain_velocity *= damping_factor
	
	elif d <= player.AT_HOOK_TIP_DISTANCE:
		finished.emit(HOOKED)
	
	update_player_velocity()

### Called by the state machine upon changing the active state. The `data` parameter
### is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	#print("Grapped from " + previous_state_path + " state")
	pass
