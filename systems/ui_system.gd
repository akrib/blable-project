extends CanvasLayer

## Système d'interface utilisateur
## Affiche la barre de santé et d'autres informations

@onready var health_bar_bg: ColorRect = $HealthBarBG
@onready var health_bar_fill: ColorRect = $HealthBarBG/HealthBarFill
@onready var health_text: Label = $HealthBarBG/HealthText

var player: Player = null

func _ready():
	# Configuration visuelle de la barre de santé
	health_bar_bg.color = Color(0.2, 0.2, 0.2)
	health_bar_fill.color = Color(0.2, 0.8, 0.3)

## Lier l'UI au joueur
func set_player(p: Player) -> void:
	if player != null:
		# Déconnecter l'ancien joueur
		if player.health_component.health_changed.is_connected(_on_player_health_changed):
			player.health_component.health_changed.disconnect(_on_player_health_changed)
	
	player = p
	
	if player != null:
		player.health_component.health_changed.connect(_on_player_health_changed)
		_update_health_display(player.health_component.current_health, player.health_component.max_health)

func _on_player_health_changed(current: int, maximum: int):
	_update_health_display(current, maximum)

func _update_health_display(current: int, maximum: int):
	var percentage = float(current) / float(maximum)
	health_bar_fill.size.x = health_bar_bg.size.x * percentage
	health_text.text = "%d / %d" % [current, maximum]
