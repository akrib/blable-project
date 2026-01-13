extends Node2D

## Carte Forêt
## Thème : Nature, ennemis verts

func _ready():
	_setup_enemies()

func _setup_enemies():
	# Configurer les ennemis avec des couleurs vertes
	var enemies = $Enemies.get_children()
	
	for i in range(enemies.size()):
		var enemy = enemies[i]
		if not enemy is Enemy:
			continue
		
		# Couleur verte pour la forêt
		var visual = enemy.get_node_or_null("Visual")
		if visual and visual is ColorRect:
			visual.color = Color(0.3, 0.8, 0.3)  # Vert
		
		# Récompenses XP variées
		match i % 3:
			0:  # Guerrier
				enemy.body_xp_reward = 15
				enemy.attack_xp_reward = 5
			1:  # Mage
				enemy.body_xp_reward = 5
				enemy.attack_xp_reward = 20
			2:  # Tank
				enemy.body_xp_reward = 25
				enemy.attack_xp_reward = 3
