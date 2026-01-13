extends Node2D

## Carte Caverne
## Thème : Sombre, ennemis violets/gris

func _ready():
	_setup_enemies()

func _setup_enemies():
	# Configurer les ennemis avec des couleurs violettes/grises
	var enemies = $Enemies.get_children()
	
	for i in range(enemies.size()):
		var enemy = enemies[i]
		if not enemy is Enemy:
			continue
		
		# Couleur violet/gris pour la caverne
		var visual = enemy.get_node_or_null("Visual")
		if visual and visual is ColorRect:
			visual.color = Color(0.5, 0.3, 0.6)  # Violet sombre
		
		# Stats élevées pour la caverne (zone difficile)
		if enemy.health_component:
			enemy.health_component.max_health = 90
			enemy.health_component.current_health = 90
		
		if enemy.attack_component:
			enemy.attack_component.damage = 15
		
		if enemy.movement_component:
			enemy.movement_component.speed = 90
		
		# Récompenses XP très élevées
		match i % 4:
			0:  # Guerrier de l'ombre
				enemy.body_xp_reward = 30
				enemy.attack_xp_reward = 10
			1:  # Mage des ténèbres
				enemy.body_xp_reward = 10
				enemy.attack_xp_reward = 35
			2:  # Gardien de pierre
				enemy.body_xp_reward = 50
				enemy.attack_xp_reward = 8
			3:  # Assassin de la caverne
				enemy.body_xp_reward = 20
				enemy.attack_xp_reward = 20
