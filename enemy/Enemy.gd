extends CharacterBody2D
class_name Enemy

# Nodes and Scene Variables
@onready var animation: Sprite2D = $Sprite2D
@onready var walk_timer: Timer = $WalkTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var death_timer: Timer = $DeathTimer
@onready var detection_ray_left: RayCast2D = $RightDetection
@onready var detection_ray_right: RayCast2D = $LeftDetection
@export var bullet_scene: PackedScene  # Drag the Bullet.tscn file here in the Inspector

# State and Constants
enum STATE { IDLE, ALERT, ATTACK, DEATH, WALKING }
var current_state: STATE = STATE.IDLE
var shoot_cooling_down: bool = false
var direction: int = 1  # 1 is right, -1 is left

const SPEED: float = 100.0
const WALK_DURATION: float = 0.1
const WAIT_DURATION: float = 2.0

# Initialization
func _ready() -> void:
	direction = 1  # Start facing right

# Main Processing
func _physics_process(delta: float) -> void:
	# Apply gravity if airborne
	if not is_on_floor():
		velocity += get_gravity() * delta

	check_player_detection()
	handle_state(delta)
	move_and_slide()

# State Handling
func handle_state(delta: float) -> void:
	match current_state:
		STATE.IDLE:
			handle_idle()
		STATE.WALKING:
			handle_walking()
		STATE.ALERT:
			handle_alert()
		STATE.ATTACK:
			handle_attack()
		STATE.DEATH:
			handle_death()

func handle_idle() -> void:
	animation.flip_h = direction == -1
	velocity.x = 0
	# animation.play("idle")

func handle_walking() -> void:
	velocity.x = direction * SPEED
	# animation.play("walk")

func handle_alert() -> void:
	velocity.x = 0
	current_state = STATE.ATTACK
	# animation.play("alert")

func handle_attack() -> void:
	if not shoot_cooling_down:
		shoot_bullet()
		current_state = STATE.ALERT  # Return to alert after attacking
	# animation.play("attack")

func handle_death() -> void:
	death_timer.start()

# Player Detection
func check_player_detection() -> void:
	var collider = null
	if detection_ray_right.is_colliding():
		collider = detection_ray_right.get_collider()
	if detection_ray_left.is_colliding():
		collider = detection_ray_left.get_collider()
	if collider is Player:
		current_state = STATE.ALERT

# Actions
func shoot_bullet() -> void:
	if bullet_scene:
		shoot_cooling_down = true
		var bullet_instance = bullet_scene.instantiate() as Node2D
		get_parent().add_child(bullet_instance)
		bullet_instance.position = global_position
		bullet_instance.direction = Vector2.RIGHT if direction > 0 else Vector2.LEFT

func take_damage(knockback_force: Vector2) -> void:
	if current_state != STATE.DEATH:
		velocity += knockback_force  # Apply knockback to the enemy's velocity
		current_state = STATE.DEATH

# Timer Callbacks
func _on_walk_timer_timeout() -> void:
	direction *= -1  # Flip direction
	current_state = STATE.IDLE

func _on_shoot_timer_timeout() -> void:
	shoot_cooling_down = false

func _on_death_timer_timeout() -> void:
	queue_free()
