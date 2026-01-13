extends Node2D

@onready var map_manager: MapManager = $MapManager

func _ready():
	# Attendre que tout soit chargé
	await get_tree().process_frame
	
	# Le MapManager s'initialisera tout seul
	if map_manager:
		map_manager.initialize()
	else:
		push_error("❌ MapManager introuvable!")
	
	# Connecter les signaux si nécessaire
	if map_manager:
		map_manager.map_changed.connect(_on_map_changed)
		map_manager.player_needed.connect(_on_player_needed)

func _on_map_changed(map_id: String) -> void:
	print("📍 Main notifié : nouvelle carte = ", map_id)

func _on_player_needed() -> void:
	push_error("❌ Le joueur est requis mais introuvable!")

## Script principal du jeu
## Initialise le MapManager et charge la carte de départ

func get_player_reference() -> CharacterBody2D:
	"""Récupère une référence au joueur dans la scène"""
	
	# Méthode 1 : Le joueur est un enfant direct de Main
	var player_node = get_node_or_null("Player")
	if player_node:
		print("✅ Joueur trouvé comme enfant de Main")
		return player_node
	
	# Méthode 2 : Le joueur est dans la carte actuelle
	if map_manager and map_manager.current_map:
		player_node = map_manager.current_map.get_node_or_null("Player")
		if player_node:
			print("✅ Joueur trouvé dans la carte")
			return player_node
	
	# Méthode 3 : Chercher dans toute la scène
	player_node = get_tree().root.find_child("Player", true, false)
	if player_node:
		print("✅ Joueur trouvé dans l'arbre de scène")
		return player_node
	
	push_error("❌ Joueur introuvable dans la scène!")
	return null
