extends Node2D

@onready var links = $Links                    # Reference to the chain links
var direction: Vector2 = Vector2.ZERO           # Direction in which the chain was shot
var tip: Vector2 = Vector2.ZERO                 # Position of the chain's tip

const SPEED: float = 70.0                       # Speed at which the chain moves

var flying: bool = false                        # Whether the chain is moving through the air
var hooked: bool = false                        # Whether the chain has connected to a wall

# shoot() shoots the chain in a given direction
func shoot(_direction: Vector2) -> void:
	self.direction = _direction
	
	flying = true
	tip = global_position                   # Reset tip position to the player's current position

# release() releases the chain
func release() -> void:
	flying = false                              # Stop flying
	hooked = false                              # Detach from any wall

# Every frame we update the chain's visuals
func _process(_delta: float) -> void:
	visible = flying or hooked                  # Only visible if flying or attached
	if not visible:
		return                                  # No need to draw if not visible

	var tip_loc = to_local(tip)                 # Convert tip position to local coordinates

	# Rotate the chain links and tip to align with the line from origin to tip
	links.rotation = position.angle_to_point(tip_loc) + deg_to_rad(90)
	$Tip.rotation = position.angle_to_point(tip_loc) + deg_to_rad(90)

	links.position = tip_loc                    # Set the links' start position to the tip
	links.region_rect.size.y = tip_loc.length() # Extend the chain to match distance to the tip

# Every physics frame we update the tip's position
func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip                  # Ensure the tip is updated to follow movement

	if flying:
		var collision = $Tip.move_and_collide(direction * SPEED)
		
		if collision:
			hooked = true                       # If we hit something, we're hooked
			flying = false
			print("Hooked!")                    # Stop flying

	tip = $Tip.global_position                  # Update tip for the next frame
