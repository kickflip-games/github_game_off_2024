extends CPUParticles2D

func _ready():
	# Start emitting
	emitting = true
	one_shot = true
	
	# Delete after particles finish
	await get_tree().create_timer(2.0).timeout
	queue_free()
