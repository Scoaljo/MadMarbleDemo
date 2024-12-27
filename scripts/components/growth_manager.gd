class_name GrowthManager
extends Node

signal state_changed(new_state: GrowthStates.Type)

var current_state: GrowthStates.Type = GrowthStates.Type.GROWING_SPROUT

func _ready() -> void:
	apply_state_config(current_state)

func transform_to(new_state: GrowthStates.Type) -> void:
	current_state = new_state
	apply_state_config(current_state)
	state_changed.emit(current_state)

func apply_state_config(state: GrowthStates.Type) -> void:
	var config = GrowthStates.STATE_CONFIGS[state]
	var player = get_parent() as CharacterBody3D
	
	player.SPEED = config.SPEED
	player.ACCELERATION = config.ACCELERATION
	player.FRICTION = config.FRICTION
	
	# Get original position and current scale for calculations
	var original_position = player.position
	var current_scale = player.get_node("MeshInstance3D").scale
	var new_scale = config.SCALE
	
	# Scale the mesh
	player.get_node("MeshInstance3D").scale = new_scale
	
	# Scale the collision shape
	var collision_shape = player.get_node("CollisionShape3D")
	if collision_shape:
		collision_shape.scale = new_scale
	
	# Adjust position based on scale difference to keep bottom on ground
	var height_difference = (new_scale.y - current_scale.y) * 0.5  # Assuming sphere with radius 0.5
	player.position.y = original_position.y + height_difference
	
	# Update ball radius for rotation calculations
	player.ball_radius = 0.5 * new_scale.y  # Update the base radius with scale
