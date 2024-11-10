extends Node

# Constants for time control
const SLOW_FACTOR: float = 0.75  # Target slow factor (e.g., 0.5 = half speed)

# TOTAL SLOWMO TIME = Transition + slow + ttransitionn
const SLOW_DURATION: float = 0.5  # Duration of time slowdown in seconds
const TRANSITION_SPEED: float = 0.5  # Speed of the smooth transition

# State tracking
var is_slowing_down: bool = false  # Track if slowing down is in effect
var slow_timer: float = 0.0

func _process(delta):
	if is_slowing_down:
		# Gradually interpolate the time_scale towards the SLOW_FACTOR during slowdown
		Engine.time_scale = lerp(Engine.time_scale, SLOW_FACTOR, TRANSITION_SPEED * delta)
		
		# Countdown the timer
		slow_timer -= delta
		if slow_timer <= 0:
			is_slowing_down = false  # Stop the slowdown effect when timer runs out
	else:
		# Smoothly reset time back to normal by lerping back to 1.0
		Engine.time_scale = lerp(Engine.time_scale, 1.0, TRANSITION_SPEED * delta)

func start():
	if not is_slowing_down:
		print(">>>>>>>>>>>>>> SLOWMO TRIGGERED <<<<<<<<<<<<<<<<<<")
		# Activate time slowdown
		is_slowing_down = true
		slow_timer = SLOW_DURATION
