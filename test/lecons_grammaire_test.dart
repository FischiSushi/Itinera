import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/lecons_grammaire_data.dart';

void main() {
  group('normaliserReponse', () {
    test('ignore la casse et les espaces superflus', () {
      expect(normaliserReponse('  Rosa  '), 'rosa');
      expect(normaliserReponse('rosa'), normaliserReponse('  Rosa  '));
    });

    test('ignore les accents pédagogiques de prononciation', () {
      expect(normaliserReponse('Rómae'), 'romae');
      expect(normaliserReponse('paenínsula'), 'paeninsula');
    });

    test('ignore la ponctuation finale', () {
      expect(normaliserReponse('rosa.'), 'rosa');
      expect(normaliserReponse('rosa !'), 'rosa');
      expect(normaliserReponse('rosa ?'), 'rosa');
    });

    test('réduit les espaces multiples internes à un seul', () {
      expect(normaliserReponse('rosa   pulchra'), 'rosa pulchra');
    });
  });

  group('Complétion des leçons', () {
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

    const lecon = Lecon(
      id: 'test_lecon_1',
      titre: 'Leçon de test',
      sousTitre: 'x',
      icone: Icons.school,
    );

    test('aucune leçon complétée au départ', () {
      expect(leconsCompletees(), isEmpty);
      expect(leconEstCompletee(lecon), isFalse);
    });

    test('marquerLeconCompletee marque uniquement cette leçon', () {
      const autreLecon = Lecon(
        id: 'test_lecon_2',
        titre: 'Autre leçon',
        sousTitre: 'x',
        icone: Icons.school,
      );

      marquerLeconCompletee(lecon.id);

      expect(leconEstCompletee(lecon), isTrue);
      expect(leconEstCompletee(autreLecon), isFalse);
    });

    test('marquer deux fois la même leçon reste idempotent', () {
      marquerLeconCompletee(lecon.id);
      marquerLeconCompletee(lecon.id);

      expect(leconsCompletees().length, 1);
    });
  });
}
