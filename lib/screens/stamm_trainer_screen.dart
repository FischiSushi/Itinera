import 'dart:math';

import 'package:flutter/material.dart';

import 'package:itinera/vocabulaire_data.dart';
import 'package:itinera/design/palette.dart';
import 'package:itinera/design/widgets.dart';

// ============================================================
// GRAMMAIRE : STAMMTRAINER (VERBES)
// ============================================================

class StammTrainerScreen extends StatefulWidget {
  const StammTrainerScreen({super.key});

  @override
  State<StammTrainerScreen> createState() => _StammTrainerScreenState();
}

class _StammTrainerScreenState extends State<StammTrainerScreen> {
  static const _labelsStamms = {
    0: 'présent',
    3: 'parfait',
    4: 'supin / participe parfait',
  };

  final _rng = Random();

  late List<Vocabulaire> verbes;
  late int totalQuestions;

  int index = 0;
  int score = 0;

  late Vocabulaire verbeActuel;
  late List<String> segmentsActuels;
  late int indexCible;
  late String reponseCorrecte;
  List<String> options = [];
  String? optionChoisie;

  @override
  void initState() {
    super.initState();

    verbes = vocabulaire
        .where(
          (mot) =>
              mot.categorie == 'Verbes' && mot.latin.split(',').length >= 4,
        )
        .toList();

    totalQuestions = verbes.length < 20 ? verbes.length : 20;

    if (verbes.isNotEmpty) genererQuestion();
  }

  List<String> segmentsDe(Vocabulaire mot) =>
      mot.latin.split(',').map((s) => s.trim()).toList();

  void genererQuestion() {
    verbeActuel = verbes[_rng.nextInt(verbes.length)];
    segmentsActuels = segmentsDe(verbeActuel);

    final indicesValides = _labelsStamms.keys
        .where((i) => i < segmentsActuels.length)
        .toList();

    indexCible = indicesValides[_rng.nextInt(indicesValides.length)];
    reponseCorrecte = segmentsActuels[indexCible];

    final distracteurs =
        verbes
            .where((mot) => mot != verbeActuel)
            .map(segmentsDe)
            .where((segments) => indexCible < segments.length)
            .map((segments) => segments[indexCible])
            .where((segment) => segment != reponseCorrecte)
            .toSet()
            .toList()
          ..shuffle(_rng);

    options = [reponseCorrecte, ...distracteurs.take(3)]..shuffle(_rng);
    optionChoisie = null;
  }

  void repondre(String option) {
    if (optionChoisie != null) return;

    setState(() {
      optionChoisie = option;

      if (option == reponseCorrecte) score++;
    });
  }

  void suivant() {
    if (index + 1 >= totalQuestions) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Terminé'),
            content: Text('$score / $totalQuestions bonnes réponses'),
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
      genererQuestion();
    });
  }

  Widget boutonOption(String option) {
    Color fond = designBlanc;
    Color texte = designNoir;

    if (optionChoisie != null) {
      if (option == reponseCorrecte) {
        fond = Colors.green;
        texte = Colors.white;
      } else if (option == optionChoisie) {
        fond = Colors.red;
        texte = Colors.white;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: fond,
            foregroundColor: texte,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () => repondre(option),
          child: Text(option, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  String get texteMasque {
    return segmentsActuels
        .asMap()
        .entries
        .map((e) => e.key == indexCible ? '___' : e.value)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (verbes.isEmpty) {
      return Scaffold(
        backgroundColor: designFond,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: const Text('Stammtrainer'),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: designGradientFond),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Pas assez de verbes avec formes complètes dans le '
                'vocabulaire pour ce jeu.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: designFond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text('Stammtrainer (${index + 1}/$totalQuestions)'),
      ),

      body: DecoratedBox(
        decoration: BoxDecoration(gradient: designGradientFond),
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              Text(
                'Score : $score',
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 16),

              CarteDesign(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      texteMasque,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: designNoir,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      verbeActuel.francais,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: designNoir.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Quelle est la forme du ${_labelsStamms[indexCible]} ?',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 24),

              for (final option in options) boutonOption(option),

              if (optionChoisie != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      optionChoisie == reponseCorrecte
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: optionChoisie == reponseCorrecte
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        optionChoisie == reponseCorrecte
                            ? 'Correct !'
                            : 'Faux — la bonne réponse était : $reponseCorrecte',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: optionChoisie == reponseCorrecte
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
                  style: styleBoutonAccent,
                  onPressed: suivant,
                  child: Text(
                    index + 1 >= totalQuestions ? 'Terminer' : 'Suivant',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
