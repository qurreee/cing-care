extends CharacterBody2D
class_name Cat

var current_facility: Facility = null
var target_cell: Vector2

var MOVE_SPEED: float = 80.0
var is_moving: bool = false



var state: State = State.IDLE
enum State {
	IDLE,
	WALKING,
	USING_FACILITY,
	UNHAPPY
}

var prev_need: Enums.Needs = Enums.Needs.FREE 
var current_need: Enums.Needs 

var need_weights : Dictionary[Enums.Needs, float]= {
	Enums.Needs.FOOD: 10.0,
	Enums.Needs.WATER: 1.0,
	Enums.Needs.SLEEP: 10.0, 
	Enums.Needs.PLAY: 1.0
}

func think(grid_manager: GridManager) -> void:
	get_weighted_need()
	var target :Array = grid_manager.get_facilities_by_type(current_need)
	print(target)
	
	if target:
		move_to(grid_manager.get_cell_center(target[0].cell))

func move_to(cell: Vector2) -> void:
	target_cell = cell
	is_moving = true
	state = State.WALKING

func _process(delta: float) -> void:
	if is_moving:
		position = position.move_toward(target_cell, MOVE_SPEED * delta)
		if position.is_equal_approx(target_cell):
			is_moving = false
			state = State.IDLE
			on_arrived()

func on_arrived() -> void:
	state = State.USING_FACILITY
	

func get_weighted_need() -> void:
	var total_weight := 0.0
	
	for w in need_weights.values():
		total_weight += w
		
	var roll = randf() * total_weight
	var cumulative := 0.0
	
	for need in need_weights:
		cumulative += need_weights[need]
		
		if roll <= cumulative:
			prev_need = current_need
			current_need = need
			return
	print(current_need)
