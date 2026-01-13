# Roadmap - Fonctionnalités Futures

## 🎯 Vue d'Ensemble

Ce document liste les fonctionnalités que vous pouvez ajouter au prototype, organisées par difficulté et impact.

---

## 🟢 FACILE - Idéal pour Débuter

### 1. Dash Component ⚡
**Temps estimé** : 30 minutes  
**Impact** : ★★★★☆  
**Description** : Capacité de faire un dash rapide avec cooldown

```gdscript
// Composant déjà décrit dans EXTENSION_GUIDE.md
```

### 2. Different Weapon Types 🗡️
**Temps estimé** : 45 minutes  
**Impact** : ★★★☆☆  
**Description** : Différentes armes avec stats différentes

**Fichiers à créer** :
- `components/weapon_component.gd`
- `data/weapons.json`

### 3. Health Pickups ❤️
**Temps estimé** : 30 minutes  
**Impact** : ★★★★☆  
**Description** : Objets qui restaurent la santé

**Fichiers à créer** :
- `entities/health_pickup.gd`
- `scenes/health_pickup.tscn`

### 4. Enemy Spawn System 👾
**Temps estimé** : 45 minutes  
**Impact** : ★★★★☆  
**Description** : Faire apparaître des ennemis automatiquement

**Fichiers à créer** :
- `systems/spawn_system.gd`
- `data/spawn_waves.json`

### 5. Sound Effects 🔊
**Temps estimé** : 1 heure  
**Impact** : ★★★★★  
**Description** : Sons pour attaques, dégâts, mort

**Fichiers à créer** :
- `components/sound_component.gd`
- Dossier `sounds/` avec fichiers .wav/.ogg

### 6. Screen Shake 📳
**Temps estimé** : 30 minutes  
**Impact** : ★★★☆☆  
**Description** : Effet de tremblement lors des impacts

**Modification** :
- `systems/camera_system.gd` → Ajouter shake logic

---

## 🟡 MOYEN - Nécessite Plus de Réflexion

### 7. Experience & Leveling System 📊
**Temps estimé** : 2 heures  
**Impact** : ★★★★★  
**Description** : XP, niveaux, montée de stats

**Fichiers à créer** :
- `components/experience_component.gd`
- `systems/level_up_ui.gd`
- `data/level_curve.json`

**Connecté à** :
- HealthComponent (bonus HP)
- AttackComponent (bonus dégâts)
- MovementComponent (bonus vitesse optionnel)

### 8. Inventory System 🎒
**Temps estimé** : 3 heures  
**Impact** : ★★★★★  
**Description** : Système d'inventaire avec items

**Fichiers à créer** :
- `components/inventory_component.gd`
- `systems/inventory_ui.gd`
- `data/items.json`

**Features** :
- Ramasser des objets
- Utiliser des objets (potions, etc.)
- Limite de slots
- UI pour voir l'inventaire

### 9. Quest System 📜
**Temps estimé** : 3 heures  
**Impact** : ★★★★☆  
**Description** : Quêtes avec objectifs et récompenses

**Fichiers à créer** :
- `systems/quest_system.gd`
- `systems/quest_ui.gd`
- `data/quests.json`

**Types de quêtes** :
- Kill X enemies
- Collect X items
- Reach location
- Talk to NPC

### 10. Dialogue System 💬
**Temps estimé** : 4 heures  
**Impact** : ★★★★★  
**Description** : Conversations avec NPCs

**Fichiers à créer** :
- `systems/dialogue_system.gd`
- `systems/dialogue_ui.gd`
- `data/dialogues.json`
- `entities/npc.gd`

**Features** :
- Boîte de dialogue
- Choix multiples
- Variables de dialogue
- Intégration avec quêtes

### 11. Multiple Enemy AI Behaviors 🤖
**Temps estimé** : 2 heures  
**Impact** : ★★★★☆  
**Description** : Différents comportements d'IA

**Fichiers à créer** :
- `components/ai_component_ranged.gd` (tire à distance)
- `components/ai_component_flee.gd` (fuit quand faible)
- `components/ai_component_swarm.gd` (attaque en groupe)

### 12. Boss Fights 👹
**Temps estimé** : 4 heures  
**Impact** : ★★★★★  
**Description** : Boss avec patterns d'attaque et phases

**Fichiers à créer** :
- `components/boss_component.gd`
- `components/phase_component.gd`
- `systems/boss_health_ui.gd`

**Features** :
- Plusieurs phases
- Patterns d'attaque complexes
- Animations d'intro/outro
- Musique spéciale

---

## 🔴 AVANCÉ - Pour Aller Plus Loin

### 13. Equipment System ⚔️🛡️
**Temps estimé** : 5 heures  
**Impact** : ★★★★★  
**Description** : Équipement avec stats (armure, armes, accessoires)

**Fichiers à créer** :
- `components/equipment_component.gd`
- `systems/equipment_ui.gd`
- `data/equipment.json`

**Slots** :
- Weapon
- Armor
- Helmet
- Accessory x2

### 14. Skill Tree 🌳
**Temps estimé** : 6 heures  
**Impact** : ★★★★★  
**Description** : Arbre de compétences avec déblocages

**Fichiers à créer** :
- `systems/skill_tree_system.gd`
- `systems/skill_tree_ui.gd`
- `data/skills.json`

**Skills possibles** :
- Double attack
- HP regen
- Critical hits
- Dash improvement
- Magic abilities

### 15. Magic System ✨
**Temps estimé** : 5 heures  
**Impact** : ★★★★★  
**Description** : Sorts magiques avec mana

