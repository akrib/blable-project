extends Node
class_name TeleportComponent

## Composant de téléportation
## Permet de téléporter une entité à une position donnée

signal teleported(from_position: Vector2, to_position: Vector2)

## Téléporter l'entité à une position
func teleport_to(body: Node2D, target_position: Vector2, instant: bool = true) -> void:
	var from_pos = body.global_position
	
	if instant:
		body.global_position = target_position
	else:
		# Animation de téléportation (fade out/in)
		var tween = body.create_tween()
		tween.tween_property(body, "modulate:a", 0.0, 0.2)
		tween.tween_callback(func(): body.global_position = target_position)
		tween.tween_property(body, "modulate:a", 1.0, 0.2)
	
	teleported.emit(from_pos, target_position)

## Téléporter avec décalage
func teleport_offset(body: Node2D, offset: Vector2) -> void:
	teleport_to(body, body.global_position + offset)
