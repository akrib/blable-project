extends Node
class_name HealthComponent

## Composant de santé réutilisable
## Gère les points de vie, dégâts, et mort

signal health_changed(current_health: int, max_health: int)
signal damage_taken(amount: int)
signal died()
signal healed(amount: int)

@export var max_health: int = 100
@export var current_health: int = 100
@export var invincible: bool = false
@export var invincibility_duration: float = 0.5

var is_invincible: bool = false
var invincibility_timer: float = 0.0

func _ready():
	current_health = max_health
	health_changed.emit(current_health, max_health)

func _process(delta: float):
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			is_invincible = false

## Infliger des dégâts
func take_damage(amount: int) -> void:
	if is_invincible or invincible:
		return
	
	current_health = maxi(0, current_health - amount)
	damage_taken.emit(amount)
	health_changed.emit(current_health, max_health)
	
	# Invincibilité temporaire après avoir pris des dégâts
	is_invincible = true
	invincibility_timer = invincibility_duration
	
	if current_health <= 0:
		died.emit()

## Soigner
func heal(amount: int) -> void:
	var old_health = current_health
	current_health = mini(max_health, current_health + amount)
	var actual_heal = current_health - old_health
	
	if actual_heal > 0:
		healed.emit(actual_heal)
		health_changed.emit(current_health, max_health)

## Vérifier si l'entité est vivante
func is_alive() -> bool:
	return current_health > 0

## Réinitialiser la santé au maximum
func reset_health() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

## Obtenir le pourcentage de santé (0.0 à 1.0)
func get_health_percentage() -> float:
	return float(current_health) / float(max_health)
