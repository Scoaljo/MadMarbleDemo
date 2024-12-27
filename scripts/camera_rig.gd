extends Node3D

@export var target_path: NodePath
@export var follow_speed: float = 5.0
@export var offset: Vector3 = Vector3(15, 15, 15)  # Equal values for isometric position

var target: Node3D

func _ready():
	target = get_node(target_path)
	if target:
		global_position = target.global_position + offset
	
func _physics_process(delta):
	if target:
		var target_pos = target.global_position
		var desired_pos = target_pos + offset
		global_position = global_position.lerp(desired_pos, follow_speed * delta)
