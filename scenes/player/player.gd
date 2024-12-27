extends CharacterBody3D

@export var SPEED = 8.0
@export var ACCELERATION = 15.0
@export var FRICTION = 3.0
@export var AIR_FRICTION = 1.0
@export var ROTATION_SPEED = 15.0
@export var MAX_VELOCITY = 15.0  # Terminal velocity
@export var INPUT_INFLUENCE = 0.5  # How much input can fight against gravity

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotation_velocity = Vector3.ZERO
var slope_normal = Vector3.UP
var ball_radius = 0.5  # Base radius, will be updated by growth manager

func get_slope_force(delta: float) -> Vector3:
	# Calculate downhill direction
	var downhill = (Vector3.UP - slope_normal * slope_normal.dot(Vector3.UP)).normalized()
	
	# Calculate angle between slope normal and up vector
	var slope_angle = acos(slope_normal.dot(Vector3.UP))
	
	# Return inverted force for proper slope physics
	return -downhill * gravity * sin(slope_angle) * delta

func _physics_process(delta):
	if $RayCast3D.is_colliding():
		slope_normal = $RayCast3D.get_collision_normal()
	else:
		slope_normal = Vector3.UP
	
	# Get input
	var input_dir = Input.get_vector("roll_left", "roll_right", "roll_forward", "roll_backward")
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()
	
	# Convert input to 3D space (isometric)
	var rotated_input = Vector2(
		(input_dir.x + input_dir.y) * 0.707107,
		(-input_dir.x + input_dir.y) * 0.707107
	)
	
	if is_on_floor():
		# Always apply slope force first
		var slope_force = get_slope_force(delta)
		
		# Calculate current velocity along the slope
		var slope_parallel = velocity - velocity.dot(slope_normal) * slope_normal
		
		# Apply slope force (gravity)
		velocity += slope_force
		
		# Apply input as a force, not direct velocity change
		if input_dir.length_squared() > 0:
			var input_force = Vector3(rotated_input.x, 0, rotated_input.y)
			var current_speed = velocity.length()
			
			# Scale input force based on current speed and slope
			var slope_dot = abs(slope_normal.dot(Vector3.UP))
			var speed_factor = 1.0 - (current_speed / MAX_VELOCITY)
			var input_multiplier = slope_dot * speed_factor * INPUT_INFLUENCE
			
			# Add input force to existing velocity
			velocity += input_force * ACCELERATION * delta * input_multiplier
		
		# Apply gradual friction
		var friction_force = -velocity.normalized() * FRICTION * delta
		velocity += friction_force
		
		# Limit maximum velocity
		if velocity.length() > MAX_VELOCITY:
			velocity = velocity.normalized() * MAX_VELOCITY
	else:
		velocity.y -= gravity * delta
	
	# Update rotation based on movement
	if velocity.length() > 0.1:
	# Forward movement (Z) affects X rotation
	# Right movement (X) affects Z rotation
		rotation_velocity.x = velocity.z * (ROTATION_SPEED / ball_radius) * delta
		rotation_velocity.z = -velocity.x * (ROTATION_SPEED / ball_radius) * delta
	else:
		rotation_velocity = rotation_velocity.move_toward(Vector3.ZERO, FRICTION * delta)
	
	# Apply rotation to mesh
	$MeshInstance3D.rotate_x(rotation_velocity.x)
	$MeshInstance3D.rotate_z(rotation_velocity.z)
	
	move_and_slide()
