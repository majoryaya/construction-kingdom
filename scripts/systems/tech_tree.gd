extends Node
class_name TechTree

# Dictionnaire des technologies
var technologies: Dictionary = {}
var unlocked_techs: Array = []
var research_points: int = 0

# Signaux
signal tech_unlocked(tech_name: String)
signal research_completed(tech_name: String)

func _ready():
	print("TechTree initialized")
	initialize_tech_tree()

func initialize_tech_tree():
	"""Initialise l'arbre technologique"""
	# Technologie de base
	add_technology("basic_farm", "Ferme Basique", 10, [])
	add_technology("basic_house", "Maison Basique", 5, [])
	add_technology("stone_mine", "Mine de Pierre", 20, ["basic_farm"])
	add_technology("lumber_mill", "Scierie", 15, ["basic_farm"])
	add_technology("market", "Marché", 30, ["basic_house", "basic_farm"])
	add_technology("tavern", "Taverne", 25, ["basic_house"])
	add_technology("guard_tower", "Tour de Garde", 40, ["stone_mine"])

add_technology("library", "Bibliothèque", 35, ["market"])

func add_technology(tech_id: String, tech_name: String, cost: int, requirements: Array):
	"""Ajoute une technologie à l'arbre"""
	var tech = Technology.new()
	tech.id = tech_id
	tech.name = tech_name
	tech.research_cost = cost
	tech.requirements = requirements
	technologies[tech_id] = tech

func can_unlock(tech_id: String) -> bool:
	"""Vérifie si une technologie peut être débloquée"""
	if tech_id not in technologies:
		return false
	
	var tech = technologies[tech_id]
	
	# Vérifier les prérequis
	for requirement in tech.requirements:
		if requirement not in unlocked_techs:
			return false
	
	return true

func unlock_technology(tech_id: String) -> bool:
	"""Débloque une technologie"""
	if tech_id in unlocked_techs:
		return false
	
	if not can_unlock(tech_id):
		return false
	
	if tech_id not in technologies:
		return false
	
	var tech = technologies[tech_id]
	
	if research_points < tech.research_cost:
		return false
	
	research_points -= tech.research_cost
	unlocked_techs.append(tech_id)
	tech_unlocked.emit(tech_id)
	return true

func add_research_points(amount: int):
	"""Ajoute des points de recherche"""
	research_points += amount

func get_available_techs() -> Array:
	"""Retourne les technologies disponibles à débloquer"""
	var available: Array = []
	for tech_id in technologies:
		if tech_id not in unlocked_techs and can_unlock(tech_id):
			available.append(tech_id)
	return available

func is_unlocked(tech_id: String) -> bool:
	return tech_id in unlocked_techs

func get_unlocked_buildings() -> Array:
	"""Retourne les bâtiments débloqués"""
	var buildings: Array = []
	for tech_id in unlocked_techs:
		if technologies[tech_id].is_building:
			buildings.append(tech_id)
	return buildings

func update(delta: float):
	# Générer des points de recherche passivement
	if randf() > 0.95:
		add_research_points(1)

class Technology:
	var id: String
	var name: String
	var research_cost: int
	var requirements: Array
	var is_building: bool = true
	var description: String = ""
