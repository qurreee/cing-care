extends Resource
class_name CatData

@export var cat_name: String
@export var description: String
@export var income_multiplier: int
@export var rules: Array[CatRule] 
#multiplier etc

@export var need_weights: Dictionary[Enums.Needs, float] = {
	Enums.Needs.FREE: 1.0,
	Enums.Needs.FOOD: 1.0,
	Enums.Needs.WATER: 1.0,
	Enums.Needs.SLEEP: 1.0,
	Enums.Needs.PLAY: 1.0,
}
