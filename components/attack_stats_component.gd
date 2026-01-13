extends Node
class_name AttackStatsComponent

## Composant de statistiques d'attaque
## Gère les stats d'attaque élémentaires et leur amélioration

signal stats_changed()
signal level_up(new_level: int, points_gained: int)

# Constantes de configuration
const POINTS_PER_LEVEL: int = 3  # Points gagnés par niveau
const XP_BASE: int = 80
const XP_MULTIPLIER: float = 1.4

# Niveau et expérience
var current_level: int = 1
var current_xp: int = 0
var available_points: int = 0

# Statistiques d'attaque
var stats: Dictionary = {
	"damage_air": 0,
	"damage_fire": 0,
	"damage_water": 0,
	"damage_earth": 0,
	"attack_width": 0,
	"attack_length": 0,
	"attack_distance": 0
}

# Valeurs de base
const BASE_DAMAGE: int = 5
const BASE_WIDTH: float = 30.0
const BASE_LENGTH: float = 40.0
const BASE_DISTANCE: float = 15.0

func _ready():
	available_points = POINTS_PER_LEVEL  # Points de départ

## Obtenir l'XP nécessaire pour le prochain niveau
func get_xp_for_next_level() -> int:
	return int(XP_BASE * pow(XP_MULTIPLIER, current_level - 1))

## Ajouter de l'expérience
func add_xp(amount: int) -> void:
	current_xp += amount
	
	while current_xp >= get_xp_for_next_level():
		level_up_attack()

## Monter de niveau
func level_up_attack() -> void:
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

## Calculer les dégâts élémentaires totaux
func get_total_elemental_damage() -> Dictionary:
	return {
		"air": BASE_DAMAGE + (stats["damage_air"] * 3),
		"fire": BASE_DAMAGE + (stats["damage_fire"] * 3),
		"water": BASE_DAMAGE + (stats["damage_water"] * 3),
		"earth": BASE_DAMAGE + (stats["damage_earth"] * 3)
	}

## Calculer les dégâts totaux (somme de tous les éléments)
func get_total_damage() -> int:
	var damages = get_total_elemental_damage()
	return damages["air"] + damages["fire"] + damages["water"] + damages["earth"]

## Obtenir l'élément dominant
func get_dominant_element() -> String:
	var damages = get_total_elemental_damage()
	var max_damage = 0
	var dominant = "air"
	
	for element in damages.keys():
		if damages[element] > max_damage:
			max_damage = damages[element]
			dominant = element
	
	return dominant

## Calculer la largeur de l'attaque
func get_attack_width() -> float:
	return BASE_WIDTH + (stats["attack_width"] * 5.0)

## Calculer la longueur de l'attaque
func get_attack_length() -> float:
	return BASE_LENGTH + (stats["attack_length"] * 8.0)

## Calculer la distance de l'attaque par rapport au corps
func get_attack_distance() -> float:
	return BASE_DISTANCE + (stats["attack_distance"] * 5.0)

## Obtenir la couleur de l'attaque basée sur l'élément dominant
func get_attack_color() -> Color:
	var element = get_dominant_element()
	match element:
		"air":
			return Color(0.8, 1.0, 1.0)  # Cyan clair
		"fire":
			return Color(1.0, 0.4, 0.2)  # Rouge-orange
		"water":
			return Color(0.2, 0.5, 1.0)  # Bleu
		"earth":
			return Color(0.6, 0.4, 0.2)  # Marron
		_:
			return Color(1.0, 1.0, 0.0)  # Jaune par défaut

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

## Obtenir les stats d'attaque formatées pour l'affichage
func get_attack_info() -> Dictionary:
	return {
		"width": get_attack_width(),
		"length": get_attack_length(),
		"distance": get_attack_distance(),
		"total_damage": get_total_damage(),
		"element": get_dominant_element(),
		"color": get_attack_color()
	}
