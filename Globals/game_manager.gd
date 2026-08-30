extends Node
#GAMEMANAGER

var cat_registry: CatRegistry = preload("uid://quh2bosh3gm4")
var facility_registry: FacilityRegistry = preload("uid://cc2kyllnf6nt1")
var config: GameConfig = preload("uid://c8k7kyedtsqnh")

var resident_cats: Array[CatData] = []  
var todays_cats: Array[CatData] = []
var cat_count: int 
var day_number: int = 1

var todays_income: float = 0.0
var money: float = 100.0

var mood_log: Array[ScoreEntry] = []



#FIXME from save file
#const DEFAULT_FACILITIES: Dictionary[String, bool] = {
	#"food_1": false,
	#"sleep_1": true,
	#"water_1": false,
	#"toilet_1": false,
	#"play_1": false,
	#"maintenance_1": false,
#}

var owned_facilities: Dictionary[String, bool] 

func _ready() -> void:
	if day_number == 1:
		owned_facilities = config.DEFAULT_FACILITIES.duplicate()
	#else:
		#pass #LOAD FROM SAVE
		
	cat_count = config.get_todays_cat_count(day_number)
	#owned_facilities = DEFAULT_FACILITIES.duplicate()
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
	

#TODO Add progression
func generate_day() -> void:
	var diff : int = cat_count - resident_cats.size()
	print("DIFF " + str(diff))
	var pool = cat_registry.cats.filter(func(c): return c not in resident_cats)
	pool.shuffle()
	todays_cats.clear()
	todays_cats.append_array(resident_cats)
	todays_cats.append_array(pool.slice(0, diff))
		

func log_mood(cat: Cat, facility: Facility, mood:float) -> void:
	var entry = ScoreEntry.new()
	entry.cat_name = cat.data.cat_name
	entry.facility_name = facility.data.facility_name
	entry.score = mood
	entry.is_positive = mood >= 0.0
	mood_log.append(entry)
	
func reset_day_mood_log() -> void:
	mood_log.clear()

func on_day_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.DAY:
		pass
	elif  phase == GameLoop.Phase.RESULT:
		pass
	elif phase == GameLoop.Phase.PREP:
		todays_income = 0
		day_number += 1
		cat_count = config.get_todays_cat_count(day_number)
		generate_day()
		print("CATCOUNT" + str(cat_count))
		reset_day_mood_log()
	
func calculate_income(base: float, mood: float) -> void:
	var income = base * mood
	todays_income += income
	print("INCOME ADDED: " + str(income) +", Total today: " + str(todays_income))
	
func finalize_income() -> void:
	money += todays_income
	print("Day ended. Income: ", todays_income, " Total money: ", money)
