extends Area2D

@onready var glass_sprite:Sprite2D = $Sprite2D
@onready var glass_fx:CPUParticles2D = $GlassFx

func _on_body_entered(body):
		glass_sprite.visible = false
		glass_fx.emitting = true
		queue_free()
		
