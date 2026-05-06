extends Node

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

	#debug
	#for k in owned_facilities:
		#print("game manager", k, owned_facilities[k])

func is_facility_owned(facility_id: String) -> bool:
	return owned_facilities.get(facility_id, false)
