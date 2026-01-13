# Guide du Système de Stats Configurable

## 🎯 Concept Principal

Votre personnage est un **blob** complètement personnalisable avec **deux arbres de progression séparés** :

### 🧬 Stats Corporelles (Body Stats)
Définissent les capacités physiques de votre blob.

### ⚔️ Stats d'Attaque (Attack Stats)
Définissent la forme et le type de vos attaques.

---

## 📊 Statistiques Corporelles

### Liste des Stats

#### 1. **Vitesse de Mouvement**
- **Effet** : +10 vitesse par point
- **Base** : 100 vitesse
- **Utilité** : Se déplacer plus vite, esquiver les ennemis

#### 2. **Points de Vie**
- **Effet** : +10 HP par point
- **Base** : 50 HP
- **Utilité** : Survivre plus longtemps, encaisser plus de dégâts

#### 3. **Défense**
- **Effet** : +2% réduction de dégâts par point (max 80%)
- **Base** : 0% réduction
- **Utilité** : Réduire les dégâts reçus

#### 4. **Chance**
- **Effet** : +5% multiplicateur général par point
- **Bonus spécial** : +2% chance de coup critique par point
- **Base** : x1.0
- **Utilité** : Coups critiques plus fréquents (1.5x dégâts), meilleur loot (futur)

#### 5. **Intelligence**
- **Effet** : +8% dégâts élémentaires par point
- **Base** : x1.0
- **Utilité** : Augmente tous les dégâts élémentaires (air, feu, eau, terre)

#### 6. **Dexterité**
- **Effet** : +6% efficacité générale par point
- **Base** : x1.0
- **Utilité** : Knockback plus fort, précision améliorée

#### 7. **Vitesse d'Attaque**
- **Effet** : -0.02s de cooldown par point
- **Base** : 0.5s entre les attaques
- **Min** : 0.1s
- **Utilité** : Attaquer plus rapidement

### Progression
- **Points par niveau** : 5 points
- **XP nécessaire** : 100 * (1.5 ^ (niveau-1))
- **Niveau de départ** : 1 (avec 5 points)

---

## ⚔️ Statistiques d'Attaque

### Liste des Stats

#### 1-4. **Dégâts Élémentaires**
- **Air** : Cyan clair
- **Feu** : Rouge-orange
- **Eau** : Bleu
- **Terre** : Marron

**Effet** : +3 dégâts par point pour l'élément choisi  
**Base** : 5 dégâts par élément  
**Utilité** : Spécialisation élémentaire ou build hybride

💡 **Astuce** : L'élément dominant détermine la couleur de votre blob et de votre attaque !

#### 5. **Largeur d'Attaque**
- **Effet** : +5 pixels par point
- **Base** : 30 pixels
- **Utilité** : Toucher plusieurs ennemis en même temps

#### 6. **Longueur d'Attaque**
- **Effet** : +8 pixels par point
- **Base** : 40 pixels
- **Utilité** : Allonge la portée de l'attaque

#### 7. **Distance d'Attaque**
- **Effet** : +5 pixels par point
- **Base** : 15 pixels du corps
- **Utilité** : Attaquer depuis plus loin, sécurité

### Progression
- **Points par niveau** : 3 points
- **XP nécessaire** : 80 * (1.4 ^ (niveau-1))
- **Niveau de départ** : 1 (avec 3 points)

---

## 👾 Types d'Ennemis et Récompenses XP

### Guerrier (Rouge)
- 💪 HP : 50 | Vitesse : 70 | Dégâts : 8
- 🎁 **15 XP Corps** | 5 XP Attaque
- 🎯 **Idéal pour** : Monter les stats corporelles

### Mage (Violet)
- 🧙 HP : 30 | Vitesse : 100 | Dégâts : 12
- 🎁 5 XP Corps | **20 XP Attaque**
- 🎯 **Idéal pour** : Monter les stats d'attaque

### Tank (Jaune-Marron)
- 🛡️ HP : 100 | Vitesse : 40 | Dégâts : 15
- 🎁 **30 XP Corps** | 3 XP Attaque
- 🎯 **Idéal pour** : Farm intensif de XP corporelle

