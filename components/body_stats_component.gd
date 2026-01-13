extends Node
class_name BodyStatsComponent


@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var level: int = 1  # ← Ajoute cette ligne

## Composant de statistiques corporelles
## Gère les stats physiques du personnage et leur amélioration

signal stats_changed()
signal level_up(new_level: int, points_gained: int)

# Constantes de configuration
const POINTS_PER_LEVEL: int = 5  # Points gagnés par niveau
const XP_BASE: int = 100
const XP_MULTIPLIER: float = 1.5

# Niveau et expérience
var current_level: int = 1
var current_xp: int = 0
var available_points: int = 0

# Statistiques corporelles
var stats: Dictionary = {
	"movement_speed": 0,
	"health_points": 0,
	"defense": 0,
	"luck": 0,
	"intelligence": 0,
	"dexterity": 0,
	"attack_speed": 0
}

# Valeurs de base (avant bonus de stats)
const BASE_SPEED: float = 100.0
const BASE_HEALTH: int = 50
const BASE_DEFENSE: float = 0.0
const BASE_ATTACK_SPEED: float = 0.5

func _ready():
	available_points = POINTS_PER_LEVEL  # Points de départ

## Obtenir l'XP nécessaire pour le prochain niveau
func get_xp_for_next_level() -> int:
	return int(XP_BASE * pow(XP_MULTIPLIER, current_level - 1))

## Ajouter de l'expérience
func add_xp(amount: int) -> void:
	current_xp += amount
	
	while current_xp >= get_xp_for_next_level():
		level_up_body()

## Monter de niveau
func level_up_body() -> void:
	current_xp -= get_xp_for_next_level()
	current_level += 1
	available_points += POINTS_PER_LEVEL
	level_up.emit(current_level, POINTS_PER_LEVEL)

## Ajouter un point dans une stat (retourne true si succès)
func add_stat_point(stat_name: String) -> bool:
	if available_points <= 0 or not stats.has(stat_name):
		return false
	
	stats[stat_name] += 1
	available_points -= 1
	stats_changed.emit()
	return true

## Retirer un point d'une stat (retourne true si succès)
func remove_stat_point(stat_name: String) -> bool:
	if not stats.has(stat_name) or stats[stat_name] <= 0:
		return false
	
	stats[stat_name] -= 1
	available_points += 1
	stats_changed.emit()
	return true

## Calculer la vitesse de mouvement finale
func get_movement_speed() -> float:
	return BASE_SPEED + (stats["movement_speed"] * 10.0)

## Calculer les points de vie max
func get_max_health() -> int:
	return BASE_HEALTH + (stats["health_points"] * 10)

## Calculer la défense (réduction de dégâts en %)
func get_defense_percentage() -> float:
	var defense_value = stats["defense"] * 2.0
	# Cap à 80% de réduction
	return min(defense_value, 80.0)

## Calculer le modificateur de chance (pour crits, drops, etc.)
func get_luck_modifier() -> float:
	return 1.0 + (stats["luck"] * 0.05)  # +5% par point

## Calculer le modificateur d'intelligence (pour dégâts magiques)
func get_intelligence_modifier() -> float:
	return 1.0 + (stats["intelligence"] * 0.08)  # +8% par point

## Calculer le modificateur de dexterité (pour précision, esquive)
func get_dexterity_modifier() -> float:
	return 1.0 + (stats["dexterity"] * 0.06)  # +6% par point

## Calculer la vitesse d'attaque (cooldown réduit)
func get_attack_cooldown() -> float:
	var reduction = stats["attack_speed"] * 0.02  # -0.02s par point
	return max(BASE_ATTACK_SPEED - reduction, 0.1)  # Min 0.1s

## Obtenir le total de points investis
func get_total_points_spent() -> int:
	var total = 0
	for value in stats.values():
		total += value
	return total

## Réinitialiser tous les points
func reset_stats() -> void:
	available_points += get_total_points_spent()
	for key in stats.keys():
		stats[key] = 0
	stats_changed.emit()

## Obtenir le pourcentage d'XP actuel
func get_xp_percentage() -> float:
	return float(current_xp) / float(get_xp_for_next_level())
