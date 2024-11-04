extends Node

var DEBUG_MODE:bool = true



func GameOver():
	SceneManager.reload_scene()


func NextLevel():
	print("For now we'll just reload...")
	SceneManager.reload_scene()



func _input(event):
	if Input.is_action_just_pressed("debug"):
		DEBUG_MODE = !DEBUG_MODE
		_set_debug_menu()
		

func _ready():
	_set_debug_menu()

func _set_debug_menu():
	if DEBUG_MODE:
		DebugMenu.visible = true
		DebugMenu.style = DebugMenu.Style.MAX
	else:
		DebugMenu.visible = false
	
