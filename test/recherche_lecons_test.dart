import 'package:flutter_test/flutter_test.dart';
import 'package:itinera/screens/recherche_lecons_screen.dart';

// rechercherLecons() est une fonction pure (pas de Hive) qui filtre
// construireParcoursComplet() par titre/sous-titre, tous volumes
// confondus. On s'appuie sur des leçons stables du programme.

void main() {
  test('requête vide ne retourne rien', () {
    expect(rechercherLecons(''), isEmpty);
    expect(rechercherLecons('   '), isEmpty);
  });

  test('trouve une leçon par son titre, insensible à la casse', () {
    final resultats = rechercherLecons('déclinaison');
    expect(
      resultats.any((l) => l.id == 'decl_1'),
      isTrue,
    );
  });

  test('trouve aussi par le sous-titre', () {
    final resultats = rechercherLecons('nominatif');
    expect(resultats, isNotEmpty);
  });

  test('aucun résultat pour une requête absurde', () {
    expect(rechercherLecons('zzzqqxxnexistepas'), isEmpty);
  });
}
