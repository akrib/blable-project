# Tutoriel Pas à Pas - Premiers Pas avec le Prototype

## 🎯 Objectif
Ce tutoriel vous guide pour comprendre et modifier le prototype RPG étape par étape.

---

## Étape 1 : Ouvrir le Projet dans Godot

1. Téléchargez et installez Godot 4.2+ depuis https://godotengine.org/
2. Ouvrez Godot
3. Cliquez sur "Import" 
4. Naviguez vers le dossier `godot_rpg_prototype`
5. Sélectionnez le fichier `project.godot`
6. Cliquez sur "Import & Edit"

✅ **Résultat attendu** : Le projet s'ouvre dans l'éditeur Godot

---

## Étape 2 : Tester le Jeu

1. Appuyez sur **F5** (ou cliquez sur le bouton "Play" ▶️)
2. Utilisez **WASD** ou les **flèches** pour vous déplacer
3. Appuyez sur **ESPACE** pour attaquer
4. Essayez de combattre les ennemis rouges

✅ **Résultat attendu** : Vous voyez un rectangle bleu (vous) et des rectangles rouges (ennemis). Vous pouvez vous déplacer et attaquer.

---

## Étape 3 : Examiner la Structure du Projet

Dans le panneau "FileSystem" (en bas à gauche), explorez :

```
components/     ← Les briques réutilisables
entities/       ← Le joueur et les ennemis
systems/        ← Les systèmes globaux (caméra, UI)
scenes/         ← Les scènes Godot
data/          ← Les configurations JSON
```

---

## Étape 4 : Modifier les Statistiques du Joueur

### 4.1 Via l'éditeur (méthode facile)

1. Ouvrez `scenes/main.tscn` (double-clic dans FileSystem)
2. Dans la hiérarchie de scène (gauche), cliquez sur `Player`
3. Développez le nœud Player → cliquez sur `MovementComponent`
4. Dans l'inspecteur (droite), trouvez `Speed`
5. Changez la valeur de `150` à `250`
6. Testez le jeu (F5) → Le joueur va maintenant plus vite !

### 4.2 Via le code (pour comprendre)

