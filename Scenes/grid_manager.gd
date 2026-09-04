extends Node2D
class_name GridManager

var grid: Dictionary[Vector2i, Facility] = {}
const GAME_CONFIG = preload("uid://c8k7kyedtsqnh")


var GRID_SIZE: Vector2i 
var CELL_SIZE: int = 128
var GRID_ORIGIN: Vector2 = Vector2(100,100)
@export var show_debug: bool = false

func _ready() -> void:
	#debug()
	GRID_SIZE = GAME_CONFIG.GRID_SIZE
	center_grid()
	queue_redraw()
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var cell = get_cell_from_mouse()
			
			if not is_inside_grid(cell): 
				return
			
			if grid.has(cell):
				print("facility exist ", grid[cell].data.facility_name)
			else:
				print("empty")
			
			
			print("Cell : ", cell)

func is_cell_free(cell: Vector2i) -> bool:
	return not grid.has(cell)

func place_facility(cell: Vector2i, facility: Facility) -> void:
	if not is_cell_free(cell):
		print("cell occupied, ", cell)
	
	grid[cell] = facility
	var pos = get_cell_center(cell)
	grid[cell].position = pos

func move_facility() -> void:
	pass

func get_cell_from_mouse():
	var mouse_pos = get_global_mouse_position()
	var local = mouse_pos - GRID_ORIGIN

	return Vector2i(int
	(local.x / CELL_SIZE),
	(local.y / CELL_SIZE)
	)

func _draw() -> void:
	if not show_debug:
		return

	for x in GRID_SIZE.x:
		for y in GRID_SIZE.y:
			var pos = GRID_ORIGIN + Vector2(x, y) * CELL_SIZE
			var rect = Rect2(pos, Vector2(CELL_SIZE, CELL_SIZE))

			draw_rect(rect, Color.WHITE, false, 2.0)

func grid_to_world(pos: Vector2i) -> Vector2:
	return GRID_ORIGIN +  Vector2(pos) * CELL_SIZE

func world_to_grid(pos: Vector2) -> Vector2i:
	var local = pos - GRID_ORIGIN
	return Vector2i(floor(local / CELL_SIZE))

func center_grid() -> void:
	var viewport_size = get_viewport_rect().size
	var grid_pixel_size = Vector2(GRID_SIZE) * CELL_SIZE
	GRID_ORIGIN = (viewport_size - grid_pixel_size) / 2

func get_cell_center(cell: Vector2i) -> Vector2:
	var pos = grid_to_world(cell)
	var x = pos.x + 0.5 * CELL_SIZE
	var y = pos.y + 0.5 * CELL_SIZE
	return Vector2(x,y)

func get_bounds() -> Array:
	var min_bound := GRID_ORIGIN
	var max_bound := GRID_ORIGIN + (Vector2(GRID_SIZE) * CELL_SIZE)
	return [min_bound, max_bound]

func is_inside_grid(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 \
	and cell.x < GRID_SIZE.x \
	and cell.y < GRID_SIZE.y

func rand_cell() -> Vector2i:
	var x = randi_range(0, GRID_SIZE.x -1)
	var y = randi_range(0, GRID_SIZE.y -1)
	
	return Vector2i(x,y)
	
func get_facilities_by_type(type: Enums.Needs) -> Array:
	var result: Array = []
	
	for cell in grid:
		var facility = grid[cell]
		if facility.data.type == type:
			result.append(facility)
			
	return result
	
#func search_facility_pos() -> 
