class_name PlayerState extends State

const IDLE = "Idle"
const WALKING = "Walking"
const JUMPING = "Jumping"
const FALLING = "Falling"
const ATTACKING = "Attacking"
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
