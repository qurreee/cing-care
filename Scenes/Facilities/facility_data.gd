extends Resource
class_name FacilityData

enum Rarity { D, C, B, A, S }

const Rarity_Multiplier: Dictionary = {
	Rarity.D: 20.0,
	Rarity.C: 35.0,
	Rarity.B: 70.0,
	Rarity.A: 100.0,
	Rarity.S: 250.0,
}

@export var id: String
@export var facility_name: String 
#export stat change type
@export var type: Enums.Needs
@export var facility_tier: Rarity

##TODO amplify mood gained with each tier.
func get_facility_multiplier() -> float:
	
	return 0
