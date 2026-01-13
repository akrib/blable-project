extends Node
class_name MovementComponent

## Composant de mouvement réutilisable
## Peut être attaché à n'importe quelle entité pour lui donner la capacité de se déplacer

signal direction_changed(new_direction: Vector2)

@export var speed: float = 100.0
@export var acceleration: float = 800.0
@export var friction: float = 600.0

var velocity: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.DOWN

func _ready():
	pass

## Déplace l'entité selon une direction donnée (normalisée automatiquement)
func move(delta: float, direction: Vector2, body: CharacterBody2D) -> void:
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		
		if direction != last_direction:
			last_direction = direction
			direction_changed.emit(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	body.velocity = velocity
	body.move_and_slide()

## Obtenir la dernière direction de mouvement
func get_last_direction() -> Vector2:
	return last_direction

## Réinitialiser la vélocité (utile pour les knockbacks, etc.)
func reset_velocity() -> void:
	velocity = Vector2.ZERO

## Appliquer une force instantanée (knockback, dash, etc.)
func apply_impulse(impulse: Vector2) -> void:
	velocity += impulse
