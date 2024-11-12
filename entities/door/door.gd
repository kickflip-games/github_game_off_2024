extends StaticBody2D

var is_interactible = false
var is_open = false

func _ready() -> void:
	$Open_Door_Sprite2D.visible=false
	$Timer.wait_time = $CPUParticles2D.lifetime

func _on_area_2d_body_entered(body: Node2D) -> void:
	is_interactible = true
	print("Press interact(E) to open or click to destroy")


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_interactible = false


func _input(event: InputEvent) -> void:
	if is_interactible and event.is_action_pressed("interact"):
		if is_open==true:
			close_door()
		else:
			open_door()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_interactible and event is InputEventMouseButton and event.is_pressed():
		destroy()

func destroy() -> void:
	$Open_Door_Sprite2D.visible=false
	$Closed_Door_Sprite2D.visible=false
	$CPUParticles2D.emitting = true
	$Timer.start()

func _on_timer_timeout() -> void:
	queue_free()


func open_door() -> void:
	is_open=true
	$CollisionShape2D.disabled=true
	$Open_Door_Sprite2D.visible = true
	$Closed_Door_Sprite2D.visible = false
	
func close_door() -> void:
	is_open=false
	$CollisionShape2D.disabled=false
	$Open_Door_Sprite2D.visible = false
	$Closed_Door_Sprite2D.visible = true
