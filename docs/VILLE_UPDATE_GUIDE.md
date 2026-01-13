# Guide de Mise à Jour - Ville, PNJ et Portails Circulaires

## 🆕 Nouveautés Ajoutées

### 1. Carte "Ville" (Zone de Départ)
- **Sans ennemis** - Zone 100% sûre
- **PNJ interactif** avec système de dialogue
- **Point de spawn** après la mort du joueur
- **Portail vers la Forêt**

### 2. Système de Dialogue
- Interaction avec les PNJ en appuyant sur **ESPACE** ou **E**
- Boîte de dialogue stylisée
- Messages personnalisables

### 3. Portails Visuels Améliorés
- **Cercles concentriques** au lieu de rectangles
- **Animation de rotation**
- **Effet de pulsation**
- **Couleurs distinctives** par destination

---

## 📝 Modifications à Apporter

### Étape 1 : Ajouter les Nouveaux Fichiers

Copiez les fichiers créés dans votre projet :

```
components/
└── dialogue_component.gd         [NOUVEAU]

entities/
├── npc.gd                        [NOUVEAU]
└── portal.gd                     [NOUVEAU]

maps/
├── ville_map.gd                  [NOUVEAU]
└── ville_map.tscn                [NOUVEAU]

scenes/
└── npc.tscn                      [NOUVEAU]
```

---

### Étape 2 : Modifier le MapManager

Éditez `systems/map_manager.gd` pour :

1. **Ajouter la carte Ville**
2. **Gérer le spawn en ville après la mort**

#### Modifications dans `map_manager.gd` :

```gdscript
# Dans la section des définitions de cartes, ajoutez :
const MAP_DEFINITIONS = {
	"ville": {
		"name": "Ville",
		"scene_path": "res://maps/ville_map.tscn",
		"spawn_position": Vector2(0, 0),
		"background_color": Color(0.3, 0.35, 0.45)
	},
	"forest": {
		# ... config existante
	},
	"desert": {
		# ... config existante
	},
	"cavern": {
		# ... config existante
	}
}

# Changer la carte de départ :
var current_map_id: String = "ville"  # Au lieu de "forest"
```

---

### Étape 3 : Modifier le Player pour Respawn en Ville

Éditez `entities/player.gd` :

```gdscript
func _on_died():
	print("💀 Joueur mort - Téléportation à la Ville")
	player_died.emit()
	
	# Au lieu de queue_free(), téléporter en ville
	var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
	if map_manager:
		# Restaurer HP avant téléportation
		if health_component:
			health_component.heal(health_component.max_health)
		
		# Téléporter en ville
		map_manager.change_map("ville", self)
	else:
		# Fallback si pas de MapManager
		queue_free()
```

---

### Étape 4 : Ajouter le PNJ dans la Ville

Éditez `maps/ville_map.tscn` (ou créez-le) :

1. Ouvrez la scène dans Godot
2. Sous le nœud `NPCs`, ajoutez une instance de `npc.tscn`
3. Positionnez-le au centre : `position = Vector2(0, 50)`
4. Configurez le dialogue :
   - Sélectionnez le nœud `NPC/DialogueComponent`
   - Modifiez `npc_name` : "Gardien de la Ville"
   - Modifiez `dialogue_text` : "Bienvenue ! La ville est sûre. Utilisez les portails pour explorer."

---

### Étape 5 : Remplacer les Portails Rectangulaires par des Cercles

#### Option A : Modifier les Scènes de Cartes Existantes

Pour chaque carte (`forest_map.tscn`, `desert_map.tscn`, `cavern_map.tscn`) :

1. Sélectionnez un portail existant
2. Remplacez le script par `res://entities/portal.gd`
3. Supprimez l'ancien `PortalVisual` (ColorRect simple)
4. Ajoutez la nouvelle structure :

```
Portal (Area2D)
├── PortalVisual (Node2D)
│   ├── OuterCircle (ColorRect)
│   ├── MiddleCircle (ColorRect)
│   └── InnerCircle (ColorRect)
├── CollisionShape2D (CircleShape2D)
└── Label
```

5. Configurez les cercles avec les dimensions indiquées dans `portal.gd`

#### Option B : Script Automatique de Mise à Jour

Créez `tools/update_portals.gd` :

```gdscript
extends Node

func update_portals_in_scene(scene_path: String):
	var scene = load(scene_path).instantiate()
	var portals = scene.get_node("Portals")
	
	for portal in portals.get_children():
		# Remplacer l'ancien visuel par le nouveau
		var old_visual = portal.get_node_or_null("PortalVisual")
		if old_visual and old_visual is ColorRect:
			old_visual.queue_free()
			
			# Créer la nouvelle structure circulaire
			var visual = Node2D.new()
			visual.name = "PortalVisual"
			portal.add_child(visual)
			
			# Ajouter les cercles (code similaire à portal.gd)
```

---

### Étape 6 : Configurer les Couleurs des Portails

Dans chaque carte, définissez les couleurs des portails :

#### Ville → Forêt
```gdscript
portal_color = Color(0.3, 0.9, 0.4)  # Vert
```

#### Forêt → Désert
```gdscript
portal_color = Color(0.9, 0.8, 0.3)  # Jaune/Orange
```

#### Forêt → Caverne
```gdscript
portal_color = Color(0.4, 0.3, 0.5)  # Violet/Gris
```

#### Désert → Forêt
```gdscript
portal_color = Color(0.3, 0.9, 0.4)  # Vert
```

#### Désert → Caverne
```gdscript
portal_color = Color(0.4, 0.3, 0.5)  # Violet/Gris
```

#### Caverne → Forêt
```gdscript
portal_color = Color(0.3, 0.9, 0.4)  # Vert
```

