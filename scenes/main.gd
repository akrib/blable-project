extends Node2D

## Script principal
## Initialise le MapManager et lance la première carte

@onready var player = $Player
@onready var map_manager = $MapManager
@onready var body_stats_ui = $BodyStatsUI
@onready var attack_stats_ui = $AttackStatsUI

func _ready():
	# Lier les interfaces de stats au joueur
	if body_stats_ui and player.body_stats:
		body_stats_ui.set_body_stats(player.body_stats)
	
	if attack_stats_ui and player.attack_stats:
		attack_stats_ui.set_attack_stats(player.attack_stats)
	
	# Connexion au signal de mort du joueur
	player.player_died.connect(_on_player_died)
	
	# Initialiser le MapManager avec la carte de départ
	map_manager.initialize("map_forest", player)
	map_manager.switch_map("map_forest", "portal_to_desert")  # Spawn au portail vers le désert
	
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
