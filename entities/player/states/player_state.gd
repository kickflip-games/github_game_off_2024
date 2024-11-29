class_name PlayerState extends State

const GRAPPLING = "Grappling"
const HOOKED = "Grappling/Hooked"
#const SWINGING = "Grappling/Swinging"
const GRAPPLE_STATES = [GRAPPLING, HOOKED]

const GROUNDED = "Grounded"
const IDLE = "Grounded/Idle"
const WALKING = "Grounded/Walking"
const ATTACKING = "Grounded/Attacking"
const GROUNDED_STATES = [IDLE, WALKING, ATTACKING]

const AIRBORNE = "Airborne"
const JUMPING = "Airborne/Jumping"
const FALLING = "Airborne/Falling"
const AIRBORNE_STATES = [JUMPING, FALLING]
const DEAD = "Dead"



var player: Player




func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(
		player != null, 
		"The Player state type must be used only in the player scene. 
		It needs the owner to be a Player node."
		)
