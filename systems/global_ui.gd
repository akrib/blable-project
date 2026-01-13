extends CanvasLayer
class_name GlobalUI

## Interface utilisateur globale
## Persiste entre les changements de cartes

@onready var body_stats_ui: BodyStatsUI = $BodyStatsUI
@onready var attack_stats_ui: AttackStatsUI = $AttackStatsUI

var player: Player = null

func _ready():
	# Les interfaces commencent cachées
	if body_stats_ui:
		body_stats_ui.visible = false
	if attack_stats_ui:
		attack_stats_ui.visible = false

func _input(event):
	# Gérer les raccourcis clavier globalement
	if event.is_action_pressed("ui_page_up"):
		toggle_body_stats()
	elif event.is_action_pressed("ui_page_down"):
		toggle_attack_stats()

## Lier le joueur aux interfaces
func set_player(p: Player):
	player = p
	
	if player:
		if body_stats_ui:
			body_stats_ui.set_body_stats(player.body_stats)
		if attack_stats_ui:
			attack_stats_ui.set_attack_stats(player.attack_stats)

## Ouvrir/fermer l'interface des stats corporelles
func toggle_body_stats():
	if body_stats_ui:
		if body_stats_ui.visible:
			body_stats_ui.visible = false
		else:
			body_stats_ui.open()

## Ouvrir/fermer l'interface des stats d'attaque
func toggle_attack_stats():
	if attack_stats_ui:
		if attack_stats_ui.visible:
			attack_stats_ui.visible = false
		else:
			attack_stats_ui.open()

## Ouvrir directement les stats corporelles
func open_body_stats():
	if body_stats_ui:
		body_stats_ui.open()

## Ouvrir directement les stats d'attaque
func open_attack_stats():
	if attack_stats_ui:
		attack_stats_ui.open()
