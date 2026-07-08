# Construction Kingdom 🏰

**Construction Kingdom** est un jeu de gestion et construction en isométrie créé avec **Godot 4.x** en GDScript. Construisez votre empire, gérez vos ressources et dirigez vos villageois pour prospérer!

![Godot](https://img.shields.io/badge/Godot-4.x-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-En%20Développement-yellow)

## 📋 Table des Matières

- [À propos](#à-propos)
- [Fonctionnalités](#fonctionnalités)
- [Installation](#installation)
- [Guide du Joueur](#guide-du-joueur)
- [Architecture](#architecture)
- [Guide de Développement](#guide-de-développement)
- [Dépannage](#dépannage)
- [Changelog](#changelog)
- [Crédits](#crédits)
- [License](#license)

---

## 🎮 À propos

Construction Kingdom est une expérience complète de city-builder où vous:
- 🏗️ Construisez des bâtiments sur une grille
- 📊 Gérez les ressources (bois, pierre, or, nourriture)
- 👥 Dirigez vos villageois avec intelligence
- 🔬 Débloquez des technologies avancées
- 🎲 Faites face à des événements aléatoires
- 💾 Sauvegardez votre progression

**Objectif:** Construire un royaume prospère en équilibrant croissance, ressources et bonheur des villageois.

---

## ✨ Fonctionnalités

### 🏗️ Système de Construction
- Grille de placement intuitive (grid-based)
- Prévisualisation avant placement
- Vérification de validité automatique
- Construction progressive avec barre de progression
- 7 types de bâtiments déverrouillables

### 📦 Gestion des Ressources
- 4 types de ressources: Bois 🌳, Pierre ⛏️, Nourriture 🍎, Or 💰
- Limites de stockage réalistes
- Récolte automatique des bâtiments
- Système économique équilibré
- Production passive des ressources

### 👥 Système de Villageois
- Création et gestion des villageois
- Pathfinding A* pour la navigation
- Attribution de tâches intelligente
- Gestion de la santé, du bonheur et de la fatigue
- États: Idle, Working, Moving, Building

### 🔬 Arbre Technologique
- 8 technologies à débloquer
- Système de prérequis
- Coûts de recherche variés
- Points de recherche générés passivement
- Progression arborescente

### 🎲 Événements Aléatoires
- 8 types d'événements uniques
- Probabilité programmable
- Effets dynamiques sur le jeu
- Durées variables
- Log des événements

### 💾 Système de Sauvegarde
- Sauvegarde/Chargement multi-slots
- Format JSON
- Export/Import de fichiers
- Timestamps automatiques
- Sérialisation complète

### 🎨 Interface Utilisateur
- Affichage en temps réel des ressources
- Menu de construction intuitif
- Panneau d'information
- Notifications d'événements
- Menu principal avec options

---

## 🚀 Installation

### Prérequis
- **Godot 4.x** ou supérieur ([Télécharger](https://godotengine.org/download))
- **Git** (optionnel)
- 500 MB d'espace disque

### Démarrage Rapide

```bash
# 1. Cloner le dépôt
git clone https://github.com/majoryaya/construction-kingdom.git
cd construction-kingdom

# 2. Ouvrir avec Godot
godot .

# 3. Cliquer sur "Play" (F5) pour lancer le jeu
```

### Installation Manuelle

1. Télécharger le code source (ZIP)
2. Extraire l'archive
3. Ouvrir Godot
4. "Import" → Sélectionner le dossier
5. Ouvrir le projet
6. Appuyer sur F5 pour jouer

---

## 🎮 Guide du Joueur

### Commandes de Base

| Touche | Action |
|--------|--------|
| **Clic gauche** | Sélectionner/Placer |
| **Clic droit** | Annuler/Déselectionner |
| **Espace** | Pause/Reprendre |
| **Échap** | Menu principal |
| **F5** | Recharger la scène |
| **Tab** | Toggle UI |
| **Ctrl+S** | Sauvegarder |
| **Ctrl+L** | Charger |

### Début du Jeu

1. **Première Construction**
   - Cliquer sur "Maison" dans le menu de construction
   - Cliquer sur la grille pour placer
   - Attendre 5 secondes pour que la maison soit construite

2. **Attirer des Villageois**
   - Les maisons attirent les villageois
   - Chaque maison accueille jusqu'à 3 villageois

3. **Générer des Ressources**
   - Placer des fermes pour la nourriture 🌾
   - Placer des scieries pour le bois 🪚
   - Placer des mines pour la pierre ⛏️

4. **Progresser Technologiquement**
   - Accumuler des points de recherche
   - Débloquer de nouveaux bâtiments
   - Améliorer votre économie

### Gestion des Villageois

**Santé (❤️)**
- Réduite par: Travail excessif, fatigue, épidémies
- Augmentée par: Repos, taverne, fête
- Morte à 0 = Le villageois meurt

**Bonheur (😊)**
- Réduit par: Travail intensif, famine
- Augmenté par: Repos, célébrations, marché
- Affecte la productivité

**Fatigue (😴)**
- Augmentée par: Travail
- Réduite par: Repos
- Trop élevée = Dégâts à la santé

### Événements Importants

**🦠 Épidémie** (30s)
- Endommage tous les villageois
- Construire une taverne pour les soigner

**🌾 Récolte Abondante** (20s)
- Bonus gratuit de nourriture
- Profitez pour avancer!

**⚔️ Raid** (25s)
- Perte d'or
- Construire une tour de garde pour la défense

**💎 Découverte** (15s)
- Bonus d'or
- Investir dans la technologie!

**😢 Famine** (35s)
- Baisse drastique de nourriture
- Augmenter la production agricole

**🎉 Fête** (20s)
- Les villageois sont heureux
- Bon moment pour construire

**💥 Accident** (10s)
- Un bâtiment est endommagé
- Réparer rapidement

**🤝 Commerce** (30s)
- Échange avantageux
- Augmente ressources

---

## 🏗️ Architecture

### Structure du Projet

```
construction-kingdom/
├── assets/                    # Ressources (sprites, sons, fonts)
│   ├── sprites/              # Images du jeu
│   ├── sounds/               # Effets sonores
│   └── fonts/                # Polices de caractères
│
├── scenes/                   # Scènes Godot
│   ├── main/
│   │   ├── main.tscn         # Scène principale
│   │   ├── main.gd           # Script principal
│   │   ├── main_menu.tscn    # Menu principal
│   │   └── main_menu.gd      # Script menu
│   ├── buildings/
│   │   ├── building.tscn     # Prefab bâtiment
│   │   └── building_base.gd  # Script base
│   ├── characters/
│   │   ├── villager.tscn     # Prefab villageois
│   │   └── villager.gd       # Script villageois
│   ├── ui/
│   │   ├── tutorial.tscn     # Interface tutoriel
│   │   └── hud.tscn          # HUD en jeu
│   └── levels/
│       └── level_manager.gd  # Gestion niveaux
│
├── scripts/                  # Scripts GDScript
│   ├── managers/
│   │   ├── game_manager.gd
│   │   ├── resource_manager.gd
│   │   ├── building_manager.gd
│   │   └── villager_manager.gd
│   ├── systems/
│   │   ├── grid_system.gd
│   │   ├── pathfinding.gd
│   │   ├── tech_tree.gd
│   │   ├── save_system.gd
│   │   ├── event_system.gd
│   │   └── tutorial_system.gd
│   └── ui/
│       └── ui_manager.gd
│
├── project.godot             # Configuration Godot
├── README.md                 # Cette documentation
└── LICENSE                   # Licence MIT
```

### Diagramme des Managers

```
┌─────────────────┐
│  GameManager    │ (Coordinateur principal)
└────────┬────────┘
         │
    ┌────┼────┬──────────┬────────────┐
    │    │    │          │            │
    v    v    v          v            v
  Res  Build Vill       Tech         Event
  Mgr   Mgr   Mgr       Tree         System
```

### Classes Principales

**GameManager**
- Gère l'état global du jeu
- Coordonne les managers
- Gère pause/reprendre
- Signaux: level_started, level_completed, game_paused, game_resumed

**ResourceManager**
- Gère l'économie du jeu
- Limite de stockage
- Signaux: resource_changed, storage_full

**BuildingManager**
- Placement sur grille
- Gestion des bâtiments
- Vérification de validité
- Signaux: building_placed, building_removed, invalid_placement

**VillagerManager**
- Création/suppression de villageois
- Attribution de tâches
- Signaux: villager_spawned, villager_died, task_assigned

**SaveSystem**
- Sauvegarde/Chargement en JSON
- Multi-slots (1-10)
- Export/Import

**EventSystem**
- 8 types d'événements
- Probabilité programmable
- Application automatique des effets
- Signaux: event_triggered, event_completed

**TutorialSystem**
- 5 étapes de tutoriel
- Highlights des éléments
- Instructions contextuelles

---

## 🔧 Guide de Développement

### Configuration de l'Environnement

```bash
# Cloner le dépôt
git clone https://github.com/majoryaya/construction-kingdom.git
cd construction-kingdom

# Ouvrir dans Godot
godot .
```

### Ajouter un Nouveau Bâtiment

1. **Créer la scène**
   ```
   Dupliquer: scenes/buildings/building.tscn
   Renommer: scenes/buildings/house.tscn
   ```

2. **Définir les propriétés**
   ```gdscript
   building_type = "house"
   building_size = Vector2i(2, 2)
   construction_time = 5.0
   resource_cost = {"wood": 20, "stone": 10}
   ```

3. **Ajouter à la technologie**
   ```gdscript
   tech_tree.add_technology("house", "Maison", 10, [])
   ```

### Ajouter un Nouvel Événement

```gdscript
# Dans EventSystem.create_event()
"mon_evenement": {
    "type": event_type,
    "name": "🎪 Mon Événement",
    "description": "Description...",
    "duration": 20.0,
    "effect": "mon_effet",
    "intensity": 25
}

# Dans apply_event_effect()
"mon_effet":
    # Appliquer l'effet
    return true
```

### Déboguer

```gdscript
# Afficher les logs
print("Message de debug")
print("Ressources: ", resource_manager.get_all_resources())
print("Villageois: ", villager_manager.villagers.size())

# Tester une sauvegarde
var save_system = SaveSystem.new()
save_system.save_game(1, game_state)

# Déclencher un événement
event_system.trigger_event("plague")
```

### Performance

- Limiter le nombre de villageois à ~50
- Limiter les bâtiments à ~100
- Utiliser la mise en cache pour les chemins
- Optimiser le rendu avec les layers

---

## 🐛 Dépannage

### Le jeu ne démarre pas

**Erreur:** "Scene not found"
- Vérifier que main.tscn existe
- Vérifier le chemin dans Project Settings → Main Scene

**Erreur:** "Script not found"
- Vérifier que tous les chemins de script sont corrects
- Recharger le projet (F5)

### Performance lente

- Réduire le nombre de villageois
- Désactiver les effets visuels en Options
- Augmenter la distance de culling

### Les villageois ne bougent pas

- Vérifier que GridSystem existe
- Vérifier le pathfinding: event_system.get_current_event()
- Assigner des tâches manuellement

### La sauvegarde ne fonctionne pas

- Vérifier les permissions du dossier user://
- Vérifier l'espace disque disponible
- Vérifier que SaveSystem est initialisé

---

## 📝 Changelog

### v1.0.0 (08 Juillet 2026)
- ✅ Managers complets (Game, Resource, Building, Villager)
- ✅ Système de grille
- ✅ Pathfinding A*
- ✅ Arbre technologique
- ✅ Interface utilisateur
- ✅ Système de sauvegarde
- ✅ Événements aléatoires
- ✅ Scènes Godot visuelles
- ✅ Menu principal
- ✅ Système de tutoriel
- ✅ Documentation complète

### Prochaines Versions
- [ ] Système d'animation
- [ ] Audio et musique
- [ ] Niveaux avec objectifs
- [ ] Multiplayer local
- [ ] Éditeur de niveaux
- [ ] Système de quêtes
- [ ] Bâtiments spéciaux

---

## 🙏 Crédits

**Développeur Principal**
- majoryaya - Concept, code, design

**Inspirations**
- SimCity (Maxis)
- Stardew Valley (ConcernedApe)
- Islanders (Grizzly Games)

**Communauté Godot**
- [Site officiel Godot](https://godotengine.org)
- [Godot Community](https://godotengine.org/community)

**Ressources Utilisées**
- Godot Engine 4.x
- GDScript
- Emojis pour l'interface

---

## 📄 License

Ce projet est sous **license MIT**. Vous êtes libre de:
- ✅ Utiliser le code commercialement
- ✅ Modifier le code
- ✅ Distribuer le code
- ✅ Utiliser à titre privé

Avec la condition d'inclure une copie de la license MIT.

```
MIT License

Copyright (c) 2026 majoryaya

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

---

## 📞 Support

**Questions ou Problèmes?**
- Ouvrir une issue sur GitHub
- Consulter la documentation Godot
- Rejoindre la communauté Godot

**Contribuer**
- Fork le projet
- Créer une feature branch
- Faire un Pull Request

---

## 🎯 Feuille de Route

**Phase 1: Fondations** ✅
- [x] Managers de base
- [x] Système de grille
- [x] Interface

**Phase 2: Gameplay** 🔄
- [ ] Niveaux avec objectifs
- [ ] Système de tutoriel avancé
- [ ] Balance des ressources

**Phase 3: Contenu** ⏳
- [ ] Plus de bâtiments
- [ ] Plus d'événements
- [ ] Campagne complète

**Phase 4: Polish** ⏳
- [ ] Animations
- [ ] Audio
- [ ] Optimisation

---

**Merci de jouer à Construction Kingdom! 👑**

Fait avec ❤️ par majoryaya
