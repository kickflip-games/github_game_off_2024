class_name PlayerState extends State

const GROUNDED = "Grounded"
const AIRBORNE = "Airborne"
const GRAPPLING = "Grappling"
const HOOKED = "Grappling/Hooked"

const IDLE = "Grounded/Idle"
const MOVING = "Grounded/Moving"
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
