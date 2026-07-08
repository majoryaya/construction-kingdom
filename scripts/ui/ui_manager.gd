extends CanvasLayer
class_name UIManager

# Références aux composants UI
var resource_panel: PanelContainer
var construction_panel: PanelContainer
var villager_panel: PanelContainer
var tech_panel: PanelContainer

# Références aux managers
var resource_manager: ResourceManager
var building_manager: BuildingManager
var villager_manager: VillagerManager
var tech_manager: TechTree

func _ready():
	create_ui()
	create_resource_display()
	create_construction_menu()
	create_villager_info()
	create_tech_display()

func create_ui():
	"""Crée l'interface utilisateur principale"""
	# Créer le conteneur principal
	var main_container = VBoxContainer.new()
	main_container.name = "MainUI"
	main_container.add_theme_constant_override("separation", 10)
	add_child(main_container)

func create_resource_display():
	"""Crée l'affichage des ressources"""
	var resource_display = HBoxContainer.new()
	resource_display.name = "ResourceDisplay"
	add_child(resource_display)
	
	# Ressources à afficher
	var resources = ["wood", "stone", "food", "gold"]
	for resource in resources:
		var label = Label.new()
		label.name = resource.capitalize() + "_Label"
		label.text = "%s: 0" % resource.capitalize()
		resource_display.add_child(label)

func create_construction_menu():
	"""Crée le menu de construction"""
	var construction_menu = HBoxContainer.new()
	construction_menu.name = "ConstructionMenu"
	add_child(construction_menu)
	
	# Boutons de construction
	var buildings = ["house", "farm", "lumber_mill", "stone_mine", "market", "tavern", "guard_tower"]
	for building in buildings:
		var button = Button.new()
		button.name = building.capitalize() + "_Button"
		button.text = building.capitalize()
		button.pressed.connect(_on_building_selected.bindv([building]))
		construction_menu.add_child(button)

func create_villager_info():
	"""Crée l'affichage des informations villageois"""
	var villager_info = VBoxContainer.new()
	villager_info.name = "VillagerInfo"
	add_child(villager_info)
	
	var label = Label.new()
	label.text = "Villageois: 0"
	villager_info.add_child(label)

func create_tech_display():
	"""Crée l'affichage de l'arbre technologique"""
	var tech_display = HBoxContainer.new()
	tech_display.name = "TechDisplay"
	add_child(tech_display)
	
	var label = Label.new()
	label.text = "Points de recherche: 0"
	tech_display.add_child(label)

func _on_building_selected(building_type: String):
	"""Appelé quand un bâtiment est sélectionné"""
	print("Construction de: ", building_type)

func update_resources(resources: Dictionary):
	"""Met à jour l'affichage des ressources"""
	for resource_type in resources:
		var label = find_child(resource_type.capitalize() + "_Label")
		if label:
			label.text = "%s: %d" % [resource_type.capitalize(), resources[resource_type]]

func update_villager_count(count: int):
	"""Met à jour le nombre de villageois affichés"""
	var label = find_child("VillagerInfo").get_child(0)
	if label:
		label.text = "Villageois: %d" % count

func update_research_points(points: int):
	"""Met à jour les points de recherche affichés"""
	var label = find_child("TechDisplay").get_child(0)
	if label:
		label.text = "Points de recherche: %d" % points
