extends Resource
class_name CatData

enum Rarity { D, C, B, A, S }

const RARITY_BASE_PAYMENT: Dictionary = {
	Rarity.D: 1.0,
	Rarity.C: 1.35,
	Rarity.B: 1.7,
	Rarity.A: 2.0,
	Rarity.S: 3.5,
}

const RARITY_STAY_RANGE: Dictionary = {
	Rarity.D: Vector2i(1, 2),
	Rarity.C: Vector2i(1, 3),
	Rarity.B: Vector2i(2, 3),
	Rarity.A: Vector2i(2, 4),
	Rarity.S: Vector2i(1, 5),
}

@export var cat_name: String
@export_multiline var description: String
@export var rarity: Rarity = Rarity.D
@export var rules: Array[CatRule]
#multiplier etc

@export var need_weights: Dictionary[Enums.Needs, float] = {
	Enums.Needs.FREE: 1.0,
	Enums.Needs.FOOD: 1.0,
	Enums.Needs.WATER: 1.0,
	Enums.Needs.SLEEP: 1.0,
	Enums.Needs.PLAY: 1.0,
	Enums.Needs.TOILET: 1.0,
	Enums.Needs.MAINTENANCE: 1.0
}

func get_base_payment() -> float:
	return RARITY_BASE_PAYMENT[rarity]

func roll_stay_duration() -> int:
	var stay_range = RARITY_STAY_RANGE[rarity]
	return randi_range(stay_range.x, stay_range.y)
	
	
