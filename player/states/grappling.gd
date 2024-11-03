extends PlayerState
# Grappling


# TODO: if reaches the end of the grapplign hook, then move to 'HOOKED' state 
# (player is attached to end of grapplingn hook)

var chain_velocity: Vector2 = Vector2.ZERO

var chain_direction:Vector2:
	get: 
		return (player.global_position - player.chain.tip).normalized()



func handle_input(_event: InputEvent) -> void:
	if mouse_released(_event):
		finished.emit(AIRBORNE)


## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	
	
	
	chain_velocity =  chain_direction * -player.CHAIN_PULL
	chain_velocity.y *= 0.55 if chain_velocity.y > 0.0 else 1.65
	if sign(chain_velocity.x) != sign(player.velocity.x):
		chain_velocity.x *= 0.7
	player.velocity += chain_velocity
	
	player.velocity = player.velocity.limit_length(player.MAX_SPEED)
	player.move_and_slide()

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	var point:Vector2 = data.get('point')
	chain_velocity = Vector2.ZERO
	player.chain.shoot(point)

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	player.chain.release()
