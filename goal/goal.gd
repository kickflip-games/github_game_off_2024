extends Area2D



func _on_body_entered(body):
	if body is Player:
		print("Goal reached --> nnext level")
		GameManager.NextLevel()
