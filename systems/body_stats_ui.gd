extends Control
class_name BodyStatsUI

## Interface de gestion des statistiques corporelles

signal closed()

@onready var panel = $Panel
@onready var title_label = $Panel/VBox/Title
@onready var level_label = $Panel/VBox/LevelInfo
@onready var points_label = $Panel/VBox/PointsAvailable
@onready var xp_bar_bg = $Panel/VBox/XPBar
@onready var xp_bar_fill = $Panel/VBox/XPBar/Fill
@onready var xp_label = $Panel/VBox/XPBar/Label
@onready var stats_container = $Panel/VBox/StatsScroll/StatsContainer
@onready var close_button = $Panel/VBox/CloseButton
@onready var reset_button = $Panel/VBox/ResetButton

var body_stats: BodyStatsComponent = null
var stat_rows: Dictionary = {}

# Noms lisibles pour les stats
const STAT_NAMES = {
	"movement_speed": "Vitesse de Mouvement",
	"health_points": "Points de Vie",
	"defense": "Défense",
	"luck": "Chance",
	"intelligence": "Intelligence",
	"dexterity": "Dexterité",
	"attack_speed": "Vitesse d'Attaque"
}

func _ready():
	visible = false
	
	# Style du panel
	panel.color = Color(0.1, 0.1, 0.15, 0.95)
	xp_bar_bg.color = Color(0.2, 0.2, 0.2)
	xp_bar_fill.color = Color(0.3, 0.7, 0.3)
	
	# Connexion des boutons
	close_button.pressed.connect(_on_close_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	
	# Créer les lignes de stats
	_create_stat_rows()

func _create_stat_rows():
	# Effacer les enfants existants
	for child in stats_container.get_children():
		child.queue_free()
	
	stat_rows.clear()
	
	# Créer une ligne pour chaque stat
	for stat_key in STAT_NAMES.keys():
		var row = _create_stat_row(stat_key, STAT_NAMES[stat_key])
		stats_container.add_child(row)
		stat_rows[stat_key] = row

func _create_stat_row(stat_key: String, stat_name: String) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.custom_minimum_size = Vector2(0, 40)
	
	# Nom de la stat
	var name_label = Label.new()
	name_label.text = stat_name
	name_label.custom_minimum_size.x = 200
	row.add_child(name_label)
	
	# Bouton -
	var minus_button = Button.new()
	minus_button.text = "-"
	minus_button.custom_minimum_size = Vector2(40, 30)
	minus_button.pressed.connect(func(): _on_stat_decreased(stat_key))
	row.add_child(minus_button)
	
	# Valeur
	var value_label = Label.new()
	value_label.text = "0"
	value_label.custom_minimum_size.x = 50
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.name = "ValueLabel"
	row.add_child(value_label)
	
	# Bouton +
	var plus_button = Button.new()
	plus_button.text = "+"
	plus_button.custom_minimum_size = Vector2(40, 30)
	plus_button.pressed.connect(func(): _on_stat_increased(stat_key))
	row.add_child(plus_button)
	
	# Info bonus
	var bonus_label = Label.new()
	bonus_label.text = ""
	bonus_label.custom_minimum_size.x = 200
	bonus_label.name = "BonusLabel"
	row.add_child(bonus_label)
	
	return row

func set_body_stats(stats: BodyStatsComponent):
	if body_stats != null:
		if body_stats.stats_changed.is_connected(_on_stats_changed):
			body_stats.stats_changed.disconnect(_on_stats_changed)
		if body_stats.level_up.is_connected(_on_level_up):
			body_stats.level_up.disconnect(_on_level_up)
	
	body_stats = stats
	
	if body_stats != null:
		body_stats.stats_changed.connect(_on_stats_changed)
		body_stats.level_up.connect(_on_level_up)
		_update_display()

func _on_stats_changed():
	_update_display()

func _on_level_up(_new_level: int, points_gained: int):
	_update_display()
	# Effet visuel de level up
	level_label.modulate = Color(1.0, 1.0, 0.0)
	var tween = create_tween()
	tween.tween_property(level_label, "modulate", Color(1.0, 1.0, 1.0), 0.5)

func _update_display():
	if body_stats == null:
		return
	
	# Mettre à jour les infos générales
	title_label.text = "Statistiques Corporelles"
	level_label.text = "Niveau: %d" % body_stats.current_level
	points_label.text = "Points Disponibles: %d" % body_stats.available_points
	
	# Barre d'XP
	var xp_pct = body_stats.get_xp_percentage()
	xp_bar_fill.size.x = xp_bar_bg.size.x * xp_pct
	xp_label.text = "%d / %d XP" % [body_stats.current_xp, body_stats.get_xp_for_next_level()]
	
	# Mettre à jour chaque ligne de stat
	for stat_key in stat_rows.keys():
		var row = stat_rows[stat_key]
		var value_label = row.get_node("ValueLabel")
		var bonus_label = row.get_node("BonusLabel")
		
		var stat_value = body_stats.stats[stat_key]
		value_label.text = str(stat_value)
		
		# Afficher le bonus
		var bonus_text = _get_bonus_text(stat_key, stat_value)
		bonus_label.text = bonus_text

func _get_bonus_text(stat_key: String, _value: int) -> String:
	match stat_key:
		"movement_speed":
			return "→ %.0f vitesse" % body_stats.get_movement_speed()
		"health_points":
			return "→ %d HP max" % body_stats.get_max_health()
		"defense":
			return "→ %.1f%% réduction" % body_stats.get_defense_percentage()
		"luck":
			return "→ x%.2f bonus" % body_stats.get_luck_modifier()
		"intelligence":
			return "→ x%.2f magie" % body_stats.get_intelligence_modifier()
		"dexterity":
			return "→ x%.2f précision" % body_stats.get_dexterity_modifier()
		"attack_speed":
			return "→ %.2fs cooldown" % body_stats.get_attack_cooldown()
	return ""

func _on_stat_increased(stat_key: String):
	if body_stats:
		body_stats.add_stat_point(stat_key)

func _on_stat_decreased(stat_key: String):
	if body_stats:
		body_stats.remove_stat_point(stat_key)

func _on_reset_pressed():
	if body_stats:
		body_stats.reset_stats()

func _on_close_pressed():
	visible = false
	closed.emit()

func open():
	visible = true
	_update_display()
