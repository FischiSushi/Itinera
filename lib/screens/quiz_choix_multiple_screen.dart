import 'package:flutter/material.dart';

import 'package:itinera/main.dart';
import 'package:itinera/vocabulaire_data.dart';

// ============================================================
// JEU : CHOIX MULTIPLE
// ============================================================

class QuizChoixMultipleScreen extends StatefulWidget {
  final List<Vocabulaire> vocabulaire;
  final String direction;

  const QuizChoixMultipleScreen({
    super.key,
    required this.vocabulaire,
    required this.direction,
  });

  @override
  State<QuizChoixMultipleScreen> createState() =>
      _QuizChoixMultipleScreenState();
}

class _QuizChoixMultipleScreenState extends State<QuizChoixMultipleScreen> {
  late List<Vocabulaire> questions;
  int index = 0;
  int score = 0;
  List<String> options = [];
  String? optionChoisie;

  @override
  void initState() {
    super.initState();
    questions = List.of(widget.vocabulaire)..shuffle();
    genererOptions();
  }

  String texteQuestion(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.latin : mot.francais;

  String texteReponse(Vocabulaire mot) =>
      widget.direction == directionLatinVersFrancais ? mot.francais : mot.latin;

  void genererOptions() {
    final motActuel = questions[index];
    final bonneReponse = texteReponse(motActuel);

    final distracteurs =
        widget.vocabulaire
            .where((m) => m != motActuel)
            .map(texteReponse)
            .where((r) => r != bonneReponse)
            .toSet()
            .toList()
          ..shuffle();

    options = [bonneReponse, ...distracteurs.take(3)]..shuffle();
    optionChoisie = null;
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    setState(() {
      optionChoisie = option;

      if (option == texteReponse(questions[index])) {
        score++;
      }
    });
  }

  void suivant() {
    if (index + 1 >= questions.length) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Quiz terminé'),
            content: Text('$score / ${questions.length} bonnes réponses'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Terminer'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      index++;
      genererOptions();
    });
  }

  Widget boutonOption(String option, String bonneReponse) {
    Color? couleur;

    if (optionChoisie != null) {
      if (option == bonneReponse) {
        couleur = Colors.green;
      } else if (option == optionChoisie) {
        couleur = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: couleur,
            foregroundColor: texteClair,
            disabledForegroundColor: texteClair.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => repondre(option),
          child: Text(option, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final motActuel = questions[index];
    final bonneReponse = texteReponse(motActuel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Choix multiple (${index + 1}/${questions.length})'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text('Score : $score', style: const TextStyle(color: texteAttenue)),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  texteQuestion(motActuel),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            for (final option in options) boutonOption(option, bonneReponse),

            if (optionChoisie != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    optionChoisie == bonneReponse
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: optionChoisie == bonneReponse
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      optionChoisie == bonneReponse
                          ? 'Correct !'
                          : 'Faux — la bonne réponse était : $bonneReponse',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: optionChoisie == bonneReponse
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const Spacer(),

            if (optionChoisie != null)
              ElevatedButton(
                onPressed: suivant,
                child: Text(
                  index + 1 >= questions.length ? 'Terminer' : 'Suivant',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
