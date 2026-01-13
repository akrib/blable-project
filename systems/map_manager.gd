# map_manager.gd
extends Node
class_name MapManager

signal map_changed(map_id: String)
signal map_ready()
signal player_needed()  # ✅ Signal pour demander le joueur

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


var current_map_id: String = "ville"
var current_map: Node2D = null
var player_stats_backup: Dictionary = {}
var _player: CharacterBody2D = null  # Référence privée

func _ready():
	print("🗺️ MapManager initialisé")

func set_player(player: CharacterBody2D) -> void:
	"""Enregistre le joueur (appelé de l'extérieur)"""
	_player = player
	print("✅ MapManager a reçu le joueur: ", player.name if player else "null")

func get_player() -> CharacterBody2D:
	"""Récupère le joueur (avec lazy loading)"""
	if not _player:
		# Tenter de trouver le joueur dans l'arbre
		_player = get_tree().get_first_node_in_group("player")
		
		if not _player:
			push_warning("⚠️ Joueur non trouvé, émission du signal player_needed")
			player_needed.emit()
	
	return _player

func initialize() -> void:
	"""Initialize sans dépendance directe"""
	print("🗺️ Initialisation du MapManager")
	
	# Attendre un frame pour s'assurer que tout est prêt
	await get_tree().process_frame
	
	# Charger la carte initiale
	load_initial_map()

func load_initial_map() -> void:
	"""Charge la carte initiale (Ville)"""
	change_map(current_map_id)

func change_map(map_id: String) -> void:
	"""Change la carte actuelle et téléporte le joueur"""
	
	if not MAP_DEFINITIONS.has(map_id):
		push_error("❌ Carte inconnue: " + map_id)
		return
	
	var player = get_player()
	if not player:
		push_error("❌ Impossible de changer de carte : joueur introuvable")
		return
	
	print("🗺️ Changement de carte: ", current_map_id, " → ", map_id)
	
	# Sauvegarder les stats
	save_player_stats()
	
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
	
	# Restaurer les stats
	restore_player_stats()
	
	# Positionner le joueur
	var spawn_pos = map_def.get("spawn_position", Vector2.ZERO)
	if current_map.has_method("get_spawn_position"):
		spawn_pos = current_map.get_spawn_position()
	
	player.global_position = spawn_pos
	print("✅ Joueur téléporté à: ", spawn_pos)
	
	# Mettre à jour l'UI
	update_map_ui(map_id)
	
	# Émettre les signaux
	map_changed.emit(map_id)
	map_ready.emit()
	
	# Log
	if map_def.get("is_safe_zone", false):
		print("✅ Entré dans la zone sûre: ", map_def["display_name"])
	else:
		print("⚔️ Entré dans: ", map_def["display_name"], " (Difficulté: ", map_def.get("difficulty", 0), ")")

func save_player_stats() -> void:
	"""Sauvegarde les stats du joueur"""
	var player = get_player()
	if not player:
		return
	
	# ... votre code de sauvegarde existant ...
	var body_stats = player.get_node_or_null("BodyStatsComponent")
	if body_stats:
		player_stats_backup["body_level"] = body_stats.get("level") if body_stats.get("level") != null else 1
		player_stats_backup["body_xp"] = body_stats.get("current_xp") if body_stats.get("current_xp") != null else 0
		# ... etc

func restore_player_stats() -> void:
	"""Restaure les stats du joueur"""
	var player = get_player()
	if not player or player_stats_backup.is_empty():
		return

func respawn_player_in_ville():
	"""Téléporte le joueur en ville (après la mort)"""
	print("💀 Respawn du joueur en ville")
	
	var player = get_player()  # ✅ Utilise get_player() au lieu de player_reference
	if not player:
		push_error("❌ Impossible de respawn : joueur null")
		return
	
	# Restaurer la santé complète
	var health_comp = player.get_node_or_null("HealthComponent")
	if health_comp:
		# ✅ Correction de la parenthèse manquante
		health_comp.heal(health_comp.max_health)
		print("✅ Santé restaurée à ", health_comp.max_health)
	else:
		push_warning("⚠️ HealthComponent introuvable, santé non restaurée")
	
	# Téléporter en ville
	change_map("ville")
	
	print("✅ Joueur respawné en ville")

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
