extends Node
class_name PortalFactory

## Utilitaire pour créer des portails circulaires facilement

## Couleurs prédéfinies pour chaque destination
const PORTAL_COLORS = {
	"ville": Color(0.5, 0.6, 0.8),      # Bleu clair
	"forest": Color(0.3, 0.9, 0.4),     # Vert
	"desert": Color(0.9, 0.8, 0.3),     # Jaune/Orange
	"cavern": Color(0.4, 0.3, 0.5)      # Violet/Gris
}

## Emojis pour les labels
const PORTAL_EMOJIS = {
	"ville": "🏘️",
	"forest": "🌲",
	"desert": "🏜️",
	"cavern": "🕳️"
}

## Noms complets des cartes
const MAP_NAMES = {
	"ville": "VILLE",
	"forest": "FORÊT",
	"desert": "DÉSERT",
	"cavern": "CAVERNE"
}

## Créer un portail complet avec visuels circulaires
static func create_portal(destination: String, position: Vector2 = Vector2.ZERO) -> Area2D:
	var portal = Area2D.new()
	portal.name = "Portal" + destination.capitalize()
	portal.position = position
	portal.collision_layer = 8
	portal.collision_mask = 1
	
	# Attacher le script Portal
	var portal_script = load("res://entities/portal.gd")
	if portal_script:
		portal.set_script(portal_script)
		portal.destination_map = destination
		portal.portal_color = PORTAL_COLORS.get(destination, Color.WHITE)
	
	# Créer le nœud visuel principal
	var visual = Node2D.new()
	visual.name = "PortalVisual"
	portal.add_child(visual)
	
	# Obtenir la couleur
	var color = PORTAL_COLORS.get(destination, Color.WHITE)
	
	# Créer les trois cercles concentriques
	create_circle(visual, "OuterCircle", 60, Color(color.r * 0.7, color.g * 0.7, color.b * 0.7, 0.5))
	create_circle(visual, "MiddleCircle", 45, Color(color.r * 0.85, color.g * 0.85, color.b * 0.85, 0.65))
	create_circle(visual, "InnerCircle", 30, Color(color.r, color.g, color.b, 0.8))
	
	# Collision shape (cercle)
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 50
	collision.shape = shape
	portal.add_child(collision)
	
	# Label avec emoji et nom
	var label = Label.new()
	label.name = "Label"
	label.offset_left = -60
	label.offset_top = -90
	label.offset_right = 60
	label.offset_bottom = -70
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	var emoji = PORTAL_EMOJIS.get(destination, "🌀")
	var map_name = MAP_NAMES.get(destination, destination.to_upper())
	label.text = emoji + " " + map_name
	
	portal.add_child(label)
	
	return portal

## Créer un cercle (approximation avec ColorRect)
static func create_circle(parent: Node2D, circle_name: String, radius: float, color: Color):
	var rect = ColorRect.new()
	rect.name = circle_name
	rect.offset_left = -radius
	rect.offset_top = -radius
	rect.offset_right = radius
	rect.offset_bottom = radius
	rect.color = color
	parent.add_child(rect)

## Créer un portail bidirectionnel (deux portails qui se pointent l'un vers l'autre)
static func create_bidirectional_portals(
	map1: String, pos1: Vector2,
	map2: String, pos2: Vector2,
	parent1: Node, parent2: Node
):
	# Portail de map1 vers map2
	var portal1 = create_portal(map2, pos1)
	parent1.add_child(portal1)
	
	# Portail de map2 vers map1
	var portal2 = create_portal(map1, pos2)
	parent2.add_child(portal2)

## Exemple d'utilisation dans une scène :
## 
## func _ready():
##     var portals_node = $Portals
##     
##     # Créer un portail vers la forêt
##     var portal_forest = PortalFactory.create_portal("forest", Vector2(0, 350))
##     portals_node.add_child(portal_forest)
##     
##     # Créer un portail vers le désert
##     var portal_desert = PortalFactory.create_portal("desert", Vector2(350, 0))
##     portals_node.add_child(portal_desert)

## Script utilitaire pour remplacer tous les anciens portails
static func upgrade_existing_portals(map_scene: Node2D):
	"""
	Remplace tous les anciens portails rectangulaires par des cercles
	Utilisation : PortalFactory.upgrade_existing_portals(get_tree().current_scene)
	"""
	var portals_node = map_scene.get_node_or_null("Portals")
	if not portals_node:
		print("❌ Pas de nœud 'Portals' trouvé")
		return
	
	print("🔄 Mise à niveau des portails...")
	
	for portal in portals_node.get_children():
		if not portal is Area2D:
			continue
		
		var destination = portal.get("destination_map")
		if not destination:
			print("⚠️ Portail sans destination ignoré")
			continue
		
		var pos = portal.position
		
		# Supprimer l'ancien
		portal.queue_free()
		
		# Créer le nouveau
		var new_portal = create_portal(destination, pos)
		portals_node.add_child(new_portal)
		
		print("✅ Portail mis à niveau: ", destination)
	
	print("🎉 Mise à niveau terminée!")

## Créer tous les portails pour une carte donnée
static func setup_map_portals(map_id: String, portals_node: Node):
	"""
	Configure automatiquement les portails selon la carte
	"""
	match map_id:
		"ville":
			# Ville → Forêt uniquement
			var p = create_portal("forest", Vector2(0, 350))
			portals_node.add_child(p)
		
		"forest":
			# Forêt → Ville, Désert, Caverne
			var p1 = create_portal("ville", Vector2(0, -350))
			var p2 = create_portal("desert", Vector2(400, 0))
			var p3 = create_portal("cavern", Vector2(-400, 0))
			portals_node.add_child(p1)
			portals_node.add_child(p2)
			portals_node.add_child(p3)
		
		"desert":
			# Désert → Forêt, Caverne
			var p1 = create_portal("forest", Vector2(-400, 0))
			var p2 = create_portal("cavern", Vector2(400, 0))
			portals_node.add_child(p1)
			portals_node.add_child(p2)
		
		"cavern":
			# Caverne → Forêt, Désert
			var p1 = create_portal("forest", Vector2(400, 0))
			var p2 = create_portal("desert", Vector2(-400, 0))
			portals_node.add_child(p1)
			portals_node.add_child(p2)
