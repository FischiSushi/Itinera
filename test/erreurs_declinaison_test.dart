import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/latin/declinaison.dart';
import 'package:itinera/latin/erreurs_declinaison.dart';
import 'package:itinera/vocabulaire_data.dart';

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

  ParadigmeNominal domina() => genererParadigme(
        Vocabulaire(latin: 'domina, ae, f.', francais: 'maîtresse', unite: 't', categorie: 'Noms'),
      )!;

  test('formeConfondue trouve une autre case identique', () {
    final p = domina();
    // genitif singulier "dominae" == datif singulier "dominae" (syncrétisme
    // du 1er groupe) : on doit retrouver au moins une des deux.
    final confusion = formeConfondue(p, 'dominae', Cas.genitif, false);
    expect(confusion, isNotNull);
  });

  test('formeConfondue retourne null si la réponse ne correspond à rien', () {
    final p = domina();
    expect(formeConfondue(p, 'xyzabc', Cas.genitif, true), isNull);
  });

  test('formeConfondue ignore la case cible elle-même', () {
    final p = domina();
    // "dominarum" n'existe qu'au génitif pluriel : chercher une confusion
    // pour CETTE case précise ne doit rien trouver d'autre.
    expect(formeConfondue(p, 'dominarum', Cas.genitif, true), isNull);
  });

  test('enregistrerErreurDeclinaison agrège et confusionsFrequentes trie', () {
    enregistrerErreurDeclinaison(
      casCible: 'Génitif',
      plurielCible: false,
      casConfondu: 'Ablatif',
      plurielConfondu: false,
    );
    enregistrerErreurDeclinaison(
      casCible: 'Génitif',
      plurielCible: false,
      casConfondu: 'Ablatif',
      plurielConfondu: false,
    );
    enregistrerErreurDeclinaison(
      casCible: 'Accusatif',
      plurielCible: true,
      casConfondu: 'Nominatif',
      plurielConfondu: true,
    );

    final top = confusionsFrequentes(limite: 5);
    expect(top.first.casCible, 'Génitif');
    expect(top.first.casConfondu, 'Ablatif');
    expect(top.first.occurrences, 2);
    expect(top[1].casCible, 'Accusatif');
  });

  test('erreur non classée (réponse inconnue) reste comptée', () {
    enregistrerErreurDeclinaison(casCible: 'Datif', plurielCible: true);

    final categories = categoriesFaibles();
    expect(categories.any((c) => c.$1 == 'Datif' && c.$2 == true && c.$3 == 1), isTrue);

    // Pas de confusion "propre" (pas de catégorie confondue) : ne doit pas
    // apparaître dans confusionsFrequentes.
    expect(confusionsFrequentes().any((c) => c.casCible == 'Datif'), isFalse);
  });

  test('categoriesFaibles cumule confusions classées et non classées', () {
    enregistrerErreurDeclinaison(
      casCible: 'Ablatif',
      plurielCible: false,
      casConfondu: 'Datif',
      plurielConfondu: false,
    );
    enregistrerErreurDeclinaison(casCible: 'Ablatif', plurielCible: false);

    final categories = categoriesFaibles();
    final ablatif = categories.firstWhere((c) => c.$1 == 'Ablatif' && c.$2 == false);
    expect(ablatif.$3, 2);
  });
}
