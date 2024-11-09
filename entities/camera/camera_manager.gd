extends Node


@onready var phantom_cam:PhantomCamera2D = $PhantomCamera2D
var player:Player 


func _ready():
	await SceneManager.scene_loaded
	player = GameManager.get_player()
	if player:
		phantom_cam.follow_target = player
