class_name StateMachine extends Node2D

@export var initial_state: State = null


@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()


@onready var _debug_font:Font = ThemeDB.fallback_font



func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)

	await owner.ready
	state.enter("")
	

	


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
	queue_redraw()


func _input(event):
	if Input.is_action_just_pressed("debug"):
		queue_redraw()




func _draw():
	if GameManager.DEBUG_MODE:
		var text_position = Vector2(10, 10)
		var text = "State: " + state.name

		# Draw a background box for the text (optional)
		var rect_size = Vector2(120, 20)
		draw_rect(Rect2(text_position, rect_size), Color(0, 0, 0, 0.5))
		# Draw the text using the default font
		draw_string(
			_debug_font,  # No font is specified, so the default font will be used
			text_position + Vector2(5, 15),  # Offset to center text in box
			text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			12,
			Color.WHITE
		)
		
		
