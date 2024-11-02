extends RigidBody2D

var glass_particles = preload("res://glass/glass_FX.tscn")

func _ready():
	# Setup collision detection
	contact_monitor = true
	max_contacts_reported = 1
	freeze = true  # Keep glass static until hit

func _on_body_entered(body):
	if body.is_in_group("player"):
		
