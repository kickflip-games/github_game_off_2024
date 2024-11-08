extends Area2D

@onready var glass_sprite:Sprite2D = $Sprite2D
@onready var glass_FX:CPUParticles2D = $GlassFx
@onready var enter_id:int = 0

func _on_body_entered(body):
		enter_id += 1 
		if enter_id == 1:
			print("Body first time entered")
			glass_sprite.visible = false
			glass_FX.emitting = true
		
		#queue_free()
