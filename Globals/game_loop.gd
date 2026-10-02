extends Node

enum Phase {
	PREP,
	DAY,
	RESULT
}

var config: GameConfig = preload("uid://c8k7kyedtsqnh")

var current_phase: Phase = Phase.PREP
var day_number: int = 1

var day_timer: float
var _timer_remaining: float = 0.0

signal phase_changed(phase: Phase)

func _ready() -> void:
	day_timer = config.day_duration
	
func start_day() -> void:
	current_phase = Phase.DAY
	_timer_remaining = day_timer
	phase_changed.emit(Phase.DAY)

func end_day() -> void:
	current_phase = Phase.RESULT
	phase_changed.emit(Phase.RESULT)

func next_day() -> void:
	day_number += 1
	current_phase = Phase.PREP
	phase_changed.emit(Phase.PREP)

func _process(delta: float) -> void:
	if current_phase == Phase.DAY:
		_timer_remaining -= delta
		if _timer_remaining <= 0.0:
			end_day()
