extends CharacterBody2D
class_name VillagerBase

# Propriétés du villageois
@export var speed: float = 100.0
@export var max_health: int = 100
@export var max_happiness: int = 100

# État
var current_health: int = 100
var current_happiness: int = 50
var fatigue: int = 0
var current_state: String = "idle"
var current_task: String = ""
var target_position: Vector2 = Vector2.ZERO

# Signaux
signal state_changed(new_state: String)
signal task_assigned(task: String)
signal health_changed(new_health: int)
signal happiness_changed(new_happiness: int)

func _ready():
	current_health = max_health
	add_to_group("villagers")

func _process(delta: float):
	update_state(delta)
	update_needs(delta)

	if current_state == "moving":
		move_towards_target(delta)

func move_towards_target(delta: float):
	"""Déplace le villageois vers la cible"""
	var direction = (target_position - global_position).normalized()
	velocity = direction * speed
	
	if global_position.distance_to(target_position) < 10:
		velocity = Vector2.ZERO
		change_state("idle")
	
	move_and_slide()

func assign_task(task: String, target: Vector2):
	"""Assigne une tâche au villageois"""
	current_task = task
	target_position = target
	change_state("moving")
	task_assigned.emit(task)

func change_state(new_state: String):
	"""Change l'état du villageois"""
	if current_state != new_state:
		current_state = new_state
		state_changed.emit(new_state)

func update_state(delta: float):
	"""Met à jour l'état du villageois"""
	match current_state:
		"idle":
			# En repos, le bonheur augmente
			set_happiness(current_happiness + 1)
			fatigue -= 1
		"working":
			# En travail, la fatigue augmente
			fatigue += 2
			set_happiness(current_happiness - 1)

func update_needs(delta: float):
	"""Met à jour les besoins du villageois"""
	# Limiter les valeurs
	fatigue = clamp(fatigue, 0, 100)
	current_happiness = clamp(current_happiness, 0, max_happiness)
	
	# Trop fatigué endommage la santé
	if fatigue > 80:
		take_damage(1)

func take_damage(damage: int):
	"""Applique des dégâts au villageois"""
	set_health(current_health - damage)

func heal(amount: int):
	"""Soigne le villageois"""
	set_health(current_health + amount)

func set_health(new_health: int):
	"""Définit la santé du villageois"""
	current_health = clamp(new_health, 0, max_health)
	health_changed.emit(current_health)
	
	if current_health <= 0:
		die()

func set_happiness(new_happiness: int):
	"""Définit le bonheur du villageois"""
	current_happiness = clamp(new_happiness, 0, max_happiness)
	happiness_changed.emit(current_happiness)

func die():
	"""Le villageois meurt"""
	print("%s est mort" % name)
	queue_free()

func get_villager_info() -> Dictionary:
	"""Retourne les informations du villageois"""
	return {
		"name": name,
		"position": global_position,
		"state": current_state,
		"health": current_health,
		"happiness": current_happiness,
		"fatigue": fatigue,
		"task": current_task
	}
