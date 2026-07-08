extends Node2D
class_name GridSystem

# Paramètres de la grille
var grid_width: int = 50
var grid_height: int = 50
var cell_size: int = 32

# Caméra
var camera: Camera2D

# Marqueurs de grille
var grid_overlay: CanvasItem

func _ready():
	setup_camera()
	draw_grid()

func setup_camera():
	"""Configure la caméra isométrique"""
	camera = Camera2D.new()
	camera.zoom = Vector2(0.5, 0.5)
	camera.position = Vector2(grid_width * cell_size / 2, grid_height * cell_size / 2)
	add_child(camera)
	make_current()

func draw_grid():
	"""Dessine la grille sur le canvas"""
	queue_redraw()

func _draw():
	"""Redessine la grille"""
	var grid_color = Color(0.3, 0.3, 0.3, 0.5)
	
	# Lignes horizontales
	for y in range(grid_height + 1):
		var start = Vector2(0, y * cell_size)
		var end = Vector2(grid_width * cell_size, y * cell_size)
		draw_line(start, end, grid_color)
	
	# Lignes verticales
	for x in range(grid_width + 1):
		var start = Vector2(x * cell_size, 0)
		var end = Vector2(x * cell_size, grid_height * cell_size)
		draw_line(start, end, grid_color)

func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	"""Convertit une position écran en position grille"""
	var local_pos = get_local_mouse_position()
	var grid_x = int(local_pos.x / cell_size)
	var grid_y = int(local_pos.y / cell_size)
	return Vector2i(grid_x, grid_y)

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	"""Convertit une position grille en position écran"""
	return Vector2(
		grid_pos.x * cell_size + cell_size / 2,
		grid_pos.y * cell_size + cell_size / 2
	)

func is_valid_grid_position(grid_pos: Vector2i) -> bool:
	"""Vérifie si une position de grille est valide"""
	return (grid_pos.x >= 0 and grid_pos.x < grid_width and
			grid_pos.y >= 0 and grid_pos.y < grid_height)

func highlight_cell(grid_pos: Vector2i, color: Color = Color.GREEN):
	"""Surligne une cellule de grille"""
	var screen_pos = grid_to_screen(grid_pos)
	draw_rect(Rect2(screen_pos - Vector2(cell_size/2, cell_size/2), Vector2(cell_size, cell_size)), color)
