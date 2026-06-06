extends CharacterBody2D
class_name Cat

var data: CatData

var current_cell: Vector2i
var current_facility: Facility
var target_cell: Vector2i
var target_pos: Vector2

var MOVE_SPEED: float = 80.0
var is_moving: bool = false

var use_timer: float = 0.0
signal facility_use_finished(cat: Cat)

var idle_timer: float = 0.0
var idle_duration: float = 0.0 
signal needs_think(cat: Cat)

var wander_timer: float = 0.0
signal needs_wander(cat: Cat)

var state: State = State.IDLE
enum State {
	IDLE,
	WALKING,
	USING_FACILITY,
	DONE_USING,
}

var move_reason: MoveReason = MoveReason.NONE
enum MoveReason {
	NONE,
	WANDER,
	GOING_TO_FACILITY
}

var prev_need: Enums.Needs = Enums.Needs.FREE 
var current_need: Enums.Needs 

func setup(cat_data: CatData) -> void:
	data = cat_data

func think(grid_manager: GridManager) -> void:
	get_weighted_need()
	var target :Array = grid_manager.get_facilities_by_type(current_need)
	
	if target:
		current_facility = target[0]
		walk_to(target[0].cell, grid_manager.get_cell_center(target[0].cell), MoveReason.GOING_TO_FACILITY)

func walk_to(cell: Vector2i, pos: Vector2, reason: MoveReason) -> void:
	target_cell = cell
	target_pos = pos
	is_moving = true
	state = State.WALKING
	move_reason = reason

func _process(delta: float) -> void:
	if is_moving:
		position = position.move_toward(target_pos, MOVE_SPEED * delta)
		if position.is_equal_approx(target_pos):
			is_moving = false
			state = State.IDLE
			_on_arrived()
	
	if state == State.USING_FACILITY:
		use_timer -= delta
		if use_timer <= 0.0:
			state = State.IDLE
			facility_use_finished.emit(self)
	
	if state == State.IDLE:
		idle_timer -= delta
		wander_timer -= delta
		
		if wander_timer <= 0.0:
			wander_timer = randf_range(3.0, 7.0)
			_wander()
		
		if idle_timer <= 0.0:
			idle_timer = 999.0
			needs_think.emit(self)

func start_idle(duration: float) -> void:
	state = State.IDLE
	idle_timer = duration
	wander_timer = randf_range(1.0, duration)
	current_facility = null

func _wander() -> void:
	needs_wander.emit(self)

func _on_arrived() -> void:
	current_cell = target_cell
	target_cell = Vector2i(-1, -1)
	
	match move_reason:
		MoveReason.GOING_TO_FACILITY:
			state = State.USING_FACILITY
			use_timer = randf_range(3.0, 6.0) 
		MoveReason.WANDER:
			state = State.IDLE
			idle_timer = randf_range(1.0, 2.0)
			current_facility = null 
	move_reason = MoveReason.NONE
	

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
	for rule: CatRule in data.rules:
		score += rule.evaluate(self, grid_manager)
	print(score, " calc")
	return score
	
