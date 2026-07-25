import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/main.dart';

// Couvre les mécaniques de jeu "coeur" de l'app (pièces, boutique, série,
// succès) — toutes stockées dans le box Hive 'vocabBox' via des fonctions
// publiques de main.dart. Chaque test repart d'un box Hive vide (répertoire
// temporaire) pour rester indépendant des autres.
//
// Limite connue : streakActuel()/registrerActiviteDuJour() appellent
// DateTime.now() directement (pas d'horloge injectable), donc on ne peut
// tester ici que le comportement "aujourd'hui" — pas l'enchaînement sur
// plusieurs jours ni la consommation d'un gel de série, qui demanderaient
// de simuler le passage du temps.
//
// SocialService/DuelService (Firestore) ne sont pas couverts ici : ça
// demanderait un émulateur Firestore ou un fake — pas en place actuellement.

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('itinera_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('vocabBox');
  });

  tearDown(() async {
    await Hive.box('vocabBox').close();
    await tempDir.delete(recursive: true);
  });

  group('Pièces', () {
    test('commence à 0', () {
      expect(coins(), 0);
    });

    test('ajouterCoins puis depenserCoins', () {
      ajouterCoins(10);
      expect(coins(), 10);

      expect(depenserCoins(4), isTrue);
      expect(coins(), 6);
    });

    test('depenserCoins refuse si le solde est insuffisant', () {
      ajouterCoins(5);
      expect(depenserCoins(10), isFalse);
      expect(coins(), 5);
    });
  });

  group('Boutique', () {
    test('aucun avatar possédé au départ, avatar par défaut équipé', () {
      expect(avatarsPossedes(), isEmpty);
      expect(emojiAvatarEquipe(), '👤');
    });

    test('acheterArticle refuse si pas assez de deniers', () {
      final article = articlesBoutique.first;
      expect(acheterArticle(article), isFalse);
      expect(avatarsPossedes(), isEmpty);
    });

    test('acheterArticle un avatar : déduit le prix, ajoute l\'emoji', () {
      final article = articlesBoutique.firstWhere((a) => a.estAvatar);
      ajouterCoins(article.prix);

      expect(acheterArticle(article), isTrue);
      expect(coins(), 0);
      expect(avatarsPossedes(), contains(article.emoji));
    });

    test('équiper un avatar change emojiAvatarEquipe', () {
      final article = articlesBoutique.firstWhere((a) => a.estAvatar);
      ajouterCoins(article.prix);
      acheterArticle(article);

      equiperAvatar(article.id);
      expect(emojiAvatarEquipe(), article.emoji);
    });

    test('acheterArticle un gel de série incrémente gelsDeSerie, pas les avatars', () {
      final gel = articlesBoutique.firstWhere((a) => !a.estAvatar);
      ajouterCoins(gel.prix);

      expect(acheterArticle(gel), isTrue);
      expect(gelsDeSerie(), 1);
      expect(avatarsPossedes(), isEmpty);
    });

    test('consommerGelDeSerie décrémente, refuse si vide', () {
      expect(consommerGelDeSerie(), isFalse);

      final gel = articlesBoutique.firstWhere((a) => !a.estAvatar);
      ajouterCoins(gel.prix);
      acheterArticle(gel);

      expect(consommerGelDeSerie(), isTrue);
      expect(gelsDeSerie(), 0);
      expect(consommerGelDeSerie(), isFalse);
    });
  });

  group('Série (streak)', () {
    test('0 avant toute activité', () {
      expect(streakActuel(), 0);
    });

    test('1 après la première activité du jour', () {
      registrerActiviteDuJour();
      expect(streakActuel(), 1);
    });

    test('idempotent : plusieurs appels le même jour ne comptent qu\'une fois', () {
      registrerActiviteDuJour();
      registrerActiviteDuJour();
      registrerActiviteDuJour();
      expect(streakActuel(), 1);
    });
  });

  group('Historique des révisions', () {
    test('dernier jour à 0 avant toute révision', () {
      final historique = historiqueRevisions(jours: 7);
      expect(historique.length, 7);
      expect(historique.last, 0);
    });

    test('enregistrerRevisionDuJour incrémente le dernier jour', () {
      enregistrerRevisionDuJour();
      enregistrerRevisionDuJour();
      final historique = historiqueRevisions(jours: 7);
      expect(historique.last, 2);
      expect(historique.take(6).every((v) => v == 0), isTrue);
    });
  });

  group('Succès', () {
    test('aucun succès débloqué au départ', () {
      expect(succesDebloques(), isEmpty);
      expect(verifierNouveauxSucces(), isEmpty);
    });

    test('pomodoro_1 se débloque et rapporte des deniers', () {
      enregistrerPomodoroTermine();

      final nouveaux = verifierNouveauxSucces();
      expect(nouveaux.map((s) => s.id), contains('pomodoro_1'));
      expect(succesDebloques(), contains('pomodoro_1'));

      final recompense = succesDisponibles.firstWhere((s) => s.id == 'pomodoro_1').recompense;
      expect(coins(), recompense);
    });

    test('un succès déjà débloqué n\'est pas réattribué', () {
      enregistrerPomodoroTermine();
      verifierNouveauxSucces();
      final coinsApresPremiereDetection = coins();

      final nouveaux = verifierNouveauxSucces();
      expect(nouveaux, isEmpty);
      expect(coins(), coinsApresPremiereDetection);
    });

    test('coins_100 se débloque à 100 deniers', () {
      ajouterCoins(100);
      final nouveaux = verifierNouveauxSucces();
      expect(nouveaux.map((s) => s.id), contains('coins_100'));
    });

    test('mot_perso se débloque après l\'ajout d\'un mot personnalisé', () {
      expect(verifierNouveauxSucces().map((s) => s.id), isNot(contains('mot_perso')));

      ajouterVocabulairePersonnalise(
        latin: 'test_mot_perso',
        francais: 'mot de test',
        unite: 'Test',
        categorie: 'Noms',
      );

      expect(verifierNouveauxSucces().map((s) => s.id), contains('mot_perso'));
    });
  });
}