#### Caverne → Désert
```gdscript
portal_color = Color(0.9, 0.8, 0.3)  # Jaune/Orange
```

---

### Étape 7 : Ajouter un Portail Ville dans Chaque Carte (Optionnel)

Si vous voulez un retour rapide à la ville depuis n'importe quelle carte :

Dans `forest_map.tscn`, `desert_map.tscn`, `cavern_map.tscn`, ajoutez :

```gdscript
[node name="PortalVille" type="Area2D" parent="Portals"]
position = Vector2(0, -350)
script = ExtResource("portal_script")

# Configurez :
destination_map = "ville"
portal_color = Color(0.5, 0.6, 0.8)  # Bleu clair (couleur ville)
```

---

## 🎮 Nouvelles Fonctionnalités

### Interaction avec les PNJ

1. **Approchez-vous** du PNJ (dans les 80 pixels)
2. Un indicateur **[E]** apparaît
3. Appuyez sur **ESPACE** ou **E**
4. Une boîte de dialogue s'affiche pendant 3 secondes

### Respawn en Ville

1. Quand le joueur meurt dans n'importe quelle carte
2. **Téléportation automatique** à la Ville
3. **Santé restaurée** complètement
4. Les stats (XP, niveaux) sont **préservées**

### Portails Améliorés

1. **Effet visuel** : Rotation + pulsation
2. **Cercles concentriques** : 3 niveaux de transparence
3. **Couleurs distinctives** : Identifiez la destination
4. **Meilleure visibilité** : Plus grands et plus animés

---

## 🗺️ Nouvelle Structure de Cartes

```
🏘️ VILLE (Spawn/Safe Zone)
   │
   └── 🌲 FORÊT (Facile)
       ├── 🏜️ DÉSERT (Moyen)
       └── 🕳️ CAVERNE (Difficile)
```

Avec retour optionnel à la Ville depuis chaque carte.

---

## ⚙️ Paramètres Configurables

### Dans `dialogue_component.gd` :
- `npc_name` : Nom du PNJ
- `dialogue_text` : Texte du dialogue (multilignes)
- `interaction_range` : Distance d'interaction (défaut: 50)

### Dans `portal.gd` :
- `destination_map` : Carte de destination
- `portal_color` : Couleur du portail
- `rotation_speed` : Vitesse de rotation (défaut: 1.0)

### Dans `ville_map.gd` :
- `get_spawn_position()` : Position de spawn (défaut: Vector2(0, 0))

---

## 🎨 Personnalisation

### Changer l'Apparence du PNJ

Dans `npc.tscn`, modifiez les ColorRect :
- `Visual` : Corps du PNJ
- `Head` : Tête du PNJ

Changez les couleurs pour créer différents types de PNJ.

### Ajouter Plus de PNJ

1. Dupliquez `npc.tscn` → `npc_merchant.tscn`
2. Changez les couleurs
3. Modifiez le dialogue
4. Ajoutez-le dans `ville_map.tscn`

### Créer d'Autres Bâtiments

Dans `ville_map.tscn`, dupliquez les ColorRect sous `Buildings` pour créer plus de structures.

---

## 🐛 Résolution de Problèmes

### Le joueur ne respawn pas en ville
→ Vérifiez que `map_manager.gd` a bien la définition de "ville"
→ Vérifiez que le path de la scène est correct

### Le PNJ ne répond pas
→ Vérifiez que le joueur est dans le groupe "player"
→ Vérifiez que l'InteractionArea a collision_mask = 1

### Les portails ne tournent pas
→ Vérifiez que le script `portal.gd` est bien attaché
→ Vérifiez que la structure PortalVisual existe

### Les cercles n'apparaissent pas
→ Vérifiez la hiérarchie : Portal → PortalVisual → Cercles
→ Vérifiez les offsets des ColorRect

---

## 📈 Améliorations Futures Possibles

1. **Dialogue à choix multiples** : Réponses A/B/C
2. **Quêtes données par les PNJ** : "Tue 10 ennemis dans la Forêt"
3. **Boutique** : PNJ marchand pour acheter des items
4. **Auberge** : PNJ qui restaure la santé contre de l'argent
5. **Banque** : Stockage d'items
6. **Panneau d'affichage** : Quêtes disponibles
7. **Portails débloquables** : Nécessitent un niveau minimum
8. **Animations de portail** : Particules, shaders

---

## ✅ Checklist de Mise en Place

- [ ] Copier tous les nouveaux fichiers .gd et .tscn
- [ ] Modifier `map_manager.gd` pour ajouter "ville"
- [ ] Modifier `player.gd` pour le respawn en ville
- [ ] Créer la scène `ville_map.tscn`
- [ ] Ajouter au moins 1 PNJ dans la ville
- [ ] Remplacer les portails par la version circulaire
- [ ] Configurer les couleurs des portails
- [ ] Tester le respawn en se faisant tuer
- [ ] Tester l'interaction avec le PNJ
- [ ] Tester la téléportation vers la Forêt

---

## 🚀 Pour Commencer

1. **Testez d'abord la Ville seule** :
   - Ouvrez `ville_map.tscn` dans Godot
   - Appuyez sur F6 pour tester la scène
   - Vérifiez le PNJ et le portail

2. **Intégrez au MapManager** :
   - Modifiez `map_manager.gd`
   - Testez le chargement de la Ville

3. **Testez le Respawn** :
   - Allez dans la Forêt
   - Faites-vous tuer par un ennemi
   - Vérifiez que vous respawn en Ville

4. **Améliorez les Portails** :
   - Remplacez un portail à la fois
   - Testez après chaque modification

**Bon développement ! 🏘️✨**
