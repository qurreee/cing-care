extends Camera2D


@onready var grid_manager: GridManager = $"../GridManager"

var zoom_speed: float = 0.1
var zoom_min: float = 0.7
var zoom_max: float = 1.5

var drag_sensitivity: float = 1.0
var padding: float = 1000.0  # how far camera can move from grid center

var grid_center: Vector2


func _ready() -> void:
	update_grid_center()
	position = grid_center


func update_grid_center() -> void:
	if grid_manager == null:
		return
	
	var origin = grid_manager.GRID_ORIGIN
	var size = grid_manager.GRID_SIZE
	var cell = grid_manager.CELL_SIZE
	
	grid_center = origin + Vector2(size) * cell * 0.5


func _unhandled_input(event: InputEvent) -> void:
	# Drag with middle mouse
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		position -= event.relative * drag_sensitivity / zoom
		clamp_camera()

	# Zoom with scroll
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 0.9
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= 1.1

		zoom = zoom.clamp(
			Vector2(zoom_min, zoom_min),
			Vector2(zoom_max, zoom_max)
		)

		clamp_camera()


func clamp_camera() -> void:
	position.x = clamp(position.x, grid_center.x - padding, grid_center.x + padding)
	position.y = clamp(position.y, grid_center.y - padding, grid_center.y + padding)
