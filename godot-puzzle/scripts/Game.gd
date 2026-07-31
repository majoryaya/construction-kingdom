extends Control

@export var grid_size: int = 3
var tiles := []
var empty_pos := Vector2.ZERO

func _ready() -> void:
	randomize()
	tiles.clear()
	create_ui()

func create_ui() -> void:
	var viewport_size = get_viewport_rect().size
	var margin = 12
	var tile_size = 120
	var total_w = tile_size * grid_size + margin * (grid_size - 1)
	var total_h = tile_size * grid_size + margin * (grid_size - 1)
	var start_x = max((viewport_size.x - total_w) / 2, 50)
	var start_y = max((viewport_size.y - total_h) / 2, 40)
	# remove previous children (useful when restarting)
	for child in get_children():
		child.queue_free()
	tiles = []
	for y in range(grid_size):
		tiles.append([])
		for x in range(grid_size):
			var idx = y * grid_size + x + 1
			var btn := Button.new()
			btn.rect_size = Vector2(tile_size, tile_size)
			btn.rect_position = Vector2(start_x + x * (tile_size + margin), start_y + y * (tile_size + margin))
			btn.name = "Tile_%d" % idx
			btn.text = str(idx)
			btn.add_theme_color_override("font_color", Color.black)
			btn.add_theme_color_override("font_color_pressed", Color.black)
			btn.connect("pressed", Callable(self, "_on_tile_pressed"), [x, y])
			add_child(btn)
			tiles[y].append(btn)
	# create restart button
	var restart := Button.new()
	restart.text = "Restart"
	restart.rect_size = Vector2(100, 36)
	restart.rect_position = Vector2(viewport_size.x - 120, 10)
	restart.connect("pressed", Callable(self, "_on_restart_pressed"))
	add_child(restart)
	# make last tile empty
	tiles[grid_size-1][grid_size-1].visible = false
	empty_pos = Vector2(grid_size - 1, grid_size - 1)
	shuffle_tiles()

func shuffle_tiles() -> void:
	var moves = grid_size * grid_size * 10
	for i in range(moves):
		var neighbors = get_neighbors(empty_pos)
		var pick = neighbors[randi() % neighbors.size()]
		swap_tiles(pick, empty_pos)
		empty_pos = pick
	# ensure shuffled state is not already solved
	if is_solved():
		shuffle_tiles()

func get_neighbors(pos: Vector2) -> Array:
	var n := []
	var dirs = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]
	for d in dirs:
		var p = pos + d
		if p.x >= 0 and p.x < grid_size and p.y >= 0 and p.y < grid_size:
			n.append(p)
	return n

func swap_tiles(a: Vector2, b: Vector2) -> void:
	var ax = int(a.x); var ay = int(a.y)
	var bx = int(b.x); var by = int(b.y)
	var at = tiles[ay][ax]
	var bt = tiles[by][bx]
	var apos = at.rect_position
	var bpos = bt.rect_position
	at.rect_position = bpos
	bt.rect_position = apos
	tiles[ay][ax] = bt
	tiles[by][bx] = at

func _on_tile_pressed(x: int, y: int) -> void:
	var pos = Vector2(x, y)
	if pos.distance_to(empty_pos) == 1:
		swap_tiles(pos, empty_pos)
		empty_pos = pos
		if is_solved():
			show_victory()

func is_solved() -> bool:
	var n = 1
	for y in range(grid_size):
		for x in range(grid_size):
			if y == grid_size - 1 and x == grid_size - 1:
				continue
			var t: Button = tiles[y][x]
			if t.text != str(n):
				return false
			n += 1
	return true

func show_victory() -> void:
	var popup := Label.new()
	popup.text = "Gagné !"
	popup.add_theme_color_override("font_color", Color(0,0.5,0))
	popup.rect_size = Vector2(300, 50)
	popup.rect_position = Vector2((get_viewport_rect().size.x - popup.rect_size.x) / 2, 10)
	add_child(popup)

func _on_restart_pressed() -> void:
	shuffle_tiles()
