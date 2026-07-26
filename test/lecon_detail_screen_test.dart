import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itinera/lecons_grammaire_data.dart';
import 'package:itinera/screens/lecon_detail_screen.dart';

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

  final leconGuidee = Lecon(
    id: 'test_guide',
    titre: 'Leçon de test',
    sousTitre: 'x',
    icone: Icons.school,
    etapes: [
      EtapeTexte((context) => [const Text('Premier bloc de lecture')]),
      const EtapeVerification(
        QuestionLecon(
          question: 'Combien font 1+1 ?',
          options: ['1', '2', '3', '4'],
          reponseCorrecte: '2',
        ),
      ),
    ],
    exercices: const [
      QuestionLecon(
        question: 'Question notée',
        options: ['a', 'b'],
        reponseCorrecte: 'a',
      ),
    ],
    fiche: (context) => const Text('Fiche récapitulative'),
  );

  final leconClassique = Lecon(
    id: 'test_classique',
    titre: 'Leçon classique',
    sousTitre: 'x',
    icone: Icons.school,
    explication: (context) => [const Text('Explication classique')],
    exercices: const [
      QuestionLecon(
        question: 'Question unique',
        options: ['vrai', 'faux'],
        reponseCorrecte: 'vrai',
      ),
    ],
  );

  testWidgets(
    'parcours guidé : texte -> vérification -> quiz noté -> fiche',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: LeconDetailScreen(lecon: leconGuidee)),
      );

      expect(find.text('Premier bloc de lecture'), findsOneWidget);

      await tester.tap(find.text('Continuer'));
      await tester.pump();

      expect(find.text('Combien font 1+1 ?'), findsOneWidget);

      await tester.tap(find.text('2'));
      await tester.pump();

      expect(find.text('Correct !'), findsOneWidget);

      await tester.tap(find.text('Continuer'));
      await tester.pump();

      // Le parcours guidé est terminé : le quiz noté démarre à zéro.
      expect(find.text('Question notée'), findsOneWidget);
      expect(find.textContaining('Score : 0'), findsOneWidget);

      await tester.tap(find.text('a'));
      await tester.pump();

      await tester.tap(find.text('Voir la fiche'));
      await tester.pump();

      expect(find.text('Fiche récapitulative'), findsOneWidget);
    },
  );

  testWidgets(
    'une leçon sans etapes garde le flux classique (explication puis quiz)',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: LeconDetailScreen(lecon: leconClassique)),
      );

      expect(find.text('Explication classique'), findsOneWidget);
      expect(find.text('Question unique'), findsNothing);

      await tester.tap(find.text('Passer aux exercices'));
      await tester.pump();

      expect(find.text('Question unique'), findsOneWidget);
    },
  );
}