1. Ouvrez `components/movement_component.gd`
2. Ligne 10, changez :
```gdscript
@export var speed: float = 100.0
```
à
```gdscript
@export var speed: float = 200.0
```
3. Cette valeur est la valeur par défaut (peut être overridée dans l'éditeur)

✅ **Ce que vous avez appris** : Les composants ont des paramètres `@export` modifiables sans toucher au code !

---

## Étape 5 : Changer la Couleur du Joueur

1. Ouvrez `scenes/player.tscn`
2. Cliquez sur `Player` → `Visual` (c'est un ColorRect)
3. Dans l'inspecteur, trouvez `Color`
4. Cliquez sur la couleur bleue
5. Choisissez une nouvelle couleur (ex: vert, violet)
6. Testez (F5)

✅ **Résultat** : Votre personnage a une nouvelle couleur !

---

## Étape 6 : Créer un Ennemi Plus Fort

### Méthode 1 : Dupliquer une scène

1. Dans FileSystem, faites clic-droit sur `scenes/enemy.tscn`
2. Choisissez "Duplicate"
3. Nommez-le `enemy_strong.tscn`
4. Ouvrez `enemy_strong.tscn`
5. Sélectionnez `Enemy` → `HealthComponent`
6. Changez `Max Health` de `50` à `100`
7. Sélectionnez `Enemy` → `AttackComponent`
8. Changez `Damage` de `10` à `20`
9. Sélectionnez `Enemy` → `Visual`
10. Changez la couleur (rouge plus foncé)

### Méthode 2 : Ajouter à la scène principale

1. Ouvrez `scenes/main.tscn`
2. Dans la barre du haut : Scene → "+ Add Child Node"
3. Cherchez et ajoutez un `CharacterBody2D`
4. Faites glisser `enemy_strong.tscn` dessus pour l'instancier
5. Déplacez-le dans la scène 2D en utilisant l'outil "Move"
6. Testez !

✅ **Ce que vous avez appris** : Créer des variantes d'ennemis sans écrire de code !

---

## Étape 7 : Modifier la Barre de Santé

1. Ouvrez `systems/ui_system.gd`
2. Trouvez la ligne 13 :
```gdscript
health_bar_fill.color = Color(0.2, 0.8, 0.3)
```
3. Changez à :
```gdscript
health_bar_fill.color = Color(1.0, 0.2, 0.2)  # Rouge
```
4. Testez (F5) → La barre de santé est maintenant rouge

✅ **Ce que vous avez appris** : Les systèmes gèrent l'UI et sont facilement modifiables

---

## Étape 8 : Ajouter Plus d'Ennemis

1. Ouvrez `scenes/main.tscn`
2. Cliquez sur le nœud `Enemy1` dans la hiérarchie
3. Ctrl+D (ou Cmd+D sur Mac) pour dupliquer
4. Un nouvel ennemi apparaît → déplacez-le avec l'outil Move (W)
5. Répétez pour créer 5-10 ennemis
6. Testez !

✅ **Défi** : Créez une "arène" avec des ennemis tout autour du joueur

---

## Étape 9 : Débugger avec les Prints

1. Ouvrez `entities/player.gd`
2. Dans la fonction `_on_died()`, ajoutez :
```gdscript
func _on_died():
	print("Le joueur est mort avec ", health_component.current_health, " PV")
	player_died.emit()
	queue_free()
```
3. Testez et laissez-vous tuer
4. Regardez la console (Output en bas) → Vous verrez votre message

✅ **Ce que vous avez appris** : `print()` est votre ami pour comprendre ce qui se passe

---

## Étape 10 : Analyser un Composant en Détail

Ouvrons `components/health_component.gd` pour comprendre :

```gdscript
extends Node
class_name HealthComponent
```
→ C'est un Node simple, pas attaché à un type spécifique

```gdscript
signal health_changed(current_health: int, max_health: int)
```
→ Émet un signal quand la santé change (l'UI l'écoute)

```gdscript
@export var max_health: int = 100
```
→ Paramètre modifiable dans l'éditeur

```gdscript
func take_damage(amount: int) -> void:
```
→ Fonction publique appelée par d'autres scripts

✅ **Pattern** : Tous les composants suivent cette structure

---

## Étape 11 : Votre Premier Composant !

Créons un composant simple de régénération :

1. Créez un nouveau fichier : `components/regeneration_component.gd`
2. Copiez ce code :

```gdscript
extends Node
class_name RegenerationComponent

@export var regen_rate: int = 2  # PV par seconde
@export var regen_delay: float = 3.0  # Délai après dégâts

var time_since_damage: float = 0.0
var health_component: HealthComponent = null

func _ready():
	health_component = get_parent().get_node_or_null("HealthComponent")
	if health_component:
		health_component.damage_taken.connect(_on_damage_taken)

func _process(delta):
	if health_component == null or not health_component.is_alive():
		return
	
	time_since_damage += delta
	
	if time_since_damage >= regen_delay:
		health_component.heal(regen_rate * delta)

func _on_damage_taken(_amount):
	time_since_damage = 0.0
```

3. Ouvrez `scenes/player.tscn`
4. Clic-droit sur `Player` → "Add Child Node"
5. Cherchez "Node" → Ajoutez un Node simple
6. Renommez-le `RegenerationComponent`
7. Dans l'inspecteur, cliquez sur "Attach Script"
8. Naviguez vers `components/regeneration_component.gd`
9. Testez ! → Votre santé se régénère après 3 secondes sans dégâts

✅ **BRAVO !** Vous avez créé votre premier composant modulaire !

---

## Étape 12 : Utiliser les Données JSON

1. Ouvrez `data/game_config.json`
2. Modifiez les valeurs (ex: augmentez les dégâts des ennemis)
3. Pour charger ces données, ouvrez `scenes/main.gd`
4. Ajoutez en haut :
```gdscript
var data_loader = preload("res://systems/data_loader.gd").new()
```
5. Dans `_ready()`, ajoutez :
```gdscript
add_child(data_loader)
```

✅ **Avantage** : Modifier le jeu sans toucher au code, juste le JSON

---

## 🎓 Exercices Pratiques

### Exercice 1 : Super Mode
Créez un bouton (touche 'T') qui multiplie la vitesse du joueur par 2 pendant 5 secondes.

**Indice** : Modifiez `player.gd` et utilisez un Timer.

### Exercice 2 : Ennemi Rapide
Créez un type d'ennemi qui va 2x plus vite mais a 2x moins de PV.

**Indice** : Dupliquez enemy.tscn et ajustez les composants.

### Exercice 3 : Zone de Poison
Créez une Area2D qui inflige des dégâts continus au joueur.

**Indice** : Utilisez `body_entered` et `body_exited`.

---

## 📚 Prochaines Lectures

Maintenant que vous maîtrisez les bases, consultez :

1. **EXTENSION_GUIDE.md** → Comment ajouter de nouveaux composants
2. **ARCHITECTURE.md** → Comprendre la structure en profondeur
3. **README.md** → Vue d'ensemble du projet

---

## 🆘 Problèmes Courants

### "Le joueur ne bouge pas"
→ Vérifiez que MovementComponent est bien attaché et que speed > 0

### "Les ennemis ne m'attaquent pas"
→ Vérifiez les collision layers (Player = 1, Enemy = 2)

### "Le jeu crash au démarrage"
→ Regardez la console (Output) pour les erreurs

### "Je ne vois pas mes modifications"
→ Assurez-vous de sauvegarder (Ctrl+S) et relancez (F5)

---

## 🎉 Félicitations !

Vous avez appris :
- ✅ L'architecture par composants
- ✅ Comment modifier le jeu sans coder
- ✅ Comment créer vos propres composants
- ✅ Les bases de Godot et GDScript

**Continuez à expérimenter et construisez votre RPG !** 🚀
