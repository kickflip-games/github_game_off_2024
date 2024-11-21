extends AnimatedSprite2D



func _on_idle_idle() -> void:
	self.play("idle")



func _on_walking_walking() -> void:
	self.play("run")
