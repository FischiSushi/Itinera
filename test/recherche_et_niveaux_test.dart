import 'package:flutter_test/flutter_test.dart';
import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';

// chercherDansVocabulaire() et niveauDifficulte()/vocabulairePourNiveau()
// n'utilisent pas Hive : ce sont des fonctions pures, testables sans box.
//
// chercherDansVocabulaire() interroge la vraie liste de vocabulaire de
// classe (vocabulaire_data.dart) : on s'appuie sur "unus, -a, -um" (le tout
// premier mot du programme, Vol. I – Unité 0), extrêmement stable.
//
// niveauDifficulte() est testé sur des Vocabulaire construits localement
// (pas ceux de la liste globale) pour ne pas muter un état partagé entre
// tests.

void main() {
  group('chercherDansVocabulaire', () {
    test('requête vide ne retourne rien', () {
      expect(chercherDansVocabulaire(''), isEmpty);
      expect(chercherDansVocabulaire('   '), isEmpty);
    });

    test('trouve un mot latin connu, insensible à la casse', () {
      final resultats = chercherDansVocabulaire('UnUs');
      expect(
        resultats.any((v) => v.latin == 'unus, -a, -um'),
        isTrue,
      );
    });

    test('trouve aussi par le sens français', () {
      final resultats = chercherDansVocabulaire('deux');
      expect(
        resultats.any((v) => v.latin == 'duo, -ae, -o'),
        isTrue,
      );
    });

    test('aucun résultat pour une requête absurde', () {
      expect(chercherDansVocabulaire('zzzqqxxnexistepas'), isEmpty);
    });
  });

  group('niveauDifficulte', () {
    Vocabulaire motAvecDifficulte(double? difficulte) {
      final mot = Vocabulaire(
        latin: 'testum',
        francais: 'test',
        unite: 'test',
        categorie: 'Noms',
      );
      mot.fsrsCard.difficulty = difficulte;
      return mot;
    }

    test('null tant que le mot n\'a jamais été révisé', () {
      expect(niveauDifficulte(motAvecDifficulte(null)), isNull);
    });

    test('facile en dessous de 4', () {
      expect(niveauDifficulte(motAvecDifficulte(2)), niveauFacile);
    });

    test('moyen entre 4 et 7', () {
      expect(niveauDifficulte(motAvecDifficulte(5)), niveauMoyen);
    });

    test('difficile à partir de 7', () {
      expect(niveauDifficulte(motAvecDifficulte(8)), niveauDifficile);
    });
  });
}
