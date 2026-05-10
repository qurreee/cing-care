extends Node

enum Phase {
	PREP,
	DAY,
	RESULT
}

var current_phase: Phase = Phase.PREP
var day_number: int = 1
var day_timer: float = 60.0

signal phase_changed(phase: Phase)


func start_day() -> void:
	GameManager.generate_day()
	current_phase = Phase.DAY
	phase_changed.emit(Phase.DAY)

func end_day() -> void:
	current_phase = Phase.RESULT
	phase_changed.emit(Phase.RESULT)

func next_day() -> void:
	day_number += 1
	current_phase = Phase.PREP
	phase_changed.emit(Phase.PREP)
	
