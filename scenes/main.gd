extends Node2D

## Script principal
## Initialise le MapManager et lance la première carte

@onready var player = $Player
@onready var map_manager = $MapManager
@onready var global_ui = $GlobalUI

func _ready():
	# Lier le joueur à l'interface globale
	if global_ui:
		global_ui.set_player(player)
	
	# Connexion au signal de mort du joueur
	player.player_died.connect(_on_player_died)
	
	# Initialiser le MapManager avec la carte de départ
	map_manager.load_initial_map(player)
	
	# Charger la première carte de façon asynchrone
	await map_manager.switch_map("map_forest", "portal_to_desert")  # Spawn au portail vers le désert
	
	print("=== RPG Prototype - Système Multi-Cartes ===")
	print("Utilisez WASD ou les flèches pour vous déplacer")
	print("Appuyez sur ESPACE pour attaquer")
	print("Appuyez sur PAGE UP pour ouvrir les stats corporelles")
	print("Appuyez sur PAGE DOWN pour ouvrir les stats d'attaque")
	print("")
	print("🗺️ NOUVEAU : Système de Téléportation et Multi-Cartes!")
	print("- Entrez dans les PORTAILS colorés pour changer de carte")
	print("- Vos stats et XP sont PRÉSERVÉS entre les cartes")
	print("- 3 cartes disponibles : Forêt (verte), Désert (orange), Caverne (violette)")
	print("- Chaque carte a des ennemis de couleurs différentes")
	print("- Les ennemis sont plus forts dans le Désert et la Caverne !")
	print("")
	print("Explorez les différentes cartes et devenez plus fort!")

func _on_player_died():
	print("Game Over!")
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
