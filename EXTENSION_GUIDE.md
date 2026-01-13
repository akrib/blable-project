# Guide d'Extension - Ajouter de Nouveaux Composants

Ce guide montre comment étendre le jeu en ajoutant de nouveaux composants modulaires.

## 📘 Exemple 1 : Ajouter un Système de Dash

### Étape 1 : Créer le composant

Créez `components/dash_component.gd` :

```gdscript
extends Node
class_name DashComponent

signal dash_started()
signal dash_finished()

@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0

var can_dash: bool = true
var is_dashing: bool = false
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func _process(delta: float):
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			dash_finished.emit()
	
	if not can_dash:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_dash = true

func try_dash(direction: Vector2) -> bool:
	if can_dash and not is_dashing and direction.length() > 0:
		start_dash(direction.normalized())
		return true
	return false

func start_dash(direction: Vector2):
	is_dashing = true
	can_dash = false
	dash_direction = direction
	dash_timer = dash_duration
	cooldown_timer = dash_cooldown
	dash_started.emit()

func get_dash_velocity() -> Vector2:
	if is_dashing:
		return dash_direction * dash_speed
	return Vector2.ZERO
```

### Étape 2 : Intégrer au joueur

Dans `entities/player.gd`, ajoutez :

```gdscript
@onready var dash_component: DashComponent = $DashComponent

func _physics_process(delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Dash si demandé
	if Input.is_action_just_pressed("dash"):
		dash_component.try_dash(input_direction)
	
	# Mouvement normal ou dash
	if dash_component.is_dashing:
		velocity = dash_component.get_dash_velocity()
		move_and_slide()
	else:
		movement_component.move(delta, input_direction, self)
```

### Étape 3 : Ajouter dans la scène

Dans `scenes/player.tscn`, ajoutez un nœud :
```
[node name="DashComponent" type="Node" parent="."]
script = ExtResource("dash_component.gd")
```

**Voilà ! Le dash est ajouté sans modifier les autres composants.**

---

## 📘 Exemple 2 : Système d'Expérience et de Niveau

### Créer `components/experience_component.gd`

```gdscript
extends Node
class_name ExperienceComponent

signal level_up(new_level: int)
signal experience_gained(amount: int)

@export var current_level: int = 1
@export var current_xp: int = 0
@export var xp_curve: float = 1.5  # Multiplicateur pour chaque niveau

func get_xp_for_next_level() -> int:
	return int(100 * pow(xp_curve, current_level - 1))

func add_experience(amount: int):
	current_xp += amount
	experience_gained.emit(amount)
	
	while current_xp >= get_xp_for_next_level():
		level_up_player()

func level_up_player():
	current_xp -= get_xp_for_next_level()
	current_level += 1
	level_up.emit(current_level)
	
	# Bonus automatiques
	var health = get_parent().get_node_or_null("HealthComponent")
	if health:
		health.max_health += 10
		health.heal(health.max_health)
	
	var attack = get_parent().get_node_or_null("AttackComponent")
	if attack:
		attack.damage += 2
```

### Intégration

Dans `entities/player.gd` :
```gdscript
@onready var xp_component: ExperienceComponent = $ExperienceComponent

func _ready():
	xp_component.level_up.connect(_on_level_up)

func _on_level_up(new_level: int):
	print("Level Up! Niveau ", new_level)
```

Dans `entities/enemy.gd` :
```gdscript
func _on_died():
	# Donner XP au joueur
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var xp_comp = player.get_node_or_null("ExperienceComponent")
		if xp_comp:
			xp_comp.add_experience(10)
	queue_free()
```

---

## 📘 Exemple 3 : Système d'Inventaire

### Créer `components/inventory_component.gd`

```gdscript
extends Node
class_name InventoryComponent

signal item_added(item_id: String)
signal item_removed(item_id: String)
signal inventory_full()

@export var max_slots: int = 20

var items: Dictionary = {}  # {item_id: quantity}

func add_item(item_id: String, quantity: int = 1) -> bool:
	if get_total_items() >= max_slots and not items.has(item_id):
		inventory_full.emit()
		return false
	
	if items.has(item_id):
		items[item_id] += quantity
	else:
		items[item_id] = quantity
	
	item_added.emit(item_id)
	return true

func remove_item(item_id: String, quantity: int = 1) -> bool:
	if not items.has(item_id):
		return false
	
	items[item_id] -= quantity
	if items[item_id] <= 0:
		items.erase(item_id)
	
	item_removed.emit(item_id)
	return true

func has_item(item_id: String, quantity: int = 1) -> bool:
	return items.get(item_id, 0) >= quantity

func get_total_items() -> int:
	return items.size()

func get_item_count(item_id: String) -> int:
	return items.get(item_id, 0)
```

