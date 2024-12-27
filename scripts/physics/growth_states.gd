class_name GrowthStates
extends Node

enum Type {
	TINY_SEED,
	GROWING_SPROUT,
	BLOOMING_SPIRIT,
	ANCIENT_GUARDIAN
}

# Physics configurations for each state
const STATE_CONFIGS = {
	Type.TINY_SEED: {
		"SPEED": 10.0,           # Higher speed for agility
		"ACCELERATION": 20.0,    # Quick direction changes
		"FRICTION": 4.0,         # More friction for control
		"SCALE": Vector3(0.5, 0.5, 0.5)  # Visual size
	},
	Type.GROWING_SPROUT: {
		"SPEED": 8.0,           # Default values
		"ACCELERATION": 15.0,
		"FRICTION": 3.0,
		"SCALE": Vector3(1, 1, 1)
	},
	Type.BLOOMING_SPIRIT: {
		"SPEED": 7.0,           # Slower but more momentum
		"ACCELERATION": 12.0,
		"FRICTION": 2.0,
		"SCALE": Vector3(1.5, 1.5, 1.5)
	},
	Type.ANCIENT_GUARDIAN: {
		"SPEED": 6.0,           # Slowest but most momentum
		"ACCELERATION": 10.0,
		"FRICTION": 1.0,
		"SCALE": Vector3(2, 2, 2)
	}
}
