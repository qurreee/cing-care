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

func _on_facility_use_finished(cat: Cat) -> void:
	var score = cat.calculate_score(grid_manager)
	GameManager.log_score(cat, cat.current_facility, score) 
	cat.start_idle(randf_range(2.0, 4.0))
	print(cat.data.cat_name,": daySCORE ", GameManager.day_score)
	
func _on_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.DAY:
		cat_datas = GameManager.todays_cats
		spawn_cats()
	elif phase == GameLoop.Phase.RESULT:
		for cat in cats:
			cat.set_process(false)
		show_result()
	elif phase == GameLoop.Phase.PREP:
		clear_cats()

func spawn_cats() -> void:
	for cat in cat_datas:
		var new_cat: Cat = cat_scene.instantiate()
		new_cat.setup(cat)
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

func clear_cats() -> void:
	for c in cats:
		c.queue_free()
	cats.clear()

func show_result() -> void:
	print("Today's Score: ", GameManager.day_score)
