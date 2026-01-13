# RPG Prototype Incrémental - Style Secret of Mana

## 📋 Description

Prototype de jeu RPG action top-down inspiré de Secret of Mana, construit avec une architecture **100% modulaire et incrémentale**. Chaque système est indépendant et facilement remplaçable.

## 🎮 Contrôles

- **WASD / Flèches** : Déplacement
- **ESPACE** : Attaque

## 🏗️ Architecture Modulaire

### Composants Réutilisables (`/components`)

Chaque composant est **complètement indépendant** et peut être attaché à n'importe quelle entité :

1. **MovementComponent** : Gestion du mouvement avec vélocité, accélération, friction
2. **HealthComponent** : Système de santé avec invincibilité temporaire
3. **AttackComponent** : Gestion des attaques, cooldown, knockback
4. **AIComponent** : Intelligence artificielle simple (chase, attack, wander)

### Entités (`/entities`)

Les entités sont des **assemblages de composants** :

- **Player** : MovementComponent + HealthComponent + AttackComponent
- **Enemy** : MovementComponent + HealthComponent + AttackComponent + AIComponent

### Systèmes (`/systems`)

Systèmes globaux facilement remplaçables :

- **CameraSystem** : Suit le joueur avec smoothing
- **UISystem** : Affichage de l'interface (barre de santé)

## 🎨 Style Visuel Minimaliste

Tout est fait avec des **ColorRect** (rectangles colorés) :
- Joueur : Rectangle bleu
- Ennemis : Rectangles rouges
- Attaques : Rectangle jaune semi-transparent
- UI : Rectangles pour la barre de santé

**Aucune ressource graphique nécessaire !**

## 🔧 Comment Remplacer un Composant

### Exemple 1 : Changer le système de mouvement

Créez un nouveau fichier `movement_component_grid.gd` qui hérite de `Node` avec les mêmes fonctions publiques, puis remplacez-le dans la scène.

### Exemple 2 : Ajouter un nouveau comportement d'IA

Créez `ai_component_ranged.gd` pour des ennemis à distance, puis attachez-le à la place de `ai_component.gd`.

### Exemple 3 : Nouveau type d'ennemi

1. Dupliquez `enemy.tscn`
2. Ajustez les valeurs exportées des composants (vitesse, santé, dégâts)
3. Changez la couleur du ColorRect
4. C'est tout !

## 📦 Structure des Fichiers

```
godot_rpg_prototype/
├── components/           # Composants réutilisables
│   ├── movement_component.gd
│   ├── health_component.gd
│   ├── attack_component.gd
│   └── ai_component.gd
├── entities/            # Entités du jeu
│   ├── player.gd
│   └── enemy.gd
├── systems/             # Systèmes globaux
│   ├── camera_system.gd
│   └── ui_system.gd
├── scenes/              # Scènes Godot
│   ├── player.tscn
│   ├── enemy.tscn
│   ├── main.tscn
│   └── main.gd
└── project.godot        # Configuration du projet
```

## 🚀 Prochaines Étapes Possibles

Grâce à l'architecture modulaire, vous pouvez facilement ajouter :

1. **DashComponent** : Ajoutez une capacité de dash
2. **InventoryComponent** : Système d'inventaire
3. **QuestComponent** : Système de quêtes
4. **DialogueSystem** : Système de dialogue
5. **LootComponent** : Drop d'objets à la mort
6. **ExperienceComponent** : Système de niveau et XP
7. **WeaponComponent** : Différentes armes équipables
8. **AIComponent variations** : Comportements d'IA plus complexes

Chaque nouveau composant :
- Est un fichier `.gd` séparé
- S'attache à une entité comme un Node enfant
- Communique via des signaux
- Ne dépend pas des autres composants

## 🎯 Philosophie du Design

### Principes clés :
- **Séparation des préoccupations** : Chaque composant fait une seule chose
- **Composition > Héritage** : Les entités sont des compositions de composants
- **Communication par signaux** : Pas de dépendances directes
- **Données externalisées** : Les paramètres sont des `@export` modifiables dans l'éditeur
- **Minimalisme visuel** : Formes géométriques simples, pas de graphismes complexes

### Avantages :
✅ Facile à tester (chaque composant isolément)
✅ Facile à débugger (responsabilités claires)
✅ Facile à étendre (ajoutez des composants sans toucher l'existant)
✅ Facile à remplacer (swap un composant pour un autre)
✅ Pas besoin de compétences en graphisme

## 📝 Notes Techniques

- Version Godot : 4.2+
- Langage : GDScript
- Pas de dépendances externes
- Fonctionne out-of-the-box

## 🎓 Pour Apprendre

Ce prototype est parfait pour apprendre :
- L'architecture par composants (ECS-like)
- Les signaux Godot
- Le système de physique 2D
- La gestion d'état (state machines)
- Les collisions et Area2D

Chaque fichier est commenté et documenté pour faciliter la compréhension.
