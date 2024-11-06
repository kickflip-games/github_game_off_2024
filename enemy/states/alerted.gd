extends EnemyState

@onready var timer:Timer = $ShootTimer

var can_shoot:bool 

func shoot_bullet() -> void:
	if enemy.bullet_scene:
		can_shoot = false
		var bullet_instance = enemy.bullet_scene.instantiate() as Node2D
		get_parent().add_child(bullet_instance)
		bullet_instance.position = enemy.global_position
		bullet_instance.direction = Vector2.RIGHT if enemy.direction > 0 else Vector2.LEFT


func _on_shoot_timer_timeout():
	can_shoot = true


func enter(previous_state_path: String, data := {}) -> void:
	enemy.animation.modulate = Color.RED
	timer.start()

func update(_delta: float) -> void:
	if not enemy.player_is_visible():
		finished.emit(IDLE)

	if can_shoot:
		shoot_bullet()
		
	if enemy.isDead:
		finished.emit(DEATH)
	
func exit() -> void:
	timer.stop()
