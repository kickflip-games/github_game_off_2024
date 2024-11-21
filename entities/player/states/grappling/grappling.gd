class_name Grappling extends PlayerState
# Grappling


var chain_velocity: Vector2 = Vector2.ZERO
var input_direction: Vector2 = Vector2.ZERO # Input direction (based on movement keys)

var chain_direction:Vector2:
	get: return (player.global_position - player.chain.tip).normalized()

var distance_to_tip:float:
	get: return player.global_position.distance_to(player.chain.tip)



func handle_input(_event: InputEvent) -> void:
	input_direction = Input.get_vector("move_left", "move_right", "jump", "move_down")
	
	if player.mouse_released(_event):
		release_chain_and_transition_state()
	
	#else:
		#if input_direction.length() != 0 and distance_to_tip > player.AT_HOOK_TIP_DISTANCE:
			#finished.emit(SWINGING)
			

# update the speed of player
func update_player_velocity()-> void:
	if player.chain.hooked:
		player.velocity += chain_velocity
		player.velocity = player.velocity.limit_length(player.MAX_SPEED)
		player.move_and_slide()
		
		
func physics_update(delta: float) -> void:
	var d:float = distance_to_tip
	
	chain_velocity =  chain_direction * -player.CHAIN_PULL
	#chain_velocity.y *= 0.55 if chain_velocity.y > 0.0 else 1.65 # commentend bc it did some strange behaviors
	
	# release if too far from hook
	if d > player.MAX_HOOK_DISTANCE:
		release_chain_and_transition_state()
		return 
		
	# speed is damped if grapple from very far, and accelerates when closer
	if d > player.MAX_HOOK_DISTANCE /2 and d < player.MAX_HOOK_DISTANCE:
		var damping_factor = (player.MAX_HOOK_DISTANCE - d) / (player.MAX_HOOK_DISTANCE /2)
		chain_velocity *= damping_factor
	
	if d <= player.AT_HOOK_TIP_DISTANCE:
		player.velocity *= 0.3 # Damping factor
		finished.emit(HOOKED)
	
	update_player_velocity()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	print("Grappling from " + previous_state_path + " state")
	var direction:Vector2 = data.get('direction')
	chain_velocity = Vector2.ZERO
	player.chain.shoot(direction)
	

	

func release_chain_and_transition_state():
	#if name not in GRAPPLE_STATES:
		#push_error("Invalid state trying to grapple release: ", name) # Is this relevant? Instead of name=="Grappled", the grappling states are "Grappling/Grappled"
	player.chain.release()
	if player.is_on_floor():
		finished.emit(IDLE)
	else:
		finished.emit(FALLING)
