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
const MAX_HOOK_DISTANCE = 400.0  				# Maximum distance the hook can extend
const AT_HOOK_TIP_DISTANCE = 15					# Threshold to dampen when close to the tip
const MIN_GRAPPLE_DIST = 0.1
const ATTACK_FORCE = 500


# Variables
var chain_velocity: Vector2 = Vector2.ZERO
var can_jump: bool = false
var nearby_enemies: Array = []
var can_attack:bool = true
var isDead:bool = false


@onready var chain = $Chain
@onready var raycast_to_cursor = $RaycastToCursor



# Attack all nearby enemies with knockback
func attack() -> void:
	for enemy in nearby_enemies:
		if enemy:
			var direction = (enemy.global_position - global_position).normalized()
			enemy.take_damage(direction * ATTACK_FORCE)

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
	print("Take damage")
	if !isDead:
		isDead = true
		GameManager.GameOver()


func _process(delta):
	update_raycast_to_cursor()
	queue_redraw()



func update_raycast_to_cursor():
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	raycast_to_cursor.target_position = direction



func attack_input_pressed(_event: InputEvent)->bool:
	if _event is InputEventMouseButton:
		if _event.is_pressed() and enemies_are_nearby:  # Mouse button down.
			return true
	return false



func get_grapple_input_vector(_event: InputEvent)->Vector2:
	var direction: Vector2 = Vector2.ZERO
	if Cursor.on_grapple_point and _event is InputEventMouseButton:
		if _event.is_pressed() and  !enemies_are_nearby: # Mouse button down
			var target_position = get_global_mouse_position()
			direction = (target_position - global_position).normalized()
			direction.y -= HOOK_DIRECTION_OFFSET # vertical offset if hook aims too low
	return direction
	#if !enemies_are_nearby:
		#var target_position:Vector2
		#if _event is InputEventMouseButton and _event.is_pressed():
			#target_position = get_global_mouse_position()
		#elif  _event is InputEventScreenTouch:
			#target_position = _event.position
		#
		#if target_position:
			#direction = (target_position - global_position).normalized()
			#direction.y -= HOOK_DIRECTION_OFFSET # vertical offset if hook aims too low
	#return direction


func mouse_released(_event:InputEvent)->bool:
	if _event is InputEventMouseButton:
			if _event.is_released():
				return true
	return false
	


func _draw():
	# Check if the raycast is colliding
	if raycast_to_cursor.is_colliding():
		# If obstructed, stop at the collision point
		var collision_point = raycast_to_cursor.get_collision_point()
		draw_line(global_position, collision_point, Color.RED, 2)
	else:
		# If unobstructed, draw line directly to the mouse
		var mouse_position = get_global_mouse_position()
		draw_line(global_position, mouse_position, Color.GREEN, 2)
