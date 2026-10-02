extends Node2D
class_name Facility

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var facility_name_label: Label = $FacilityNameLabel


@export var data: FacilityData
var cell: Vector2i

var is_held: bool = false

func _ready() -> void:
	pass

func setup(facility_data: FacilityData, facility_cell: Vector2i) -> void:
	data = facility_data
	cell = facility_cell
	if data.sprite:
		sprite_2d.texture = data.sprite
	if data.facility_name:
		facility_name_label.text = data.facility_name
	facility_name_label.visible = false

func _process(delta: float) -> void:
	if is_held:
		global_position = get_global_mouse_position()


func _on_area_2d_mouse_entered() -> void:
	facility_name_label.visible = true


func _on_area_2d_mouse_exited() -> void:
	facility_name_label.visible = false
