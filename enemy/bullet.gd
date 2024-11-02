extends Area2D

@export var speed: float = 500.0  # Speed of the bullet
@export var direction: Vector2 = Vector2.RIGHT  # Direction to shoot the bullet
@export var lifetime: float = 2.0  # Seconds before the bullet is destroyed
@onready var timer:Timer = $Timer


func _ready():
	timer.autostart = true
	timer.wait_time = lifetime


func _physics_process(delta: float) -> void:
	# Move the bullet
	position += direction * speed * delta



func _on_body_entered(body):
	if body.is_in_group("Player"):  # Assuming the player is added to a group named "Player"
		GameManager.GameOver()
	queue_free()  # Remove the bullet after collision


func _on_timer_timeout():
	queue_free()
