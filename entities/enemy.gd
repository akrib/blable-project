extends CharacterBody2D
class_name Enemy

## Entité ennemie
## Utilise les mêmes composants que le joueur mais avec un comportement AI

# Récompenses d'XP
@export var body_xp_reward: int = 10
@export var attack_xp_reward: int = 5

@onready var movement_component: MovementComponent = $MovementComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var attack_component: AttackComponent = $AttackComponent
@onready var ai_component: AIComponent = $AIComponent
@onready var visual: ColorRect = $Visual
@onready var detection_area: Area2D = $DetectionArea
@onready var attack_area: Area2D = $AttackArea

var player_target: Node2D = null
var attack_timer: float = 0.0

func _ready():
	# Configuration visuelle (rouge pour les ennemis)
	visual.color = Color(1.0, 0.3, 0.3)
	
	# Connexion aux signaux
	health_component.died.connect(_on_died)
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	attack_component.attack_started.connect(_on_attack_started)

func _process(_delta):
	# Effet visuel d'invincibilité
	if health_component.is_invincible:
		visual.modulate.a = 0.5 if int(Time.get_ticks_msec() / 100) % 2 == 0 else 1.0
	else:
		visual.modulate.a = 1.0

func _physics_process(delta):
	# L'IA détermine la direction
	var ai_direction = ai_component.update_ai(delta, global_position)
	
	# Ne bouge pas pendant l'attaque
	if not attack_component.is_attacking:
		movement_component.move(delta, ai_direction, self)
	
	# Tentative d'attaque si le joueur est à portée
	if ai_component.should_attack():
		attack_timer -= delta
		if attack_timer <= 0:
			if attack_component.try_attack():
				_perform_attack()
				attack_timer = 1.0  # Délai entre les attaques

func _perform_attack():
	if player_target == null:
		return
	
	var bodies = attack_area.get_overlapping_bodies()
	if player_target in bodies:
		var health = player_target.get_node_or_null("HealthComponent")
		if health and health is HealthComponent:
			health.take_damage(attack_component.damage)
			
			# Knockback sur le joueur
			var movement = player_target.get_node_or_null("MovementComponent")
			if movement and movement is MovementComponent:
				var knockback = attack_component.get_knockback_impulse(global_position, player_target.global_position)
				movement.apply_impulse(knockback)

func _on_detection_area_entered(body):
	# ✅ Vérifier avec le groupe au lieu du type
	if body.is_in_group("player"):
		player_target = body
		ai_component.set_target(body)

func _on_detection_area_exited(body):
	if body == player_target:
		player_target = null
		ai_component.set_target(null)

func _on_attack_started():
	# Effet visuel d'attaque (clignotement)
	visual.color = Color(1.0, 0.8, 0.3)
	await get_tree().create_timer(0.1).timeout
	visual.color = Color(1.0, 0.3, 0.3)

func _on_died():
	# Donner de l'XP au joueur
	if player_target and is_instance_valid(player_target):
		var body_stats = player_target.get_node_or_null("BodyStatsComponent")
		var attack_stats = player_target.get_node_or_null("AttackStatsComponent")
		
		if body_stats:
			body_stats.add_xp(body_xp_reward)
		
		if attack_stats:
			attack_stats.add_xp(attack_xp_reward)
	
	queue_free()
