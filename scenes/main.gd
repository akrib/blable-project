extends Node

## Script principal du jeu
## Initialise le MapManager et charge la carte de départ

# Références
@onready var map_manager: MapManager = $MapManager
var player: CharacterBody2D = null

func _ready():
	print("=================================")
	print("🎮 Démarrage du jeu...")
	print("=================================")
	
	# Vérifier que le MapManager existe
	if not map_manager:
		push_error("❌ ERREUR CRITIQUE : MapManager introuvable!")
		push_error("   → Assure-toi qu'un nœud 'MapManager' existe dans la scène main.tscn")
		return
	
	# Initialiser le MapManager (appeler la fonction initialize si elle existe)
	if map_manager.has_method("initialize"):
		map_manager.initialize(player)
	else:
		print("⚠️ MapManager n'a pas de méthode 'initialize()', on continue...")
	
	# Attendre un frame pour que tout soit prêt
	await get_tree().process_frame
	
	# Récupérer le joueur
	player = get_player_reference()
	
	if not player:
		push_error("❌ ERREUR : Joueur introuvable après initialisation!")
		return
	
	# ✅ CORRECTION : Utiliser "change_map" au lieu de "switch_map"
	# La fonction s'appelle "change_map", pas "switch_map"
	if map_manager.has_method("load_initial_map"):
		map_manager.load_initial_map(player)
	else:
		# Alternative : appeler directement change_map
		map_manager.change_map("ville", player)
	
	print("✅ Initialisation terminée!")
	print("=================================")

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
