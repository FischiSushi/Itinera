# Activer le compte en ligne (Firebase)

L'écran Compte (l'avatar en haut à gauche du parcours) affiche un message
d'attente tant que ces étapes n'ont pas été faites — le reste de l'app
fonctionne normalement sans elles.

## 1. Créer le projet Firebase

1. Va sur https://console.firebase.google.com et crée un nouveau projet
   (ou réutilise un projet existant).
2. Dans **Créer une application** → choisis **Android**, package name :
   `com.example.itinera` (celui défini dans
   `android/app/build.gradle.kts`). Si tu veux aussi iOS : bundle ID
   `com.example.itinera` (défini dans
   `ios/Runner.xcodeproj/project.pbxproj`).
   > Ce nom de package est encore le défaut Flutter — pense à le changer
   > avant une publication sur le Play Store / App Store (les stores
   > refusent `com.example.*`), mais pour développer/tester ça suffit.

## 2. Activer l'authentification par e-mail

Dans la console : **Authentication → Sign-in method → Ajouter un
fournisseur → E-mail/Mot de passe** → activer.

## 3. Créer la base Firestore

**Firestore Database → Créer une base de données** (mode production).
Puis dans l'onglet **Règles**, colle le contenu du fichier
[`firestore.rules`](firestore.rules) de ce dépôt et publie.

## 4. Générer la configuration côté app

Dans un terminal, à la racine du projet (`d:\flutter_projects\itinera`) :

```
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```

`firebase login` ouvre une fenêtre de navigateur pour te connecter avec le
même compte Google que celui utilisé pour créer le projet. `flutterfire
configure` te demande ensuite quel projet Firebase utiliser et pour quelles
plateformes (coche au moins Android) ; il génère automatiquement :

- `lib/firebase_options.dart` (remplace le fichier factice déjà présent)
- `android/app/google-services.json`
- (si iOS coché) `ios/Runner/GoogleService-Info.plist`

Aucune autre modification de code n'est nécessaire — dès que ces fichiers
existent, `firebaseDisponible` passe automatiquement à `true` au prochain
lancement de l'app et l'écran Compte affiche le formulaire de
connexion/inscription.

## Vérifier que ça marche

1. `flutter run`
2. Ouvrir l'onglet Parcours, taper sur l'avatar en haut à gauche.
3. Créer un compte test avec une adresse e-mail.
4. Sur un deuxième appareil/émulateur (ou en te déconnectant puis en créant
   un second compte), chercher le premier compte par e-mail et le suivre —
   vérifier que le nombre d'abonnés/abonnements se met à jour des deux
   côtés.
