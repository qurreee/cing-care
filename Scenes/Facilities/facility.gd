extends Node2D
class_name Facility

@export var data: FacilityData
var cell: Vector2i


func _ready() -> void:
	pass

func setup(facility_data: FacilityData, facility_cell: Vector2i) -> void:
	data = facility_data
	cell = facility_cell
