extends CanvasLayer
class_name GameHUD

## HUD principal du jeu avec barres de santé et d'XP

@onready var health_bar_bg: ColorRect = $HealthBarBG
@onready var health_bar_fill: ColorRect = $HealthBarBG/HealthBarFill
@onready var health_text: Label = $HealthBarBG/HealthText

@onready var body_xp_bar_bg: ColorRect = $BodyXPBarBG
@onready var body_xp_bar_fill: ColorRect = $BodyXPBarBG/Fill
@onready var body_xp_text: Label = $BodyXPBarBG/Label

@onready var attack_xp_bar_bg: ColorRect = $AttackXPBarBG
@onready var attack_xp_bar_fill: ColorRect = $AttackXPBarBG/Fill
@onready var attack_xp_text: Label = $AttackXPBarBG/Label

@onready var body_stats_button: Button = $BodyStatsButton
@onready var attack_stats_button: Button = $AttackStatsButton
@onready var instructions: Label = $Instructions

var player: Player = null

func _ready():
	# Configuration visuelle de la barre de santé
	health_bar_bg.color = Color(0.2, 0.2, 0.2)
	health_bar_fill.color = Color(0.2, 0.8, 0.3)
	
	# Configuration des barres d'XP
	body_xp_bar_bg.color = Color(0.15, 0.15, 0.2)
	body_xp_bar_fill.color = Color(0.3, 0.7, 1.0)
	
	attack_xp_bar_bg.color = Color(0.2, 0.15, 0.15)
	attack_xp_bar_fill.color = Color(1.0, 0.4, 0.3)
	
	# Connexion des boutons
	body_stats_button.pressed.connect(_on_body_stats_button_pressed)
	attack_stats_button.pressed.connect(_on_attack_stats_button_pressed)

func _process(_delta):
	# Raccourcis clavier
	if Input.is_action_just_pressed("ui_page_up"):  # Page Up
		_on_body_stats_button_pressed()
	if Input.is_action_just_pressed("ui_page_down"):  # Page Down
		_on_attack_stats_button_pressed()

## Lier l'UI au joueur
func set_player(p: Player) -> void:
	if player != null:
		# Déconnecter l'ancien joueur
		_disconnect_player_signals()
	
	player = p
	
	if player != null:
		_connect_player_signals()
		_update_all_displays()

func _connect_player_signals():
	if not player:
		return
	
	# Santé
	if player.health_component:
		player.health_component.health_changed.connect(_on_player_health_changed)
	
	# Stats corporelles
	if player.body_stats:
		player.body_stats.stats_changed.connect(_update_body_xp_bar)
		player.body_stats.level_up.connect(_on_body_level_up)
	
	# Stats d'attaque
	if player.attack_stats:
		player.attack_stats.stats_changed.connect(_update_attack_xp_bar)
		player.attack_stats.level_up.connect(_on_attack_level_up)

func _disconnect_player_signals():
	if not player:
		return
	
	if player.health_component and player.health_component.health_changed.is_connected(_on_player_health_changed):
		player.health_component.health_changed.disconnect(_on_player_health_changed)
	
	if player.body_stats:
		if player.body_stats.stats_changed.is_connected(_update_body_xp_bar):
			player.body_stats.stats_changed.disconnect(_update_body_xp_bar)
		if player.body_stats.level_up.is_connected(_on_body_level_up):
			player.body_stats.level_up.disconnect(_on_body_level_up)
	
	if player.attack_stats:
		if player.attack_stats.stats_changed.is_connected(_update_attack_xp_bar):
			player.attack_stats.stats_changed.disconnect(_update_attack_xp_bar)
		if player.attack_stats.level_up.is_connected(_on_attack_level_up):
			player.attack_stats.level_up.disconnect(_on_attack_level_up)

func _update_all_displays():
	if player:
		if player.health_component:
			_update_health_display(player.health_component.current_health, player.health_component.max_health)
		_update_body_xp_bar()
		_update_attack_xp_bar()

func _on_player_health_changed(current: int, maximum: int):
	_update_health_display(current, maximum)

func _update_health_display(current: int, maximum: int):
	var percentage = float(current) / float(maximum)
	health_bar_fill.size.x = health_bar_bg.size.x * percentage
	health_text.text = "%d / %d HP" % [current, maximum]

func _update_body_xp_bar():
	if not player or not player.body_stats:
		return
	
	var pct = player.body_stats.get_xp_percentage()
	body_xp_bar_fill.size.x = body_xp_bar_bg.size.x * pct
	body_xp_text.text = "Corps Niv.%d - %d/%d XP (%d pts)" % [
		player.body_stats.current_level,
		player.body_stats.current_xp,
		player.body_stats.get_xp_for_next_level(),
		player.body_stats.available_points
	]

func _update_attack_xp_bar():
	if not player or not player.attack_stats:
		return
	
	var pct = player.attack_stats.get_xp_percentage()
	attack_xp_bar_fill.size.x = attack_xp_bar_bg.size.x * pct
	attack_xp_text.text = "Attaque Niv.%d - %d/%d XP (%d pts)" % [
		player.attack_stats.current_level,
		player.attack_stats.current_xp,
		player.attack_stats.get_xp_for_next_level(),
		player.attack_stats.available_points
	]

func _on_body_level_up(new_level: int, points_gained: int):
	_update_body_xp_bar()
	_show_level_up_notification("CORPS", new_level, points_gained)

func _on_attack_level_up(new_level: int, points_gained: int):
	_update_attack_xp_bar()
	_show_level_up_notification("ATTAQUE", new_level, points_gained)

func _show_level_up_notification(type: String, level: int, points: int):
	var label = Label.new()
	label.text = "%s NIVEAU %d!\n+%d points" % [type, level, points]
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(400, 200)
	label.modulate = Color(1.0, 1.0, 0.0)
	add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "position:y", 150, 1.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(label.queue_free)

func _on_body_stats_button_pressed():
	# Chercher le GlobalUI dans la scène
	var global_ui = get_tree().root.get_node_or_null("Main/GlobalUI")
	if global_ui and global_ui.has_method("open_body_stats"):
		global_ui.open_body_stats()

func _on_attack_stats_button_pressed():
	# Chercher le GlobalUI dans la scène
	var global_ui = get_tree().root.get_node_or_null("Main/GlobalUI")
	if global_ui and global_ui.has_method("open_attack_stats"):
		global_ui.open_attack_stats()
