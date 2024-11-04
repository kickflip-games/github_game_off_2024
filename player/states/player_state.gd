class_name PlayerState extends State

const GROUNDED = "Grounded"
const AIRBORNE = "Airborne"
const GRAPPLING = "Grappling"
const HOOKED = "Hooked"

#TODO: add these other states
const IDLE = "Idle"
const DANCING = "Dancing"
const STUNNED = "Stunned"
const INJURED = "Injured" # or hit?


var player: Player

# Put this func here so other states can inherit (grappling, hooked, stunned?)
func release_chain_and_transition_state():
	player.chain.release()
	if player.is_on_floor():
		finished.emit(GROUNDED)
	else:
		finished.emit(AIRBORNE)



func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(
		player != null, 
		"The Player state type must be used only in the player scene. 
		It needs the owner to be a Player node."
		)
