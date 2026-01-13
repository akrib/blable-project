# 📦 Package - Ville, PNJ et Portails Circulaires

## 🎯 Contenu du Package

Ce package contient **tous les fichiers nécessaires** pour ajouter à votre jeu :
- ✅ Une **carte Ville** (zone sûre de départ)
- ✅ Un **système de PNJ** avec dialogue
- ✅ Des **portails circulaires animés**
- ✅ Un **système de respawn** en ville après la mort

---

## 📁 Structure des Fichiers

```
📂 Package/
│
├── 📚 Documentation/
│   ├── README_PACKAGE.md              ← Ce fichier
│   ├── NOUVELLES_FONCTIONNALITES.md   ← Vue d'ensemble complète
│   ├── VILLE_UPDATE_GUIDE.md          ← Guide d'intégration détaillé
│   └── PLAYER_RESPAWN_PATCH.md        ← Patch pour le respawn
│
├── 🧩 components/
│   └── dialogue_component.gd          ← Composant de dialogue pour PNJ
│
├── 🎭 entities/
│   ├── npc.gd                         ← Script du PNJ interactif
│   └── portal.gd                      ← Portail avec effets circulaires
│
├── 🗺️ maps/
│   ├── ville_map.gd                   ← Script de la carte Ville
│   └── ville_map.tscn                 ← Scène de la carte Ville
│
├── 🎬 scenes/
│   └── npc.tscn                       ← Scène du PNJ préconfigurée
│
├── ⚙️ systems/
│   └── map_manager_with_ville.gd      ← MapManager modifié
│
└── 🛠️ tools/
    └── portal_factory.gd              ← Utilitaire de création de portails
```

---

## 🚀 Installation Express (5 minutes)

### Étape 1 : Copier les Fichiers
Copiez **tous les dossiers** dans votre projet Godot :
- `components/` → `res://components/`
- `entities/` → `res://entities/`
- `maps/` → `res://maps/`
- `scenes/` → `res://scenes/`
- `systems/` → `res://systems/`
- `tools/` → `res://tools/`

### Étape 2 : Modifications Minimales

#### A. Modifier `systems/map_manager.gd`
Ajoutez dans `MAP_DEFINITIONS` :
```gdscript
"ville": {
	"name": "Ville",
	"scene_path": "res://maps/ville_map.tscn",
	"spawn_position": Vector2(0, 0),
	"is_safe_zone": true
}
```

Et changez :
```gdscript
var current_map_id: String = "ville"  # Au lieu de "forest"
```

#### B. Modifier `entities/player.gd`
Remplacez la fonction `_on_died()` :
```gdscript
func _on_died():
	player_died.emit()
	
	var map_manager = get_tree().root.get_node_or_null("Main/MapManager")
	if map_manager:
		map_manager.respawn_player_in_ville(self)
	else:
		queue_free()
```

#### C. Ajouter la fonction dans `MapManager`
```gdscript
func respawn_player_in_ville(player: CharacterBody2D):
	var health_comp = player.get_node_or_null("HealthComponent")
	if health_comp:
		health_comp.heal(health_comp.max_health)
	change_map("ville", player)
```

### Étape 3 : Tester
1. Lancez le jeu (F5)
2. Vous devriez spawner en **Ville**
3. Approchez-vous du **PNJ** et appuyez sur **ESPACE**
4. Utilisez le **portail vert** pour aller en Forêt
5. Laissez-vous tuer → Vérifiez le respawn en Ville

✅ **C'est tout ! Ça devrait fonctionner.**

---

## 📖 Documentation Détaillée

### Pour une Installation Complète
Lisez : **VILLE_UPDATE_GUIDE.md**
- Guide pas à pas avec toutes les options
- Personnalisations possibles
- Troubleshooting

### Pour Comprendre le Respawn
Lisez : **PLAYER_RESPAWN_PATCH.md**
- Explication du système de respawn
- Options de pénalité
- Effets visuels bonus

