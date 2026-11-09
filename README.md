## 🧩 Exercice Flutter / Firestore ODM

### **Gestion des Produits et Catégories avec DTO et ODM**

------

### 🎯 **Objectif général**

L’objectif de cet exercice est de pratiquer la **manipulation de DTO (Data Transfer Objects)** et l’utilisation du **Firestore ODM** pour interagir avec une base de données Firestore de manière **typée, sécurisée et structurée**.

Votre mission :

- modéliser les données avec des DTO,
- générer le schéma ODM,
- puis afficher dynamiquement des **catégories** et des **produits** dans une interface Flutter.

------

### 🧱 **Contexte**

Vous développez une application Flutter de gestion de produits appelée **MyFruitz** 🍓.
 Chaque utilisateur possède plusieurs **catégories**, et chaque catégorie contient plusieurs **produits**.

L’application doit permettre :

- d’afficher les **catégories existantes** ;
- d’afficher les **produits associés** à chaque catégorie.

L’ensemble repose sur **Firestore ODM**, afin de garantir la cohérence des types et la maintenabilité du code.

------

### 🚀 **Étapes à suivre**

#### 🧩 Étape 0 — Installation

1. Cloner ce repository.
2. Exécuter `flutter pub get` dans chacun des dossiers suivants :
   - `code/dto`
   - `code/dto_exercice`
   - `code/push_data_firestore`

------

#### 🔗 Étape 1 — Lier le projet à Firebase

