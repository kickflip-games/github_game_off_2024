extends EnemyState


const FX: PackedScene = preload("res://entities/FXs/bang_fx.tscn")
signal death
@onready var timer:Timer = $DeathTimer


func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	enemy.velocity += enemy.get_gravity() * _delta
	enemy.move_and_slide()

func enter(previous_state_path: String, data := {}) -> void:
	timer.start()
	
	print("FX spawned")
	var _fx = FX.instantiate()
	_fx.global_position = enemy.global_position 
	_fx.emitting = true
	enemy.add_child(_fx)
	death.emit()

func exit() -> void:
	pass

func _on_death_timer_timeout():
	enemy.queue_free()
