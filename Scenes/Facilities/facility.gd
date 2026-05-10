extends Node2D
class_name Facility

@export var data: FacilityData
var cell: Vector2i

var is_held: bool = false

func _ready() -> void:
	pass

func setup(facility_data: FacilityData, facility_cell: Vector2i) -> void:
	data = facility_data
	cell = facility_cell

func _process(delta: float) -> void:
	if is_held:
		global_position = get_global_mouse_position()
