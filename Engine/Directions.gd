extends Node

# Direction Constants
const center = Vector2(0,0)
const left = Vector2(-1,0)
const right = Vector2(1,0)
const up = Vector2(0,-1)
const down = Vector2(0,1)

# Random Selection for movement
func rand() -> Vector2:
	var rand_val = randi() % 4 + 1
	match rand_val:
		1:
			return left
		2:
			return right
		3:
			return up
		4:
			return down