### Pour une Vue d'Ensemble
Lisez : **NOUVELLES_FONCTIONNALITES.md**
- Toutes les fonctionnalités
- Idées d'extension
- Statistiques et benchmarks

---

## 🎮 Nouvelles Fonctionnalités en Bref

### 🏘️ Ville (Zone Sûre)
- Carte sans ennemis
- Point de spawn initial
- Point de respawn après mort
- Bâtiments décoratifs
- Portail vers la Forêt

### 👤 PNJ Interactif
- Appuyez sur **ESPACE** ou **E** pour parler
- Zone de détection : 80 pixels
- Indicateur visuel **[E]**
- Boîte de dialogue stylisée
- Auto-fermeture après 3 secondes

### 🌀 Portails Circulaires
- **3 cercles concentriques**
- **Rotation continue**
- **Effet de pulsation**
- **Couleurs par destination** :
  - 🟢 Vert → Forêt
  - 🟡 Jaune → Désert
  - 🟣 Violet → Caverne
  - 🔵 Bleu → Ville

### 💀 Respawn Automatique
- Mort → Téléportation en Ville
- Santé restaurée à 100%
- XP et niveaux préservés
- Pas de perte de progression

---

## 🗺️ Nouvelle Carte du Monde

```
           🏘️ VILLE
         (Zone Sûre)
              ↓
          🟢 Portail
              ↓
          🌲 FORÊT
         (Facile ★)
          /      \
    🟡 Port.   🟣 Port.
        /          \
   🏜️ DÉSERT    🕳️ CAVERNE
   (Moyen ★★)  (Difficile ★★★)
        \          /
     🟣 Port.  🟡 Port.
          \      /
           -------
```

---

## 🛠️ Outils Inclus

### PortalFactory
Créez des portails facilement :
```gdscript
var portal = PortalFactory.create_portal("forest", Vector2(0, 350))
$Portals.add_child(portal)
```

Mettez à jour automatiquement les anciens portails :
```gdscript
PortalFactory.upgrade_existing_portals(get_tree().current_scene)
```

Configurez tous les portails d'une carte :
```gdscript
PortalFactory.setup_map_portals("ville", $Portals)
```

---

## ⚙️ Configuration Rapide

### Changer le Dialogue du PNJ
Ouvrez `scenes/npc.tscn` → `DialogueComponent` :
- `npc_name` = "Votre Nom"
- `dialogue_text` = "Votre message"

### Changer les Couleurs des Portails
Éditez `tools/portal_factory.gd` :
```gdscript
const PORTAL_COLORS = {
	"ville": Color(0.5, 0.6, 0.8),  # Modifiez ici
}
```

### Ajouter un Nouveau PNJ
1. Instanciez `npc.tscn`
2. Positionnez dans `ville_map.tscn`
3. Modifiez le dialogue

---

## 🧪 Tests Recommandés

1. **Test de spawn** : Le jeu démarre en Ville ✓
2. **Test PNJ** : Interaction fonctionne ✓
3. **Test portail** : Téléportation Ville → Forêt ✓
4. **Test respawn** : Mort → Retour en Ville ✓
5. **Test stats** : XP/Niveaux préservés ✓
6. **Test animation** : Portails tournent et pulsent ✓

---

## 🐛 Problèmes Communs

### "Le joueur ne respawn pas"
→ Vérifiez que le MapManager a la fonction `respawn_player_in_ville()`
→ Vérifiez le chemin : `Main/MapManager`

### "Les cercles ne s'affichent pas"
→ Vérifiez la hiérarchie : `Portal/PortalVisual/Cercles`
→ Vérifiez que `portal.gd` est attaché à l'Area2D

### "Le PNJ ne répond pas"
→ Vérifiez que le joueur est dans le groupe "player"
→ Vérifiez collision_mask = 1 sur InteractionArea

---

## 📊 Statistiques du Package

- **Fichiers** : 9 fichiers GDScript + 2 fichiers TSCN
- **Lignes de code** : ~560 lignes
- **Temps d'installation** : 5-10 minutes
- **Difficulté** : ⭐⭐ Moyen
- **Impact** : ⭐⭐⭐⭐⭐ Transforme le jeu !

