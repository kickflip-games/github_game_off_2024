extends Grounded

signal attack

func enter(previous_state_path: String, data := {}) -> void:
	attack.emit()
	player.isAttacking = true
	




func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_left" or anim_name == "attack_right":
		player.isAttacking = false
		finished.emit(IDLE)
		


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name == "attack_left" or anim_name == "attack_right":
		player.attack()
