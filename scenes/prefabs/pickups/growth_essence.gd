class_name GrowthEssence
extends Area3D

@export var transform_to_state: GrowthStates.Type

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.has_node("GrowthManager"):
		var growth_manager = body.get_node("GrowthManager")
		growth_manager.transform_to(transform_to_state)
		queue_free()
