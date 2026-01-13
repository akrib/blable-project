# Index des Fichiers - Prototype RPG

## 📁 Structure Complète du Projet

```
godot_rpg_prototype/
│
├── 📄 project.godot              # Configuration du projet Godot
├── 📘 README.md                  # Vue d'ensemble et introduction
├── 📘 TUTORIAL.md                # Tutoriel pas à pas pour débutants
├── 📘 ARCHITECTURE.md            # Explication détaillée de l'architecture
├── 📘 EXTENSION_GUIDE.md         # Guide pour ajouter de nouveaux composants
├── 📘 ROADMAP.md                 # Fonctionnalités futures possibles
├── 📘 INDEX.md                   # Ce fichier
│
├── 📂 components/                # ⭐ Composants réutilisables
│   ├── movement_component.gd    # Gestion du mouvement (vélocité, accélération)
│   ├── health_component.gd      # Gestion de la santé et des dégâts
│   ├── attack_component.gd      # Gestion des attaques et cooldowns
│   └── ai_component.gd          # Intelligence artificielle pour ennemis
│
├── 📂 entities/                  # Entités du jeu
│   ├── player.gd                # Script du joueur (assemblage de composants)
│   └── enemy.gd                 # Script de l'ennemi (assemblage de composants)
│
├── 📂 systems/                   # Systèmes globaux
│   ├── camera_system.gd         # Système de caméra qui suit le joueur
│   ├── ui_system.gd             # Système d'interface utilisateur
│   └── data_loader.gd           # Chargement des données JSON
│
├── 📂 scenes/                    # Scènes Godot
│   ├── player.tscn              # Scène du joueur
│   ├── enemy.tscn               # Scène de l'ennemi
│   ├── main.tscn                # Scène principale du jeu
│   └── main.gd                  # Script d'initialisation principale
│
└── 📂 data/                      # Données de configuration
    └── game_config.json         # Configuration des stats (ennemis, joueur, etc.)
```

---

## 🔑 Fichiers Clés à Connaître

### 🎮 Pour Jouer
- **scenes/main.tscn** : Ouvrez ce fichier dans Godot et appuyez sur F5

### 📖 Pour Apprendre
1. **README.md** : Commencez ici pour comprendre le projet
2. **TUTORIAL.md** : Tutoriel pas à pas pour modifier le jeu
3. **ARCHITECTURE.md** : Comprendre la structure en profondeur

