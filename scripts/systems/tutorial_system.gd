extends Node
class_name TutorialSystem

# Étapes du tutoriel
var tutorial_steps: Array = []
var current_step: int = 0
var is_tutorial_active: bool = false

# UI du tutoriel
var tutorial_panel: PanelContainer
var tutorial_label: RichTextLabel
var next_button: Button
var skip_button: Button
var highlight_rect: ColorRect

# Signaux
signal tutorial_started
signal tutorial_completed
signal step_changed(step_number: int)

func _ready():
	initialize_tutorial_steps()

func initialize_tutorial_steps():
	"""Initialise les étapes du tutoriel"""
	tutorial_steps = [
		{
			"title": "🎮 Bienvenue dans Construction Kingdom!",
			"description": "Vous allez apprendre à construire votre empire.\n\nObjectifs: Gérer vos ressources, construire des bâtiments, et diriger vos villageois!",
			"position": "center",
			"highlight": null
		},
		{
			"title": "📦 Comprendre les Ressources",
			"description": "Vous avez 4 ressources:\n🌳 Bois - Pour construire\n⛏️ Pierre - Pour les défenses\n🍎 Nourriture - Pour les villageois\n💰 Or - Pour les technologies",
			"position": "top_left",
			"highlight": "ResourcePanel"
		},
		{
			"title": "🏗️ Construire un Bâtiment",
			"description": "Cliquez sur 'Maison' puis sur la grille pour placer.\n\nLa construction prend 5 secondes.\nAttendez la barre de progression!",
			"position": "top_left",
			"highlight": "ConstructionMenu"
		},
		{
			"title": "👥 Gérer les Villageois",
			"description": "Les maisons attirent les villageois.\n\nChaque villageois a:\n❤️ Santé - Réduite par le travail\n😊 Bonheur - Augmenté par le repos\n😴 Fatigue - Réduite par le repos",
			"position": "top_right",
			"highlight": "VillagerContainer"
		},
		{
			"title": "🔬 Débloquer des Technologies",
			"description": "Accumulez des points de recherche pour débloquer:\n🔨 Nouveaux bâtiments\n⚔️ Améliorations\n🎯 Fonctionnalités avancées\n\nBon jeu! 🏆",
			"position": "top_right",
			"highlight": "ResearchLabel"
		}
	]

func start_tutorial():
	"""Démarre le tutoriel"""
	is_tutorial_active = true
	current_step = 0
	tutorial_started.emit()
	create_tutorial_ui()
	show_step(0)

func create_tutorial_ui():
	"""Crée l'interface du tutoriel"""
	# Créer le panneau du tutoriel
	tutorial_panel = PanelContainer.new()
	tutorial_panel.add_theme_stylebox_override("panel", preload("res://resources/tutorial_style.tres"))
	
	# Contenu du tutoriel
	var vbox = VBoxContainer.new()
	
	tutorial_label = RichTextLabel.new()
	tutorial_label.custom_minimum_size = Vector2(400, 200)
	tutorial_label.bbcode_enabled = true
	vbox.add_child(tutorial_label)
	
	# Boutons
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	
	skip_button = Button.new()
	skip_button.text = "⏭️ Passer le tutoriel"
	skip_button.pressed.connect(_on_skip_tutorial)
	hbox.add_child(skip_button)
	
	next_button = Button.new()
	next_button.text = "Suivant →"
	next_button.pressed.connect(_on_next_step)
	hbox.add_child(next_button)
	
	vbox.add_child(hbox)
	tutorial_panel.add_child(vbox)
	
	# Ajouter à la scène
	get_tree().root.add_child(tutorial_panel)

func show_step(step_number: int):
	"""Affiche une étape du tutoriel"""
	if step_number >= tutorial_steps.size():
		complete_tutorial()
		return
	
	current_step = step_number
	var step = tutorial_steps[step_number]
	
	# Mettre à jour le contenu
	var content = "[b]%s[/b]\n\n%s\n\n[i]Étape %d/%d[/i]" % [
		step.title,
		step.description,
		step_number + 1,
		tutorial_steps.size()
	]
	tutorial_label.text = content
	
	# Mettre à jour le bouton
	if step_number == tutorial_steps.size() - 1:
		next_button.text = "✅ Terminer"
	else:
		next_button.text = "Suivant →"
	
	# Highlight
	if step.highlight != null:
		highlight_element(step.highlight)
	
	step_changed.emit(step_number)

func highlight_element(element_name: String):
	"""Surligne un élément de l'interface"""
	var element = get_tree().root.find_child(element_name, true, false)
	if element != null and element is CanvasItem:
		print("Surlignage de: ", element_name)
		# TODO: Créer un effet de highlight

func _on_next_step():
	"""Bouton Suivant"""
	if current_step < tutorial_steps.size() - 1:
		show_step(current_step + 1)
	else:
		complete_tutorial()

func _on_skip_tutorial():
	"""Saute le tutoriel"""
	complete_tutorial()

func complete_tutorial():
	"""Complète le tutoriel"""
	is_tutorial_active = false
	tutorial_completed.emit()
	if tutorial_panel:
		tutorial_panel.queue_free()
	print("Tutoriel complété!")

func _process(delta: float):
	if is_tutorial_active:
		# Gestion des entrées
		if Input.is_action_just_pressed("ui_accept"):
			_on_next_step()
		elif Input.is_action_just_pressed("ui_cancel"):
			_on_skip_tutorial()
