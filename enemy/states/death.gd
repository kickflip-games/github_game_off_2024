extends EnemyState


@onready var timer:Timer = $DeathTimer


func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(previous_state_path: String, data := {}) -> void:
	timer.start()
	enemy.animation.modulate = Color.BLACK

func exit() -> void:
	pass


func _on_death_timer_timeout():
	enemy.queue_free()
