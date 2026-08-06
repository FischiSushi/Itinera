import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/screens/unite_screen.dart';
import 'package:itinera/vocabulaire_data.dart';

// La taille de fenêtre de test par défaut (800x600) fait déborder le
// panneau « Réviser » (plusieurs cartes d'action l'une sous l'autre) : on
// simule un écran de téléphone réaliste, comme dans vocabulaire_screen_test.
void _vueTelephone(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  late Directory tempDir;

  // Deux volumes dédiés aux tests, jamais utilisés par le vrai contenu, pour
  // vérifier le filtrage par volume sans toucher au vocabulaire réel.
  const uniteVolumeTest = 'Vol. Test – Unité 1';
  const uniteAutreVolumeTest = 'Vol. Autre – Unité 1';

  final motsVolumeTest = [
    Vocabulaire(
      latin: 'rosa',
      francais: 'rose',
      unite: uniteVolumeTest,
      categorie: 'Noms',
    ),
    Vocabulaire(
      latin: 'silva',
      francais: 'forêt',
      unite: uniteVolumeTest,
      categorie: 'Noms',
    ),
  ];

  final motAutreVolume = Vocabulaire(
    latin: 'lupus',
    francais: 'loup',
    unite: uniteAutreVolumeTest,
    categorie: 'Noms',
  );

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('itinera_test_');
    Hive.init(tempDir.path);
    await Hive.openBox('vocabBox');
    vocabulaire.addAll(motsVolumeTest);
    vocabulaire.add(motAutreVolume);
  });

  tearDown(() async {
    // `vocabulaire` est une liste globale partagée par tous les tests : on
    // retire tout résidu de test pour ne pas polluer les tests suivants.
    vocabulaire.removeWhere(
      (mot) => mot.unite == uniteVolumeTest || mot.unite == uniteAutreVolumeTest,
    );
    await Hive.box('vocabBox').close();
    await tempDir.delete(recursive: true);
  });

  testWidgets(
    'ne montre que les unités du volume sélectionné',
    (tester) async {
      _vueTelephone(tester);

      await tester.pumpWidget(
        const MaterialApp(home: UniteScreen(unite: 'Vol. Test')),
      );

      expect(find.text(uniteVolumeTest), findsOneWidget);
      expect(find.text(uniteAutreVolumeTest), findsNothing);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  testWidgets(
    'la barre de progression ne compte que les mots du volume affiché',
    (tester) async {
      _vueTelephone(tester);

      await tester.pumpWidget(
        const MaterialApp(home: UniteScreen(unite: 'Vol. Test')),
      );

      // motsVolumeTest : 2 mots, tous neufs (jamais révisés) -> 0 appris.
      expect(find.text('0/2 mots'), findsOneWidget);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );

  testWidgets(
    'les stats "Réviser" restent globales, pas limitées au volume affiché',
    (tester) async {
      _vueTelephone(tester);

      final maintenant = DateTime.now().toUtc();
      final totalGlobalARevoir = vocabulaire
          .where((mot) => mot.estDu(maintenant))
          .length;

      await tester.pumpWidget(
        const MaterialApp(home: UniteScreen(unite: 'Vol. Test')),
      );

      // Si ce nombre était limité au volume affiché, il vaudrait 2 (les
      // mots de test) — les dates d'échéance FSRS ignorent les volumes,
      // donc "à revoir" doit rester basé sur tout le vocabulaire.
      expect(find.text('$totalGlobalARevoir'), findsAtLeastNWidgets(1));
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
