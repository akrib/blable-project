extends Node
class_name AttackComponent

## Composant d'attaque réutilisable
## Gère la création et le timing des attaques

signal attack_started()
signal attack_finished()

@export var damage: int = 10
@export var attack_cooldown: float = 0.5
@export var attack_duration: float = 0.2
@export var attack_range: float = 30.0
@export var knockback_force: float = 150.0

var can_attack: bool = true
var is_attacking: bool = false
var cooldown_timer: float = 0.0
var attack_timer: float = 0.0

func _process(delta: float):
	# Gestion du cooldown
	if not can_attack:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_attack = true
	
	# Gestion de la durée d'attaque
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			attack_finished.emit()

## Tenter une attaque
func try_attack() -> bool:
	if can_attack and not is_attacking:
		start_attack()
		return true
	return false

## Démarrer une attaque
func start_attack() -> void:
	is_attacking = true
	can_attack = false
	attack_timer = attack_duration
	cooldown_timer = attack_cooldown
	attack_started.emit()

## Vérifier si une cible est dans la portée d'attaque
func is_in_range(attacker_pos: Vector2, target_pos: Vector2) -> bool:
	return attacker_pos.distance_to(target_pos) <= attack_range

## Calculer la direction du knockback
func get_knockback_direction(attacker_pos: Vector2, target_pos: Vector2) -> Vector2:
	return (target_pos - attacker_pos).normalized()

## Obtenir la force de knockback comme vecteur
func get_knockback_impulse(attacker_pos: Vector2, target_pos: Vector2) -> Vector2:
	return get_knockback_direction(attacker_pos, target_pos) * knockback_force
