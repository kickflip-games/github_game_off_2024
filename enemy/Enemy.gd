extends CharacterBody2D

@onready var animation := $AnimatedSprite2D
@onready var walk_timer := $Timer

enum STATE {IDLE, ATTACK, DEATH}
var current_state: STATE = STATE.IDLE

const SPEED = 100.0
const WALK_DURATION: float = 3.0
const WAIT_DURATION: float = 2.0

var is_walking: bool = true
var direction: int = 1 # 1 is right, -1 is left

func _ready():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# State handling
	match current_state:
		STATE.IDLE:
			handle_idle(delta)
			walk_timer.start() # Two second timer
		STATE.ATTACK:
			print("Enemy attacks.")
		STATE.DEATH:
			print("Enemy dies.")

	move_and_slide()
	
func handle_idle(delta: float) -> void:
		if direction == -1:
			animation.flip_h = true
		else:
			animation.flip_h = false
				
		if(is_walking):
			animation.play("walk")
			velocity.x = direction * SPEED
		else: 
			animation.play("idle")
			velocity.x = 0
		

	

func _on_timer_timeout() -> void:
	direction *= -1 # After timer ends, flip direction
