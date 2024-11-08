extends Airborne
# jumping



func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = -player.JUMP_FORCE
	#player.animation_player.play("jump")



## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	super(_delta)
	if player.velocity.y >= 0:
		finished.emit(FALLING)
