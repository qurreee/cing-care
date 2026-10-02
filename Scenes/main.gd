extends Node2D

@onready var grid_manager: GridManager = $GridManager
@onready var cat_list: Label = $CanvasLayer/UI/CatList
@onready var day_phase: Label = $CanvasLayer/UI/DayPhase
@onready var pause_ui: Control = $CanvasLayer/UI/PauseUI

func _ready() -> void:
	update_label()
	GameLoop.phase_changed.connect(_on_phase_changed)
	pause_ui.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit"):
		get_tree().quit()
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func _on_next_phase_button_pressed() -> void:
	if GameLoop.current_phase == GameLoop.Phase.PREP:
		GameLoop.start_day()
	elif GameLoop.current_phase == GameLoop.Phase.DAY:
		GameLoop.end_day()
	elif GameLoop.current_phase == GameLoop.Phase.RESULT:
		GameLoop.next_day()
		update_label()

func _on_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.DAY:
		day_phase.text = "DAY"
	elif phase == GameLoop.Phase.RESULT:
		day_phase.text = "RESULT"
	elif phase == GameLoop.Phase.PREP:
		day_phase.text = "PREPARATION"

func update_label() -> void:
	var list: String = ""
	for cat in GameManager.todays_cats:
		list += cat.cat_name + "\n"
	cat_list.text = list

func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	pause_ui.visible = get_tree().paused


func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_ui.hide()
