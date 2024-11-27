extends EnemyState

@onready var timer:Timer = $ShootTimer

var can_shoot:bool 

func shoot_bullet() -> void:
	if enemy.bullet_scene:
		can_shoot = false
		var bullet_instance = enemy.bullet_scene.instantiate() as Node2D
		enemy.get_parent().add_child(bullet_instance)
		bullet_instance.position = enemy.global_position
		bullet_instance.direction = Vector2.RIGHT if enemy.direction > 0 else Vector2.LEFT


func _on_shoot_timer_timeout():
	can_shoot = true
	# after timer alert everyone
	get_tree().call_group("Enemy", "enter_alert_mode")


func enter(previous_state_path: String, data := {}) -> void:
	timer.start()
	if enemy.isAlerted:
		can_shoot = true
	else: # first time entering alert state
		Slowmo.start()
		

func update(_delta: float) -> void:
	enemy.update_view_cone()
	if not enemy.player_is_visible():
		finished.emit(IDLE)
		enemy.exit_alert_mode()

	if can_shoot:
		shoot_bullet()
		
	if enemy.isDead:
		finished.emit(DEATH)
		enemy.exit_alert_mode()
	
func exit() -> void:
	timer.stop()
