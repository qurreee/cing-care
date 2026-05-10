extends CharacterBody2D
class_name Cat

var data: CatData

var current_cell: Vector2i
var target_cell: Vector2i
var target_pos: Vector2

var MOVE_SPEED: float = 80.0
var is_moving: bool = false

var use_duration: float = 3.0  # how long cat uses a facility
var use_timer: float = 0.0
signal facility_use_finished(cat: Cat)

var state: State = State.IDLE
enum State {
	IDLE,
	WALKING,
	USING_FACILITY,
	DONE_USING,
	UNHAPPY
}

var prev_need: Enums.Needs = Enums.Needs.FREE 
var current_need: Enums.Needs 

func setup(cat_data: CatData) -> void:
	data = cat_data

func think(grid_manager: GridManager) -> void:
	get_weighted_need()
	var target :Array = grid_manager.get_facilities_by_type(current_need)
	
	if target:
		move_to(target[0].cell, grid_manager.get_cell_center(target[0].cell))

func move_to(cell: Vector2i, pos: Vector2) -> void:
	target_cell = cell
	target_pos = pos
	is_moving = true
	state = State.WALKING

func _process(delta: float) -> void:
	if is_moving:
		position = position.move_toward(target_pos, MOVE_SPEED * delta)
		if position.is_equal_approx(target_pos):
			is_moving = false
			state = State.IDLE
			on_arrived()
	
	if state == State.USING_FACILITY:
		use_timer -= delta
		if use_timer <= 0.0:
			state = State.DONE_USING
			emit_signal("facility_use_finished", self) 

func on_arrived() -> void:
	state = State.USING_FACILITY
	use_timer = use_duration
	current_cell = target_cell
	target_cell = Vector2i(-1, -1)

func get_weighted_need() -> void:
	var total_weight := 0.0
	
	for w in data.need_weights.values():
		total_weight += w
		
	var roll = randf() * total_weight
	var cumulative := 0.0
	
	for need in data.need_weights:
		cumulative += data.need_weights[need]
		
		if roll <= cumulative:
			prev_need = current_need
			current_need = need
			return
	print(current_need)

func calculate_score(grid_manager: GridManager) -> float:
	var score : float = 0.0
	for rule in data.rules:
		score += rule.evaluate(self, grid_manager)
	print(score, " calc")
	return score
	
