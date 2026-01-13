extends Node2D

## Carte Désert
## Thème : Sable, ennemis jaunes/orange

func _ready():
	_setup_enemies()

func _setup_enemies():
	# Configurer les ennemis avec des couleurs jaunes/orange
	var enemies = $Enemies.get_children()
	
	for i in range(enemies.size()):
		var enemy = enemies[i]
		if not enemy is Enemy:
			continue
		
		# Couleur jaune/orange pour le désert
		var visual = enemy.get_node_or_null("Visual")
		if visual and visual is ColorRect:
			visual.color = Color(1.0, 0.7, 0.2)  # Orange/jaune
		
		# Stats augmentées pour le désert (zone plus difficile)
		if enemy.health_component:
			enemy.health_component.max_health = 70
			enemy.health_component.current_health = 70
		
		if enemy.attack_component:
			enemy.attack_component.damage = 12
		
		# Récompenses XP augmentées
		match i % 3:
			0:  # Guerrier du désert
				enemy.body_xp_reward = 20
				enemy.attack_xp_reward = 8
			1:  # Élémentaire du feu
				enemy.body_xp_reward = 8
				enemy.attack_xp_reward = 25
			2:  # Tank du sable
				enemy.body_xp_reward = 35
				enemy.attack_xp_reward = 5
