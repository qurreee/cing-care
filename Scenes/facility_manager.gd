extends Node2D
class_name FacilityManager

@export var facilities: Array[FacilityData]
var owned_facilities: Array[FacilityData]
@export var facility_scene: PackedScene 
@onready var grid_manager: GridManager = $"../GridManager"


func _ready() -> void:
	for facility in facilities:
		if GameManager.is_facility_owned(facility.id):
			owned_facilities.append(facility)
			
	for f in owned_facilities:
		place_facility(f)
	

func place_facility(facility: FacilityData) -> void:
	var cell = grid_manager.rand_cell()
	while not grid_manager.is_cell_free(cell):
		cell = grid_manager.rand_cell()
		
	var instance: Facility = facility_scene.instantiate()
	add_child(instance)
	instance.setup(facility, cell)
	grid_manager.place_facility(cell, instance)
	print("placed facilty ", facility.facility_name, " ", cell)
	
	
