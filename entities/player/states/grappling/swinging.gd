extends Grappling

const SWING_FORCE = 50							# Force applied to swing while hooked

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	
	
	player.velocity.x += sign(input_direction.x) * SWING_FORCE
	player.velocity.y += sign(input_direction.y) * SWING_FORCE / 5
	
	update_player_velocity()

func enter(previous_state_path: String, data := {}) -> void:
	pass
