extends Resource
class_name GameConfig

@export var cat_capacity: int = 2
@export var day_duration: float = 60.0
@export var GRID_SIZE: Vector2i = Vector2i(4, 4)
#X is day, Y is cat count
const CAT_COUNT: Array[Vector2]= [
	Vector2(1, 2),
	Vector2(4, 3),
	Vector2(8, 4),
	Vector2(10, 5)
]

#Cats

#Facilities
const DEFAULT_FACILITIES: Dictionary[String, bool] = {
	"food_1": true,
	"sleep_1": true,
	"water_1": false,
	"toilet_1": false,
	"play_1": false,
	"maintenance_1": false,
}

const FACILITY_UNLOCK_SCHEDULE: Dictionary[int, Array] = {
	3 : ["water_1"],
	5 : ["toilet_1"],
	8 : ["play_1"],
	10: ["maintenance_1"]
}

func get_todays_cat_count(day: int) -> int:
	for threshold in CAT_COUNT:
		if day >= threshold.x:
			cat_capacity = int(threshold.y)
		else:
			break
	print("Hari " + str(day) + ": " + str(cat_capacity))
	return cat_capacity
