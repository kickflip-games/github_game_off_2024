class_name PlayerState extends State

const GRAPPLING = "Grappling"
const GRAPPLED = "Grappling/Grappled"
const HOOKED = "Grappling/Hooked"
const SWINGING = "Grappling/Swinging"
const GRAPPLE_STATES = [GRAPPLING, HOOKED, SWINGING,GRAPPLED]

const GROUNDED = "Grounded"
const IDLE = "Grounded/Idle"
const WALKING = "Grounded/Walking"
const GROUNDED_STATES = [GROUNDED, IDLE, WALKING]

const AIRBORNE = "Airborne"
const JUMPING = "Airborne/Jumping"
const FALLING = "Airborne/Falling"
const AIRBORNE_STATES = [AIRBORNE,JUMPING, FALLING]

const ATTACKING = "Attacking"
const DEAD = "Dead"

#TODO: add these other states?
#const DANCING = "Dancing"
#const STUNNED = "Stunned"
#const INJURED = "Injured" # or hit?


var player: Player




func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(
		player != null, 
		"The Player state type must be used only in the player scene. 
		It needs the owner to be a Player node."
		)
