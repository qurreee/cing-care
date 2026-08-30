extends Node2D
class_name CatManager

var cat_datas: Array[CatData] = []
var cats: Array[Cat] =[]
@export var cat_scene: PackedScene 

@onready var grid_manager: GridManager = $"../GridManager"


func _ready() -> void:
	GameLoop.phase_changed.connect(_on_phase_changed)

func place_cat(cat: Cat) -> void:
	var cell = grid_manager.rand_cell()
	
	var pos = grid_manager.get_cell_center(cell)
	cat.position = pos

func cat_action() -> void:
	for c in cats:
		c.think(grid_manager)

##FIXME
func _on_facility_use_finished(cat: Cat) -> void:
	var mood = cat.calculate_score(grid_manager, cats)
	GameManager.log_mood(cat, cat.current_facility, mood) 
	cat.start_idle(randf_range(0.0, 4.0))
	
func _on_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.PREP:
		pass
	elif phase == GameLoop.Phase.DAY:
		cat_datas = GameManager.todays_cats
		#for cat in cat_datas:
			#print(cat.cat_name)
		spawn_cats()
	elif phase == GameLoop.Phase.RESULT:
		for cat in cats:
			cat.set_process(false)
		process_day_end()

func spawn_cats() -> void:
	var existing_data = cats.map(func(c): return c.data)
	
	for cat_data in cat_datas:
		if cat_data in existing_data:
			var resident: Cat = cats.filter(func(c): return c.data == cat_data)[0]
			resident.set_process(true)
			resident.start_idle(randf_range(0.0, 4.0))
		else:
			var new_cat: Cat = cat_scene.instantiate()
			new_cat.setup(cat_data)
			#print(cat.cat_name + " is staying for " + str(new_cat.stay_duration))
			new_cat.facility_use_finished.connect(_on_facility_use_finished)
			new_cat.needs_think.connect(_on_cat_needs_think)
			new_cat.needs_wander.connect(_on_cat_needs_wander)
			add_child(new_cat)
			cats.append(new_cat)
			place_cat(new_cat)
			new_cat.start_idle(randf_range(1.0, 4.0))

func _on_cat_needs_think(cat: Cat) -> void:
	cat.think(grid_manager)

func _on_cat_needs_wander(cat: Cat) -> void:
	var cell = grid_manager.rand_cell()
	cat.walk_to(cell, grid_manager.get_cell_center(cell), Cat.MoveReason.WANDER)

func process_day_end() -> void:
	GameManager.resident_cats.clear()
	var cat_to_remove: Array[Cat] = []
	
	for cat in cats: 
		cat.stay_duration -= 1
		if cat.stay_duration > 0:
			GameManager.resident_cats.append(cat.data)
		else:
			cat_to_remove.append(cat)
			
	for cat in cat_to_remove:
		process_checkout(cat)
	
	GameManager.finalize_income()
		
func process_checkout(cat: Cat) -> void:
	var base: float = cat.data.get_base_payment()
	GameManager.calculate_income(base, cat.mood)
	cats.erase(cat)
	cat.queue_free()
	
##FIXME
func show_result() -> void:
	pass
