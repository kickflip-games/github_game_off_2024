extends Node2D

@export var animation_tree: AnimationTree
@export var sprite: AnimatedSprite2D
@onready var enemy: Enemy = get_owner()

var last_facing_direction : int

func _physics_process(delta: float) -> void:
	
	var idle = !enemy.velocity
	
	if !idle:
		last_facing_direction = enemy.velocity.normalized().x
	
	animation_tree.set("parameters/Death/blend_position", last_facing_direction)
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/Run/blend_position", last_facing_direction)
	
	#Colour changing
	if enemy.isAlerted:
		set_colour(Color.RED)
	elif enemy.isDead:
		set_colour(Color.BLACK)
	else:
		set_colour(Color(1,1,1)) #return to default

func set_colour(colour: Color) -> void:
	sprite.modulate = colour
