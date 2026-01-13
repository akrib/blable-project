# PATCH pour entities/player.gd
# Ajouter le respawn en ville lors de la mort

## 🔧 Modification à appliquer dans player.gd

### Remplacer la fonction _on_died() existante par :

```gdscript
func _on_died():
	print("💀 Joueur mort")
	player_died.emit()
	
	# Vérifier si on est dans une zone sûre
	var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
	
	if map_manager:
		# Si déjà en ville, juste restaurer la santé
		if map_manager.is_in_safe_zone():
			print("🏥 Déjà en zone sûre - Restauration de la santé")
			if health_component:
				health_component.heal(health_component.max_health)
			return
		
		# Sinon, respawn en ville
		print("🚑 Téléportation vers la zone sûre (Ville)")
		map_manager.respawn_player_in_ville(self)
	else:
		# Fallback : comportement par défaut (suppression)
		push_warning("⚠️ MapManager non trouvé - Suppression du joueur")
		queue_free()
```

---

## 📝 Explication des Changements

### Avant (Ancien Code)
```gdscript
func _on_died():
	player_died.emit()
	queue_free()  # Le joueur disparaît = Game Over
```

### Après (Nouveau Code)
```gdscript
func _on_died():
	player_died.emit()
	
	# Vérifier où on est
	if en_ville:
		# Juste restaurer HP
	else:
		# Téléporter en ville + restaurer HP
```

---

## 🎮 Comportement

### Mort dans la Forêt/Désert/Caverne
1. Le joueur meurt
2. **Téléportation automatique** vers la Ville
3. **Santé restaurée** à 100%
4. **Stats préservées** (XP, niveaux, points)
5. Le joueur peut réessayer

### Mort en Ville (cas rare)
1. Le joueur ne peut pas mourir normalement (pas d'ennemis)
2. Si mort forcée (ex: chute dans le vide futur)
3. **Santé restaurée** sans téléportation
4. Reste en ville

---

## ✨ Fonctionnalités Bonus (Optionnel)

### Pénalité de Mort

Si vous voulez ajouter une pénalité légère :

```gdscript
func _on_died():
	player_died.emit()
	
	var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
	
	if map_manager and not map_manager.is_in_safe_zone():
		# Pénalité : Perdre 10% de l'XP actuelle
		var body_stats = get_node_or_null("BodyStatsComponent")
		if body_stats:
			var xp_loss = int(body_stats.current_xp * 0.1)
			body_stats.current_xp = max(0, body_stats.current_xp - xp_loss)
			print("💸 Perte de ", xp_loss, " XP corporelle")
		
		var attack_stats = get_node_or_null("AttackStatsComponent")
		if attack_stats:
			var xp_loss = int(attack_stats.current_xp * 0.1)
			attack_stats.current_xp = max(0, attack_stats.current_xp - xp_loss)
			print("💸 Perte de ", xp_loss, " XP d'attaque")
		
		# Téléporter
		map_manager.respawn_player_in_ville(self)
```

### Effet Visuel de Mort

Ajoutez un fade out avant la téléportation :

```gdscript
func _on_died():
	player_died.emit()
	
	# Effet de fade
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	
	# Puis téléportation
	var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
	if map_manager:
		map_manager.respawn_player_in_ville(self)
	
	# Fade in
	modulate.a = 1.0
```

### Message de Mort

Afficher un message temporaire :

```gdscript
func _on_died():
	player_died.emit()
	show_death_message()
	
	await get_tree().create_timer(2.0).timeout
	
	var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
	if map_manager:
		map_manager.respawn_player_in_ville(self)

func show_death_message():
	var label = Label.new()
	label.text = "💀 VOUS ÊTES MORT 💀\nRetour à la ville..."
	label.position = Vector2(300, 250)
	label.z_index = 1000
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color.RED)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	get_tree().root.add_child(label)
	
	await get_tree().create_timer(2.0).timeout
	label.queue_free()
```

---

## 🧪 Tests à Effectuer

### Test 1 : Mort Basique
1. ✅ Aller dans la Forêt
2. ✅ Se faire tuer par un ennemi
3. ✅ Vérifier téléportation en Ville
4. ✅ Vérifier santé restaurée

### Test 2 : Préservation des Stats
1. ✅ Monter plusieurs niveaux
2. ✅ Se faire tuer
3. ✅ Vérifier que XP/niveaux sont conservés

### Test 3 : Mort Multiple
1. ✅ Mourir 3 fois de suite
2. ✅ Vérifier que ça fonctionne toujours

### Test 4 : Mort en Ville (Edge Case)
1. ✅ Être en Ville
2. ✅ Forcer la mort (via console ou debug)
3. ✅ Vérifier comportement

---

## 🔍 Debugging

Si le respawn ne fonctionne pas :

### Vérification 1 : MapManager existe ?
```gdscript
var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
if not map_manager:
	print("❌ MapManager introuvable!")
else:
	print("✅ MapManager trouvé")
```

### Vérification 2 : Fonction respawn_player_in_ville existe ?
```gdscript
if map_manager.has_method("respawn_player_in_ville"):
	print("✅ Méthode respawn disponible")
else:
	print("❌ Méthode respawn manquante")
```

### Vérification 3 : Signal player_died connecté ?
```gdscript
func _ready():
	health_component.died.connect(_on_died)
	print("✅ Signal de mort connecté")
```

---

## 📊 Statistiques de Mort (Bonus)

Ajoutez un compteur de morts :

```gdscript
# Dans player.gd
var death_count: int = 0

func _on_died():
	death_count += 1
	print("💀 Mort #", death_count)
	player_died.emit()
	
	# Afficher un message différent selon le nombre de morts
	if death_count == 1:
		print("💬 'Tout le monde commence quelque part...'")
	elif death_count == 5:
		print("💬 'Persévérance est la clé du succès!'")
	elif death_count == 10:
		print("💬 'Tu es encore là ? Impressionnant!'")
	
	# Téléportation
	var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
	if map_manager:
		map_manager.respawn_player_in_ville(self)
```

---

## 🎯 Résumé des Modifications

| Fichier | Action | Difficulté |
|---------|--------|-----------|
| `player.gd` | Modifier `_on_died()` | ⭐ Facile |
| `map_manager.gd` | Ajouter définition "ville" | ⭐ Facile |
| `map_manager.gd` | Ajouter `respawn_player_in_ville()` | ⭐⭐ Moyen |

**Temps estimé** : 15-30 minutes

---

## ✅ Validation Finale

Avant de valider, assurez-vous que :

- [ ] Le joueur respawn en ville après la mort
- [ ] La santé est restaurée à 100%
- [ ] Les XP et niveaux sont préservés
- [ ] Les stats investies sont conservées
- [ ] Pas de crash ou d'erreur dans la console
- [ ] Le message de mort s'affiche (si implémenté)
- [ ] L'effet visuel fonctionne (si implémenté)

**Tout est bon ? Profitez de votre système de respawn ! 🎉**
