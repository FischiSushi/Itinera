import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';

void main() {
  late Directory tempDir;

  // Unité dédiée aux tests : jamais utilisée par le vrai contenu, pour ne
  // jamais toucher au vocabulaire réel de l'app.
  const uniteTest = 'Test Unité Vocabulaire Perso';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('itinera_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('vocabBox');
  });

  tearDown(() async {
    // `vocabulaire` est une liste globale partagée par tous les tests de ce
    // fichier (contrairement au box Hive, réinitialisé à chaque test) : on
    // retire tout résidu de test pour ne pas polluer les tests suivants.
    vocabulaire.removeWhere((mot) => mot.unite == uniteTest);
    await Hive.box('vocabBox').close();
    await tempDir.delete(recursive: true);
  });

  group('ajouterVocabulairePersonnalise', () {
    test('ajoute le mot à la liste globale avec les bons champs', () {
      ajouterVocabulairePersonnalise(
        latin: 'proba',
        francais: 'éprouve',
        unite: uniteTest,
        categorie: 'Verbes',
        etymologie: 'éprouver',
      );

      final mot = vocabulaire.firstWhere((m) => m.latin == 'proba');
      expect(mot.francais, 'éprouve');
      expect(mot.unite, uniteTest);
      expect(mot.categorie, 'Verbes');
      expect(mot.etymologie, 'éprouver');
    });

    test('étymologie vide ou blanche devient null', () {
      ajouterVocabulairePersonnalise(
        latin: 'vacuus',
        francais: 'vide',
        unite: uniteTest,
        categorie: 'Adjectifs',
        etymologie: '   ',
      );

      final mot = vocabulaire.firstWhere((m) => m.latin == 'vacuus');
      expect(mot.etymologie, isNull);
    });
  });

  group('cleDuMot', () {
    test('compose latin|unite|categorie', () {
      final mot = Vocabulaire(
        latin: 'x',
        francais: 'y',
        unite: 'u',
        categorie: 'c',
      );
      expect(cleDuMot(mot), 'x|u|c');
    });
  });

  group('supprimerVocabulaire', () {
    test('retire le mot de la liste globale', () {
      ajouterVocabulairePersonnalise(
        latin: 'delendus',
        francais: 'à détruire',
        unite: uniteTest,
        categorie: 'Adjectifs',
      );

      final mot = vocabulaire.firstWhere((m) => m.latin == 'delendus');
      supprimerVocabulaire(mot);

      expect(vocabulaire.any((m) => m.latin == 'delendus'), isFalse);
    });
  });

  group('Renommage d\'unité', () {
    test('nomAffiche renvoie le nom original tant que jamais renommé', () {
      expect(nomAffiche(uniteTest), uniteTest);
    });

    test('renommerUnite change nomAffiche', () {
      renommerUnite(uniteTest, 'Mon nom perso');
      expect(nomAffiche(uniteTest), 'Mon nom perso');
    });

    test('renommer avec une chaîne vide restaure le nom original', () {
      renommerUnite(uniteTest, 'Mon nom perso');
      renommerUnite(uniteTest, '');
      expect(nomAffiche(uniteTest), uniteTest);
    });

    test('renommer avec le nom original restaure aussi (pas de no-op superflu)', () {
      renommerUnite(uniteTest, 'Mon nom perso');
      renommerUnite(uniteTest, uniteTest);
      expect(nomAffiche(uniteTest), uniteTest);
    });
  });

  group('supprimerUnite', () {
    test('retire tous les mots de cette unité de la liste globale', () {
      ajouterVocabulairePersonnalise(
        latin: 'primus_mot_test',
        francais: 'x',
        unite: uniteTest,
        categorie: 'Noms',
      );
      ajouterVocabulairePersonnalise(
        latin: 'second_mot_test',
        francais: 'y',
        unite: uniteTest,
        categorie: 'Noms',
      );

      supprimerUnite(uniteTest);

      expect(vocabulaire.any((m) => m.unite == uniteTest), isFalse);
    });
  });
}
