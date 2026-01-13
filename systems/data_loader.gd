extends Node

## Système de chargement de données
## Charge les configurations depuis des fichiers JSON

var game_config: Dictionary = {}

func _ready():
	load_game_config()

## Charger la configuration du jeu
func load_game_config() -> void:
	var file_path = "res://data/game_config.json"
	
	if not FileAccess.file_exists(file_path):
		push_warning("Config file not found: " + file_path)
		return
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("Could not open config file")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result == OK:
		game_config = json.data
		print("Game config loaded successfully")
	else:
		push_error("Error parsing JSON: " + json.get_error_message())

## Obtenir les stats d'un ennemi
func get_enemy_data(enemy_type: String) -> Dictionary:
	if game_config.has("enemies") and game_config["enemies"].has(enemy_type):
		return game_config["enemies"][enemy_type]
	return {}

## Obtenir les paramètres du joueur
func get_player_data() -> Dictionary:
	if game_config.has("player"):
		return game_config["player"]
	return {}

## Obtenir les paramètres de jeu
func get_game_settings() -> Dictionary:
	if game_config.has("game_settings"):
		return game_config["game_settings"]
	return {}

## Appliquer les données à un ennemi
func apply_enemy_data(enemy: Node2D, enemy_type: String) -> void:
	var data = get_enemy_data(enemy_type)
	if data.is_empty():
		return
	
	var health = enemy.get_node_or_null("HealthComponent")
	if health:
		health.max_health = data.get("health", 50)
		health.current_health = health.max_health
	
	var movement = enemy.get_node_or_null("MovementComponent")
	if movement:
		movement.speed = data.get("speed", 80)
	
	var attack = enemy.get_node_or_null("AttackComponent")
	if attack:
		attack.damage = data.get("damage", 10)
		attack.attack_range = data.get("attack_range", 35)
	
	var ai = enemy.get_node_or_null("AIComponent")
	if ai:
		ai.detection_range = data.get("detection_range", 150)
	
	var visual = enemy.get_node_or_null("Visual")
	if visual and visual is ColorRect:
		var color_array = data.get("color", [1.0, 0.3, 0.3])
		visual.color = Color(color_array[0], color_array[1], color_array[2])
