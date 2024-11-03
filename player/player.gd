extends CharacterBody2D
class_name Player

# Constants
const JUMP_FORCE = 1550.0
const MOVE_SPEED = 500.0
const GRAVITY = 60.0
const MAX_SPEED = 2000.0
const FRICTION_AIR = 0.95
const FRICTION_GROUND = 0.85
const CHAIN_PULL = 105.0
const HOOK_DIRECTION_OFFSET = 0.05				# Vertical offset for the hook direction
const SWING_FORCE = 50							# Force applied to swing while hooked
const MAX_HOOK_DISTANCE = 800.0  				# Maximum distance the hook can extend

# Enums for player states
enum STATE { IDLE, WALKING, JUMPING, FALLING, ATTACKING, HOOKED, AT_HOOK_TIP }
var current_state: STATE = STATE.IDLE

# Variables
var chain_velocity: Vector2 = Vector2.ZERO
var can_jump: bool = false     
var nearby_enemies: Array = []
var gravity_scale: float = GRAVITY / ProjectSettings.get("physics/2d/default_gravity")
var can_attack:bool = true

@onready var chain = $Chain

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if current_state != STATE.ATTACKING and can_attack:
			attack()
		
		# Calculate direction to mouse position in world coordinates
		var target_position = get_global_mouse_position()
		var direction = (target_position - global_position).normalized()
		direction.y -= HOOK_DIRECTION_OFFSET # vertical offset if hook aims too low

		chain.shoot(direction)
		# chain.shoot(event.position - get_viewport().get_visible_rect().size * 0.5)
		
	elif event is InputEventMouseButton and not event.pressed:
		chain.release()

func _physics_process(delta: float) -> void:
	# State Machine
	match current_state:
		STATE.IDLE, STATE.WALKING, STATE.JUMPING, STATE.FALLING:
			handle_movement()
		STATE.ATTACKING:
			handle_attacking()
		STATE.HOOKED:
			handle_hooked()

	apply_gravity()
	move_and_slide()

	# Update state based on conditions
	update_state()

# Handle movement and input
func handle_movement() -> void:
	var walk_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = walk_input * MOVE_SPEED

	# Apply friction based on whether grounded or airborne
	if is_on_floor():
		velocity.x *= FRICTION_GROUND
	else:
		velocity.x *= FRICTION_AIR

	# Apply jump force if jump is pressed
	if Input.is_action_just_pressed("jump") and can_jump:
		can_jump = false
		velocity.y = -JUMP_FORCE
		current_state = STATE.JUMPING

	# Limit velocity to prevent exceeding maximum speed
	velocity = velocity.limit_length(MAX_SPEED)

# Apply gravity if not hooked
func apply_gravity() -> void:
	if !chain.hooked:
		velocity.y += GRAVITY

func handle_hooked() -> void:
	chain_velocity = (global_position - chain.tip).normalized() * -CHAIN_PULL
	chain_velocity.y *= 0.55 if chain_velocity.y > 0.0 else 1.65
	if sign(chain_velocity.x) != sign(velocity.x):
		chain_velocity.x *= 0.7

	# Dampen the chain velocity based on distance
	var distance = global_position.distance_to(chain.tip)
	if distance > MAX_HOOK_DISTANCE / 2 and distance < MAX_HOOK_DISTANCE:
		# Calculate a damping factor
		var damping_factor = (MAX_HOOK_DISTANCE - distance) / (MAX_HOOK_DISTANCE / 2)

		chain_velocity.x *= damping_factor
		chain_velocity.x *= damping_factor

	# Release the hook if reach a max length
	elif distance > MAX_HOOK_DISTANCE:
		chain.release()  # Retract the hook
		return  

	# Swing swing mechanics if hooked
	if current_state == STATE.HOOKED:
		if Input.is_action_pressed("move_right"):
			velocity.x += SWING_FORCE
		elif Input.is_action_pressed("move_left"):
			velocity.x -= SWING_FORCE

	velocity += chain_velocity  # Combine chain movement with player's movement

	if !chain.hooked:
		current_state = STATE.FALLING

func handle_attacking() -> void:
	# Attack logic (e.g., animations, cooldown)
	pass

# Manage state transitions
func update_state() -> void:
	if is_on_floor():
		can_jump = true
		if abs(velocity.x) > 0:
			current_state = STATE.WALKING
		else:
			current_state = STATE.IDLE
	elif velocity.y < 0 and !can_jump:
		current_state = STATE.JUMPING
	elif velocity.y > 0:
		current_state = STATE.FALLING
	if chain.hooked:
		current_state = STATE.HOOKED

# Attack all nearby enemies with knockback
func attack() -> void:
	for enemy in nearby_enemies:
		if enemy:
			var knockback_force = 3000
			var direction = (enemy.global_position - global_position).normalized()
			enemy.take_damage(direction * knockback_force)

# Detection area signals
func _on_detection_area_2d_body_entered(body):
	if body is Enemy:
		nearby_enemies.append(body)
		can_attack = true

func _on_detection_area_2d_body_exited(body):
	if body is Enemy:
		nearby_enemies.erase(body)
		can_attack = nearby_enemies.size() > 0