### Assassin (Gris Foncé)
- 🗡️ HP : 25 | Vitesse : 150 | Dégâts : 20
- 🎁 10 XP Corps | 10 XP Attaque
- 🎯 **Idéal pour** : Progression équilibrée, challenge

### Élémentaire (Cyan)
- ✨ HP : 40 | Vitesse : 80 | Dégâts : 10
- 🎁 3 XP Corps | **25 XP Attaque**
- 🎯 **Idéal pour** : Maximiser les dégâts élémentaires

### Mini-Boss (Orange)
- 👹 HP : 150 | Vitesse : 60 | Dégâts : 25
- 🎁 **50 XP Corps** | **50 XP Attaque**
- 🎯 **Idéal pour** : Grosse récompense, défi

---

## 🎮 Stratégies de Build

### 🛡️ Build Tank
**Objectif** : Survivabilité maximale

**Stats Corporelles** :
- Points de Vie : MAX
- Défense : 20+ points (40% réduction)
- Vitesse de Mouvement : 5-10 points

**Stats d'Attaque** :
- Dégâts Terre : MAX (thème défensif)
- Largeur : 10+ points
- Distance : Minimal

**Ennemis à cibler** : Warriors, Tanks, Mini-Boss

---

### ⚡ Build Vitesse
**Objectif** : Mobilité et esquive

**Stats Corporelles** :
- Vitesse de Mouvement : MAX
- Dexterité : 15+ points
- Vitesse d'Attaque : 10+ points

**Stats d'Attaque** :
- Dégâts Air : MAX (thème vitesse)
- Distance : MAX
- Longueur : Moyen

**Ennemis à cibler** : Mages, Élémentaires, Assassins

---

### 🔥 Build Dégâts Élémentaires
**Objectif** : DPS maximum

**Stats Corporelles** :
- Intelligence : MAX
- Chance : 10+ points (crits)
- Vitesse d'Attaque : MAX

