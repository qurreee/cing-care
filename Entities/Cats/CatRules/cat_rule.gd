extends Resource
class_name CatRule

@export var rule_name: String
@export var is_negative: bool = true
@export var weight: float = 1.0
@export var reward: float = 0.5  

func evaluate(cat: Cat, grid_manager: GridManager) -> float:
	return 0.0
	

static func cell_distance(from: Vector2i, to: Vector2i) -> int:
	# Chebyshev - use if cats can move diagonally
	return maxi(absi(to.x - from.x), absi(to.y - from.y))
	
	# Manhattan - use if cats move only up/down/left/right
	# return absi(to.x - from.x) + absi(to.y - from.y)
	
