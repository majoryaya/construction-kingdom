extends Node
class_name VillagerManager

# Dictionnaire des villageois
var villagers: Dictionary = {}
var villager_count: int = 0

# États possibles
const STATES = {"IDLE": 0, "WORKING": 1, "MOVING": 2, "BUILDING": 3}

# Signaux
signal villager_spawned(villager: Villager)
signal villager_died(villager: Villager)
signal task_assigned(villager: Villager, task: String)

func _ready():
	print("VillagerManager initialized")

func spawn_villager(start_pos: Vector2i) -> Villager:
	"""Crée un nouveau villageois"""
	var villager = Villager.new()
	villager.id = villager_count
	villager.name = "Villager_%d" % villager_count
	villager.position = start_pos
	villager.state = STATES.IDLE
	villager.health = 100
	villager.happiness = 50
	villager_count += 1
	
	villagers[villager.id] = villager
	villager_spawned.emit(villager)
	return villager

func remove_villager(villager_id: int) -> bool:
	"""Supprime un villageois"""
	if villager_id not in villagers:
		return false
	
	var villager = villagers[villager_id]
	villagers.erase(villager_id)
	villager_died.emit(villager)
	return true

func assign_task(villager_id: int, task: String, target: Vector2i) -> bool:
	"""Assigne une tâche à un villageois"""
	if villager_id not in villagers:
		return false
	
	var villager = villagers[villager_id]
	villager.current_task = task
	villager.task_target = target
	villager.state = STATES.MOVING
	
	task_assigned.emit(villager, task)
	return true

func get_villager(villager_id: int) -> Villager:
	return villagers.get(villager_id, null)

func get_all_villagers() -> Dictionary:
	return villagers.duplicate()

func get_idle_villagers() -> Array:
	"""Retourne tous les villageois libres"""
	var idle_villagers: Array = []
	for villager_id in villagers:
		if villagers[villager_id].state == STATES.IDLE:
			idle_villagers.append(villagers[villager_id])
	return idle_villagers

func update(delta: float):
	# Mettre à jour tous les villageois
	for villager_id in villagers:
		var villager = villagers[villager_id]
		villager.update(delta)
		
		# Gérer la santé
		if villager.health <= 0:
			remove_villager(villager_id)

class Villager:
	var id: int
	var name: String
	var position: Vector2i
	var state: int
	var health: int
	var happiness: int
	var fatigue: int = 0
	var current_task: String = ""
	var task_target: Vector2i = Vector2i.ZERO
	var speed: float = 1.0
	
	func update(delta: float):
		# Augmenter la fatigue au fil du temps
		fatigue += int(delta * 5)
		if fatigue > 100:
			fatigue = 100
			# Réduire la santé si trop fatigué
			if randf() > 0.95:
				health -= 1
		
		# Régénérer le bonheur en repos
		if state == 0:  # IDLE
			happiness += 1
			fatigue -= 2
		else:
			happiness -= 1
		
		# Limites
		happiness = clamp(happiness, 0, 100)
		fatigue = clamp(fatigue, 0, 100)
		health = clamp(health, 0, 100)