**Stats d'Attaque** :
- Tous les éléments : Équilibré OU spécialisé dans un
- Largeur : MAX (toucher plus d'ennemis)
- Longueur : MAX

**Ennemis à cibler** : Élémentaires, Mages, Mini-Boss

---

### 🎯 Build Hybride
**Objectif** : Équilibre parfait

**Stats Corporelles** :
- Répartition égale dans tout
- Focus sur Chance et Dexterité

**Stats d'Attaque** :
- 2 éléments principaux
- Distance et Largeur équilibrées

**Ennemis à cibler** : Tous types

---

### 🌈 Build Arc-en-Ciel
**Objectif** : Tous les éléments en même temps

**Stats Corporelles** :
- Intelligence : MAXIMUM (boost tous les éléments)
- Vitesse d'Attaque : Important
- Chance : Pour les crits

**Stats d'Attaque** :
- **1 point dans CHAQUE élément** d'abord
- Puis augmenter tous proportionnellement
- Largeur MAX pour effet visuel spectaculaire

**Résultat** : Attaque multicolore qui fait des dégâts de tous types !

---

## 💡 Conseils Avancés

### Synergie Intelligence + Éléments
- Intelligence multiplie TOUS les dégâts élémentaires
- 10 points en Intelligence = x1.8 dégâts
- Si vous avez 30 dégâts en Feu, avec 10 Intelligence = 54 dégâts !

### Chance et Coups Critiques
- Chance donne 2% de crit par point
- 15 points = 30% de chance de crit
- Les crits font 1.5x dégâts
- **Excellent avec** : Intelligence, Dégâts Élémentaires

### Dexterité et Knockback
- Dexterité augmente la force du knockback
- Utile pour maintenir les ennemis à distance
- **Excellent avec** : Distance d'Attaque, Vitesse de Mouvement

### Géométrie de l'Attaque
- Largeur : Bon pour les groupes d'ennemis
- Longueur : Bon pour garder la distance
- Distance : Permet d'attaquer sans risque

**Conseil** : Distance + Longueur = Attaque sniper !

### Farm Optimal
1. **Début de partie** : Tuez des Warriors (XP Corps équilibrée)
2. **Build la défense** : Montez HP et Défense en premier
3. **Puis les dégâts** : Tuez des Mages et Élémentaires
4. **Montez Intelligence** : Vos dégâts explosent
5. **Farm efficace** : Vous pouvez tuer n'importe quoi facilement

---

## 🔧 Interface

### Raccourcis
- **PAGE UP** : Ouvrir menu Stats Corporelles
- **PAGE DOWN** : Ouvrir menu Stats d'Attaque
- **Boutons** : Cliquer directement sur le HUD

### Barres d'XP
- **Verte** (haut) : Santé
- **Bleue** (milieu) : XP Corps
- **Rouge** (bas) : XP Attaque

### Dans les Menus
- **[+]** : Ajouter un point
- **[-]** : Retirer un point
- **Réinitialiser** : Récupérer tous les points (gratuit)

### Prévisualisation
- Le menu d'attaque montre la forme de votre attaque
- La couleur change selon l'élément dominant
- Les dégâts totaux sont affichés

---

## 🎨 Personnalisation Visuelle

### Couleur du Blob
Votre blob change de couleur selon votre élément dominant :
- **Air** : Cyan clair
- **Feu** : Rouge-orange
- **Eau** : Bleu
- **Terre** : Marron
- **Équilibré** : Vert (par défaut)

### Attaque Visuelle
- La forme rectangulaire change selon vos stats
- La couleur reflète l'élément
- L'opacité montre la puissance

---

## 📈 Progression Recommandée

### Niveaux 1-5 (Survie)
- **Corps** : HP (20 pts) + Défense (5 pts)
- **Attaque** : Un élément (10 pts) + Largeur (5 pts)

### Niveaux 6-10 (Mobilité)
- **Corps** : Vitesse Mouvement (15 pts) + Vitesse Attaque (10 pts)
- **Attaque** : Distance (10 pts) + Longueur (5 pts)

### Niveaux 11-20 (Puissance)
- **Corps** : Intelligence (25 pts) + Chance (25 pts)
- **Attaque** : Maxer vos éléments préférés + Dimensions

### Niveaux 21+ (Perfection)
- Compléter ce qui manque selon votre style
- Expérimenter avec différentes combinaisons

---

## 🏆 Défis

### Défi "Moine"
- **Aucun** point dans les dégâts élémentaires
- Uniquement forme de l'attaque
- Comptez sur Intelligence et Chance

### Défi "Pacifiste Rapide"
- MAX Vitesse de Mouvement
- MIN Dégâts
- Survivez en évitant

### Défi "Glass Cannon"
- MIN HP et Défense
- MAX Intelligence et Dégâts
- Un coup = mort, mais vous one-shot tout

### Défi "Pur Élément"
- UN SEUL élément
- 0 dans les 3 autres
- Devenez le maître de cet élément

---

## ❓ FAQ

**Q : Puis-je réinitialiser mes stats ?**  
R : Oui, gratuitement avec le bouton "Réinitialiser" dans chaque menu.

**Q : Quel est le cap de stats ?**  
R : Pas de cap ! Montez à l'infini selon votre niveau.

**Q : Les éléments ont-ils des faiblesses ?**  
R : Pas encore, mais possibilité future (Feu > Terre > Eau > Air > Feu).

**Q : Je dois choisir entre Corps OU Attaque ?**  
R : Non ! Les deux progressent indépendamment. Tuez différents ennemis.

**Q : Quelle est la meilleure build ?**  
R : Ça dépend de votre style ! Testez et expérimentez.

---

## 🚀 Prochaines Améliorations Possibles

- Résistances élémentaires des ennemis
- Buffs temporaires
- Équipement qui modifie les stats
- Compétences spéciales débloquées par les stats
- Système de prestige (reset pour bonus permanents)
- Classements par build

---

**Amusez-vous à créer le blob parfait ! 🟢**
