extends Node

var cat_registry: CatRegistry = preload("res://Cats/CatDatas/cat_registry.tres")
var facility_registry: FacilityRegistry = preload("res://Scenes/Facilities/FacilityDatas/facility_registry.tres")


var todays_cats: Array[CatData] = []
var day_number: int = 1

var score_log: Array[ScoreEntry] = []



#facility unlocked
const DEFAULT_FACILITIES: Dictionary[String, bool] = {
	"food_1": true,
	"sleep_1": true,
	"water_1": true,
	"toilet_1": false,
	"play_1": false,
	"maintenance_1": false,
	
}

var owned_facilities: Dictionary[String, bool] 

func _ready() -> void:
	owned_facilities = DEFAULT_FACILITIES.duplicate()
	generate_day()
	GameLoop.phase_changed.connect(on_day_phase_changed)
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
	todays_cats = pool.slice(0, 3)

func log_score(cat: Cat, facility: Facility, score:float) -> void:
	var entry = ScoreEntry.new()
	entry.cat_name = cat.data.cat_name
	entry.facility_name = facility.data.facility_name
	entry.score = score
	entry.is_positive = score > 0.0
	score_log.append(entry)

	
func reset_day_score() -> void:
	score_log.clear()



func on_day_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.RESULT:
		for i in score_log.size():
			print(str(score_log[i].score) + "\n" )
	
