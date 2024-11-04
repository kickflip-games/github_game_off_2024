extends CharacterBody2D
class_name Player

# Constants
const JUMP_FORCE = 550.0
const MOVE_SPEED = 500.0
const GRAVITY = 60.0
const MAX_SPEED = 2000.0
const FRICTION_AIR = 0.95
const FRICTION_GROUND = 0.85
const CHAIN_PULL = 105.0
const HOOK_DIRECTION_OFFSET = 0.05				# Vertical offset for the hook direction
const SWING_FORCE = 50							# Force applied to swing while hooked
const MAX_HOOK_DISTANCE = 800.0  				# Maximum distance the hook can extend
const AT_HOOK_TIP_DISTANCE = 10					# Threshold to dampen when close to the tip
const MIN_GRAPPLE_DIST = 0.1

# Variables
var chain_velocity: Vector2 = Vector2.ZERO
var can_jump: bool = false
var nearby_enemies: Array = []
var gravity_scale: float = GRAVITY / ProjectSettings.get("physics/2d/default_gravity")
var can_attack:bool = true
var isDead:bool = true


@onready var chain = $Chain



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


func _on_detection_area_2d_body_exited(body):
	if body is Enemy:
		nearby_enemies.erase(body)


var enemies_are_nearby:bool:
	get: return nearby_enemies.size() > 0


func take_damage():
	if !isDead:
		isDead = true
		GameManager.GameOver()




#### INPUT HELPERS ####
# Maybe these should be in the PlayerState.gd script?


func attack_input_pressed(_event: InputEvent)->bool:
	if _event is InputEventMouseButton:
		if _event.is_pressed() and enemies_are_nearby:  # Mouse button down.
			return true
	return false


func get_grapple_input_vector(_event: InputEvent)->Vector2:
	var direction: Vector2 = Vector2.ZERO
	if _event is InputEventMouseButton:
		if _event.is_pressed() and  !enemies_are_nearby: # Mouse button down
			var target_position = get_global_mouse_position()
			direction = (target_position - global_position).normalized()
			direction.y -= HOOK_DIRECTION_OFFSET # vertical offset if hook aims too low
	return direction


func mouse_released(_event:InputEvent)->bool:
	if _event is InputEventMouseButton:
			if _event.is_released():
				return true
	return false
