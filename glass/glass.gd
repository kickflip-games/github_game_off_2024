extends RigidBody2D

var glass_particles = preload("res://glass/glass_FX.tscn")

func _ready():
	# Make sure we can detect collisions
	contact_monitor = true
	max_contacts_reported = 1
	freeze = true  # Keep the glass static until hit

func _on_Glass_body_entered(body):
	if body.is_in_group("player"):
		# Instantiate particle effect
		var particles = glass_particles.instance()
		particles.position = position
		get_parent().add_child(particles)
		particles.emitting = true
		
		# Make the glass invisible
		$Sprite2D.visible = false
		
		# Disable collision
		$CollisionShape2D.disabled = true
		
		# Queue for deletion after particles finish
		await get_tree().create_timer(1.0).timeout
		queue_free()
