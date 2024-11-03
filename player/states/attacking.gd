extends PlayerState



func handle_input(_event: InputEvent) -> void:
	if _event is InputEventMouseButton and _event.pressed:
		attack()
	if _event is InputEventAction and _event.is_action_pressed("jump"):
		finished.emit(JUMPING)



## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass


# Attack all nearby enemies with knockback
# TODO: add a coldown for attack? i guess i shouldnbt be able to spam..
func attack() -> void:
	for enemy in player.nearby_enemies:
		if enemy:
			var knockback_force = 3000
			var direction = (enemy.global_position - player.global_position).normalized()
			enemy.take_damage(direction * knockback_force)
