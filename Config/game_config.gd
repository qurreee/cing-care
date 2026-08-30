extends Resource
class_name GameConfig

@export var cat_capacity: int = 3
@export var day_duration: float = 60.0
@export var GRID_SIZE: Vector2i = Vector2i(4, 4)
#X is day, Y is cat count
const CAT_COUNT: Array[Vector2]= [
	Vector2(1, 2),
	Vector2(4, 3),
	Vector2(8, 4),
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

func get_todays_cat_count(day: int) -> int:
	var current_count: int = 0
	for threshold in CAT_COUNT:
		if day >= threshold.x:
			current_count = int(threshold.y)
		else:
			break
	print("Hari " + str(day) + ": " + str(current_count))
	return current_count
