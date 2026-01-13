extends Node
class_name MapManager

## Gestionnaire de cartes avec support de la Ville (spawn/safe zone)

signal map_changed(map_id: String)
signal map_ready()

const MAP_DEFINITIONS = {
	"ville": {
		"name": "Ville",
		"display_name": "🏘️ VILLE - ZONE SÛRE",
		"scene_path": "res://maps/ville_map.tscn",
		"spawn_position": Vector2(0, 0),
		"background_color": Color(0.3, 0.35, 0.45),
		"is_safe_zone": true,
		"description": "Zone de départ sans ennemis"
	},
	"forest": {
		"name": "Forêt",
		"display_name": "🌲 FORÊT VERTE",
		"scene_path": "res://maps/forest_map.tscn",
		"spawn_position": Vector2(0, 0),
		"background_color": Color(0.15, 0.25, 0.15),
		"enemy_count": 5,
		"difficulty": 1
	},
	"desert": {
		"name": "Désert",
		"display_name": "🏜️ DÉSERT DORÉ",
		"scene_path": "res://maps/desert_map.tscn",
		"spawn_position": Vector2(0, 0),
		"background_color": Color(0.9, 0.73, 0.3),
		"enemy_count": 6,
		"difficulty": 2
	},
	"cavern": {
		"name": "Caverne",
		"display_name": "🕳️ CAVERNE SOMBRE",
		"scene_path": "res://maps/cavern_map.tscn",
		"spawn_position": Vector2(0, 0),
		"background_color": Color(0.2, 0.15, 0.25),
		"enemy_count": 7,
		"difficulty": 3
	}
}

var current_map_id: String = "ville"  # Démarrer en ville
var current_map: Node2D = null
var player_stats_backup: Dictionary = {}

func _ready():
	print("🗺️ MapManager initialisé")

func load_initial_map(player: CharacterBody2D):
	"""Charge la carte initiale (Ville)"""
	change_map(current_map_id, player)

func change_map(map_id: String, player: CharacterBody2D):
	"""Change la carte actuelle et téléporte le joueur"""
	
	if not MAP_DEFINITIONS.has(map_id):
		push_error("❌ Carte inconnue: " + map_id)
		return
	
	print("🗺️ Changement de carte: ", current_map_id, " → ", map_id)
	
	# Sauvegarder les stats du joueur
	save_player_stats(player)
	
	# Décharger l'ancienne carte
	if current_map:
		current_map.queue_free()
		current_map = null
	
	# Charger la nouvelle carte
	var map_def = MAP_DEFINITIONS[map_id]
	var map_scene = load(map_def["scene_path"])
	
	if not map_scene:
		push_error("❌ Impossible de charger la scène: " + map_def["scene_path"])
		return
	
	current_map = map_scene.instantiate()
	current_map_id = map_id
	
	# Ajouter la carte à la scène
	get_parent().add_child(current_map)
	
	# Restaurer les stats du joueur
	restore_player_stats(player)
	
	# Positionner le joueur
	var spawn_pos = map_def.get("spawn_position", Vector2.ZERO)
	if current_map.has_method("get_spawn_position"):
		spawn_pos = current_map.get_spawn_position()
	
	player.global_position = spawn_pos
	
	# Mettre à jour l'UI
	update_map_ui(map_id)
	
	# Émettre le signal
	map_changed.emit(map_id)
	map_ready.emit()
	
	# Log
	if map_def.get("is_safe_zone", false):
		print("✅ Entré dans la zone sûre: ", map_def["display_name"])
	else:
		print("⚔️ Entré dans: ", map_def["display_name"], " (Difficulté: ", map_def.get("difficulty", 0), ")")

func respawn_player_in_ville(player: CharacterBody2D):
	"""Téléporte le joueur en ville (après la mort)"""
	print("💀 Respawn du joueur en ville")
	
	# Restaurer la santé complète
	var health_comp = player.get_node_or_null("HealthComponent")
	if health_comp:
		health_comp.heal(health_comp.max_health)
	
	# Téléporter en ville
	change_map("ville", player)

