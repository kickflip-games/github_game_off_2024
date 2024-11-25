extends Grounded

signal attack

func enter(previous_state_path: String, data := {}) -> void:
	attack.emit()



func _on_animated_sprite_2d_animation_looped() -> void:
	if player.animation_sprite.animation == "attack":
		player.attack()
		finished.emit(IDLE)
