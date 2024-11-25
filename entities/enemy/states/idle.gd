extends EnemyState


@onready var timer:Timer = $IdleTimer

signal idle

func enter(previous_state_path: String, data := {}) -> void:
	enemy.animation.modulate = Color.WHITE
	enemy.velocity = Vector2.ZERO
	timer.start(enemy.idling_time_before_flipping)
	idle.emit()


func _on_idle_timer_timeout():
	enemy.flip_direction()
	if enemy.patrollingEnemy :
		finished.emit(PATROL)
	if enemy.RandomPatrollingEnemy :
		finished.emit(RANDOMPATROL)


func update(_delta: float) -> void:
	enemy.update_view_cone()
	if enemy.player_is_visible():
		finished.emit(ALERTED)
	if enemy.isDead:
		finished.emit(DEATH)
		


func exit() -> void:
	timer.stop()
