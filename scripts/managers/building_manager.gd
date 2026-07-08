extends Node
class_name BuildingManager

# Dictionnaire des bâtiments placés
var buildings: Dictionary = {}
var building_count: int = 0

# Grille de placement
var grid_width: int = 50
var grid_height: int = 50
var occupied_cells: Array = []

# Signaux
signal building_placed(building: Building)
signal building_removed(building: Building)
signal invalid_placement

func _ready():
	print("BuildingManager initialized")

func can_place_building(grid_pos: Vector2i, building_size: Vector2i) -> bool:
	"""Vérifie si on peut placer un bâtiment à cette position"""
	if not is_within_bounds(grid_pos, building_size):
		return false
	
	for x in range(grid_pos.x, grid_pos.x + building_size.x):
		for y in range(grid_pos.y, grid_pos.y + building_size.y):
			if Vector2i(x, y) in occupied_cells:
				return false
	
	return true

func place_building(building_type: String, grid_pos: Vector2i, building_size: Vector2i) -> bool:
	"""Place un bâtiment sur la grille"""
	if not can_place_building(grid_pos, building_size):
		invalid_placement.emit()
		return false
	
	var building = Building.new()
	building.building_type = building_type
	building.grid_pos = grid_pos
	building.size = building_size
	building.id = building_count
	building_count += 1
	
	# Marquer les cellules comme occupées
	for x in range(grid_pos.x, grid_pos.x + building_size.x):
		for y in range(grid_pos.y, grid_pos.y + building_size.y):
			occupied_cells.append(Vector2i(x, y))
	
	buildings[building.id] = building
	building_placed.emit(building)
	return true

func remove_building(building_id: int) -> bool:
	"""Supprime un bâtiment de la grille"""
	if building_id not in buildings:
		return false
	
	var building = buildings[building_id]
	
	# Libérer les cellules
	for x in range(building.grid_pos.x, building.grid_pos.x + building.size.x):
		for y in range(building.grid_pos.y, building.grid_pos.y + building.size.y):
			occupied_cells.erase(Vector2i(x, y))
	
	buildings.erase(building_id)
	building_removed.emit(building)
	return true

func get_building(building_id: int) -> Building:
	return buildings.get(building_id, null)

func get_all_buildings() -> Dictionary:
	return buildings.duplicate()

func is_within_bounds(grid_pos: Vector2i, building_size: Vector2i) -> bool:
	return (grid_pos.x >= 0 and grid_pos.x + building_size.x <= grid_width and
			grid_pos.y >= 0 and grid_pos.y + building_size.y <= grid_height)

func update(delta: float):
	# Mettre à jour les bâtiments
	for building_id in buildings:
		buildings[building_id].update(delta)

class Building:
	var id: int
	var building_type: String
	var grid_pos: Vector2i
	var size: Vector2i
	var health: int = 100
	var is_completed: bool = false
	var construction_progress: float = 0.0
	var construction_time: float = 5.0
	
	func update(delta: float):
		if not is_completed:
			construction_progress += delta
			if construction_progress >= construction_time:
				is_completed = true
				construction_progress = construction_time
