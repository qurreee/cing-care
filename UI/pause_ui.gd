extends Control

const MAIN_MENU = preload("uid://cs1ybq8hgnlcv")



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	visible = get_tree().paused
	


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU)
