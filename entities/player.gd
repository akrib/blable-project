extends CharacterBody2D
class_name Player

## Entité joueur principale
## Utilise des composants modulaires pour toutes ses capacités

@onready var movement_component: MovementComponent = $MovementComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var body_stats: BodyStatsComponent = $BodyStatsComponent
@onready var attack_stats: AttackStatsComponent = $AttackStatsComponent
@onready var visual: ColorRect = $Visual
@onready var attack_area: Area2D = $AttackArea
@onready var attack_visual: ColorRect = $AttackArea/AttackVisual

signal player_died()

func _ready():
	# Configuration visuelle - blob de couleur changeante selon l'élément
	visual.color = Color(0.5, 0.8, 0.5)  # Vert blob par défaut
	attack_visual.visible = false
	
	# Connexion aux signaux des composants
	health_component.died.connect(_on_died)
	attack_component.attack_started.connect(_on_attack_started)
	attack_component.attack_finished.connect(_on_attack_finished)
	movement_component.direction_changed.connect(_on_direction_changed)
	body_stats.stats_changed.connect(_on_body_stats_changed)
	attack_stats.stats_changed.connect(_on_attack_stats_changed)
	
	# Appliquer les stats initiales
	_apply_body_stats()
	_apply_attack_stats()

func _process(_delta):
	# Effet visuel d'invincibilité
	if health_component.is_invincible:
		visual.modulate.a = 0.5 if int(Time.get_ticks_msec() / 100) % 2 == 0 else 1.0
	else:
		visual.modulate.a = 1.0
	
	# Changer la couleur du blob selon l'élément dominant
	if attack_stats:
		visual.color = attack_stats.get_attack_color().lerp(Color(0.5, 0.8, 0.5), 0.5)

func _apply_body_stats():
	# Appliquer les stats corporelles aux composants
	if body_stats and movement_component:
		movement_component.speed = body_stats.get_movement_speed()
	
	if body_stats and health_component:
		var old_max = health_component.max_health
		var new_max = body_stats.get_max_health()
		health_component.max_health = new_max
		
		# Augmenter la santé actuelle proportionnellement
		if old_max > 0:
			var health_pct = float(health_component.current_health) / float(old_max)
			health_component.current_health = int(new_max * health_pct)
		else:
			health_component.current_health = new_max
		
		health_component.health_changed.emit(health_component.current_health, health_component.max_health)
	
	if body_stats and attack_component:
		attack_component.attack_cooldown = body_stats.get_attack_cooldown()

func _apply_attack_stats():
	# Appliquer les stats d'attaque
	if not attack_stats:
		return
	
	var info = attack_stats.get_attack_info()
	
	# Mettre à jour la taille et position de la zone d'attaque
	attack_visual.color = info["color"]
	attack_visual.color.a = 0.6
	attack_visual.size = Vector2(info["width"], info["length"])
	attack_visual.position.x = info["distance"]
	attack_visual.position.y = -info["length"] / 2
	
	# Mettre à jour le collider de l'attaque
	var collision = attack_area.get_node_or_null("CollisionShape2D")
	if collision and collision.shape is RectangleShape2D:
		collision.shape.size = Vector2(info["width"], info["length"])
		collision.position.x = info["distance"] + info["width"] / 2
	
	# Mettre à jour les dégâts
	if attack_component:
		attack_component.damage = info["total_damage"]

func _on_body_stats_changed():
	_apply_body_stats()

func _on_attack_stats_changed():
	_apply_attack_stats()

func _physics_process(delta):
	# Récupérer l'input du joueur
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Ne peut pas bouger pendant l'attaque
	if not attack_component.is_attacking:
		movement_component.move(delta, input_direction, self)
	
	# Attaque
	if Input.is_action_just_pressed("attack"):
		if attack_component.try_attack():
			_perform_attack()

## Exécuter l'attaque et détecter les ennemis
func _perform_attack():
	var enemies = attack_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy is Enemy:
			var health = enemy.get_node_or_null("HealthComponent")
			if health and health is HealthComponent:
				# Calculer les dégâts avec modificateurs
				var base_damage = attack_component.damage
				
				# Appliquer le modificateur d'intelligence pour dégâts élémentaires
				if body_stats:
					base_damage = int(base_damage * body_stats.get_intelligence_modifier())
				
				# Chance de coup critique
				var is_crit = false
				if body_stats:
					var crit_chance = body_stats.stats["luck"] * 2  # 2% par point de chance
					if randf() * 100 < crit_chance:
						is_crit = true
						base_damage = int(base_damage * 1.5)
				
				health.take_damage(base_damage)
				
				# Effet visuel de critique
				if is_crit:
					_show_crit_effect(enemy.global_position)
				
				# Appliquer le knockback avec bonus de dexterité
				var movement = enemy.get_node_or_null("MovementComponent")
				if movement and movement is MovementComponent:
					var knockback = attack_component.get_knockback_impulse(global_position, enemy.global_position)
					if body_stats:
						knockback *= body_stats.get_dexterity_modifier()
					movement.apply_impulse(knockback)

func _show_crit_effect(pos: Vector2):
	# Effet visuel simple pour les coups critiques
	var label = Label.new()
	label.text = "CRIT!"
	label.modulate = Color(1.0, 1.0, 0.0)
	label.global_position = pos
	get_parent().add_child(label)
	
	var tween = create_tween()
	tween.tween_property(label, "global_position:y", pos.y - 30, 0.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)

func _on_attack_started():
	attack_visual.visible = true

func _on_attack_finished():
	attack_visual.visible = false

func _on_direction_changed(direction: Vector2):
	# Orienter la zone d'attaque selon la direction
	var angle = direction.angle()
	attack_area.rotation = angle

func _on_died():
	player_died.emit()
	queue_free()
