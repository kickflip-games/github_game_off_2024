extends RigidBody2D

var glass_particles = preload("res://glass/glass_FX.tscn")
var fx_instance =glass_particles.instantiate()

func _ready():
	print("player test")
	pass
	
func on_collision() -> void:
	print("player collided")
	Sprite2D.visible = false
	add_child(fx_instance)
	glass_particles.can_instantiate()
	queue_free()
