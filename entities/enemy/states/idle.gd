extends EnemyState


@onready var timer:Timer = $IdleTimer


func enter(previous_state_path: String, data := {}) -> void:
	enemy.animation.modulate = Color.WHITE
	enemy.velocity = Vector2.ZERO
	timer.start(enemy.idling_time_before_flipping)
	#enemy.animation_player.play("idle")


func _on_idle_timer_timeout():
	enemy.flip_direction()
	if enemy.patrollingEnemy or(enemy.Behavior == enemy.Choices.Random):
		finished.emit(PATROL)


func update(_delta: float) -> void:
	if enemy.player_is_visible():
		finished.emit(ALERTED)
	if enemy.isDead:
		finished.emit(DEATH)
		


func exit() -> void:
	timer.stop()
