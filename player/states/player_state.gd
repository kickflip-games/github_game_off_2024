class_name PlayerState extends State

const GROUNDED = "Grounded"
const AIRBORNE = "Airborne"
const GRAPPLING = "Grappling"
const HOOKED = "Hooked"


var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(
		player != null, 
		"The Player state type must be used only in the player scene. 
		It needs the owner to be a Player node."
		)



### Some helpers
	
func attack_input_pressed(_event: InputEvent)->bool:
	if _event is InputEventMouseButton and _event.pressed and player.enemies_are_nearby:
		return true
	return false

func get_grapple_input_point(_event: InputEvent)->Vector2:
	var point: Vector2 = Vector2.ZERO
	if _event is InputEventMouseButton and _event.pressed and !player.enemies_are_nearby:
		print("Mouse click")
		point = _event.position - get_viewport().get_visible_rect().size * 0.5
	return point


func mouse_released(_event:InputEvent)->bool:
	if _event is InputEventMouseButton and not _event.pressed:
		return true
	return false
