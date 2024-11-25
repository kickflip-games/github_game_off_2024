extends AnimatedSprite2D

func _on_idle_idle() -> void:
	self.play("idle")


func _on_patrol_walk() -> void:
	self.play("run")


func _on_death_death() -> void:
	self.play("death")
