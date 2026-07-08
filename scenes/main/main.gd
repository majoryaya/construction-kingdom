extends Node2D

# Managers
var game_manager: GameManager
var resource_manager: ResourceManager
var building_manager: BuildingManager
var villager_manager: VillagerManager
var tech_manager: TechTree
var grid_system: GridSystem
var ui_manager: UIManager

func _ready():
	# Initialiser les systèmes
	setup_managers()
	setup_ui()
	setup_initial_state()

func setup_managers():
	"""Configure tous les managers"""
	# Créer les managers
	game_manager = GameManager.new()
	resource_manager = ResourceManager.new()
	building_manager = BuildingManager.new()
	villager_manager = VillagerManager.new()
	tech_manager = TechTree.new()
	grid_system = GridSystem.new()
	
	# Les ajouter à la scène
	add_child(game_manager)
	add_child(resource_manager)
	add_child(building_manager)
	add_child(villager_manager)
	add_child(tech_manager)
	add_child(grid_system)

func setup_ui():
	"""Configure l'interface utilisateur"""
	ui_manager = UIManager.new()
	ui_manager.resource_manager = resource_manager
	ui_manager.building_manager = building_manager
	ui_manager.villager_manager = villager_manager
	ui_manager.tech_manager = tech_manager
	add_child(ui_manager)

func setup_initial_state():
	"""Configure l'état initial du jeu"""
	# Ressources de départ
	resource_manager.add_resource("wood", 100)
	resource_manager.add_resource("stone", 50)
	resource_manager.add_resource("food", 75)
	resource_manager.add_resource("gold", 25)
	
	# Premier villageois
	for i in range(3):
		var villager = villager_manager.spawn_villager(Vector2i(10 + i, 10))
		print("Villageois créé: ", villager.name)
	
	# Premier bâtiment de test
	var success = building_manager.place_building("house", Vector2i(5, 5), Vector2i(2, 2))
		if success:
			print("Maison placée avec succès")

func _process(delta: float):
	# Gérer les clics de souris pour construire
	if Input.is_action_just_pressed("ui_accept"):
		var grid_pos = grid_system.screen_to_grid(get_global_mouse_position())
		print("Position grille cliquée: ", grid_pos)
	
	# Mettre à jour l'UI
	ui_manager.update_resources(resource_manager.get_all_resources())
	ui_manager.update_villager_count(villager_manager.villagers.size())
	ui_manager.update_research_points(tech_manager.research_points)
