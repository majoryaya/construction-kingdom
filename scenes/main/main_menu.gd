extends Control
class_name MainMenu

# Références aux éléments UI
var new_game_button: Button
var load_game_button: Button
var settings_button: Button
var tutorial_button: Button
var about_button: Button
var quit_button: Button

# Managers
var save_system: SaveSystem

# État
var current_menu: String = "main"

func _ready():
	save_system = SaveSystem.new()
	setup_ui()
	setup_buttons()
	play_background_music()

func setup_ui():
	"""Configure l'interface du menu"""
	var bg = ColorRect.new()
	bg.color = Color(0.1, 0.1, 0.15)
	add_child(bg)
	
	# Logo/Titre
	var title = Label.new()
	title.text = "🏰 Construction Kingdom 🏰"
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color.YELLOW)
	title.set_anchors_preset(Control.PRESET_CENTER_TOP)
	title.offset_y = 50
	add_child(title)

func setup_buttons():
	"""Configure les boutons du menu"""
	var button_container = VBoxContainer.new()
	button_container.set_anchors_preset(Control.PRESET_CENTER)
	button_container.add_theme_constant_override("separation", 20)
	add_child(button_container)
	
	# Bouton Nouveau Jeu
	new_game_button = Button.new()
	new_game_button.text = "🎮 Nouveau Jeu"
	new_game_button.custom_minimum_size = Vector2(300, 60)
	new_game_button.pressed.connect(_on_new_game)
	button_container.add_child(new_game_button)
	
	# Bouton Charger
	load_game_button = Button.new()
	load_game_button.text = "📂 Charger Jeu"
	load_game_button.custom_minimum_size = Vector2(300, 60)
	load_game_button.pressed.connect(_on_load_game)
	button_container.add_child(load_game_button)
	
	# Bouton Tutoriel
	tutorial_button = Button.new()
	tutorial_button.text = "📖 Tutoriel"
	tutorial_button.custom_minimum_size = Vector2(300, 60)
	tutorial_button.pressed.connect(_on_tutorial)
	button_container.add_child(tutorial_button)
	
	# Bouton Paramètres
	settings_button = Button.new()
	settings_button.text = "⚙️ Paramètres"
	settings_button.custom_minimum_size = Vector2(300, 60)
	settings_button.pressed.connect(_on_settings)
	button_container.add_child(settings_button)
	
	# Bouton À Propos
	about_button = Button.new()
	about_button.text = "❓ À Propos"
	about_button.custom_minimum_size = Vector2(300, 60)
	about_button.pressed.connect(_on_about)
	button_container.add_child(about_button)
	
	# Bouton Quitter
	quit_button = Button.new()
	quit_button.text = "🚪 Quitter"
	quit_button.custom_minimum_size = Vector2(300, 60)
	quit_button.pressed.connect(_on_quit)
	button_container.add_child(quit_button)

func _on_new_game():
	"""Démarre un nouveau jeu"""
	print("Démarrage d'un nouveau jeu...")
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_load_game():
	"""Ouvre le menu de chargement"""
	print("Ouverture du menu de chargement...")
	show_load_menu()

func _on_tutorial():
	"""Lance le tutoriel"""
	print("Lancement du tutoriel...")
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_settings():
	"""Ouvre le menu des paramètres"""
	print("Ouverture des paramètres...")
	show_settings_menu()

func _on_about():
	"""Affiche les informations sur le jeu"""
	print("Affichage des informations...")
	show_about_dialog()

func _on_quit():
	"""Quitte le jeu"""
	print("Fermeture du jeu...")
	get_tree().quit()

func show_load_menu():
	"""Affiche le menu de chargement"""
	var slots = save_system.get_save_slots()
	
	if slots.is_empty():
		show_dialog("Aucune sauvegarde trouvée!")
		return
	
	print("Sauvegardes disponibles: ", slots)

func show_settings_menu():
	"""Affiche le menu des paramètres"""
	print("Menu des paramètres")

func show_about_dialog():
	"""Affiche les informations sur le jeu"""
	var about_text = """
	🏰 Construction Kingdom 🏰
	
	Version: 1.0.0
	Développeur: majoryaya
	Engine: Godot 4.x
	
	Un jeu de gestion et construction
	Constituisez votre empire, gérez vos ressources
	et dirigez vos villageois!
	
	Merci de jouer! ❤️
	"""
	show_dialog(about_text)

func show_dialog(message: String):
	"""Affiche un dialogue"""
	var dialog = AcceptDialog.new()
	dialog.dialog_text = message
	dialog.title = "Construction Kingdom"
	add_child(dialog)
	dialog.popup_centered_ratio(0.6)

func play_background_music():
	"""Joue la musique de fond"""
	print("Lecture de la musique de fond...")
	# TODO: Ajouter AudioStreamPlayer

func _process(delta: float):
	# Gestion des entrées
	if Input.is_action_just_pressed("ui_cancel"):
		_on_quit()
