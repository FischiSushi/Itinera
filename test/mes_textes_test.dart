import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/main.dart';

// Couvre le CRUD de "Mes textes" (textes personnalisés analysés dans
// AnalyseTexteScreen), stocké dans le box Hive 'vocabBox'.

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

  test('aucun texte au départ', () {
    expect(mesTextes(), isEmpty);
  });

  test('ajouterMonTexte crée un texte sans tags puis le retrouve', () {
    final ajoute = ajouterMonTexte('Fabula', 'Olim erat...');

    expect(ajoute.titre, 'Fabula');
    expect(ajoute.texte, 'Olim erat...');
    expect(ajoute.tags, isEmpty);

    final textes = mesTextes();
    expect(textes, hasLength(1));
    expect(textes.first.id, ajoute.id);
    expect(textes.first.titre, 'Fabula');
  });

  test('mettreAJourTagsTexte remplace les tags d\'un texte existant', () {
    final texte = ajouterMonTexte('Fabula', 'Puella rosam amat.');

    mettreAJourTagsTexte(texte.id, const [
      TagMot(index: 0, mot: 'Puella', fonction: 'Sujet'),
      TagMot(index: 1, mot: 'rosam', fonction: 'COD'),
    ]);

    final misAJour = mesTextes().firstWhere((t) => t.id == texte.id);
    expect(misAJour.tags, hasLength(2));
    expect(misAJour.tags.first.mot, 'Puella');
    expect(misAJour.tags.first.fonction, 'Sujet');
    // Le titre et le texte ne doivent pas être affectés par la mise à jour.
    expect(misAJour.titre, 'Fabula');
    expect(misAJour.texte, 'Puella rosam amat.');
  });

  test('mettreAJourTagsTexte ne fait rien pour un id inconnu', () {
    ajouterMonTexte('Fabula', 'Olim erat...');

    mettreAJourTagsTexte('id_inexistant', const [
      TagMot(index: 0, mot: 'x', fonction: 'y'),
    ]);

    expect(mesTextes(), hasLength(1));
    expect(mesTextes().first.tags, isEmpty);
  });

  test('supprimerMonTexte retire uniquement le texte ciblé', () async {
    final premier = ajouterMonTexte('Premier', 'Texte un.');
    // ajouterMonTexte dérive son id de l'horloge (milliseconde) : on attend
    // un peu pour garantir un id différent du précédent.
    await Future.delayed(const Duration(milliseconds: 2));
    final second = ajouterMonTexte('Second', 'Texte deux.');

    supprimerMonTexte(premier.id);

    final restants = mesTextes();
    expect(restants, hasLength(1));
    expect(restants.first.id, second.id);
  });
}
