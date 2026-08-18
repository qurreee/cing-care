extends Control
class_name ResultUI

@onready var day_label: Label = $backpanel/DayLabel
@onready var score_list: VBoxContainer = $backpanel/ScoreList
@onready var total_score_label: Label = $backpanel/TotalScoreLabel

func _ready() -> void:
	hide()
	GameLoop.phase_changed.connect(_on_phase_changed)

func _on_phase_changed(phase: GameLoop.Phase) -> void:
	if phase == GameLoop.Phase.RESULT:
		show_result()
	else:
		hide()

func show_result() -> void:
	show()
	day_label.text = "Day %d" % GameLoop.day_number
	
	for child in score_list.get_children():
		child.queue_free()
	
	for entry in GameManager.score_log:
		var label = Label.new()
		var prefix = "+" if entry.is_positive else ""
		label.text = "%s at %s: %s%1.f" % [entry.cat_name, entry.facility_name, prefix, entry.score]
		label.modulate = Color.GREEN if entry.is_positive else Color.RED
		score_list.add_child(label)
		
	total_score_label.text = str(0)
