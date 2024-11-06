extends Area2D


@onready var timer: Timer = $Timer



func _on_body_entered(body: Node2D) -> void:
	print("ur dead lmao !")
	Engine.time_scale = 0.5 # slow time for dramatic effect
	body.get_node("CollisionShape2D").queue_free()
	# when player dies, falls through ground
	timer.start()
	


func _on_timer_timeout() -> void:
	Engine.time_scale = 1 # reset time scale
	get_tree().reload_current_scene()
