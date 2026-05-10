extends Node2D
class_name FacilityManager

var owned_facilities: Array[FacilityData]
@export var facility_scene: PackedScene 
@onready var grid_manager: GridManager = $"../GridManager"


var held_facility: Facility = null
var held_from_cell: Vector2i
var has_spawned: bool = false

func _ready() -> void:
	GameLoop.phase_changed.connect(_on_phase_changed)
	_on_phase_changed(GameLoop.Phase.PREP)

func _on_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.PREP and not has_spawned:
		spawn_facilities(GameManager.get_owned_facility_datas())
		has_spawned = true

func spawn_facilities(facility_datas: Array[FacilityData]) -> void:
	for data in facility_datas:
		place_facility(data)


func _input(event: InputEvent) -> void:
	if GameLoop.current_phase != GameLoop.Phase.PREP:
		return
	if not event is InputEventMouseButton:
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	
	if held_facility:
		# second click — drop
		var cell = grid_manager.world_to_grid(get_global_mouse_position())
		drop_at(cell)
	else:
		# first click — try pick up
		var cell = grid_manager.world_to_grid(get_global_mouse_position())
		if grid_manager.grid.has(cell):
			pick_up(grid_manager.grid[cell])

func place_facility(facility: FacilityData) -> void:
	var cell = grid_manager.rand_cell()
	while not grid_manager.is_cell_free(cell):
		cell = grid_manager.rand_cell()
		
	var instance: Facility = facility_scene.instantiate()
	add_child(instance)
	instance.setup(facility, cell)
	grid_manager.place_facility(cell, instance)
	print("placed facilty ", facility.facility_name, " ", cell)

func add_facility(facility_data: FacilityData) -> void:
	place_facility(facility_data)

func pick_up(facility: Facility) -> void:
	held_facility = facility
	held_from_cell = facility.cell
	held_facility.is_held = true
	grid_manager.grid.erase(held_from_cell)
	print("picked Up ",held_facility.data.facility_name, " ", held_facility.is_held )

func drop_at(cell: Vector2i) -> void:
	held_facility.is_held = false
	if grid_manager.is_cell_free(cell):
		grid_manager.place_facility(cell, held_facility)
		held_facility.setup(held_facility.data, cell)
	else:
		grid_manager.place_facility(held_from_cell, held_facility)
		held_facility.setup(held_facility.data, held_from_cell)
	held_facility = null
