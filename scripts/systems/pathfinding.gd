extends Node
class_name Pathfinding

# Paramètres de la grille
var grid_width: int = 50
var grid_height: int = 50
var cell_size: int = 32

# Obstacles
var obstacles: Array = []

class Node:
	var pos: Vector2i
	var g: float = 0.0
	var h: float = 0.0
	var parent: Node = null
	
	func _init(p_pos: Vector2i):
		pos = p_pos
	
	func f() -> float:
		return g + h

func _ready():
	print("Pathfinding system initialized")

func find_path(start: Vector2i, end: Vector2i) -> Array:
	var open_set: Array = []
	var closed_set: Array = []
	
	var start_node = Node.new(start)
	start_node.h = heuristic(start, end)
	open_set.append(start_node)
	
	while open_set.size() > 0:
		# Trouver le nœud avec le plus petit f
		var current_idx = 0
		for i in range(open_set.size()):
			if open_set[i].f() < open_set[current_idx].f():
				current_idx = i
		
		var current = open_set[current_idx]
		
		if current.pos == end:
			return reconstruct_path(current)
		
		open_set.remove_at(current_idx)
		closed_set.append(current)
		
		# Vérifier les voisins
		for neighbor_pos in get_neighbors(current.pos):
			if is_walkable(neighbor_pos):
				var neighbor = Node.new(neighbor_pos)
				neighbor.g = current.g + 1.0
				neighbor.h = heuristic(neighbor_pos, end)
				neighbor.parent = current
				
				open_set.append(neighbor)
	
	return []  # Pas de chemin trouvé

func get_neighbors(pos: Vector2i) -> Array:
	var neighbors: Array = []
	var directions = [
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i.LEFT,
		Vector2i.RIGHT,
		Vector2i(1, 1),    # Diagonales
		Vector2i(1, -1),
		Vector2i(-1, 1),
		Vector2i(-1, -1)
	]
	
	for dir in directions:
		var neighbor_pos = pos + dir
		if is_within_bounds(neighbor_pos):
			neighbors.append(neighbor_pos)
	
	return neighbors

func heuristic(pos1: Vector2i, pos2: Vector2i) -> float:
	# Distance de Manhattan
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)

func is_walkable(pos: Vector2i) -> bool:
	if not is_within_bounds(pos):
		return false
	
	for obstacle in obstacles:
		if obstacle == pos:
			return false
	
	return true

func is_within_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < grid_width and pos.y >= 0 and pos.y < grid_height

func reconstruct_path(node: Node) -> Array:
	var path: Array = []
	var current = node
	
	while current != null:
		path.insert(0, current.pos)
		current = current.parent
	
	return path

func add_obstacle(pos: Vector2i):
	if pos not in obstacles:
		obstacles.append(pos)

func remove_obstacle(pos: Vector2i):
	obstacles.erase(pos)
