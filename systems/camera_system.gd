extends Camera2D

## Système de caméra qui suit le joueur
## Peut être facilement remplacé par un autre type de caméra

@export var smoothing_enabled: bool = true
@export var smoothing_speed: float = 5.0
@export var offset_from_player: Vector2 = Vector2.ZERO

var target: Node2D = null

func _ready():
	if smoothing_enabled:
		position_smoothing_enabled = true
		position_smoothing_speed = smoothing_speed

## Définir la cible à suivre
func set_target(new_target: Node2D) -> void:
	target = new_target
	if target:
		global_position = target.global_position + offset_from_player

func _process(_delta):
	if target and is_instance_valid(target):
		var target_pos = target.global_position + offset_from_player
		if not smoothing_enabled:
			global_position = target_pos
