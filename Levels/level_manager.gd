# LevelManager.gd
extends Node

var level_paths = []
var current_level_index = 0

func _ready():
	load_levels()  
	#if level_paths.size() > 0:
		#load_level(current_level_index) 


func load_levels():
	var dir = DirAccess.open("res://Levels")
	if dir == null:
		push_error("Error: Unable to open directory.")
		return
		
	# Ensure the directory can be read
	if not dir.dir_exists("res://Levels"):
		push_error("Error: Directory res://Levels does not exist.")
		return

	level_paths.clear()

	var file_names:PackedStringArray = dir.get_files()
	for file_name in file_names:
		if file_name.begins_with("level_") and file_name.ends_with(".tscn"):
			level_paths.append("res://Levels/" + file_name)

	# Sort the levels
	#level_paths.sort_custom(_compare_two_lvls)
	print("Loaded levels:", level_paths)
	if len(level_paths)<2:
		push_error("Very few levels loaded... ", level_paths)


func _compare_two_lvls(a,b):
	return _lvl_num(a) < _lvl_num(b)


func _lvl_num(fp) -> int:
	return int(fp.get_basename().get_slicec("_", 1))


func load_level(index):
	if index < 0 or index >= level_paths.size():
		return  # Out of bounds, do nothing
	current_level_index = index
	SceneManager.change_scene(level_paths[index])

func load_next_level():
	if current_level_index + 1 < level_paths.size():
		current_level_index += 1
		load_level(current_level_index)
	else:
		print("All levels completed!")  # Handle end of game here
