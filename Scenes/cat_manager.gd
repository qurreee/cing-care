extends Node2D
class_name CatManager

@export var cats: Array[Cat] =[]
@export var cat_scene: PackedScene 

@onready var grid_manager: GridManager = $"../GridManager"

func _ready() -> void:
	for i in 2:
		var new_cat = cat_scene.instantiate()
		add_child(new_cat)
		cats.append(new_cat)
		place_cat(new_cat)
		
	cat_action()
	
func place_cat(cat: Cat) -> void:
	var cell = grid_manager.rand_cell()
	
	var pos = grid_manager.get_cell_center(cell)
	cat.position = pos

func _test_move() -> void:
	for cell in grid_manager.grid:
		var facility = grid_manager.grid[cell]
		if facility.data.id == "feeding_station":
			cats[0].move_to(grid_manager.get_cell_center(facility.cell))
			return

func cat_action() -> void:
	for c in cats:
		c.think(grid_manager)
