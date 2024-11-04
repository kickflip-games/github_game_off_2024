extends EnemyState


@onready var timer:Timer = $IdleTimer


# func enter(previous_state_path: String, data := {}) -> void:
#   enemy.animation.modulate = Color.WHITE
#   enemy.velocity = Vector2.ZERO
#   timer.start(enemy.idling_time_before_flipping)
#   #enemy.animation_player.play("idle")

func enter(previous_state_path: String, data := {}) -> void:
  if enemy == null:
    enemy = get_parent() as Enemy  # or however you need to retrieve it
  if enemy:
    enemy.animation.modulate = Color.WHITE
    enemy.velocity = Vector2.ZERO
    timer.start(enemy.idling_time_before_flipping)
    # enemy.animation_player.play("idle")
  else:
    push_error("Enemy instance is not set for IdleState.")


func _on_idle_timer_timeout():
  enemy.flip_direction()
  if enemy.patrollingEnemy:
    finished.emit(PATROL)


func update(_delta: float) -> void:
  if enemy.player_is_visible():
    finished.emit(ALERTED)
  if enemy.isDead:
    finished.emit(DEATH)


func exit() -> void:
  timer.stop()