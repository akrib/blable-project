extends Area2D
class_name Portal

## Portail pour voyager entre les cartes
## Détecte l'entrée du joueur et déclenche le changement de carte

signal player_entered_portal(portal: Portal)

@export var target_map: String = "map_1"  # Nom de la carte de destination
@export var target_portal_id: String = "portal_1"  # ID du portail de destination
@export var portal_id: String = "portal_0"  # ID de ce portail
@export var portal_color: Color = Color(0.5, 0.5, 1.0, 0.7)

@onready var visual: ColorRect = $Visual
@onready var label: Label = $Label

var player_inside: bool = false
var can_teleport: bool = true
var cooldown_timer: float = 0.0
const TELEPORT_COOLDOWN: float = 1.0  # Cooldown pour éviter les téléportations infinies

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Configuration visuelle
	if visual:
		visual.color = portal_color
	
	if label:
		label.text = "→ %s" % target_map

func _process(delta):
	# Gestion du cooldown
	if not can_teleport:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_teleport = true
	
	# Effet visuel de pulsation
	if visual:
		var pulse = (sin(Time.get_ticks_msec() / 500.0) + 1.0) / 2.0
		visual.modulate.a = 0.5 + (pulse * 0.3)

func _on_body_entered(body):
	if body is Player:
		player_inside = true
		if can_teleport:
			_trigger_portal(body)

func _on_body_exited(body):
	if body is Player:
		player_inside = false

func _trigger_portal(player: Player):
	if not can_teleport:
		return
	
	can_teleport = false
	cooldown_timer = TELEPORT_COOLDOWN
	
	player_entered_portal.emit(self)

## Réactiver le portail après téléportation
func reset_cooldown():
	can_teleport = true
	cooldown_timer = 0.0

## Désactiver temporairement le portail (utilisé après spawn)
func disable_temporarily(duration: float = 1.0):
	can_teleport = false
	cooldown_timer = duration
