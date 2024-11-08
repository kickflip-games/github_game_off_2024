extends Grappling



## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	var direction:Vector2 = data.get('direction')
	chain_velocity = Vector2.ZERO
	player.chain.shoot(direction)
