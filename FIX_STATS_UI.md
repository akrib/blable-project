# Correction du Système de Stats UI

## 🔧 Problème Résolu

Les interfaces de statistiques (Body Stats et Attack Stats) n'étaient plus accessibles après le changement de carte car elles étaient attachées à la scène Main qui n'est pas visible dans les sous-cartes.

## ✅ Solution Implémentée

### Nouveau Système : GlobalUI

J'ai créé un **GlobalUI** (CanvasLayer) qui persiste au-dessus de toutes les cartes :

**Fichier** : `systems/global_ui.gd`

```
Main (Node2D)
├── Player
├── MapManager
└── GlobalUI (CanvasLayer - layer 100)
    ├── BodyStatsUI
    └── AttackStatsUI
```

### Fonctionnalités

1. **CanvasLayer avec layer=100** : S'affiche au-dessus de tout
2. **Gestion des inputs globaux** : Écoute PAGE UP et PAGE DOWN
3. **Accessible depuis n'importe quelle carte** : Via `get_tree().root.get_node("Main/GlobalUI")`

### Raccourcis Clavier

- **PAGE UP** : Ouvre/ferme les stats corporelles
- **PAGE DOWN** : Ouvre/ferme les stats d'attaque
- **Boutons dans le HUD** : Fonctionnent aussi

### Modifications des Fichiers

1. **Nouveau** : `systems/global_ui.gd`
2. **Modifié** : `scenes/main.tscn` - GlobalUI ajouté
3. **Modifié** : `scenes/main.gd` - Utilise GlobalUI
4. **Modifié** : `systems/game_hud.gd` - Communique avec GlobalUI

## 🎮 Utilisation

Les interfaces de stats sont maintenant **toujours accessibles** :
- Appuyez sur PAGE UP/DOWN à tout moment
- Cliquez sur les boutons du HUD dans chaque carte
- Les interfaces persistent entre les changements de carte

## 🔄 Migration

Si vous avez l'ancienne version :
1. Remplacez `scenes/main.tscn`
2. Remplacez `scenes/main.gd`
3. Ajoutez `systems/global_ui.gd`
4. Remplacez `systems/game_hud.gd`

Tout le reste fonctionne exactement pareil !
