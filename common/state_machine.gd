class_name StateMachine extends Node

@export var initial_state: State = null

@onready var state: State = null

# # Got an error of initialisation while trying to play
# @onready var state: State = (func get_initial_state() -> State:
# 	return initial_state if initial_state != null else get_child(0)
# ).call()

#func _ready() -> void:
	#for state_node: State in find_children("*", "State"):
		#state_node.finished.connect(_transition_to_next_state)
#
	#await owner.ready
	#state.enter("")

func _ready() -> void:
	state = get_initial_state()
	if state:
		state.enter("")
	else:
		push_error("State not initialised")

func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0) as State
	

func _unhandled_input(event: InputEvent) -> void:
	if state:
		state.handle_input(event)
	else:
		push_error("State is null in _unhandled_input")


func _process(delta: float) -> void:
	if state:
		state.update(delta)
	else:
		push_error("State is null in _process")


func _physics_process(delta: float) -> void:
	if state:
		state.physics_update(delta)
	else:
		push_error("State is null in _physics_process")

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