### 🔧 Pour Développer
- **components/** : Créez de nouveaux composants ici
- **EXTENSION_GUIDE.md** : Exemples de nouveaux composants à créer
- **ROADMAP.md** : Idées de fonctionnalités à ajouter

### 🎨 Pour Personnaliser
- **data/game_config.json** : Modifiez les stats sans toucher au code
- **scenes/*.tscn** : Changez les couleurs et paramètres visuels

---

## 📊 Statistiques du Projet

- **Lignes de code GDScript** : ~600
- **Composants** : 4 (Movement, Health, Attack, AI)
- **Entités** : 2 (Player, Enemy)
- **Systèmes** : 3 (Camera, UI, DataLoader)
- **Scènes** : 3 (Player, Enemy, Main)
- **Documentation** : 6 fichiers MD

---

## 🎯 Fichiers par Fonction

### Mouvement
- `components/movement_component.gd`
- Utilisé par : Player, Enemy

### Combat
- `components/attack_component.gd`
- `components/health_component.gd`
- Utilisé par : Player, Enemy

### Intelligence
- `components/ai_component.gd`
- Utilisé par : Enemy

### Interface
- `systems/ui_system.gd`
- `scenes/main.tscn` (éléments UI)

### Caméra
- `systems/camera_system.gd`

### Données
- `data/game_config.json`
- `systems/data_loader.gd`

---

## 🚀 Ordre de Lecture Recommandé

### Débutant Complet
1. README.md
2. Ouvrir le projet dans Godot et tester (F5)
3. TUTORIAL.md (faire tous les exercices)
4. Expérimenter avec les scènes .tscn

### Déjà des Bases en Godot
1. README.md
2. ARCHITECTURE.md
3. Lire les composants dans `components/`
4. EXTENSION_GUIDE.md
5. Implémenter une fonctionnalité de ROADMAP.md

### Développeur Expérimenté
1. README.md (comprendre la philosophie)
2. Code source dans `components/` et `entities/`
3. EXTENSION_GUIDE.md (patterns)
4. Implémenter des systèmes complexes

---

## 💡 Conseils d'Utilisation

### Pour Modifier Sans Casser
1. Dupliquez toujours les fichiers avant modification
2. Testez un composant à la fois
3. Utilisez `print()` pour débugger
4. Commitez avec Git après chaque fonctionnalité

### Pour Ajouter des Fonctionnalités
1. Identifiez quel type : Composant, Système, ou Entité
2. Créez le fichier dans le bon dossier
3. Suivez les patterns de EXTENSION_GUIDE.md
4. Testez indépendamment avant intégration

### Pour Apprendre
1. Lisez un composant entier (ex: health_component.gd)
2. Modifiez les `@export` dans l'éditeur
3. Ajoutez des `print()` pour voir ce qui se passe
4. Créez des variantes (enemy_strong, enemy_fast, etc.)

---

## 🎨 Convention de Nommage

### Fichiers
- **Composants** : `nom_component.gd` (ex: `movement_component.gd`)
- **Entités** : `nom.gd` (ex: `player.gd`)
- **Systèmes** : `nom_system.gd` (ex: `ui_system.gd`)
- **Scènes** : `nom.tscn` (ex: `player.tscn`)

### Classes
- **Composants** : `NomComponent` (ex: `MovementComponent`)
- **Entités** : `Nom` (ex: `Player`, `Enemy`)

### Variables
- **Exportées** : `snake_case` (ex: `max_health`)
- **Privées** : `snake_case` (ex: `cooldown_timer`)
- **Signaux** : `past_tense` (ex: `health_changed`, `died`)

### Fonctions
- **Publiques** : `verbe_action()` (ex: `take_damage()`, `apply_impulse()`)
- **Callbacks** : `_on_signal_name()` (ex: `_on_died()`)

---

## 🔍 Recherche Rapide

### "Je veux modifier la vitesse du joueur"
→ `scenes/player.tscn` → MovementComponent → Propriété `speed`

### "Je veux changer les dégâts d'une attaque"
→ `scenes/player.tscn` → AttackComponent → Propriété `damage`

### "Je veux plus de vie pour mon personnage"
→ `scenes/player.tscn` → HealthComponent → Propriété `max_health`

### "Je veux créer un nouvel ennemi"
→ Dupliquer `scenes/enemy.tscn` et ajuster les propriétés

### "Je veux ajouter une nouvelle mécanique"
→ Créer un nouveau composant dans `components/`

### "Je veux comprendre comment ça marche"
→ ARCHITECTURE.md puis lire le code des composants

---

## 📞 Où Trouver de l'Aide

### Dans ce Projet
- **README.md** : Vue d'ensemble
- **TUTORIAL.md** : Exercices pratiques
- **ARCHITECTURE.md** : Explication technique
- **EXTENSION_GUIDE.md** : Exemples de code

### Ressources Externes
- **Documentation Godot** : https://docs.godotengine.org/
- **GDScript Basics** : https://gdscript.com/
- **Godot Community** : https://godotengine.org/community

### Commentaires dans le Code
- Chaque composant est commenté
- Les fonctions publiques ont des descriptions
- Les parties complexes ont des explications

---

## ✅ Checklist du Débutant

Avant de commencer à coder, assurez-vous d'avoir :

- [ ] Lu le README.md
- [ ] Testé le jeu (F5 dans Godot)
- [ ] Modifié au moins un paramètre dans l'éditeur
- [ ] Changé une couleur
- [ ] Fait les 5 premiers exercices du TUTORIAL.md
- [ ] Compris le concept de "composant"
- [ ] Créé au moins une variante d'ennemi

Une fois ces points validés, vous êtes prêt à créer vos propres fonctionnalités ! 🚀

---

## 🎓 Prochaines Étapes

1. **Maîtriser les bases** : Terminez TUTORIAL.md
2. **Comprendre l'architecture** : Lisez ARCHITECTURE.md
3. **Créer votre premier composant** : Suivez EXTENSION_GUIDE.md
4. **Planifier** : Choisissez une fonctionnalité dans ROADMAP.md
5. **Développer** : Implémentez la fonctionnalité
6. **Itérer** : Répétez avec de nouvelles fonctionnalités

**Bon développement !** 🎮
