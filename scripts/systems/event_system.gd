extends Node
class_name EventSystem

# Types d'événements
const EVENT_TYPES = {
	"PLAGUE": "plague",
	"ABUNDANCE": "abundance",
	"RAID": "raid",
	"DISCOVERY": "discovery",
	"FAMINE": "famine",
	"CELEBRATION": "celebration",
	"ACCIDENT": "accident",
	"TRADE": "trade"
}

# Gestionnaire d'événements
var events_queue: Array = []
var current_event: Dictionary = {}
var event_timer: float = 0.0
var event_duration: float = 0.0

# Probabilités d'événements (par seconde)
var event_probability: float = 0.02  # 2% de chance par seconde

# Signaux
signal event_triggered(event: Dictionary)
signal event_completed(event: Dictionary)

func _ready():
	print("EventSystem initialized")

func _process(delta: float):
	if not current_event.is_empty():
		update_event(delta)
	elif randf() < event_probability:
		trigger_random_event()

func trigger_random_event():
	"""Déclenche un événement aléatoire"""
	var event_types = EVENT_TYPES.values()
	var random_event = event_types[randi() % event_types.size()]
	trigger_event(random_event)

func trigger_event(event_type: String):
	"""Déclenche un événement spécifique"""
	current_event = create_event(event_type)
	event_timer = 0.0
	event_triggered.emit(current_event)
	print("Événement déclenché: ", current_event.name)

func create_event(event_type: String) -> Dictionary:
	"""Crée un événement selon son type"""
	match event_type:
		EVENT_TYPES.PLAGUE:
			return {
				"type": event_type,
				"name": "🦠 Épidémie!",
				"description": "Une épidémie ravage le village",
				"duration": 30.0,
				"effect": "damage_villagers",
				"intensity": 5
			}
		EVENT_TYPES.ABUNDANCE:
			return {
				"type": event_type,
				"name": "🌾 Récolte abondante!",
				"description": "Les récoltes sont exceptionnelles",
				"duration": 20.0,
				"effect": "increase_resources",
				"intensity": 50
			}
		EVENT_TYPES.RAID:
			return {
				"type": event_type,
				"name": "⚔️ Raid!",
				"description": "Des bandits attaquent le village!",
				"duration": 25.0,
				"effect": "steal_resources",
				"intensity": 30
			}
		EVENT_TYPES.DISCOVERY:
			return {
				"type": event_type,
				"name": "💎 Découverte!",
				"description": "On a découvert un trésor!",
				"duration": 15.0,
				"effect": "find_treasure",
				"intensity": 100
			}
		EVENT_TYPES.FAMINE:
			return {
				"type": event_type,
				"name": "😢 Famine!",
				"description": "Les provisions s'épuisent",
				"duration": 35.0,
				"effect": "decrease_food",
				"intensity": 40
			}
		EVENT_TYPES.CELEBRATION:
			return {
				"type": event_type,
				"name": "🎉 Fête!",
				"description": "Les villageois sont heureux!",
				"duration": 20.0,
				"effect": "increase_happiness",
				"intensity": 25
			}
		EVENT_TYPES.ACCIDENT:
			return {
				"type": event_type,
				"name": "💥 Accident!",
				"description": "Un bâtiment a été endommagé",
				"duration": 10.0,
				"effect": "damage_building",
				"intensity": 20
			}
		EVENT_TYPES.TRADE:
			return {
				"type": event_type,
				"name": "🤝 Commerce!",
				"description": "Des marchands arrivent au village",
				"duration": 30.0,
				"effect": "trade_opportunity",
				"intensity": 15
			}
		_:
			return {}

func update_event(delta: float):
	"""Met à jour l'événement en cours"""
	event_timer += delta
	
	if event_timer >= current_event.duration:
		complete_event()

func complete_event():
	"""Termine l'événement en cours"""
	if not current_event.is_empty():
		event_completed.emit(current_event)
		print("Événement terminé: ", current_event.name)
		current_event = {}
		event_timer = 0.0

func apply_event_effect(event: Dictionary, managers: Dictionary) -> bool:
	"""Applique les effets d'un événement"""
	var resource_manager = managers.get("resources")
	var villager_manager = managers.get("villagers")
	var building_manager = managers.get("buildings")
	
	if resource_manager == null or villager_manager == null:
		return false
	
	match event.effect:
		"damage_villagers":
			for villager_id in villager_manager.villagers:
				var villager = villager_manager.villagers[villager_id]
				villager.take_damage(event.intensity)
			return true
		
		"increase_resources":
			resource_manager.add_resource("food", event.intensity)
			return true
		
		"steal_resources":
			resource_manager.remove_resource("gold", event.intensity)
			return true
		
		"find_treasure":
			resource_manager.add_resource("gold", event.intensity)
			return true
		
		"decrease_food":
			resource_manager.remove_resource("food", event.intensity)
			return true
		
		"increase_happiness":
			for villager_id in villager_manager.villagers:
				var villager = villager_manager.villagers[villager_id]
				villager.set_happiness(villager.current_happiness + event.intensity)
			return true
		
		"damage_building":
			if not building_manager == null and building_manager.buildings.size() > 0:
				var random_building_id = building_manager.buildings.keys()[randi() % building_manager.buildings.size()]
				var building = building_manager.buildings[random_building_id]
				building.take_damage(event.intensity)
			return true
		
		"trade_opportunity":
			resource_manager.add_resource("wood", 20)
			resource_manager.add_resource("stone", 15)
			return true
		
		_:
			return false

func get_event_progress() -> float:
	"""Retourne la progression de l'événement (0-1)"""
	if current_event.is_empty():
		return 0.0
	return min(event_timer / current_event.duration, 1.0)

func is_event_active() -> bool:
	"""Vérifie s'il y a un événement actif"""
	return not current_event.is_empty()

func get_current_event() -> Dictionary:
	"""Retourne l'événement actuel"""
	return current_event