func save_player_stats(player: CharacterBody2D):
	"""Sauvegarde les stats du joueur avant changement de carte"""
	
	# Stats corporelles
	var body_stats = player.get_node_or_null("BodyStatsComponent")
	if body_stats:
		player_stats_backup["body_level"] = body_stats.level
		player_stats_backup["body_xp"] = body_stats.current_xp
		player_stats_backup["body_points"] = body_stats.available_points.duplicate()
		player_stats_backup["body_stats"] = body_stats.current_stats.duplicate()
	
	# Stats d'attaque
	var attack_stats = player.get_node_or_null("AttackStatsComponent")
	if attack_stats:
		player_stats_backup["attack_level"] = attack_stats.level
		player_stats_backup["attack_xp"] = attack_stats.current_xp
		player_stats_backup["attack_points"] = attack_stats.available_points.duplicate()
		player_stats_backup["attack_stats"] = attack_stats.current_stats.duplicate()
	
	# Santé actuelle
	var health_comp = player.get_node_or_null("HealthComponent")
	if health_comp:
		player_stats_backup["current_health"] = health_comp.current_health
		player_stats_backup["max_health"] = health_comp.max_health

func restore_player_stats(player: CharacterBody2D):
	"""Restaure les stats du joueur après changement de carte"""
	
	if player_stats_backup.is_empty():
		return
	
	# Stats corporelles
	var body_stats = player.get_node_or_null("BodyStatsComponent")
	if body_stats and player_stats_backup.has("body_level"):
		body_stats.level = player_stats_backup["body_level"]
		body_stats.current_xp = player_stats_backup["body_xp"]
		body_stats.available_points = player_stats_backup["body_points"].duplicate()
		body_stats.current_stats = player_stats_backup["body_stats"].duplicate()
		body_stats.apply_all_stats()
	
	# Stats d'attaque
	var attack_stats = player.get_node_or_null("AttackStatsComponent")
	if attack_stats and player_stats_backup.has("attack_level"):
		attack_stats.level = player_stats_backup["attack_level"]
		attack_stats.current_xp = player_stats_backup["attack_xp"]
		attack_stats.available_points = player_stats_backup["attack_points"].duplicate()
		attack_stats.current_stats = player_stats_backup["attack_stats"].duplicate()
		attack_stats.apply_all_stats()
	
	# Santé
	var health_comp = player.get_node_or_null("HealthComponent")
	if health_comp and player_stats_backup.has("current_health"):
		health_comp.max_health = player_stats_backup["max_health"]
		health_comp.current_health = player_stats_backup["current_health"]

func update_map_ui(map_id: String):
	"""Met à jour l'interface pour afficher le nom de la carte"""
	var hud = get_tree().root.get_node_or_null("Main/GameHUD")
	if hud and hud.has_method("update_map_name"):
		var map_name = MAP_DEFINITIONS[map_id]["name"]
		hud.update_map_name(map_name)

func get_current_map_name() -> String:
	"""Retourne le nom de la carte actuelle"""
	if MAP_DEFINITIONS.has(current_map_id):
		return MAP_DEFINITIONS[current_map_id]["name"]
	return "Inconnu"

func is_in_safe_zone() -> bool:
	"""Vérifie si la carte actuelle est une zone sûre"""
	if MAP_DEFINITIONS.has(current_map_id):
		return MAP_DEFINITIONS[current_map_id].get("is_safe_zone", false)
	return false

func get_map_difficulty() -> int:
	"""Retourne la difficulté de la carte actuelle (0 = safe zone)"""
	if MAP_DEFINITIONS.has(current_map_id):
		return MAP_DEFINITIONS[current_map_id].get("difficulty", 0)
	return 0
