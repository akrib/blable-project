extends Control
class_name AttackStatsUI

## Interface de gestion des statistiques d'attaque

signal closed()

@onready var panel = $Panel
@onready var title_label = $Panel/VBox/Title
@onready var level_label = $Panel/VBox/LevelInfo
@onready var points_label = $Panel/VBox/PointsAvailable
@onready var xp_bar_bg = $Panel/VBox/XPBar
@onready var xp_bar_fill = $Panel/VBox/XPBar/Fill
@onready var xp_label = $Panel/VBox/XPBar/Label
@onready var stats_container = $Panel/VBox/StatsScroll/StatsContainer
@onready var preview_area = $Panel/VBox/PreviewArea
@onready var close_button = $Panel/VBox/CloseButton
@onready var reset_button = $Panel/VBox/ResetButton

var attack_stats: AttackStatsComponent = null
var stat_rows: Dictionary = {}

# Noms lisibles pour les stats
const STAT_NAMES = {
	"damage_air": "Dégâts Air",
	"damage_fire": "Dégâts Feu",
	"damage_water": "Dégâts Eau",
	"damage_earth": "Dégâts Terre",
	"attack_width": "Largeur d'Attaque",
	"attack_length": "Longueur d'Attaque",
	"attack_distance": "Distance d'Attaque"
}

func _ready():
	visible = false
	
	# Style du panel
	panel.color = Color(0.15, 0.1, 0.1, 0.95)
	xp_bar_bg.color = Color(0.2, 0.2, 0.2)
	xp_bar_fill.color = Color(0.7, 0.3, 0.3)
	
	# Connexion des boutons
	close_button.pressed.connect(_on_close_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	
	# Créer les lignes de stats
	_create_stat_rows()
	
	# Créer la zone de prévisualisation
	_setup_preview_area()

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
	
	# Couleur pour les éléments
	var name_label = Label.new()
	name_label.text = stat_name
	name_label.custom_minimum_size.x = 200
	
	# Colorer les labels d'éléments
	if stat_key.begins_with("damage_"):
		match stat_key:
			"damage_air":
				name_label.modulate = Color(0.8, 1.0, 1.0)
			"damage_fire":
				name_label.modulate = Color(1.0, 0.4, 0.2)
			"damage_water":
				name_label.modulate = Color(0.2, 0.5, 1.0)
			"damage_earth":
				name_label.modulate = Color(0.6, 0.4, 0.2)
	
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

func _setup_preview_area():
	preview_area.color = Color(0.05, 0.05, 0.05, 0.8)
	
	# Créer un label d'info
	var info_label = Label.new()
	info_label.text = "Prévisualisation de l'attaque"
	info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	info_label.position = Vector2(10, 10)
	preview_area.add_child(info_label)

func set_attack_stats(stats: AttackStatsComponent):
	if attack_stats != null:
		if attack_stats.stats_changed.is_connected(_on_stats_changed):
			attack_stats.stats_changed.disconnect(_on_stats_changed)
		if attack_stats.level_up.is_connected(_on_level_up):
			attack_stats.level_up.disconnect(_on_level_up)
	
	attack_stats = stats
	
	if attack_stats != null:
		attack_stats.stats_changed.connect(_on_stats_changed)
		attack_stats.level_up.connect(_on_level_up)
		_update_display()

func _on_stats_changed():
	_update_display()
	_update_preview()

func _on_level_up(_new_level: int, points_gained: int):
	_update_display()
	# Effet visuel de level up
	level_label.modulate = Color(1.0, 0.5, 0.0)
	var tween = create_tween()
	tween.tween_property(level_label, "modulate", Color(1.0, 1.0, 1.0), 0.5)

func _update_display():
	if attack_stats == null:
		return
	
	# Mettre à jour les infos générales
	title_label.text = "Statistiques d'Attaque"
	level_label.text = "Niveau: %d" % attack_stats.current_level
	points_label.text = "Points Disponibles: %d" % attack_stats.available_points
	
	# Barre d'XP
	var xp_pct = attack_stats.get_xp_percentage()
	xp_bar_fill.size.x = xp_bar_bg.size.x * xp_pct
	xp_label.text = "%d / %d XP" % [attack_stats.current_xp, attack_stats.get_xp_for_next_level()]
	
	# Mettre à jour chaque ligne de stat
	for stat_key in stat_rows.keys():
		var row = stat_rows[stat_key]
		var value_label = row.get_node("ValueLabel")
		var bonus_label = row.get_node("BonusLabel")
		
		var stat_value = attack_stats.stats[stat_key]
		value_label.text = str(stat_value)
		
		# Afficher le bonus
		var bonus_text = _get_bonus_text(stat_key, stat_value)
		bonus_label.text = bonus_text

func _get_bonus_text(stat_key: String, _value: int) -> String:
	if stat_key.begins_with("damage_"):
		var element = stat_key.replace("damage_", "")
		var damages = attack_stats.get_total_elemental_damage()
		return "→ %d dégâts" % damages[element]
	
	match stat_key:
		"attack_width":
			return "→ %.0f largeur" % attack_stats.get_attack_width()
		"attack_length":
			return "→ %.0f longueur" % attack_stats.get_attack_length()
		"attack_distance":
			return "→ %.0f distance" % attack_stats.get_attack_distance()
	return ""

func _update_preview():
	if attack_stats == null:
		return
	
	# Effacer l'ancienne prévisualisation
	for child in preview_area.get_children():
		if child is ColorRect and child.name == "PreviewRect":
			child.queue_free()
	
	# Créer la nouvelle prévisualisation
	var info = attack_stats.get_attack_info()
	
	var preview_rect = ColorRect.new()
	preview_rect.name = "PreviewRect"
	preview_rect.color = info["color"]
	preview_rect.color.a = 0.6
	
	# Positionner au centre de la zone de prévisualisation
	var center_x = preview_area.size.x / 2
	var center_y = preview_area.size.y / 2
	
	preview_rect.position = Vector2(
		center_x - info["width"] / 2 + info["distance"],
		center_y - info["length"] / 2
	)
	preview_rect.size = Vector2(info["width"], info["length"])
	
	preview_area.add_child(preview_rect)
	
	# Ajouter un label avec les dégâts totaux
	var damage_label = Label.new()
	damage_label.text = "Total: %d dégâts\nÉlément: %s" % [info["total_damage"], info["element"].capitalize()]
	damage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_label.position = Vector2(10, preview_area.size.y - 50)
	preview_area.add_child(damage_label)

func _on_stat_increased(stat_key: String):
	if attack_stats:
		attack_stats.add_stat_point(stat_key)

func _on_stat_decreased(stat_key: String):
	if attack_stats:
		attack_stats.remove_stat_point(stat_key)

func _on_reset_pressed():
	if attack_stats:
		attack_stats.reset_stats()

func _on_close_pressed():
	visible = false
	closed.emit()

func open():
	visible = true
	_update_display()
	_update_preview()
