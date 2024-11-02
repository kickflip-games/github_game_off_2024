extends CharacterBody2D
class_name Player

const JUMP_FORCE = 1550.0                # Force applied on jumping
const MOVE_SPEED = 500.0                 # Speed to walk with
const GRAVITY = 60.0                     # Gravity applied every second
const MAX_SPEED = 2000.0                 # Maximum speed the player is allowed to move
const FRICTION_AIR = 0.95                # The friction while airborne
const FRICTION_GROUND = 0.85             # The friction while on the ground
const CHAIN_PULL = 105.0
	 # The velocity of the player (kept over time)
var chain_velocity: Vector2 = Vector2.ZERO
var can_jump: bool = false     
var can_attack:bool = false
var gravity_scale: float = GRAVITY

# needed for can_attack check
var nearby_enemies: Array = []

func _ready() -> void:
	# Ensure the character's gravity scale is set if needed for specific movement
	gravity_scale = GRAVITY / ProjectSettings.get("physics/2d/default_gravity")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if can_attack:
				attack()
			
			$Chain.shoot(event.position - get_viewport().get_visible_rect().size * 0.5)
		else:
			$Chain.release()

func attack():
	for enemy in nearby_enemies:
		if enemy:  # Ensure the enemy instance is still valid
			var knockback_force = 3000  # Adjust the strength of the knockback as needed
			var direction = (enemy.global_position - global_position).normalized()
			enemy.take_damage(direction * knockback_force)
	
func _physics_process(delta: float) -> void:
	# Handle walking input
	var walk_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var walk = walk_input * MOVE_SPEED

	# Apply gravity
	velocity.y += GRAVITY

	# Hook physics
	if $Chain.hooked:
		chain_velocity = (global_position - $Chain.tip).normalized() * -CHAIN_PULL
		if chain_velocity.y > 0.0:
			chain_velocity.y *= 0.55 
		else:
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(walk):
			chain_velocity.x *= 0.7
	else:
		chain_velocity = Vector2.ZERO

	velocity += chain_velocity

	# Apply walk force and then move the player
	velocity.x += walk
	move_and_slide()

	# Friction and limit checks
	velocity.x -= walk
	velocity = velocity.limit_length(MAX_SPEED)

	# Check if grounded and apply ground friction
	if is_on_floor():
		velocity.x *= FRICTION_GROUND
		can_jump = true
		if velocity.y > 5.0:
			velocity.y = 5.0
	elif is_on_ceiling() and velocity.y < -5.0:
		velocity.y = -5.0

	# Air friction
	if not is_on_floor():
		velocity.x *= FRICTION_AIR
		if velocity.y > 0:
			velocity.y *= FRICTION_AIR

	# Jump input handling
	if Input.is_action_just_pressed("jump"):
		print("Jump")
		if is_on_floor():
			velocity.y = -JUMP_FORCE
		elif can_jump:
			can_jump = false
			velocity.y = -JUMP_FORCE
			
			
	
		
			
		


func _on_detection_area_2d_body_entered(body):
	
	if body is Enemy:
		nearby_enemies.append(body)  # Add the enemy to the list
		can_attack = true            # Enable attack mode when any enemy is nearby

func _on_detection_area_2d_body_exited(body):
	if body is Enemy:
		nearby_enemies.erase(body)   # Remove the enemy from the list
		can_attack = nearby_enemies.size() > 0  # Set can_attack based on remaining enemies
