extends CharacterBody2D

@onready var animation:AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_timer:Timer = $WalkTimer
@onready var shoot_timer:Timer = $ShootTimer
@onready var detection_ray_left:ShapeCast2D = $RightDetection
@onready var detection_ray_right:ShapeCast2D = $LeftDetection

@export var bullet_scene: PackedScene  # Drag the Bullet.tscn file here in the Inspector




enum STATE {IDLE, ALERT, ATTACK, DEATH, WALKING}
var current_state: STATE = STATE.IDLE
var shoot_cooling_down:bool = false

const SPEED = 100.0
const WALK_DURATION: float = 0.1
const WAIT_DURATION: float = 2.0


var is_walking: bool = false
var direction: int = 1 # 1 is right, -1 is left


func _ready() -> void:
	direction = 1 # Start by idle right




func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if detection_ray_left.is_colliding():
		print("leftt colliin")
	if detection_ray_right.is_colliding():
		print("right colliin")

	check_player_detection()
	
	# State handling
	match current_state:
		STATE.IDLE:
			handle_idle(delta)
		STATE.WALKING:
			handle_walking(delta)
		STATE.ATTACK:
			print("Enemy attacks.")
			handle_attack()
		STATE.DEATH:
			print("Enemy dies.")
		STATE.ALERT:
			print("Enemy alerted")
			handle_alert()

	move_and_slide()

func handle_walking(delta:float)->void:
	animation.play("walk")
	velocity.x = direction * SPEED

func handle_idle(delta: float) -> void:
		if direction == -1:
			animation.flip_h = true
		else:
			animation.flip_h = false


		animation.play("idle")
		velocity.x = 0


func handle_alert() -> void:
	#animation.play("alert")
	velocity.x = 0
	current_state = STATE.ATTACK

func handle_attack() -> void:
	#animation.play("attack")
	print("Enemy attacks!")
	if not shoot_cooling_down:
		shoot_bullet()
		current_state = STATE.ALERT # Return to alert after attacking



func shoot_bullet() -> void:
	if bullet_scene:
		shoot_cooling_down = true
		var bullet_instance = bullet_scene.instantiate() as Node2D
		get_parent().add_child(bullet_instance)
		bullet_instance.position = global_position
		if direction > 0:  # Set starting position near the enemy
			bullet_instance.direction = Vector2.RIGHT
		else:
			bullet_instance.direction = Vector2.LEFT



func check_player_detection() -> void:
	var collider = null
	if detection_ray_right.is_colliding():
		collider = detection_ray_right.get_collider(0)
	if detection_ray_left.is_colliding():
		collider = detection_ray_left.get_collider(0)
	if collider is Player:
		print("Plauer found")
		current_state = STATE.ALERT




func _on_walk_timer_timeout() -> void:
	print("Timeout!")
	direction *= -1 # Flip direction
	current_state = STATE.IDLE # Return to idle state


func _on_shoot_timer_timeout():
	shoot_cooling_down = false
	