### Créer un objet ramassable

`entities/pickup.gd` :
```gdscript
extends Area2D

@export var item_id: String = "potion"
@export var quantity: int = 1

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:
		var inventory = body.get_node_or_null("InventoryComponent")
		if inventory and inventory.add_item(item_id, quantity):
			queue_free()
```

---

## 📘 Exemple 4 : Système de Quêtes

### Créer `systems/quest_system.gd`

```gdscript
extends Node
class_name QuestSystem

signal quest_started(quest_id: String)
signal quest_completed(quest_id: String)
signal objective_updated(quest_id: String, progress: int, total: int)

var active_quests: Dictionary = {}
var completed_quests: Array = []

func start_quest(quest_id: String, objectives: Dictionary):
	active_quests[quest_id] = {
		"objectives": objectives,
		"progress": {}
	}
	
	for obj_id in objectives:
		active_quests[quest_id]["progress"][obj_id] = 0
	
	quest_started.emit(quest_id)

func update_objective(quest_id: String, objective_id: String, amount: int = 1):
	if not active_quests.has(quest_id):
		return
	
	var quest = active_quests[quest_id]
	quest["progress"][objective_id] += amount
	
	var total = quest["objectives"][objective_id]
	var progress = quest["progress"][objective_id]
	
	objective_updated.emit(quest_id, progress, total)
	
	if is_quest_complete(quest_id):
		complete_quest(quest_id)

func is_quest_complete(quest_id: String) -> bool:
	if not active_quests.has(quest_id):
		return false
	
	var quest = active_quests[quest_id]
	for obj_id in quest["objectives"]:
		if quest["progress"][obj_id] < quest["objectives"][obj_id]:
			return false
	return true

func complete_quest(quest_id: String):
	active_quests.erase(quest_id)
	completed_quests.append(quest_id)
	quest_completed.emit(quest_id)
```

---

## 🎯 Pattern de Création de Composants

Suivez ce template pour créer n'importe quel composant :

```gdscript
extends Node
class_name VotreComponent

## Description du composant

# Signaux pour communiquer avec l'extérieur
signal something_happened()

# Paramètres exportables
@export var some_parameter: float = 10.0

# Variables internes privées
var internal_state: int = 0

func _ready():
	# Initialisation
	pass

func _process(delta: float):
	# Logique par frame si nécessaire
	pass

## Fonction publique principale
func do_something() -> void:
	# Implémentation
	something_happened.emit()

## Fonctions utilitaires
func get_state() -> int:
	return internal_state
```

## ✅ Checklist pour un Bon Composant

- [ ] **Une seule responsabilité** : Le composant fait une chose et la fait bien
- [ ] **Indépendant** : Ne dépend pas d'autres composants spécifiques
- [ ] **Communicatif** : Utilise des signaux pour informer les changements
- [ ] **Paramétrable** : Utilise `@export` pour les valeurs ajustables
- [ ] **Documenté** : Commentaires clairs sur l'utilisation
- [ ] **Testé** : Peut être testé isolément

## 🚀 Composants Suggérés à Implémenter

1. **StaminaComponent** : Gestion de l'endurance (course, dash)
2. **MagicComponent** : Système de magie/mana
3. **DialogueComponent** : Interactions avec NPCs
4. **ShopComponent** : Système d'achat/vente
5. **EquipmentComponent** : Gestion d'équipement
6. **BuffComponent** : Effets temporaires (boost, slow, poison)
7. **SoundComponent** : Gestion des sons de l'entité
8. **AnimationComponent** : Si vous passez aux sprites
9. **ParticleComponent** : Effets de particules
10. **SaveComponent** : Sauvegarde de l'état du composant

Chaque nouveau composant enrichit votre "bibliothèque" réutilisable !
