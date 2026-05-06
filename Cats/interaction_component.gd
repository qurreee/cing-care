extends Node2D

@export var need_comp: NeedComponent
var FEED_AMOUNT : int = 20

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if need_comp:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				need_comp.feed(FEED_AMOUNT)
