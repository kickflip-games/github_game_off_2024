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
const MIN_GRAPPLE_DIST = 0.1

# Variables
var nearby_enemies: Array = []
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
