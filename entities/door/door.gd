extends StaticBody2D


func _ready() -> void:
	$Open_Door_Sprite2D.visible=false
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	$Open_Door_Sprite2D.visible = true
	$Closed_Door_Sprite2D.visible = false
	
	$CollisionShape2D.set_deferred("disabled",true)
	