---

## 🌟 Ce que Ça Apporte à Votre Jeu

### Avant
- ✗ Spawn aléatoire
- ✗ Mort = Game Over
- ✗ Pas d'interaction
- ✗ Portails basiques

### Après
- ✅ Hub central (Ville)
- ✅ Respawn sécurisé
- ✅ PNJ interactifs
- ✅ Portails stylés
- ✅ Progression préservée
- ✅ Narration possible (via dialogues)

---

## 🎯 Prochaines Extensions Possibles

Une fois installé, vous pourrez ajouter :

1. **Quêtes** : PNJ qui donnent des missions
2. **Boutique** : Achat d'items
3. **Auberge** : Restauration HP contre argent
4. **Banque** : Stockage d'objets
5. **Panneau de quêtes** : Affichage des missions
6. **Musique de ville** : Ambiance calme
7. **Plus de PNJ** : Diversité de personnages
8. **Événements** : Actions spéciales en ville

---

## 📞 Support

### Si vous rencontrez un problème :

1. **Consultez la documentation** :
   - VILLE_UPDATE_GUIDE.md (détaillé)
   - NOUVELLES_FONCTIONNALITES.md (complet)
   - PLAYER_RESPAWN_PATCH.md (respawn)

2. **Vérifiez les logs** :
   - Console Godot (Output)
   - Messages d'erreur

3. **Testez étape par étape** :
   - Une fonctionnalité à la fois
   - Utilisez print() pour déboguer

---

## ✅ Checklist d'Installation

- [ ] Tous les fichiers copiés
- [ ] MapManager modifié
- [ ] Player.gd modifié
- [ ] Ville testée (F6 sur ville_map.tscn)
- [ ] PNJ testé (interaction)
- [ ] Portail testé (téléportation)
- [ ] Respawn testé (mort → ville)
- [ ] Stats préservées vérifiées

**Tout coché ? Vous êtes prêt ! 🎉**

---

## 🚀 Démarrage Rapide

```bash
# Dans votre projet Godot :

# 1. Copier les fichiers
cp -r package/* mon_projet/

# 2. Modifier map_manager.gd (ajoutez "ville")

# 3. Modifier player.gd (ajoutez respawn)

# 4. Lancer (F5)

# 5. Profiter ! 🎮
```

---

## 🎓 Ce que Vous Allez Apprendre

En intégrant ce package, vous comprendrez :

- ✅ Comment créer des zones de jeu variées
- ✅ Comment gérer la téléportation entre cartes
- ✅ Comment implémenter des dialogues
- ✅ Comment créer des effets visuels (rotation, pulsation)
- ✅ Comment sauvegarder/restaurer l'état du joueur
- ✅ Architecture modulaire et réutilisable
- ✅ Pattern Factory pour génération d'objets

---

## 💡 Conseil Final

**N'installez pas tout d'un coup !**

1. **Jour 1** : Ville + MapManager
2. **Jour 2** : PNJ + Dialogue
3. **Jour 3** : Portails circulaires
4. **Jour 4** : Respawn system
5. **Jour 5** : Tests et polish

Cette approche incrémentale vous permet de comprendre chaque partie et de débuguer facilement.

---

## 🎉 Félicitations !

Avec ce package, votre prototype devient un **vrai RPG** avec :
- 🏘️ Hub central
- 🗺️ Monde explorable
- 👥 Interactions sociales
- 💀 Système de vie/mort équilibré
- 📈 Progression sécurisée

**Vous êtes maintenant prêt pour ajouter des quêtes et du contenu narratif !**

---

**Bon développement ! 🌟**

---

## 📄 Licence

Ce code est fourni comme exemple éducatif pour votre projet Godot.
Utilisez-le librement, modifiez-le, étendez-le !

---

**Version** : 1.0
**Date** : 2025
**Compatible** : Godot 4.2+
