class_name EnemyState extends State

const IDLE = "Idle"
const ALERTED = "Alerted"
const PATROL = "Patrol"
const DEATH = "Death"
const RANDOMPATROL = "RandomPatrol"

var enemy: Enemy


func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	assert(
		enemy != null, 
		"The Enemy state type must be used only in the enemy scene. 
		It needs the owner to be a Enemy node."
		)
