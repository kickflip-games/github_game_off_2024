extends Node2D

@export var animation_tree: AnimationTree
@onready var player: Player = get_owner()

var last_facing_direction : int

func _physics_process(delta: float) -> void:
	var idle = !player.velocity
	if !idle:
		if player.velocity.x > 0:
			last_facing_direction = 1
		else:
			last_facing_direction = -1
		
		
	
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/Run/blend_position", last_facing_direction)
	animation_tree.set("parameters/Attack/blend_position", last_facing_direction)
	animation_tree.set("parameters/Death/blend_position", last_facing_direction)
	
