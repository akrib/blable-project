extends Node
class_name AIComponent

## Composant d'IA simple pour les ennemis
## Comportement de type "chase and attack"

enum AIState { IDLE, CHASE, ATTACK, RETREAT }

@export var detection_range: float = 150.0
@export var attack_range: float = 40.0
@export var retreat_range: float = 20.0
@export var wander_enabled: bool = true
@export var wander_radius: float = 50.0

var current_state: AIState = AIState.IDLE
var target: Node2D = null
var home_position: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0
var wander_direction: Vector2 = Vector2.ZERO

func _ready():
	# Enregistrer la position de départ
	if get_parent() is Node2D:
		home_position = get_parent().global_position

## Mise à jour de l'IA
func update_ai(delta: float, owner_position: Vector2) -> Vector2:
	if target == null or not is_instance_valid(target):
		return get_idle_direction(delta, owner_position)
	
	var distance_to_target = owner_position.distance_to(target.global_position)
	
	# Machine à états simple
	if distance_to_target <= attack_range:
		current_state = AIState.ATTACK
		return Vector2.ZERO  # Ne bouge pas pendant l'attaque
	elif distance_to_target <= detection_range:
		current_state = AIState.CHASE
		return (target.global_position - owner_position).normalized()
	else:
		current_state = AIState.IDLE
		return get_idle_direction(delta, owner_position)

## Direction en mode idle (errance ou retour à la base)
func get_idle_direction(delta: float, owner_position: Vector2) -> Vector2:
	if not wander_enabled:
		return Vector2.ZERO
	
	# Retourner vers la position de départ si trop loin
	var distance_from_home = owner_position.distance_to(home_position)
	if distance_from_home > wander_radius * 2:
		return (home_position - owner_position).normalized()
	
	# Errance aléatoire
	wander_timer -= delta
	if wander_timer <= 0:
		wander_timer = randf_range(2.0, 4.0)
		wander_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	return wander_direction

## Définir la cible
func set_target(new_target: Node2D) -> void:
	target = new_target

## Vérifier si peut attaquer
func should_attack() -> bool:
	return current_state == AIState.ATTACK and target != null

## Obtenir l'état actuel
func get_state() -> AIState:
	return current_state
