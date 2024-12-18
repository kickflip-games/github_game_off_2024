extends Node

var DEBUG_MODE:bool = true
var ON_MOBILE:bool 


@onready var debug_font:Font = ThemeDB.fallback_font



func GameOver():
	print("Game over")
	SceneManager.reload_scene()


func NextLevel():
	LevelManager.load_next_level()



func _input(event):
	if Input.is_action_just_pressed("debug"):
		DEBUG_MODE = !DEBUG_MODE
		_set_debug_menu()
		

func _ready():
	ON_MOBILE = OS.has_feature("web_android") or OS.has_feature("web_ios")
	_set_debug_menu()
	await SceneManager.scene_loaded
	DebugMenu.update_information_label()
	DebugMenu.update_settings_label()

func _set_debug_menu():
	if DEBUG_MODE:
		DebugMenu.visible = true
		DebugMenu.style = DebugMenu.Style.MAX
	else:
		DebugMenu.visible = false
		


func get_player()->Player:
	return get_tree().get_first_node_in_group("Player")

func get_enemies()->Array[Node]:
	return get_tree().get_nodes_in_group("Enemy")
	
