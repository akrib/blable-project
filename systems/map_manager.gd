extends Node
class_name MapManager

## Gestionnaire de cartes
## Gère le chargement/déchargement des cartes et la transition entre elles

signal map_changed(old_map: String, new_map: String)
signal map_loaded(map_name: String)

var current_map: Node2D = null
var current_map_name: String = ""
var player: Player = null

# Stockage de l'état du joueur entre les cartes
var player_data: Dictionary = {}

# Référence aux scènes de cartes
var map_scenes: Dictionary = {
	"map_forest": "res://scenes/maps/map_forest.tscn",
	"map_desert": "res://scenes/maps/map_desert.tscn",
	"map_cave": "res://scenes/maps/map_cave.tscn"
}

func _ready():
	pass

## Initialiser avec la carte de départ et le joueur
func initialize(starting_map: String, starting_player: Player):
	player = starting_player
	current_map_name = starting_map
	_save_player_data()

## Changer de carte
func switch_map(target_map_name: String, target_portal_id: String) -> void:
	if not map_scenes.has(target_map_name):
		push_error("Map not found: " + target_map_name)
		return
	
	# Sauvegarder l'état du joueur
	_save_player_data()
	
	var old_map_name = current_map_name
	
	# Décharger l'ancienne carte
	if current_map:
		_unload_current_map()
	
	# Charger la nouvelle carte
	_load_map(target_map_name, target_portal_id)
	
	current_map_name = target_map_name
	map_changed.emit(old_map_name, target_map_name)

## Charger une carte
func _load_map(map_name: String, spawn_portal_id: String):
	var map_scene_path = map_scenes[map_name]
	var map_scene = load(map_scene_path)
	
	if map_scene:
		current_map = map_scene.instantiate()
		get_tree().root.add_child(current_map)
		
		# Positionner le joueur au portail de destination
		_spawn_player_at_portal(spawn_portal_id)
		
		# Connecter les portails de cette carte
		_connect_portals()
		
		map_loaded.emit(map_name)

## Décharger la carte actuelle
func _unload_current_map():
	if current_map:
		# Retirer le joueur de la carte avant de la supprimer
		if player and player.get_parent() == current_map:
			current_map.remove_child(player)
		
		current_map.queue_free()
		current_map = null

## Placer le joueur à un portail spécifique
func _spawn_player_at_portal(portal_id: String):
	if not current_map or not player:
		return
	
	# Chercher le portail de spawn
	var spawn_portal = _find_portal_by_id(portal_id)
	
	if spawn_portal:
		# Ajouter le joueur à la carte
		current_map.add_child(player)
		
		# Positionner le joueur sur le portail
		player.global_position = spawn_portal.global_position
		
		# Restaurer les données du joueur
		_restore_player_data()
		
		# Désactiver temporairement le portail pour éviter la retéléportation
		spawn_portal.disable_temporarily(1.0)
		
		# Mettre à jour la caméra
		var camera = current_map.get_node_or_null("Camera2D")
		if camera and camera.has_method("set_target"):
			camera.set_target(player)
		
		# Mettre à jour le HUD
		var hud = current_map.get_node_or_null("HUD")
		if hud and hud.has_method("set_player"):
			hud.set_player(player)
	else:
		push_warning("Spawn portal not found: " + portal_id)
		# Position par défaut
		current_map.add_child(player)
		player.global_position = Vector2.ZERO
		_restore_player_data()

## Trouver un portail par son ID
func _find_portal_by_id(portal_id: String) -> Portal:
	if not current_map:
		return null
	
	var portals = _get_all_portals()
	for portal in portals:
		if portal.portal_id == portal_id:
			return portal
	
	return null

## Obtenir tous les portails de la carte actuelle
func _get_all_portals() -> Array:
	if not current_map:
		return []
	return _find_nodes_of_type(current_map, "Portal")

## Trouver tous les nœuds d'un type donné
func _find_nodes_of_type(node: Node, class_id: String) -> Array:
	var result := []

	if node.is_class(class_id):
		result.append(node)
	
	for child in node.get_children():
		result.append_array(_find_nodes_of_type(child, class_id))
	
	return result

## Connecter tous les portails de la carte actuelle
func _connect_portals():
	var portals = _get_all_portals()
	
	for portal in portals:
		if not portal.player_entered_portal.is_connected(_on_portal_activated):
			portal.player_entered_portal.connect(_on_portal_activated)

## Callback quand un portail est activé
func _on_portal_activated(portal: Portal):
	switch_map(portal.target_map, portal.target_portal_id)

## Sauvegarder les données du joueur
func _save_player_data():
	if not player:
		return
	
	player_data = {
		"position": player.global_position,
		
		# Stats corporelles
		"body_level": player.body_stats.current_level,
		"body_xp": player.body_stats.current_xp,
		"body_available_points": player.body_stats.available_points,
		"body_stats": player.body_stats.stats.duplicate(),
		
		# Stats d'attaque
		"attack_level": player.attack_stats.current_level,
		"attack_xp": player.attack_stats.current_xp,
		"attack_available_points": player.attack_stats.available_points,
		"attack_stats": player.attack_stats.stats.duplicate(),
		
		# Santé actuelle
		"current_health": player.health_component.current_health,
		"max_health": player.health_component.max_health
	}

## Restaurer les données du joueur
func _restore_player_data():
	if not player or player_data.is_empty():
		return
	
	# Stats corporelles
	player.body_stats.current_level = player_data.get("body_level", 1)
	player.body_stats.current_xp = player_data.get("body_xp", 0)
	player.body_stats.available_points = player_data.get("body_available_points", 0)
	player.body_stats.stats = player_data.get("body_stats", {}).duplicate()
	
	# Stats d'attaque
	player.attack_stats.current_level = player_data.get("attack_level", 1)
	player.attack_stats.current_xp = player_data.get("attack_xp", 0)
	player.attack_stats.available_points = player_data.get("attack_available_points", 0)
	player.attack_stats.stats = player_data.get("attack_stats", {}).duplicate()
	
	# Santé
	player.health_component.current_health = player_data.get("current_health", 50)
	player.health_component.max_health = player_data.get("max_health", 50)
	
	# Appliquer les stats
	player._apply_body_stats()
	player._apply_attack_stats()
	
	# Émettre les signaux pour mettre à jour l'UI
	player.body_stats.stats_changed.emit()
	player.attack_stats.stats_changed.emit()
	player.health_component.health_changed.emit(
		player.health_component.current_health,
		player.health_component.max_health
	)

## Obtenir la carte actuelle
func get_current_map() -> Node2D:
	return current_map

## Obtenir le nom de la carte actuelle
func get_current_map_name() -> String:
	return current_map_name
