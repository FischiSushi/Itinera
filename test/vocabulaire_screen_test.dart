import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/screens/vocabulaire_screen.dart';
import 'package:itinera/vocabulaire_data.dart';

// La taille de fenêtre de test par défaut (800x600) est bien plus petite
// qu'un vrai téléphone et fait déborder la carte de révision (hauteur
// fixe de 300) : on simule un écran de téléphone réaliste pour tester le
// layout tel qu'il est réellement vu.
void _vueTelephone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  late Directory tempDir;

  final motsTest = [
    Vocabulaire(
      latin: 'rosa',
      francais: 'rose',
      unite: 'test',
      categorie: 'Noms',
    ),
    Vocabulaire(
      latin: 'silva',
      francais: 'forêt',
      unite: 'test',
      categorie: 'Noms',
    ),
  ];

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('itinera_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('vocabBox');
  });

  tearDown(() async {
    await Hive.box('vocabBox').close();
    await tempDir.delete(recursive: true);
  });

  testWidgets(
    'affiche la question puis la réponse après un tap',
    (tester) async {
      _vueTelephone(tester);

      await tester.pumpWidget(
        MaterialApp(
          home: VocabulaireScreen(vocabulaire: motsTest, startIndex: 0),
        ),
      );

      expect(find.text('rosa'), findsOneWidget);
      expect(find.text('rose'), findsNothing);

      await tester.tap(find.text('Afficher la réponse'));
      await tester.pump();

      expect(find.text('rose'), findsOneWidget);
      expect(find.text('Masquer la réponse'), findsOneWidget);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  // Pas de test ici pour "noter une carte" (tap sur Bien/Difficile/...) :
  // carteEvaluee() déclenche plusieurs box.put() Hive non attendus depuis un
  // handler de bouton, ce qui bloque indéfiniment sur Hive.box(...).close()/
  // flush() en tearDown — reproduit avec un cas minimal (un simple
  // ElevatedButton + box.put(), sans aucun code de l'app) donc c'est une
  // interaction Hive/testWidgets sur cet environnement, pas un bug de
  // l'écran. La logique elle-même (FSRS, coins, série) est déjà couverte
  // par des tests non-widget dans logique_coeur_test.dart.

  testWidgets(
    'la navigation "Suivant" boucle vers la première carte',
    (tester) async {
      _vueTelephone(tester);

      await tester.pumpWidget(
        MaterialApp(
          home: VocabulaireScreen(vocabulaire: motsTest, startIndex: 1),
        ),
      );

      expect(find.text('silva'), findsOneWidget);

      await tester.tap(find.text('Suivant →'));
      await tester.pump();

      expect(find.text('rosa'), findsOneWidget);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
