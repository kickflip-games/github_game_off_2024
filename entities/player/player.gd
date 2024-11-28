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
const MAX_HOOK_DISTANCE = 250.0  				# Maximum distance the hook can extend TODO: remove it
const AT_HOOK_TIP_DISTANCE = 25					# Threshold to dampen when close to the tip
const MIN_GRAPPLE_DIST = 0.1
const ATTACK_FORCE = 500

const RAYCAST_LENGTH = 250

# Variables
var chain_velocity: Vector2 = Vector2.ZERO
var can_jump: bool = false
var nearby_enemies: Array = []
var can_attack:bool = true
var isDead:bool = false



@onready var raycast_grapple = $RayCastGrapple
@onready var chain = $Chain
#@onready var raycast_to_cursor = $RaycastToCursor

func _ready():
	raycast_grapple.enabled = true


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

#
#func _process(delta):
	#update_raycast_to_cursor()
	#queue_redraw()
#
#
#
#func update_raycast_to_cursor():
	#var mouse_position = get_global_mouse_position()
	#var direction = mouse_position - global_position
	#raycast_to_cursor.target_position = direction



func attack_input_pressed(_event: InputEvent)->bool:
	if _event is InputEventMouseButton:
		if _event.is_pressed() and enemies_are_nearby:  # Mouse button down.
			return true
	return false



func get_grapple_input_vector(_event: InputEvent)->Vector2:
	var direction: Vector2 = Vector2.ZERO
	

	# VERSION 1: just randomly aiming
	#var target_position:Vector2
	#if _event is InputEventMouseButton and _event.is_pressed():
	#target_position = get_global_mouse_position()
	#elif  _event is InputEventScreenTouch:
	#	target_position = _event.position
	#
	#if target_position:
	#	direction = (target_position - global_position).normalized()
	#	direction.y -= HOOK_DIRECTION_OFFSET # vertical offset if hook aims too low
	
	# VERSION 2: with detecting touching a grapple-able tile
	# if Cursor.on_grapple_point and _event is InputEventMouseButton:
	# 	if _event.is_pressed() and  !enemies_are_nearby: # Mouse button down
	# 		var target_position = get_global_mouse_position()
	# 		direction = (target_position - global_position).normalized()
	# 		direction.y -= HOOK_DIRECTION_OFFSET # vertical offset if hook aims too low
	# return direction

	## VERSION 3: checking the direction is aimed at grapple-able tile
	#var mouse_pos: Vector2 = get_global_mouse_position()
	#direction = (mouse_pos - global_position).normalized()
	#raycast_grapple.target_position = direction * RAYCAST_LENGTH
	#raycast_grapple.force_raycast_update()
#
	## check if raycast hits a grappable tile
	#if raycast_grapple.is_colliding() and _event is InputEventMouseButton:
		#if _event.is_pressed() and  !enemies_are_nearby: # Mouse button down
			#var collider = raycast_grapple.get_collider()
			#
			#if collider and collider is TileMapLayer:
				#var collision_point: Vector2 = raycast_grapple.get_collision_point()
				#var tile_pos: Vector2 = collider.local_to_map(collision_point)
				#var tile_data: TileData = collider.get_cell_tile_data(tile_pos)
#
				## Check if this tile has the "grapple_point" flag or custom metadata
				#if tile_data and tile_data.get_custom_data("grapple_point"):
					#print("Grappable point detected at:", tile_pos)
					#return direction


	# VERSION 4: checking the direction is aimed at grapple-able tile
	var mouse_pos: Vector2 = get_global_mouse_position()
	direction = (mouse_pos - global_position).normalized()
	raycast_grapple.target_position = direction * RAYCAST_LENGTH
	raycast_grapple.force_raycast_update()

	# check if raycast hits a grappable tile
	if raycast_grapple.is_colliding() and _event is InputEventMouseButton:
		if _event.is_pressed() and  !enemies_are_nearby: # Mouse button down
			var collider = raycast_grapple.get_collider()
			

			if collider and collider is StaticBody2D and collider.name == "DetectionBody2D":
				var grapple_center: Vector2 = collider.global_position
				print("Raycast collision point:", raycast_grapple.get_collision_point())
				print("Collider global position (center):", collider.global_position)
				return (grapple_center - global_position).normalized()
	# if no collision with grappable tile			
	return Vector2.ZERO

func mouse_released(_event:InputEvent)->bool:
	if _event is InputEventMouseButton:
			if _event.is_released():
				return true
	return false
	#
#
#
#func _draw():
	## Check if the raycast is colliding
	#if raycast_to_cursor.is_colliding():
		## If obstructed, stop at the collision point
		#var collision_point = raycast_to_cursor.get_collision_point()
		#draw_line(position, collision_point, Color.RED, 2)
	#else:
		## If unobstructed, draw line directly to the mouse
		#var mouse_position = get_global_mouse_position()
		#draw_line(position, mouse_position, Color.GREEN, 2)
