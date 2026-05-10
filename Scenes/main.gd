extends Node2D

@onready var grid_manager: GridManager = $GridManager
@onready var cat_list: Label = $CanvasLayer/UI/CatList
@onready var day_phase: Label = $CanvasLayer/UI/DayPhase

func _ready() -> void:
	update_label()

func _on_next_phase_button_pressed() -> void:
	if GameLoop.current_phase == GameLoop.Phase.PREP:
		GameLoop.start_day()
		update_label()
		day_phase.text = "DAY"
	elif GameLoop.current_phase == GameLoop.Phase.DAY:
		GameLoop.end_day()
		day_phase.text = "RESULT"
	elif GameLoop.current_phase == GameLoop.Phase.RESULT:
		GameLoop.next_day()
		day_phase.text = "PREP"


func update_label() -> void:
	var list: String = ""
	for cat in GameManager.todays_cats:
		list += cat.cat_name + "\n"
	cat_list.text = list