**Fichiers à créer** :
- `components/mana_component.gd`
- `components/spell_component.gd`
- `entities/projectile.gd`
- `data/spells.json`

**Types de sorts** :
- Projectiles
- Zones (AOE)
- Buffs
- Healing

### 16. Procedural Dungeon Generation 🏰
**Temps estimé** : 8 heures  
**Impact** : ★★★★★  
**Description** : Génération procédurale de donjons

**Fichiers à créer** :
- `systems/dungeon_generator.gd`
- `systems/room_manager.gd`
- `data/room_templates.json`

**Algorithmes** :
- Binary Space Partitioning
- Cellular Automata
- Wave Function Collapse

### 17. Save/Load System 💾
**Temps estimé** : 4 heures  
**Impact** : ★★★★★  
**Description** : Sauvegarder et charger la partie

**Fichiers à créer** :
- `systems/save_system.gd`
- `components/saveable_component.gd`

**À sauvegarder** :
- Position du joueur
- Stats (HP, XP, niveau)
- Inventaire
- Quêtes complétées
- Ennemis tués

### 18. Minimap 🗺️
**Temps estimé** : 3 heures  
**Impact** : ★★★☆☆  
**Description** : Mini-carte du niveau

**Fichiers à créer** :
- `systems/minimap_system.gd`
- Viewport pour la minimap

### 19. Status Effects 🧪
**Temps estimé** : 4 heures  
**Impact** : ★★★★☆  
**Description** : Poison, slow, stun, burn, etc.

**Fichiers à créer** :
- `components/status_effect_component.gd`
- `data/status_effects.json`

**Effets** :
- Poison (dégâts sur durée)
- Slow (réduction vitesse)
- Stun (immobilisé)
- Burn (dégâts + réduction défense)
- Freeze (immobilisé temporaire)

### 20. Multiplayer Co-op 🤝
**Temps estimé** : 15+ heures  
**Impact** : ★★★★★  
**Description** : Jeu en coopération locale ou en ligne

**Fichiers à créer** :
- `systems/multiplayer_system.gd`
- Adaptation de tous les composants

**Complexité** : Très élevée, requiert synchronisation réseau

---

## 📊 Roadmap Suggérée par Priorité

### Phase 1 : Gameplay Core (2-4 heures)
1. ✅ Mouvement, combat, IA (déjà fait)
2. Health Pickups
3. Dash Component
4. Sound Effects

### Phase 2 : Progression (6-8 heures)
5. Experience & Leveling
6. Different Weapon Types
7. Inventory System
8. Enemy Spawn System

### Phase 3 : Contenu (10-15 heures)
9. Dialogue System
10. Quest System
11. Multiple Enemy AI
12. Boss Fights

### Phase 4 : Systèmes Avancés (15-20 heures)
13. Equipment System
14. Magic System
15. Save/Load System
16. Status Effects

### Phase 5 : Polish (10+ heures)
17. Screen Shake
18. Minimap
19. Skill Tree
20. Procedural Dungeons

---

## 🎨 Alternatives Visuelles (Si Vous Voulez)

Si vous décidez d'améliorer les visuels tout en restant simple :

### Option 1 : Sprites Simples
- Utilisez des sprites 8x8 ou 16x16 pixels
- Sites gratuits : OpenGameArt.org, itch.io

### Option 2 : Pixel Art Généré
- Outils : Piskel, Aseprite
- 10 minutes par sprite

### Option 3 : Formes Géométriques Évoluées
- Gardez les ColorRect mais ajoutez :
  - Rotation
  - Scale animation
  - Glow effects (shader simple)

### Option 4 : ASCII Art
- Utilisez des Label avec police monospace
- Très rétro, très unique

---

## 🔧 Outils Recommandés

### Pour le Son
- **Générateurs** : Chiptone, BFXR
- **Musique** : Bosca Ceoil

### Pour les Sprites (si besoin)
- **Gratuit** : Piskel, GIMP
- **Payant** : Aseprite (20€)

### Pour le Level Design
- **Tiled** : Éditeur de cartes 2D (gratuit)

### Pour les Données
- **JSON Editor Online** : Édition visuelle de JSON

---

## 📝 Template pour Nouvelles Fonctionnalités

Quand vous ajoutez une fonctionnalité :

1. **Définir** : Que fait exactement cette feature ?
2. **Découper** : Quels composants/systèmes sont nécessaires ?
3. **Créer** : Créez les fichiers dans le bon dossier
4. **Connecter** : Utilisez des signaux pour la communication
5. **Tester** : Testez isolément avant d'intégrer
6. **Documenter** : Ajoutez des commentaires

---

## 🎯 Objectifs par Niveau de Compétence

### Débutant (0-20h de développement)
- Compléter les exercices du TUTORIAL.md
- Ajouter 2-3 fonctionnalités faciles (🟢)
- Modifier toutes les stats via JSON

### Intermédiaire (20-100h)
- Implémenter un système complet (XP, Inventaire, Quêtes)
- Créer 5+ types d'ennemis différents
- Faire un niveau jouable complet

### Avancé (100h+)
- Tous les systèmes RPG
- Génération procédurale
- Skill tree complet
- Publier sur itch.io

---

## 🌟 Conseil Final

**N'implémentez PAS tout d'un coup !**

Ajoutez une fonctionnalité à la fois, testez-la bien, puis passez à la suivante. L'architecture modulaire permet cela : chaque ajout est **indépendant** et ne casse pas l'existant.

**Bonne création !** 🚀
