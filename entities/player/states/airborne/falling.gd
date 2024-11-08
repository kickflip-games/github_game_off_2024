extends Airborne	
# falling


## Called by the state machine on the engine's main loop tick.
func physics_update(_delta: float) -> void:
	super(_delta)
	if player.is_on_floor():
		finished.emit(IDLE)


	