1. Rendez-vous sur la [console Firebase](https://console.firebase.google.com/).

2. Créez un **nouveau projet** nommé `DTO-EXERCICE`.

3. Ajoutez votre **application Flutter** :

   - Cliquez sur **Ajouter une application** → **Flutter** ;
   - Suivez les étapes d’intégration proposées.

4. Activez le module **Authentication** :

   - Activez la connexion **par e-mail et mot de passe**.

5. Activez le module **Firestore Database** :

   - Choisissez une **région européenne** ;
   - Configurez temporairement les **règles de sécurité** en `true` pour éviter les erreurs de permission.

6. Vérifiez la présence du fichier `firebase_options.dart` dans `code/dto_exercice/lib/`.

   > ✅ Cela confirme que votre projet Firebase est bien connecté.

------

#### 🧱 Étape 2 — Création des DTO

1. Rendez-vous dans le dossier `code/dto`.
2. Complétez les deux modèles de données :
   - **Category**
     - `id`, `title`, `description`, `createdAt`
   - **Product**
     - `id`, `name`, `description`, `price`, `createdAt`
3. Utilisez les bonnes annotations pour la sérialisation :
   - `@Freezed`, `@DocumentIdField`, `@Collection`, etc.
4. Complétez le fichier `schema.dart` pour définir la hiérarchie :
   - un utilisateur possède des **catégories** ;
   - chaque catégorie contient des **produits**.

------

#### 🗃️ Étape 3 — Définition du schéma ODM

Dans le fichier `schema.dart` :

- Définissez la structure hiérarchique Firestore :

  ```
  db.users(userId).categories(categoryId).products
  ```

- Assurez-vous que le schéma permet une navigation fluide :

  - `db.users(userId).categories`
  - `db.users(userId).categories(categoryId).products`

------

#### ⚙️ Étape 4 — Génération du code ODM

- Exécutez la commande :

  ```
  dart run build_runner build --delete-conflicting-outputs
  ```

- Vérifiez que les fichiers générés contiennent bien les extensions ODM.

- Si les modèles ne sont pas reconnus dans Flutter :

  - regénérez le code (`build_runner build`) ;
  - puis exécutez `flutter pub get` dans votre projet Flutter pour mettre à jour les dépendances.

------

#### 🧾 Étape 5 — Compléter les formulaires

1. Dans `dto_exercice/lib/screens/forms`, deux formulaires sont déjà présents.
2. Votre mission : **compléter la logique de soumission**.
   - Utilisez `await` et `.then()` pour gérer les actions après envoi.
   - Bloquez le bouton ou affichez un indicateur de chargement pendant le traitement.
3. Vérifiez ensuite dans la console Firebase que les données sont bien enregistrées.

> 💡 Astuce : Inspirez-vous du widget `RegisterForm`, qui contient déjà un exemple de logique d’enregistrement dans la base.

------

#### 🖼️ Étape 6 — Affichage des catégories et produits

1. Dans le `HomeScreen`, deux widgets commentés sont à réactiver :
   - `CategorySlider()` → pour afficher les **catégories** ;
   - `ProductSlider()` → pour afficher les **produits sans catégorie**.
2. Commencez par implémenter uniquement `CategorySlider`.

---

##### CategorySlider

Le widget `CategorySlider`, dans le `HomeScreen`, ne retourne pour l’instant **qu’un simple texte**.
 Votre tâche consiste à **le transformer en un widget dynamique** affichant **la liste des catégories** sous forme de **cartes**.

##### 🎓 Pourquoi utiliser un `StreamBuilder` ici ?

- Firestore est une base **réactive** : lorsqu’un document change, vous pouvez recevoir automatiquement la mise à jour sans recharger toute la page.
- Le `StreamBuilder` permet d’**écouter en temps réel** les modifications dans Firestore (ajout, suppression, mise à jour).
- À l’inverse, le `FutureBuilder` n’effectue **qu’une seule requête** : il ne met pas à jour les données automatiquement après coup.
   👉 Dans notre cas, comme les catégories peuvent être ajoutées ou supprimées dynamiquement, **le `StreamBuilder` est donc le bon choix.**

----

##### ProductSlider 

Le widget `ProductSlider`, présent dans le `HomeScreen`, a pour objectif d’afficher **tous les produits qui ne sont associés à aucune catégorie**.
 Dans votre base Firestore, ces produits sont regroupés dans une **catégorie spéciale** dont l’identifiant unique est :

```
"NotRefered"
```

Cette catégorie “symbolique” permet de conserver une structure uniforme dans Firestore (tous les produits sont dans une catégorie, même les non-classés), tout en gardant la possibilité d’exclure cette catégorie de l’affichage principal.

------

##### 🎓 Pourquoi utiliser un `StreamBuilder` ici aussi ?

Comme pour les catégories, il est important que la liste des produits se **mette à jour automatiquement** lorsqu’un produit est ajouté, modifié ou supprimé.

- `StreamBuilder` écoute en **temps réel** les changements dans Firestore.
- `FutureBuilder`, lui, ne fait qu’une seule requête (idéal pour des vues statiques, mais pas ici).
- En utilisant un **flux (`Stream`)** des produits de la catégorie `NotRefered`, on assure que la vue est toujours synchronisée avec la base de données, sans devoir recharger manuellement la page.

------

#### 🍋 Étape 7 — Gestion des produits sans catégorie

- Les produits non rattachés à une catégorie doivent être placés dans une **catégorie symbolique** dont l’`id` est `"NotRefered"`.
- Lors de vos requêtes Firestore :
  - **excluez** la catégorie `"NotRefered"` de la liste principale ;
  - pour afficher les produits non classés, chargez le contenu de cette catégorie spéciale.

------

#### 🔍 Étape 8 — Vue détaillée (Single View)

- Créez une vue dédiée pour afficher les **détails** :
  - d’un **produit**, ou
  - d’une **catégorie**.
- Utilisez un `FutureBuilder` pour récupérer les données via leur identifiant.
- Présentez les informations dans une interface claire, cohérente et responsive.

------

#### ✅ Étape 9 — Vérifications finales

- Ajoutez des **indicateurs de chargement** (`CircularProgressIndicator`) lorsque les données ne sont pas encore disponibles.
- Vérifiez :
  - l’affichage correct après ajout ou modification ;
  - les mises à jour en temps réel avec `StreamBuilder` (si utilisé) ;
  - la cohérence entre les modèles DTO et les documents Firestore.

------

### 🧭 **Critères de réussite**

- Les modèles DTO sont bien définis et annotés.
- Le schéma ODM permet une navigation fluide entre utilisateurs, catégories et produits.
- Les listes de catégories et de produits s’affichent dynamiquement depuis Firestore.
- L’application est fonctionnelle, stable et cohérente avec le design global.

------

### 💡 **Bonus (facultatif)**

- Permettre la **modification** de la catégorie d’un produit depuis la vue “Single Product”.
- Ajouter des boutons pour **supprimer** une catégorie ou un produit.
- Gérer les cas où la base est vide avec un affichage clair :
  - “Aucune catégorie disponible”
  - “Aucun produit trouvé”.

------

### 💡 **Ressources**

- Repo du package ODM : https://github.com/SylphxAI/firestore_odm
- Repo de notre DTO : https://github.com/trans-dam-2025-2026/dto-2526

------

### ⚖️ **Exemples : FutureBuilder vs StreamBuilder (avec Firestore ODM)**

------

#### Exemple 1 — `FutureBuilder`

Pour charger **une seule fois** les données d’un document (ex : profil utilisateur).

```
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example/data/firestore_odm.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirestoreODM(
      appSchema,
      firestore: FirebaseFirestore.instance,
    );

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Text("Aucun utilisateur connecté");
    }

    return FutureBuilder(
      future: db.users(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        final user = snapshot.data  ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.firstname} ${user.lastname}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("${user.email}"),
            Text("Créé le : ${user.createdAt.toLocal()}"),
          ],
        );
      },
    );
  }
}
```

🧠 **À retenir :**

- `FutureBuilder` exécute **une seule requête** (`.get()`).
- Idéal pour les pages de **détail** (profil utilisateur, fiche produit…).
- Ne se met **pas à jour automatiquement**.

------

#### 🔹 Exemple 2 — `StreamBuilder`

👉 Pour **écouter en temps réel** une collection (ex : catégories d’un utilisateur).

```
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:example/data/firestore_odm.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirestoreODM(
      appSchema,
      firestore: FirebaseFirestore.instance,
    );

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Text("Aucun utilisateur connecté");
    }

    return StreamBuilder(
      stream: db.users(userId).categories.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        final categories = snapshot.data  ?? [];
        
        if (categories.isEmpty) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Center(
              child: Text(
                'Aucune catégorie',
                style: TextStyle(
                fontSize: 18.0, 
                fontWeight: FontWeight.bold
                ),
              ),
            ),
          );
        }

        return SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width ,
          child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              child: ListTile(
                title: Text(category.title),
                subtitle: Text(category.description ?? ''),
              ),
            );
          },
          ),
        );
      },
    );
  }
}
```



# 🧩 Partie 2 — Création du Seeder Firestore

Cette seconde partie consiste à créer un **seeder Firestore** qui permettra à l’étudiant de **remplir** et **vider** la base de données Firestore automatiquement avec un jeu d’exemples : *catégories, produits et utilisateurs*.

Ce seeder est situé dans le dossier :

```
code/push_data_firestore
```

Il s’agit d’une **application Flutter indépendante**, pouvant tourner sur :

- macOS 🖥️
- Windows 💻

Elle dispose d’une **interface simple** avec deux boutons :

1. **Générer les données**
2. **Supprimer les données**

------

## 🧱 Étape 1 — Lier `push_data_firestore` à Firebase (macOS / Windows)

⚠️ Cette configuration est **indépendante** de votre application principale (`dto_exercice`).

Vous devez relier **ce projet distinct** à Firebase pour qu’il puisse injecter les données dans votre Firestore.

### 1. Ouvrir Firebase Console

Rendez-vous sur : https://console.firebase.google.com/

### 2. Ajouter une nouvelle application *à l’intérieur du même projet Firebase que DTO-EXERCICE*.

- Cliquez sur **Ajouter une application**
- Choisissez **Flutter**
- Sélectionnez **macOS** ou **Windows** selon votre OS
- Suivez les étapes d’intégration

------

## 📦 Étape 2 — Ajouter vos données dans `/lib/data`

Le dossier `data/` contient les listes d’objets qui seront envoyés dans Firestore.

Exemple existant :

```
users.dart
```

### 🎯 Votre mission : créer deux nouveaux fichiers

```
category.dart
product.dart
```

### Exemple `category.dart`

```
import 'package:dto/models/category.dart';

String generateId() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final random = DateTime.now().millisecondsSinceEpoch.remainder(1000000);
  return '${now.toRadixString(36)}${random.toRadixString(36)}';
}

List<Category> categories = [
  Category(
    id: generateId(),
    title: "Fruits frais",
    description: "Fruits cueillis du jour 🍎",
    createdAt: DateTime.now(),
  ),
  Category(
    id: generateId(),
    title: "Légumes",
    description: "Des légumes tout verts 🥦",
    createdAt: DateTime.now(),
  ),
];
```

### Exemple `product.dart`

```
import 'package:dto/models/product.dart';
import 'package:firestore_odm/firestore_odm.dart';

List<Product> products = [
  Product(
    id: FirestoreODM.autoGeneratedId,
    name: "Pomme",
    description: "Rouge, juteuse, bio 🍎",
    price: 120,
    createdAt: DateTime.now(),
  ),
  Product(
    id: FirestoreODM.autoGeneratedId,
    name: "Banane",
    description: "Sucrée et mûre 🍌",
    price: 090,
    createdAt: DateTime.now(),
  ),
];
```

------

## 🔑 Pourquoi générer les IDs **manuellement** ?

Firestore ODM propose :

```
FirestoreODM.autoGeneratedId()
```

MAIS :

- cette fonction **ne renvoie pas l’ID généré** ;
- impossible donc d’utiliser cet ID pour créer une sous-collection ;
- impossible de créer des relations entre documents (ex : produits dans une catégorie) ;
- dans un seeder, vous devez connaître l’ID **avant** d’insérer le document.

👉 **Donc dans un seeder, générer l’ID manuellement est la bonne pratique.**
 👉 C’est **100% normal** et même recommandé dans les scripts d’initialisation.

Cependant, si la donnée n'a pas de sous-collection, on peut générer son ID avec la fonction de l'ODM.

------

## ⚙️ Étape 3 — Compléter `home.dart` : méthodes de seed

Le fichier :

```
code/push_data_firestore/lib/screens/home.dart
```

contient déjà :

- une interface avec deux boutons
- une fonction `addUsers()`
- une fonction `deleteUsers()`

### 🎯 Vous devez y ajouter :

- `addCategories()`
- `addProducts()`
- `deleteCategories()`
- `deleteProducts()`

------

### Exemple : Ajouter les catégories

```
Future<void> addCategories() async {
  for (final category in categories) {
    await db.categories.insert(category);
  }
}
```

### Exemple : Ajouter les produits

⚠️ Si vos produits vont dans une sous-collection :

```
db.users(userId).categories(categoryId).products.insert(product)
```

Sinon, insertion directe :

```
Future<void> addProducts() async {
  for (final product in products) {
    await db.products.insert(product);
  }
}
```

------

### Exemple : supprimer les catégories

```
Future<void> deleteCategories() async {
  final data = await db.categories.get();
  for (final category in data) {
    await db.categories.delete(category.id);
  }
}
```

### Exemple : supprimer les produits

```
Future<void> deleteProducts() async {
  final data = await db.products.get();
  for (final product in data) {
    await db.products.delete(product.id);
  }
}
```

------

## 🧩 Étape 4 — Appeler les méthodes dans l’interface

Dans `home.dart`, modifiez :

### Bouton **Générer les données**

```
onPressed: () async {
  await addUsers();
  await addCategories();
  await addProducts();
},
```

### Bouton **Supprimer les données**

```
onPressed: () async {
  await deleteProducts();
  await deleteCategories();
  await deleteUsers();
},
```

> 💡 L’ordre est important : on supprime les produits **avant** les catégories.

------

# 🎉 Résultat final

Une fois tout en place :

- cliquez sur **Générer les données** → Firestore se remplit automatiquement
- cliquez sur **Supprimer les données** → Firestore revient à zéro

L’étudiant obtient une base Firestore propre et cohérente pour travailler sur son exercice DTO+ODM.