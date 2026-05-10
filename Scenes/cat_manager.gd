extends Node2D
class_name CatManager

var cat_datas: Array[CatData] = []
var cats: Array[Cat] =[]
@export var cat_scene: PackedScene 

@onready var grid_manager: GridManager = $"../GridManager"

var day_score: float = 0.0

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
	day_score += score
	cat.state = Cat.State.IDLE
	print(cat.data.cat_name,": daySCORE ", day_score)
	
func _on_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.DAY:
		cat_datas = GameManager.todays_cats
		spawn_cats()
		cat_action()
	elif phase == GameLoop.Phase.RESULT:
		clear_cats()

func spawn_cats() -> void:
	for cat in cat_datas:
		var new_cat: Cat = cat_scene.instantiate()
		new_cat.setup(cat)
		new_cat.facility_use_finished.connect(_on_facility_use_finished)
		add_child(new_cat)
		cats.append(new_cat)
		place_cat(new_cat)

func clear_cats() -> void:
	for c in cats:
		c.queue_free()
	cats.clear()
	
