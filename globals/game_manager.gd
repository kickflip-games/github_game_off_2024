extends Node



func GameOver():
	SceneManager.reload_scene()


func NextLevel():
	print("For now we'll just reload...")
	SceneManager.reload_scene()
