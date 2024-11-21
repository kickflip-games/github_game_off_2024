extends Grounded
# Idle

signal idle

func enter(previous_state_path: String, data := {}) -> void:
	idle.emit()

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	super(_delta)
	var input_direction_x := Input.get_axis("move_left", "move_right")
	
	if input_direction_x!=0:
		finished.emit(WALKING)
