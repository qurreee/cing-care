extends Node

var cat_registry: CatRegistry = preload("res://Cats/CatDatas/cat_registry.tres")
var facility_registry: FacilityRegistry = preload("res://Scenes/Facilities/FacilityDatas/facility_registry.tres")


var todays_cats: Array[CatData] = []
var day_number: int = 1
var day_score: float = 0.0


#facility unlocked
const DEFAULT_FACILITIES: Dictionary[String, bool] = {
	"cat_bed": true,
	"feeding_station": true,
	"water_fountain": false,
	"scratching_post": false,
}

var owned_facilities: Dictionary[String, bool] 

func _ready() -> void:
	owned_facilities = DEFAULT_FACILITIES.duplicate()
	generate_day()
	#debug
	#for k in owned_facilities:
		#print("game manager", k, owned_facilities[k])

func is_facility_owned(facility_id: String) -> bool:
	return owned_facilities.get(facility_id, false)

func unlock_facility(facility_id: String) -> void:
	if owned_facilities.has(facility_id):
		owned_facilities[facility_id] = true
	else:
		push_warning("unknown id : ", facility_id)

func get_owned_facility_datas() -> Array[FacilityData]:
	var result: Array[FacilityData] = []
	
	for facility in facility_registry.facilities:
		if is_facility_owned(facility.id):
			result.append(facility)
	
	return result
	

func generate_day() -> void:
	todays_cats.clear()
	var pool = cat_registry.cats.duplicate()
	pool.shuffle()
	todays_cats = pool.slice(0, 2)
