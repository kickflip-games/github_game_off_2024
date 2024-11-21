extends CharacterBody2D
class_name Enemy

# Nodes and Scene Variables
@onready var animation: Sprite2D = $Sprite2D
@onready var detection_ray: RayCast2D = $DetectionRay
@onready var detection_cone:Node = $ViewCone
@export var bullet_scene: PackedScene  # Drag the Bullet.tscn file here in the Inspector


# have to suply this for the enemy to walk.. (% of path per frame)
enum Choices {NONE, Static, Along_Path, Random}
@export var Behavior: Choices = Choices.NONE # pick behavior we want for the enemy
@export var walk_speed: float = 2.5
@export var idling_time_before_flipping: float = 2.0
@export var path_follow:PathFollow2D


var isDead:bool 
var isAlerted:bool


var patrollingEnemy:bool:
	get: return walk_speed > 0 and path_follow!=null
	
var RandomPatrollingEnemy:bool:
	get: return walk_speed > 0 


var facing_right:bool:
	get:return !animation.flip_h 

var direction: int: # 1 is right, -1 is left
	get: return 1 if facing_right else -1


func flip_direction() -> void:
	animation.flip_h = !animation.flip_h
	detection_ray.target_position.x = -1*detection_ray.target_position.x
	if facing_right :
		detection_cone.rotation = 0
	else:
		detection_cone.rotate(PI)


func player_is_visible() -> bool:
	var collider = null
	if detection_ray.is_colliding():
		if detection_ray.get_collider() is Player:
			return true
	return false


func enter_alert_mode():
	isAlerted = true
	$ViewCone/Sprite2D.modulate = Color.RED

func take_damage(knockback_force: Vector2) -> void:
	if !isDead:
		velocity += knockback_force  # Apply knockback to the enemy's velocity
		isDead = true



func is_path_pointing_right(path: Path2D) -> bool:
	# Make sure there are enough points to determine direction
	if path.curve.get_point_count() < 2:
		return false  # Not enough points to determine direction

	# Get the first two points
	var start_point = path.curve.get_point_position(0)
	var next_point = path.curve.get_point_position(1)

	# Check if the path is pointing in the positive X direction
	return next_point.x > start_point.x


func _ready():
	await SceneManager.scene_loaded
	if patrollingEnemy:
		if !is_path_pointing_right(path_follow.get_parent()):
			push_error("Path2d must be poinnting in the +ive right dir")
