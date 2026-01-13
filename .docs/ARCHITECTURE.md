# Architecture du Projet - Vue d'Ensemble

## 🏛️ Structure Hiérarchique

```
Main Scene (Node2D)
│
├── Player (CharacterBody2D)
│   ├── Visual (ColorRect)
│   ├── CollisionShape2D
│   ├── MovementComponent (Node)
│   ├── HealthComponent (Node)
│   ├── AttackComponent (Node)
│   └── AttackArea (Area2D)
│       ├── AttackVisual (ColorRect)
│       └── CollisionShape2D
│
├── Enemy (CharacterBody2D) [x3]
│   ├── Visual (ColorRect)
│   ├── CollisionShape2D
│   ├── MovementComponent (Node)
│   ├── HealthComponent (Node)
│   ├── AttackComponent (Node)
│   ├── AIComponent (Node)
│   ├── DetectionArea (Area2D)
│   │   └── CollisionShape2D
│   └── AttackArea (Area2D)
│       └── CollisionShape2D
│
├── Camera2D
│   └── CameraSystem (Script)
│
└── UI (CanvasLayer)
    └── UISystem (Script)
        ├── HealthBarBG (ColorRect)
        │   ├── HealthBarFill (ColorRect)
        │   └── HealthText (Label)
        └── Instructions (Label)
```

## 🔄 Flux de Communication

### 1. Mouvement du Joueur
```
Input (WASD)
    ↓
Player._physics_process()
    ↓
MovementComponent.move()
    ↓
CharacterBody2D.move_and_slide()
    ↓
Signal: direction_changed
```

### 2. Attaque du Joueur
```
Input (SPACE)
    ↓
AttackComponent.try_attack()
    ↓
Signal: attack_started
    ↓
Player._perform_attack()
    ↓
DetectCollisions(AttackArea)
    ↓
Enemy.HealthComponent.take_damage()
    ↓
Signal: health_changed / died
```

### 3. Comportement de l'Ennemi
```
Enemy._physics_process()
    ↓
AIComponent.update_ai()
    ↓
[Decision: IDLE / CHASE / ATTACK]
    ↓
MovementComponent.move() ou AttackComponent.try_attack()
    ↓
Si attaque → Player.HealthComponent.take_damage()
    ↓
UISystem met à jour l'affichage
```

## 🎨 Principe de Composition

### Entité = Somme de Composants

```
Player = {
    CharacterBody2D (base)
    + MovementComponent (capacité de se déplacer)
    + HealthComponent (capacité de prendre des dégâts)
    + AttackComponent (capacité d'attaquer)
}

Enemy = {
    CharacterBody2D (base)
    + MovementComponent (capacité de se déplacer)
    + HealthComponent (capacité de prendre des dégâts)
    + AttackComponent (capacité d'attaquer)
    + AIComponent (comportement automatique)
}
```

### Pour créer une nouvelle entité :

```
NPC = {
    CharacterBody2D
    + MovementComponent
    + DialogueComponent (nouveau!)
}

Boss = {
    CharacterBody2D
    + MovementComponent
    + HealthComponent (max_health = 500)
    + AttackComponent (damage = 30)
    + AIComponent
    + PhaseComponent (nouveau! change de comportement)
}

Chest = {
    StaticBody2D
    + InteractComponent (nouveau!)
    + LootComponent (nouveau!)
}
```

## 📡 Communication par Signaux

Les composants ne se connaissent pas directement, ils communiquent par signaux :

```gdscript
# HealthComponent émet un signal
signal health_changed(current, max)

# Player écoute le signal
health_component.health_changed.connect(_on_health_changed)

# UISystem écoute aussi le même signal
player.health_component.health_changed.connect(_on_player_health_changed)
```

### Avantages :
- ✅ Pas de dépendances directes
- ✅ Un composant peut avoir plusieurs "auditeurs"
- ✅ Facile d'ajouter/retirer des fonctionnalités
- ✅ Testable indépendamment

## 🔧 Remplacement de Composants

### Exemple : Remplacer le système de mouvement

**Avant :**
```
Player
└── MovementComponent (mouvement libre 8 directions)
```

**Après :**
```
Player
└── GridMovementComponent (mouvement par cases)
```

Le nouveau composant doit juste exposer les mêmes fonctions publiques :
```gdscript
func move(delta: float, direction: Vector2, body: CharacterBody2D) -> void
func get_last_direction() -> Vector2
func apply_impulse(impulse: Vector2) -> void
```

**Tout le reste continue de fonctionner !**

## 🎯 Exemple Concret : Ajouter un Dash

### 1. Créer le composant
```
components/dash_component.gd
```

### 2. L'attacher au joueur
```
Player
├── MovementComponent
├── HealthComponent
├── AttackComponent
└── DashComponent (nouveau!)
```

### 3. Modifier Player.gd
```gdscript
@onready var dash = $DashComponent

func _physics_process(delta):
    if Input.is_action_just_pressed("dash"):
        dash.try_dash(input_direction)
    
    if dash.is_dashing:
        velocity = dash.get_dash_velocity()
    else:
        movement_component.move(delta, input_direction, self)
```

### 4. C'est tout !
- ✅ Les autres composants ne sont pas affectés
- ✅ Le dash peut être réutilisé sur d'autres entités
- ✅ Facile de le retirer si on change d'avis

## 📊 Diagramme de Dépendances

```
┌─────────────────────────────────────────┐
│           NO DEPENDENCIES               │
│  (Composants complètement indépendants) │
│                                         │
│  • MovementComponent                    │
│  • HealthComponent                      │
│  • AttackComponent                      │
│  • AIComponent                          │
└─────────────────────────────────────────┘
                    ↑
                    │ utilisés par
                    │
┌─────────────────────────────────────────┐
│          ENTITY LAYER                   │
│   (Assemblent les composants)           │
│                                         │
│  • Player                               │
│  • Enemy                                │
└─────────────────────────────────────────┘
                    ↑
                    │ gérés par
                    │
┌─────────────────────────────────────────┐
│          SYSTEM LAYER                   │
│   (Orchestrent le jeu)                  │
│                                         │
│  • CameraSystem                         │
│  • UISystem                             │
│  • DataLoader                           │
└─────────────────────────────────────────┘
```

## 🚀 Évolution Future

### Phase 1 : Gameplay de Base ✅
- Mouvement
- Combat
- IA ennemie

### Phase 2 : Systèmes RPG
```
+ ExperienceComponent
+ InventoryComponent
+ EquipmentComponent
+ StatsComponent (force, défense, etc.)
```

### Phase 3 : Contenu
```
+ QuestSystem
+ DialogueSystem
+ ShopComponent
+ NPCComponent
```

### Phase 4 : Polish
```
+ SoundComponent
+ ParticleComponent
+ AnimationComponent (si sprites)
+ SaveSystem
```

Chaque phase ajoute des composants **sans modifier les précédents** !

## 💡 Principes Clés à Retenir

1. **Un composant = Une responsabilité**
2. **Communication = Signaux uniquement**
3. **Données = @export pour l'éditeur ou JSON**
4. **Entités = Composition de composants**
5. **Systèmes = Orchestration globale**

Cette architecture vous permet de construire un jeu complexe **par petites itérations indépendantes**.
