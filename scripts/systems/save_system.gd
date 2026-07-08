extends Node
class_name SaveSystem

# Chemins de sauvegarde
var save_dir: String = "user://construction_kingdom/saves/"
var save_file: String = "savegame_%d.save"

# Format de sauvegarde
var save_data: Dictionary = {}

func _ready():
	# Créer les répertoires s'ils n'existent pas
	if not DirAccess.dir_exists_absolute(save_dir):
		DirAccess.make_abs_absolute(save_dir)

# Sauvegarder l'état du jeu
func save_game(slot: int, game_state: Dictionary) -> bool:
	"""Sauvegarde le jeu dans un slot"""
	var save_path = save_dir + save_file.format([slot])
	
	save_data = {
		"timestamp": Time.get_ticks_msec(),
		"level": game_state.get("level", 1),
		"game_time": game_state.get("game_time", 0.0),
		"resources": game_state.get("resources", {}),
		"buildings": game_state.get("buildings", []),
		"villagers": game_state.get("villagers", []),
		"research_points": game_state.get("research_points", 0),
		"unlocked_techs": game_state.get("unlocked_techs", []),
		"events_log": game_state.get("events_log", [])
	}
	
	var json_string = JSON.stringify(save_data)
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_error("Erreur lors de la création du fichier de sauvegarde")
		return false
	
	file.store_string(json_string)
	print("Jeu sauvegardé dans le slot ", slot)
	return true

# Charger l'état du jeu
func load_game(slot: int) -> Dictionary:
	"""Charge le jeu depuis un slot"""
	var save_path = save_dir + save_file.format([slot])
	
	if not FileAccess.file_exists(save_path):
		push_error("Fichier de sauvegarde non trouvé: ", save_path)
		return {}
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		push_error("Erreur lors de la lecture du fichier")
		return {}
	
	var json_string = file.get_as_text()
	var json = JSON.new()
	
	if json.parse(json_string) != OK:
		push_error("Erreur lors du parsing du JSON")
		return {}
	
	save_data = json.get_data()
	print("Jeu chargé depuis le slot ", slot)
	return save_data

# Lister les sauvegardes disponibles
func get_save_slots() -> Array:
	"""Retourne la liste des sauvegardes disponibles"""
	var slots: Array = []
	
	var dir = DirAccess.open(save_dir)
	if dir == null:
		return slots
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".save"):
			var slot_num = int(file_name.get_slice("_", 1).trim_suffix(".save"))
			slots.append(slot_num)
		file_name = dir.get_next()
	
	return slots.sorted()

# Supprimer une sauvegarde
func delete_save(slot: int) -> bool:
	"""Supprime une sauvegarde"""
	var save_path = save_dir + save_file.format([slot])
	
	if not FileAccess.file_exists(save_path):
		push_error("Fichier de sauvegarde non trouvé")
		return false
	
	var err = DirAccess.remove_absolute(save_path)
	if err == OK:
		print("Sauvegarde slot ", slot, " supprimée")
		return true
	else:
		push_error("Erreur lors de la suppression de la sauvegarde")
		return false

# Exporter la sauvegarde en JSON
func export_save(slot: int, export_path: String) -> bool:
	"""Exporte une sauvegarde en JSON"""
	var save_data_loaded = load_game(slot)
	if save_data_loaded.is_empty():
		return false
	
	var json_string = JSON.stringify(save_data_loaded)
	var file = FileAccess.open(export_path, FileAccess.WRITE)
	
	if file == null:
		push_error("Erreur lors de l'export")
		return false
	
	file.store_string(json_string)
	print("Sauvegarde exportée vers ", export_path)
	return true
