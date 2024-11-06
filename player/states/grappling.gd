class_name Grappling extends PlayerState
# Grappling


var chain_velocity: Vector2 = Vector2.ZERO

var chain_direction:Vector2:
	get: 
		return (player.global_position - player.chain.tip).normalized()


var distance_to_tip:float:
	get: return player.global_position.distance_to(player.chain.tip)


func handle_input(_event: InputEvent) -> void:
	if player.mouse_released(_event):
		release_chain_and_transition_state()


# Put this func here so other sub states can inherit (grappling, hooked, stunned?)
func release_chain_and_transition_state():
	player.chain.release()
	if player.is_on_floor():
		finished.emit(GROUNDED)
	else:
		finished.emit(AIRBORNE)


## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	var input_direction := Input.get_vector("move_left", "move_right", "jump", "move_down")
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
		# Dampen only if not wanting to swing
		if input_direction.length() ==0:
			player.velocity *= 0.3
			
			# goes into hooked state when immobile
			if player.velocity.length() <= 5:
				finished.emit(HOOKED) 
	
	# swing mechanics
	if input_direction.length() !=0:
		player.velocity.x += sign(input_direction.x) * player.SWING_FORCE
		player.velocity.y += sign(input_direction.y) * player.SWING_FORCE / 5

	# update the speed of player
	if player.chain.hooked:
		player.velocity += chain_velocity
		player.velocity = player.velocity.limit_length(player.MAX_SPEED)
		player.move_and_slide()
	


## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	var direction:Vector2 = data.get('direction')
	chain_velocity = Vector2.ZERO
	player.chain.shoot(direction)
