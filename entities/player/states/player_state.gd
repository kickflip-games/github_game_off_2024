class_name PlayerState extends State

const GRAPPLING = "GrapplePull"
const HOOKED = "Hooked"
const GRAPPLE_STATES = [GRAPPLING, HOOKED]

const IDLE = "Idle"
const WALKING = "Walking"

const JUMPING = "Jumping"
const FALLING = "Falling"
const AIRBORNE_STATES = [JUMPING, FALLING]

const ATTACKING = "Attacking"
const DEAD = "Dead"

#TODO: add these other states?
const DANCING = "Dancing"
const STUNNED = "Stunned"
const INJURED = "Injured" # or hit?


var player: Player




func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(
		player != null, 
		"The Player state type must be used only in the player scene. 
		It needs the owner to be a Player node."
		)
