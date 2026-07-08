extends Node2D
class_name BuildingBase

# Propriétés du bâtiment
@export var building_type: String = "basic_building"
@export var grid_position: Vector2i = Vector2i.ZERO
@export var building_size: Vector2i = Vector2i(1, 1)
@export var construction_time: float = 5.0
@export var health: int = 100
@export var resource_cost: Dictionary = {}

# État
var is_completed: bool = false
var construction_progress: float = 0.0
var current_health: int = 100

# Signaux
signal construction_started
signal construction_completed
signal building_damaged(damage: int)

func _ready():
	construction_started.emit()
	current_health = health

func _process(delta: float):
	if not is_completed:
		update_construction(delta)

func update_construction(delta: float):
	"""Met à jour la progression de la construction"""
	construction_progress += delta
	var progress_percent = (construction_progress / construction_time) * 100.0
	
	if construction_progress >= construction_time:
		is_completed = true
		construction_completed.emit()
		print("%s complété!" % building_type)

func take_damage(damage: int):
	"""Applique des dégâts au bâtiment"""
	if not is_completed:
		return
	
	current_health -= damage
	building_damaged.emit(damage)
	
	if current_health <= 0:
		destroy_building()

func repair(amount: int):
	"""Répare le bâtiment"""
	current_health = min(current_health + amount, health)

func destroy_building():
	"""Détruit le bâtiment"""
	print("%s destroyed!" % building_type)
	queue_free()

func get_building_info() -> Dictionary:
	"""Retourne les informations du bâtiment"""
	return {
		"type": building_type,
		"position": grid_position,
		"size": building_size,
		"completed": is_completed,
		"progress": construction_progress / construction_time,
		"health": current_health,
		"max_health": health
	}
