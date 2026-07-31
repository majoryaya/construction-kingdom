# Construction Kingdom - ToDo demo (Godot 4)

Cette petite application To‑Do est une démo pour Godot 4 et stocke les tâches localement
dans le dossier utilisateur du moteur (user://todos.json).

Comment ouvrir et utiliser
1. Installez Godot Engine 4.x (https://godotengine.org).
2. Clonez le dépôt et basculez sur la branche feature/godot-todo :
   git fetch origin
   git checkout feature/godot-todo
3. Ouvrez le dossier `godot-todo` dans Godot.
4. Ouvrez la scène `res://scenes/Main.tscn` et lancez-la.

Fonctionnalités
- Ajouter une tâche (saisie + Entrée ou bouton "Ajouter").
- Modifier le texte d'une tâche (la modification est sauvegardée automatiquement).
- Marquer comme fait via la case à cocher.
- Supprimer une tâche ou tout supprimer.
- Sauvegarde automatique dans user://todos.json.

Fichiers clés
- scenes/Main.tscn - interface
- scripts/TodoManager.gd - gestion et persistance (user://todos.json)
- scripts/MainUI.gd - logique d'interface

Licence : MIT
